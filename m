Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A78187568;
	Mon, 12 Aug 2024 16:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478964; cv=none; b=Q+V9hvo/f9JKkCBtHh9HmHoZ4hNDvAzfp4kxUVriBi8eLAgrpCOCLpjmfHzm2YRONfPB3iTs3st0UaV6YjUpTr119xs+L3T+6dhRaU4FxhHnvRbwg4if7DKDKp8VB8x8Sho7tOsgebNM0yzjsF7lKtQpRtj7GkV1b0B8fdP/r28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478964; c=relaxed/simple;
	bh=dMU9Y+M45TiJF6sChOnOpYnvFWI8BuLvTr8/sOFQc0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5g602S2ThGBfIapocVRz0Gr0SdW1PURAQ0fEV+3Bq/zem1d0gTsXFVzBP8Oy+ESy+M7oE5EGCTTouGepDx7AHSvZsACem6Dx7SksqCEo8trUbs/7XH+QWyzr6wNdXJPQmG8DW1vHxm5GT9X8JC1KtyG7xQuQggq9Xhr2TudAGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQFWtd6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQFWtd6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCEDC32782;
	Mon, 12 Aug 2024 16:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478963;
	bh=dMU9Y+M45TiJF6sChOnOpYnvFWI8BuLvTr8/sOFQc0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQFWtd6im3Z80aTbFrPXChTiFR2BJFWnkKqCLsCUfH/Z5LEgSn6CKORrB4Iy3s8JQ
	 uu/JFXkT931fSlkvPem90AFr9oCpf+SKPUc2Jx1ZHVIFe8TZzUnrocTPAlzlkals+W
	 Dq5WTtBfp3DV2T2Ongugx6xPU5FH1Ry2C5SZNmnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/150] arm64: barrier: Restore spec_bar() macro
Date: Mon, 12 Aug 2024 18:02:20 +0200
Message-ID: <20240812160127.451846769@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit ebfc726eae3f31bdb5fae1bbd74ef235d71046ca ]

Upcoming errata workarounds will need to use SB from C code. Restore the
spec_bar() macro so that we can use SB.

This is effectively a revert of commit:

  4f30ba1cce36d413 ("arm64: barrier: Remove spec_bar() macro")

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20240508081400.235362-2-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/barrier.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index 2cfc4245d2e2d..e22ec44d50f5f 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -38,6 +38,10 @@
  */
 #define dgh()		asm volatile("hint #6" : : : "memory")
 
+#define spec_bar()	asm volatile(ALTERNATIVE("dsb nsh\nisb\n",		\
+						 SB_BARRIER_INSN"nop\n",	\
+						 ARM64_HAS_SB))
+
 #ifdef CONFIG_ARM64_PSEUDO_NMI
 #define pmr_sync()						\
 	do {							\
-- 
2.43.0



