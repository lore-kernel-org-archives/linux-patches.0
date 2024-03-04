Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F087C083;
	Mon,  4 Mar 2024 21:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587784; cv=none; b=nxvwk0SeGWNfCV3FSrzaKc6oaR52av6H4iQ+Y+lgHw+EtbwrScYX9xKGKc498UNti40pvmjDzNUIQZ2IZxI1ct99NjkgdAfZ547RwNv+JrBYyG+F1PUs8cpX63F2dw5R3jK3zSFuIVIQLTRiwCDdmzrQywOHiRxXzLFS3jgmqGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587784; c=relaxed/simple;
	bh=+QHZ3go9iyUwVzevPXSJSOLYDDVeFqjFh2Ad7RsjQSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnVVujD7VEsYAH+Nvi1WkyOGkR2aVmcAEdtwzj4TVouR1o6tfHpiz95iwyXWubOxASyWyK7iWYejV/Iq2dg0cExUDsdcm6oPfEiYiHvmMiu6jgMu/quLmgu1oXusPZ23fHS7rJnyEuGqdBgLy5fDYq3Uxb5GxM5+m6uz3bGa5Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=coxyDvhc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="coxyDvhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402BDC433A6;
	Mon,  4 Mar 2024 21:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587784;
	bh=+QHZ3go9iyUwVzevPXSJSOLYDDVeFqjFh2Ad7RsjQSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=coxyDvhcY8XoUiHO0HeG6M0Jg4xJAB7TYXlRJe0uMC1K6oUS+3CXvLa317dPGBaLJ
	 Aotlmy0hATyCpa143LPESL+8XTsPqLrWiA5/mxwpRWMxaxhw2Wmwblq7q4MXR6UW7f
	 CL2PpXyvQVg3QSNuiSHDpqPvStf0+s0GtLEKr148=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Vadim Shakirov <vadim.shakirov@syntacore.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 065/162] drivers: perf: added capabilities for legacy PMU
Date: Mon,  4 Mar 2024 21:22:10 +0000
Message-ID: <20240304211553.930665039@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



