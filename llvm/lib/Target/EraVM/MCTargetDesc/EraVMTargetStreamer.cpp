//===-- EraVMTargetStreamer.cpp - EraVM Target Streamer ---------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the EraVMTargetStreamer class.
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/EraVMMCTargetDesc.h"
#include "MCTargetDesc/EraVMTargetStreamer.h"
#include "llvm/MC/ConstantPools.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/TargetParser.h"

using namespace llvm;

//
// EraVMTargetStreamer Implemenation
//

EraVMTargetStreamer::EraVMTargetStreamer(MCStreamer &S)
    : MCTargetStreamer(S), ConstantPools(new AssemblerConstantPools()) {}

EraVMTargetStreamer::~EraVMTargetStreamer() = default;

void EraVMTargetStreamer::emitGlobalConst(APInt Value) {
  if (Value.getBitWidth() < 256) {
    // align by 256 bit
    Value = Value.sext(256);
  }
  SmallString<86> Str;
  raw_svector_ostream OS(Str);
  OS << "\t.cell " << Value;
  Streamer.emitRawText(OS.str());
}
