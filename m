Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5376D76413;
	Mon,  8 Apr 2024 13:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582066; cv=none; b=aoxATZHmbtdOwxtIaPvsUb4ti4I504HnB6tfBJY22I/siE8fhymdoN12Uua2rc1J95fiWiOmdG01gCGpS5jylCfcRDCeLdfsNnKq45f7xe3W5pJniGb2pEu58sCpC/pB67otLofW1oeiU6caRttJZGCcsLbvtteQofUNjSoTmSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582066; c=relaxed/simple;
	bh=bB6paYrKwv2ucRSkxcFpnCM7sCW/TZZDbXBPirs3/Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SiDHR+T+2Wa8MPTFIo54X4e5zS/pUXYKfBEHGhN3Noy+yj9Vx/sEhZARae79O8LL2IZ7s5H4fYnJSeSErM+/2/uYS/pUF6KfYXke1YlFsQpOBUMgzMLJletdhem8VVN1EJ583JvzyQlO5wtZ+0sQ/rWwrKrFNx+WuA11HYkI4t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9pHXaZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9pHXaZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF04C433F1;
	Mon,  8 Apr 2024 13:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582066;
	bh=bB6paYrKwv2ucRSkxcFpnCM7sCW/TZZDbXBPirs3/Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9pHXaZ+6/6guu/hIJQV+Qmf70H6+syAmHX9NJfMD1m/1kVi4E+UMRSJGCalf4ypt
	 YKoxM5e3t456qV9HQpWdamFuNcrARDc4TSYREGzxQENaArvv2D1866xLQby8yXTYQg
	 ENxl1bqFkE/oCwIZjzAiNA1K5zRxMFeebwYbzJaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/252] x86/CPU/AMD: Get rid of amd_erratum_1054[]
Date: Mon,  8 Apr 2024 14:56:00 +0200
Message-ID: <20240408125308.534293330@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit 54c33e23f75d5c9925495231c57d3319336722ef ]

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: http://lore.kernel.org/r/20231120104152.13740-10-bp@alien8.de
Stable-dep-of: c7b2edd8377b ("perf/x86/amd/core: Update and fix stalled-cycles-* events for Zen 2 and later")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f4373530c7de0..98fa23ef97df2 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -66,10 +66,6 @@ static const int amd_erratum_400[] =
 static const int amd_erratum_383[] =
 	AMD_OSVW_ERRATUM(3, AMD_MODEL_RANGE(0x10, 0, 0, 0xff, 0xf));
 
-/* #1054: Instructions Retired Performance Counter May Be Inaccurate */
-static const int amd_erratum_1054[] =
-	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x17, 0, 0, 0x2f, 0xf));
-
 static const int amd_erratum_1485[] =
 	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x19, 0x10, 0x0, 0x1f, 0xf),
 			   AMD_MODEL_RANGE(0x19, 0x60, 0x0, 0xaf, 0xf));
@@ -1194,7 +1190,7 @@ static void init_amd(struct cpuinfo_x86 *c)
 	 * Counter May Be Inaccurate".
 	 */
 	if (cpu_has(c, X86_FEATURE_IRPERF) &&
-	    !cpu_has_amd_erratum(c, amd_erratum_1054))
+	    (boot_cpu_has(X86_FEATURE_ZEN) && c->x86_model > 0x2f))
 		msr_set_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
 
 	check_null_seg_clears_base(c);
-- 
2.43.0



