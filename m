Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCE14F200;
	Thu, 11 Apr 2024 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712859075; cv=none; b=mpLOG/rT5hAzkcxfH45IyDGKG/kOJ19cUBrfn6rCkVutERHvQ8cdkxslCq3X3ux5rqFOHMa2vjyLyxBLyLUnGOKrMft5NreHsmLVU7Ke0Rdq/qj7XUJcAmbWAf+maFz0QxRJny/DTPi/8lpC8IZuGQSxzbCwUSHsD0yYXTzR2Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712859075; c=relaxed/simple;
	bh=9NzfINZ1S8aXBjc5RBSY7BqV3Hq/eKdHBSjs+CeXu+k=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=tiRG1wn2uXILHjE1gLS0Tu9aKmtsYfWqfFMopmDZxIQpvN3D9IeAD3JfukjCWDsEXVl0rw4bWQwwBADDsitTGFV6eDdhdlnfOELHqiLDxxsOr40McgP930b37xSLIn93NyfXSt8OCqiX3gutv9DdgOd/lqtZqDdN7FAD398EGK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rRb5sizW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rRb5sizW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B402C072AA;
	Thu, 11 Apr 2024 18:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712859074;
	bh=9NzfINZ1S8aXBjc5RBSY7BqV3Hq/eKdHBSjs+CeXu+k=;
	h=From:Subject:Date:To:Cc:From;
	b=rRb5sizWWZWRdP5hpnqtCNKyfLib/BUEznR2WT48dYnijLPrNQjPWTRsK/TRqbE9E
	 Zz2SpFxVMMxo+i2mu3NV8Rg1ejSgVbYNr2Nsfcp0vXEjsEHh5pr8KK2mxpZR9HZgfP
	 T6Kdvrkm4tgoFaox2EW5m0cxFDFKoOgS/BgiqdSODmZN8l6VtQR3CyrdP8xZ3oNV69
	 YtFQ6UUPI9VsCezaHZ8xVl6/nhlePJhZMdN/WIeKdB8CSvNPgVsBkbZsE3p1Hfeyip
	 ksHim2RBtpSMrrtIV5xOOCC+r+rhN7JHPInMqeE5AZ7gBil3S5ZxBq6KdKv3rfsDik
	 U95vZeE98kM9w==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 0/2] configs/hardening: Some fixes for UBSAN
Date: Thu, 11 Apr 2024 11:11:05 -0700
Message-Id: <20240411-fix-ubsan-in-hardening-config-v1-0-e0177c80ffaa@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALknGGYC/x3MQQqAIBBA0avErBtQEaGuEi1MR5vNGEoRRHdPW
 r7F/w80qkwN5uGBShc3LtKhxwHC7iUTcuwGo4xVVitMfOO5NS/IgruvkYQlYyiSOONkknMxKRc
 sQX8clXrw/5f1fT9KVK9cbwAAAA==
To: keescook@chromium.org
Cc: gustavoars@kernel.org, justinstitt@google.com, 
 linux-hardening@vger.kernel.org, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4231; i=nathan@kernel.org;
 h=from:subject:message-id; bh=9NzfINZ1S8aXBjc5RBSY7BqV3Hq/eKdHBSjs+CeXu+k=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGkS6oc8NKrOPjQ58TXqSfs/7rRlJ0WSJoXuLb2i8VFVP
 0Em9s60jlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCRl+oM/yvUGIwjrJdYrD9q
 u/tfSr/0exORcwxap3PVK/bdFVlb9Ybhr1TS25tcobUPo/uz6suWs853nOq7xiCt/sgLEfPHDDn
 8bAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Hi all,

This series was spurred by a couple of recent UBSAN reports in our
continuous integration that appear to be related to
CONFIG_UBSAN_SIGNED_WRAP (which gets enabled with hardening.config due
to 'default UBSAN'), as they only appear with clang-19 and newer:

  https://github.com/ClangBuiltLinux/continuous-integration2/actions/runs/8646488985/job/23709324479#step:6:500
  https://github.com/ClangBuiltLinux/continuous-integration2/actions/runs/8646488985/job/23709330815#step:6:651

I'll include the information that I have gathered so far on these
specific instances below but I think that it is debatable whether
CONFIG_UBSAN_SIGNED_WRAP should be enabled by hardening.config at this
point in time, as it does not seem "production ready" to me, given that
there has not been many resources towards getting the majority of
instances cleaned up yet from what I can tell. This is particularly
problematic since hardening.config enables CONFIG_UBSAN_TRAP, so all
instances of this problem will break the kernel at runtime, which does
not seem great to me, hence patch 2. Patch 1 seems rather
uncontroversial to me :)

As for the actual crash itself, which seems like it should still be
addressed, I landed on commit 1211f3b21c2a ("workqueue: Preserve OFFQ
bits in cancel[_sync] paths") in -next for both crashes. Not immediately
obvious to me what it is complaining about though.

  [    0.000000] Linux version 6.9.0-rc1-00001-g1211f3b21c2a (nathan@dev-arch.thelio-3990X) (ClangBuiltLinux clang version 19.0.0git (https://github.com/llvm/llvm-project be10070f91b86a6f126d2451852242bfcb2cd366), ClangBuiltLinux LLD 19.0.0) #1 SMP PREEMPT Thu Apr 11 11:02:26 MST 2024
  ...
  [    0.189542] Internal error: UBSAN: unrecognized failure code: 00000000f2005515 [#1] PREEMPT SMP
  [    0.193125] Modules linked in:
  [    0.193865] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.9.0-rc1-00001-g1211f3b21c2a #1
  [    0.194185] Hardware name: linux,dummy-virt (DT)
  [    0.194464] pstate: 010000c9 (nzcv daIF -PAN -UAO -TCO +DIT -SSBS BTYPE=--)
  [    0.194778] pc : cancel_delayed_work+0x54/0x94
  [    0.195742] lr : cancel_delayed_work+0x40/0x94
  [    0.195877] sp : ffff80008000ba30
  [    0.195990] x29: ffff80008000ba40 x28: 0000000000000000 x27: 0000000000000000
  [    0.196315] x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
  [    0.196528] x23: ffff9ce4d84ac000 x22: 0000000000000000 x21: fff000000294b480
  [    0.196746] x20: ffff9ce4d8c5e000 x19: ffff9ce4d8b28c30 x18: ffff80008000d058
  [    0.196955] x17: 0000000000000000 x16: 0000000000000000 x15: dead000000000100
  [    0.197173] x14: 0000000000000001 x13: 0000000000000075 x12: 00000a0000000000
  [    0.197383] x11: fff0000002b10018 x10: 0008b1020000f0ff x9 : 7058149bb97ccd00
  [    0.197619] x8 : 00000000000000e1 x7 : 3d4d455453595342 x6 : 000000004e514553
  [    0.197828] x5 : fff0000002b1026b x4 : fff000001fbdaef0 x3 : 0000000000003400
  [    0.198038] x2 : ffff80008000ba30 x1 : 0000000000000000 x0 : 0000000000000000
  [    0.198326] Call trace:
  [    0.198544]  cancel_delayed_work+0x54/0x94
  [    0.198810]  deferred_probe_extend_timeout+0x20/0x6c
  [    0.198988]  driver_register+0xa8/0x10c
  [    0.199122]  __platform_driver_register+0x28/0x38
  [    0.199258]  tegra194_cbb_init+0x24/0x34
  [    0.199393]  do_one_initcall+0xec/0x2d0
  [    0.199543]  do_initcall_level+0xa4/0xd0
  [    0.199663]  do_initcalls+0x78/0xcc
  [    0.199770]  do_basic_setup+0x24/0x34
  [    0.199880]  kernel_init_freeable+0x110/0x180
  [    0.200014]  kernel_init+0x28/0x1b8
  [    0.200123]  ret_from_fork+0x10/0x20
  [    0.200547] Code: 54ffff60 37f80080 39400268 371001c8 (d42aa2a0) 
  [    0.200996] ---[ end trace 0000000000000000 ]---

---
Nathan Chancellor (2):
      configs/hardening: Fix disabling UBSAN configurations
      configs/hardening: Disable CONFIG_UBSAN_SIGNED_WRAP

 kernel/configs/hardening.config | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)
---
base-commit: fec50db7033ea478773b159e0e2efb135270e3b7
change-id: 20240410-fix-ubsan-in-hardening-config-92f66df06c4e

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

