Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A2C1C6AB;
	Mon,  4 Mar 2024 21:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588315; cv=none; b=ubgkexSlg2v+JQma8vi4BpaDn+t6WMpeuJqHr+iy69Veatz4Z6nRR8GqPj7Bz9b+dZmYeNw1DpZmwgKc99RzPxSMfboUO41jw+QTvAbIVXubZON+bQJEoN2cMHX3hZV4oLyzztwYu8BitfZkGZR8W/LFqnBCLjsEsgKlDJovi7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588315; c=relaxed/simple;
	bh=KRK8sSuKJgaZt3Mne677eF5ocvjk/emfbleeXwCjQ7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HloQfxLX5YIPu+axUclbA29BmztCEzoCLL/3K8JULszeV/BVbdMXpj60qTFTXSJ5DQhVSvVmZ9L5rEPjgLE6c2L+zbr+sVOcFDFrp6oZDM2NPaGf+NochNIuhvxu4tTPboAx4EcRdGemtjgCwzZ9WUSPR+kRl8Idrx6u20bfRCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFFfpxPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFFfpxPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BE4C43390;
	Mon,  4 Mar 2024 21:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588315;
	bh=KRK8sSuKJgaZt3Mne677eF5ocvjk/emfbleeXwCjQ7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFFfpxPEv0J5WtqROlsLMqrhbGxcv9VWzTu8pFYLvbxGK7EIxgIYsUVQQBtr8FEMa
	 HlhppSGYJ8BDn4HsNUIpBHDpRGcGEe3cdqgaDtsakDm0V8l1ORrflfiAH95KGMu+IN
	 bdhF2JXxYrlznzSGbzrxuQK/leVLzxHfsYC4XFik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Vadim Shakirov <vadim.shakirov@syntacore.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/143] drivers: perf: added capabilities for legacy PMU
Date: Mon,  4 Mar 2024 21:23:01 +0000
Message-ID: <20240304211551.878049190@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

From: Vadim Shakirov <vadim.shakirov@syntacore.com>

[ Upstream commit 65730fe8f4fb039683d76fa8ea7e8d18a53c6cc6 ]

Added the PERF_PMU_CAP_NO_INTERRUPT flag because the legacy pmu driver
does not provide sampling capabilities

Added the PERF_PMU_CAP_NO_EXCLUDE flag because the legacy pmu driver
does not provide the ability to disable counter incrementation in
different privilege modes

Suggested-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Vadim Shakirov <vadim.shakirov@syntacore.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Fixes: 9b3e150e310e ("RISC-V: Add a simple platform driver for RISC-V  legacy perf")
Link: https://lore.kernel.org/r/20240227170002.188671-2-vadim.shakirov@syntacore.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/riscv_pmu_legacy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/perf/riscv_pmu_legacy.c b/drivers/perf/riscv_pmu_legacy.c
index 79fdd667922e8..a85fc9a15f039 100644
--- a/drivers/perf/riscv_pmu_legacy.c
+++ b/drivers/perf/riscv_pmu_legacy.c
@@ -117,6 +117,8 @@ static void pmu_legacy_init(struct riscv_pmu *pmu)
 	pmu->event_mapped = pmu_legacy_event_mapped;
 	pmu->event_unmapped = pmu_legacy_event_unmapped;
 	pmu->csr_index = pmu_legacy_csr_index;
+	pmu->pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+	pmu->pmu.capabilities |= PERF_PMU_CAP_NO_EXCLUDE;
 
 	perf_pmu_register(&pmu->pmu, "cpu", PERF_TYPE_RAW);
 }
-- 
2.43.0



