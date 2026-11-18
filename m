Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049812;
	b=0/I71iFw/2yA3P0OoUXMY3dmzsKXQCXWChinJcBjUD+PrN4Qf+DuR2HHuabcHtaeGWwi
	 jgy2kL/aWk7EG6aOXExX4FnzCuhLeIehPZEwIG6CrH+ADPrkn4LftL1vXPfpT4TaLZUiO
	 06V0l+C2+opiLMuMc/Egvot86vaurOv1p+XnLps1rDDIR0zLW9APzB8neAXqhaBConIag
	 zhXDjZbx3Urxz5mQePDLoism8xMgdyafho9ujn1mphdu3ElpMNSVdoQ3PVbB4zpJV8f+9
	 ORHr3jRXEpzEMAxG7OZG2yfVRhSv+RPBBcqa1pKOjLABnKgJa3bIW61ATxEZie97GEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B0NEcDQMHReiH+GB8lRpnUlBEi+/wzLrinTRpDY0anY=;
	b=eo+KIj2cD3MTw6eK6Pe8WrrCfw6Ar6JzDYfAIxZ6NmP0Zj5fVOXEjCdj7nVMdktkwYNz
	 6PnPIY/CCuMrlqQ+pShef+bvABhyIkCmSOqTTlsLsiyRrCB++Z7U3I14xN0bOLKaGo/D8
	 jBfuzhIwonXm6m+Ehq8z0uH6unDnXwnCGu6hS4wmAjBOju+VOf4CitFoYpzW3qlPCbGBJ
	 6ETB4oQT+L3v9YAMK57wan50DvbQBOcq/xpe3fmQC2XRuM/t8+UgIePDcZhpfciZdpPfM
	 3+WudRKXLee5dnx6iXguZjbL+vO6iyYnfL+57z3EMSTbArDM+9xiYiH0UcWECT5OiXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dj0pz1E5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ADB606A31C;
	Thu, 19 Nov 2026 00:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dj0pz1E5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBDA1F000C4;
	Thu, 19 Nov 2026 00:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049812;
	bh=B0NEcDQMHReiH+GB8lRpnUlBEi+/wzLrinTRpDY0anY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dj0pz1E5PrA/E4OqPfK9Yoi2wc5l61bw7DEcz0pQGpwpbAl+sQt2BmgIZ/2WHH0g6
	 MfLpkJ/FUM4eGZGrL/nDqIzVxZ0uGHEx+9RzIUf2XUr1OkRhva9mGBbbBq0IpzoOc8
	 7ZAYRIH6ZxG/0U1xgH8D8xarPEwQdxPnkyl9bl6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2484/2857] ARM: 9492/1: alignment: fix LSR #32 and ASR #32 offset decoding
Date: Wed, 18 Nov 2026 15:58:38 +0100
Message-ID: <20261118150331.003167457@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 9f878a6c2207f0c12f34a715a6a05cfc95f47460 ]

The register-offset form of LDR/STR may apply a shift to Rm.  Per
DecodeImmShift() (ARM ARM DDI0406C section A8.4.3, "Pseudocode details
of instruction-specified shifts and rotates"), an imm5 of 0 encodes a
shift of 32 for LSR and ASR; only LSL treats 0 as "no shift", and ROR
with 0 encodes RRX.

do_alignment() special-cases RRX but not LSR or ASR, and IS_SHIFT() does
not filter these encodings out, so the block is entered with
shiftval == 0 and the offset becomes Rm instead of 0 (LSR #32) or the
replicated sign of Rm (ASR #32).

do_alignment_finish_ldst() applies the offset to the base-register
writeback of the post-indexed form, so the emulated access itself uses
the correct faulting address but Rn is left holding the wrong value.

Reproduced on ARM926EJ-S (versatile_defconfig, CONFIG_ALIGNMENT_TRAP=y,
gcc 13.3.0) with a misaligned base and Rm = 0x1000:

  ldr r0, [r1], r2, lsr #32   Rn advanced by 0x1000, must be unchanged
  ldr r0, [r1], r2, asr #32   Rn advanced by 0x1000, must be unchanged
  ldr r0, [r1], r2, asr #32   with Rm negative, Rn must decrease by 1

All three are correct with the patch applied, while a lsr #1 control
case is emulated correctly both before and after.

Assisted-by: Claude:claude-fable-5

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/alignment.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 41f1497e2fd28..291ba517f66df 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -915,11 +915,17 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 				break;
 
 			case SHIFT_LSR:
-				offset.un >>= shiftval;
+				if (shiftval == 0)
+					offset.un = 0;
+				else
+					offset.un >>= shiftval;
 				break;
 
 			case SHIFT_ASR:
-				offset.sn >>= shiftval;
+				if (shiftval == 0)
+					offset.sn >>= 31;
+				else
+					offset.sn >>= shiftval;
 				break;
 
 			case SHIFT_RORRRX:
-- 
2.53.0



