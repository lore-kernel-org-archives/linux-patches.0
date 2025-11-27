Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9FF28D830;
	Thu, 27 Nov 2025 14:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255418; cv=none; b=n6nG/K98PXy5taSXd7kpViK/PVoh1XqmDxBRcDJ5V/yM5DxeL/aIgJgNKpAS1BIpPEqw5ZkFM6rQlxrCtO0MJEew9P4cngeOc6G8fz7Ix0iuGYpPcfkckFAmscvFtorgzu2P9ySuu9pbSJIL5+hdkUjPSwzez6PNiLTzfHMAmEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255418; c=relaxed/simple;
	bh=b0nbNU+6HoKlyaEoy/PY/l2w6K36vUz3IgyNT97ygrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkhYRgmIlesa3bTcLwkS08Df7Cqswb27AKjV/Da7Gq1y7DIKASc3OhsNI5V7QnKHFWd3J31rHjVyClIIuCeymLYqMitHQS/eHWv76t3wvPSxJAFbs7ImJRFkleiQxsZhkz//Y6g/UChxMUzb+51cHUuKj+wqIkHt7hoqaROLg/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVzhBwXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVzhBwXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DEBC4CEF8;
	Thu, 27 Nov 2025 14:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255418;
	bh=b0nbNU+6HoKlyaEoy/PY/l2w6K36vUz3IgyNT97ygrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVzhBwXBpogUrjt8paIlNMtkZa3BlH2Us91vj2SiAVX9zZ/8RRf2oHzWbHjf0turD
	 aJxsIgSBjGxPkFJ/+hC0RyxQyApGPBQmMx77Dl/Zh0QMoUB1a2FrHDY4ejyCSqRgaw
	 Mp4of7rc2SSB4xjhW+RP1A5xq/914qjKD9j9XD/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Pei <cp0613@linux.alibaba.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/112] tools: riscv: Fixed misalignment of CSR related definitions
Date: Thu, 27 Nov 2025 15:46:08 +0100
Message-ID: <20251127144035.257990807@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Chen Pei <cp0613@linux.alibaba.com>

[ Upstream commit e2cb69263e797c0aa6676bcef23e9e27e44c83b0 ]

The file tools/arch/riscv/include/asm/csr.h borrows from
arch/riscv/include/asm/csr.h, and subsequent modifications
related to CSR should maintain consistency.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Link: https://patch.msgid.link/20251114071215.816-1-cp0613@linux.alibaba.com
[pjw@kernel.org: dropped Fixes: lines for patches that weren't broken; removed superfluous blank line]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/riscv_pmu_sbi.c       | 2 +-
 tools/arch/riscv/include/asm/csr.h | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index da3651d329069..6df8b260f0702 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -1016,7 +1016,7 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
 			/* compute hardware counter index */
 			hidx = info->csr - CSR_CYCLE;
 
-		/* check if the corresponding bit is set in sscountovf or overflow mask in shmem */
+		/* check if the corresponding bit is set in scountovf or overflow mask in shmem */
 		if (!(overflow & BIT(hidx)))
 			continue;
 
diff --git a/tools/arch/riscv/include/asm/csr.h b/tools/arch/riscv/include/asm/csr.h
index 0dfc09254f99a..1cd824aaa3ba2 100644
--- a/tools/arch/riscv/include/asm/csr.h
+++ b/tools/arch/riscv/include/asm/csr.h
@@ -167,7 +167,8 @@
 #define VSIP_TO_HVIP_SHIFT	(IRQ_VS_SOFT - IRQ_S_SOFT)
 #define VSIP_VALID_MASK		((_AC(1, UL) << IRQ_S_SOFT) | \
 				 (_AC(1, UL) << IRQ_S_TIMER) | \
-				 (_AC(1, UL) << IRQ_S_EXT))
+				 (_AC(1, UL) << IRQ_S_EXT) | \
+				 (_AC(1, UL) << IRQ_PMU_OVF))
 
 /* AIA CSR bits */
 #define TOPI_IID_SHIFT		16
@@ -280,7 +281,7 @@
 #define CSR_HPMCOUNTER30H	0xc9e
 #define CSR_HPMCOUNTER31H	0xc9f
 
-#define CSR_SSCOUNTOVF		0xda0
+#define CSR_SCOUNTOVF		0xda0
 
 #define CSR_SSTATUS		0x100
 #define CSR_SIE			0x104
-- 
2.51.0



