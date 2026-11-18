Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020199;
	b=MhyvalUAsY8KFJ45hsAuLaTEd24Hya3Kzfm8Iti3j6yknIFmtQ6BZMewIPeUJdgH9nwM
	 Y1RwWigHYkq3adt/57RDHvWh4E5g9+v+4Ftc6pTYOoA/FyT0J2GMmz8CHNkUse6n7S76r
	 8Y9zMl+FlFVups7dQIaxlIl4SQg/j83K+jz288hiTwnq40H3GXilbjbCR9PjxkfIr7xA9
	 2h4QnalizZMeXTnLgaOXoYFdLl5VhWU0N5/FL0m5xAouazgHBj8JEkMPn4Tdhp1l1/UGy
	 HVgkUnAoyCQ3mf535fQOFifhriiVRVhtc7UClQeRi5sCt7z6IjNjc4dmhG7cOLgZUaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2TR+grnAO6PJJ4zk7aQXpaUaT7RiPozexIoySJmAlhM=;
	b=CAK3pE284VtVCniwIrMRGSTxH+FvO/Hx2BZDOQvIiw8m8OPH3zeiCQDKjtgnR/ocH2bR
	 T8MapI3R1FGcbHCCKvtRvN6Agxb8sWHMMrpZJrkBmtqg6UptT38RoZ4kFiI42W7tXxeyR
	 +fg5+O79L4d8+5i8F8khZCkknJqTy3ZTZngpXeOwnbXcN4w/ZmMHmUQ0vN2uRlf7ID0a2
	 5xcdNDZAcp9osMlT9/O0xhRSYUbTVPf2+e5WLXWPp3VR3zse3i2ziLWD55Cd+3pqpABtW
	 dC1HhwNYfR2ikOgCmrh6hmdACCZmj5Jf/5hKuibLgnJvCw/VHJiN7A8Ufe2JHMOhh8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJpjYrzJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E70606A330;
	Wed, 18 Nov 2026 16:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJpjYrzJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760341F000C6;
	Wed, 18 Nov 2026 16:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020199;
	bh=2TR+grnAO6PJJ4zk7aQXpaUaT7RiPozexIoySJmAlhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJpjYrzJwevQHkcxitIjFq/5kRDJlSuys1tYlQNb/AKqW8uDph1HqmKYlNbrmdCly
	 odMP7G7BrhejoH1Eh5McZ1Ch4e4nCXHO6//36Uk4wdQa0M2XEgNV5wj9VpN2Mn21sW
	 LwkevXrJmJ4cYzk2DbFPj6aNHrhC5HAiaj8N03Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1865/2651] ARM: 9492/1: alignment: fix LSR #32 and ASR #32 offset decoding
Date: Wed, 18 Nov 2026 15:51:45 +0100
Message-ID: <20261118150354.121735919@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 2b470a419dda3..f6c1e6b61179c 100644
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



