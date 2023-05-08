Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EEF168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015B5C433D2;
	Mon,  8 May 2023 10:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542575;
	bh=Dw70lXX5xwC42VpQOj9Lt9Bo8BHCxzZFOJkwc5yELl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeHyJCHCBK9ANDX6SrSA0m0R3b+MSxLRVq3El1714whJr0263lnnljdWFWrDLmRlW
	 Euxd0norlZIIJnTC8hYME3dtkL86qax5vwmgGHC786ipJQqbhTow2WbJDHqi4rrLbt
	 1OtNLMlHDDO5GdbJs2Jptd2NmSdDk3ENEyi8QSkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 479/663] coresight: etm_pmu: Set the module field
Date: Mon,  8 May 2023 11:45:05 +0200
Message-Id: <20230508094443.864935016@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 18996a113f2567aef3057e300e3193ce2df1684c ]

struct pmu::module must be set to the module owning the PMU driver.
Set this for the coresight etm_pmu.

Fixes: 8e264c52e1dab ("coresight: core: Allow the coresight core driver to be built as a module")
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20230405094922.667834-1-suzuki.poulose@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm-perf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
index 43bbd5dc3d3b1..f9a0ee49d8e80 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -870,6 +870,7 @@ int __init etm_perf_init(void)
 	etm_pmu.addr_filters_sync	= etm_addr_filters_sync;
 	etm_pmu.addr_filters_validate	= etm_addr_filters_validate;
 	etm_pmu.nr_addr_filters		= ETM_ADDR_CMP_MAX;
+	etm_pmu.module			= THIS_MODULE;
 
 	ret = perf_pmu_register(&etm_pmu, CORESIGHT_ETM_PMU_NAME, -1);
 	if (ret == 0)
-- 
2.39.2



