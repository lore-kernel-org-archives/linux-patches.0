Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1000746AEC5;
	Tue, 16 Jun 2026 16:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626786; cv=none; b=fvtXLrpfQY5c9ARtwhv37a2xULI8oRQG6J9a1xYKTTdWwuReaU1dIprVdX6HZoMXRj5s/8soc4ozCrpU3jgZrzzzmg4dhqf0y0EkPLzlb/XHv6FkqdT4f4WM61LfMZuTMcxnOsUacdEWrzC19LIyMrwDNymas03CRUbOJ5ZsfXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626786; c=relaxed/simple;
	bh=UINWYiysNppNf4KdVLCbalXuYh7oXBVpjz/sOyoH6RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SemcO5ODPNVoUL9ZBkoaDGyKdJTGTGfmibtjBTsCpgKzfwyXc5Qd0k9w/tpQDNEepAAztGbcSMwhwTM5oD5WeArxp8IlTy00y/6Cm8TW5eO1At7Vzx+LiI6NSNgPmltJOlPULxiDGApq91yWKvgYFYSEf+rzl4WuTVCTrOqXPQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmLOM0c9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmLOM0c9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FED1F000E9;
	Tue, 16 Jun 2026 16:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626785;
	bh=XhMAIXsthHMJyBZ3ONNI3im28GE/A8LIumJckdNcSUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fmLOM0c9N5r4T5L9vlvArUzx1eVsSwbdCpkKmowunu8PV+Sbp400bsXbUFTPmXMkC
	 QlkWSJmFM+kxYV3kSLUbhJAjcnkmmrty1d/2CNVCTkhZj/bwlb8xvhxnnWItEOoTJe
	 k7NnRzhqqitcDcBQoHViFfVMO0HVak6DSgmkpqWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/261] arm64: tlb: Allow XZR argument to TLBI ops
Date: Tue, 16 Jun 2026 20:28:28 +0530
Message-ID: <20260616145048.368119121@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit bfd9c931d19aa59fb8371d557774fa169b15db9a upstream.

The TLBI instruction accepts XZR as a register argument, and for TLBI
operations with a register argument, there is no functional difference
between using XZR or another GPR which contains zeroes. Operations
without a register argument are encoded as if XZR were used.

Allow the __TLBI_1() macro to use XZR when a register argument is all
zeroes.

Today this only results in a trivial code saving in
__do_compat_cache_op()'s workaround for Neoverse-N1 erratum #1542419. In
subsequent patches this pattern will be used more generally.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Mark: Backport to v6.12.y]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/tlbflush.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 5f12cdc2b9671a..dd802d58b39436 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -38,12 +38,12 @@
 			    : : )
 
 #define __TLBI_1(op, arg) asm (ARM64_ASM_PREAMBLE			       \
-			       "tlbi " #op ", %0\n"			       \
+			       "tlbi " #op ", %x0\n"			       \
 		   ALTERNATIVE("nop\n			nop",		       \
-			       "dsb ish\n		tlbi " #op ", %0",     \
+			       "dsb ish\n		tlbi " #op ", %x0",    \
 			       ARM64_WORKAROUND_REPEAT_TLBI,		       \
 			       CONFIG_ARM64_WORKAROUND_REPEAT_TLBI)	       \
-			    : : "r" (arg))
+			    : : "rZ" (arg))
 
 #define __TLBI_N(op, arg, n, ...) __TLBI_##n(op, arg)
 
-- 
2.53.0



