Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFCE1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627B8C433D2;
	Wed, 28 Dec 2022 15:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240377;
	bh=Qnz2Q2W1D4s7Im2sMTjlrRPEJ7DyXob3fGrWZMetkvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nfsdg2FrCRBoGxEkfo++OndEJsJI/f89/dKOyb/OXreoroXulxb5ZfxYMFl55tNBB
	 YQTnBD9fOUy8etCSaIcwj6u//oxIhKfixV82yTP2UiHHkiw524lHK3on2Msuvfd+AU
	 /oSACVKZ3DhstbMokvfUKajLET+SPHcwmPAk+Y20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0094/1146] drivers/perf: hisi: Fix some event id for hisi-pcie-pmu
Date: Wed, 28 Dec 2022 15:27:13 +0100
Message-Id: <20221228144332.696298975@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit 6b4bb4f38dbfe85247f006f06135ba46450d5bf0 ]

Some event id of hisi-pcie-pmu is incorrect, fix them.

Fixes: 8404b0fbc7fb ("drivers/perf: hisi: Add driver for HiSilicon PCIe PMU")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20221117084136.53572-2-yangyicong@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/hisilicon/hisi_pcie_pmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/perf/hisilicon/hisi_pcie_pmu.c b/drivers/perf/hisilicon/hisi_pcie_pmu.c
index 21771708597d..071e63d9a9ac 100644
--- a/drivers/perf/hisilicon/hisi_pcie_pmu.c
+++ b/drivers/perf/hisilicon/hisi_pcie_pmu.c
@@ -693,10 +693,10 @@ static struct attribute *hisi_pcie_pmu_events_attr[] = {
 	HISI_PCIE_PMU_EVENT_ATTR(rx_mrd_cnt, 0x10210),
 	HISI_PCIE_PMU_EVENT_ATTR(tx_mrd_latency, 0x0011),
 	HISI_PCIE_PMU_EVENT_ATTR(tx_mrd_cnt, 0x10011),
-	HISI_PCIE_PMU_EVENT_ATTR(rx_mrd_flux, 0x1005),
-	HISI_PCIE_PMU_EVENT_ATTR(rx_mrd_time, 0x11005),
-	HISI_PCIE_PMU_EVENT_ATTR(tx_mrd_flux, 0x2004),
-	HISI_PCIE_PMU_EVENT_ATTR(tx_mrd_time, 0x12004),
+	HISI_PCIE_PMU_EVENT_ATTR(rx_mrd_flux, 0x0804),
+	HISI_PCIE_PMU_EVENT_ATTR(rx_mrd_time, 0x10804),
+	HISI_PCIE_PMU_EVENT_ATTR(tx_mrd_flux, 0x0405),
+	HISI_PCIE_PMU_EVENT_ATTR(tx_mrd_time, 0x10405),
 	NULL
 };
 
-- 
2.35.1



