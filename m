Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025338;
	b=eRJtSd73NijMoKNvHa0u1Kxnxfdayq42TfKNDhASOLQDfpMvbWz+nklAI6qRX5LQW347
	 vrQ4sAnqb/GRc3RX+Us3ouM6XmaKwZ09YWD+uYc31HG0cHw9cfqUcPvtdn0xpkROmYSOA
	 8sAGA8HCbaWC9zPYaxjzACPNBOuDb+vqZxwybXbf0cAcHNXKDl6m3MYiwuMV+gCJh1OXX
	 HP6QrpwgsKzFw9FKZ5XSL2Q4Qid+LVYxn0o/KHYOtZ/Z/slDE945g9xrEZncXHHfRpdn8
	 TnytMjAYR/32MqrXDXCon1RQYFL9+EbN1NuolHEaYXKo8xeNACaHyWw6zj4L1UU4+RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zf0hnL55+0/17/f009gnB0rSM760MWS7l5tjO+t/sZE=;
	b=UxXOcn3BpnAuis1DlILMdC5PPtnXiGFmC/leWqpNRYvaWT6eAWdvKhp3w4DLAP4j2XiW
	 nfMmUh94XEn5e5Ye5aAM8qqRrncPUol/nkEnQQAFMVWYpgo4HNj4t36VtUHBTI3uOPr1R
	 Kwk1fNZM2B0mKt5/W5mOIrKxiBmDePl2uLSOYYGgv0Lw1UiT67xQ2c8mKxyF+jlDaL+Jp
	 jXM+sAV+LElgXn+jSvQu5YBMpqY+R8dYqomQ+lnmqW2sLohBf3aavb0JwB3xK0s/k1OJ/
	 uZQgywDsP0ViZG03u5e4U3pqvgHLw+CTdObPun8gLmmEyKpEf9c5ioHcQfgFtAd00uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qD1umf0h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A305606A32C;
	Wed, 18 Nov 2026 18:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qD1umf0h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8351F000C4;
	Wed, 18 Nov 2026 18:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025337;
	bh=Zf0hnL55+0/17/f009gnB0rSM760MWS7l5tjO+t/sZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qD1umf0hveRA7Sw1u1B4zZtShDL2a/fhyd5RP2s8JTO0kV4yRBO+FnLRCN1cW8CCq
	 S8K/G+zABPzcy50Rdsm4DOAt+E5DEP+5UFjP1xPanjt3z2LiPUD7UG9ZrzDpWMyGIJ
	 kBixnZ3dLVWB60TltRiYiAIrFHRcLCzK25nw3ldk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1044/2151] perf/cxl: Validate the hardware-reported counter width
Date: Wed, 18 Nov 2026 15:46:19 +0100
Message-ID: <20261118150200.361285678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 1c5499e67303a9393388197fb14b39ed06a3dc55 ]

cxl_pmu_parse_caps() takes the Counter Width straight from the CPMU
Capability register without a bounds check. The Counter Data register is 64
bits wide, so a device reporting 0 or more than 64 is reporting nonsense,
and GENMASK_ULL(width - 1, 0) in the read path then shifts out of range.
That is undefined behaviour, and a UBSAN splat where it is enabled.

Reject a counter width outside 1..64 at probe.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index 1d2bc25155929..2164b3b2d1ffd 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -141,6 +141,15 @@ static int cxl_pmu_parse_caps(struct device *dev, struct cxl_pmu_info *info)
 
 	info->num_counters = FIELD_GET(CXL_PMU_CAP_NUM_COUNTERS_MSK, val) + 1;
 	info->counter_width = FIELD_GET(CXL_PMU_CAP_COUNTER_WIDTH_MSK, val);
+	/*
+	 * The Counter Data register is 64 bits wide, so a Counter Width of 0 or
+	 * >64 is invalid. Reject it rather than let GENMASK_ULL(width - 1, 0) in
+	 * the read path shift out of range.
+	 */
+	if (info->counter_width == 0 || info->counter_width > 64) {
+		dev_err(dev, "Invalid counter width %d\n", info->counter_width);
+		return -ENODEV;
+	}
 	info->num_event_capabilities = FIELD_GET(CXL_PMU_CAP_NUM_EVN_CAP_REG_SUP_MSK, val) + 1;
 
 	info->filter_hdm = FIELD_GET(CXL_PMU_CAP_FILTERS_SUP_MSK, val) & CXL_PMU_FILTER_HDM;
-- 
2.53.0



