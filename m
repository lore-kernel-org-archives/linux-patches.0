Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030769;
	b=cVgDK2yku6tpbLkpnHyTQq4qeQjLA8RkDjZN7KHbkycrEzRoMgvR3vLrmXvUCUZR1vrY
	 C31WYFjtSfR713jkQf6TnATWKKJ62dO8z1A4gcl9T4Yfn2d0XmRFuj78iK7r0FoTzZhlh
	 4HsMb6uHl/lybmCog3AHkVVSzjSm5SwDF5zGqSVDxmlvqG1Ip3sGCos2li82altZ4fEWx
	 9lbS/r9vF46ZnsBeUwBt3pFPsFo5l/unMRpLCrUrDln1FBbMOw5IsOdL/4wdk557EgLCe
	 DR174MrD7E3OKWpEdmvMPc//ARM/FQVPrRFUub7tOxvz2tDXCxh89usWjmAY87cTkuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FrpdKWncXCd/mrr6nPtBZtlo1HnAzSrGqpPrI/jwRbE=;
	b=Fx4m1tLgKurdA3tswubIpCilCMgEnCEAIuapzzR2gah9q7qGV+8diTzwA3tsqduha3xn
	 aC0pzMaKgxZDAUaWBG1XBEC9n2Fmgy+bzHd2/2Hsxpb24P1MjkndiPb6u7PBSYl/CJt3G
	 b1xUhjExjl813CpSGjgEYUHYRZwphJlLK5CX8W0ZAspa/15JlXNAoFyzkjhBF8K7OlzqL
	 qS5R1Is1eYah6mZYlnSs2fhLEttmTrwrKIdThywi1rZVGg7WYut3VQPDCs7Fnltnk+sdX
	 egDSAOsVNlgcdIjmvJNvsvuMAXlXQjDW6ztG31bL9Sir9CtdtlMZarvUja5l8UZ6aQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTeGSavm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3E4606A932;
	Wed, 18 Nov 2026 19:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTeGSavm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317551F000C4;
	Wed, 18 Nov 2026 19:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030769;
	bh=FrpdKWncXCd/mrr6nPtBZtlo1HnAzSrGqpPrI/jwRbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTeGSavmaKsScZsXRADAkhMB9Y8fPgc7d+ISenUzYU4SkuU2Zv9jS4zoj7g3thJJz
	 FAyx6cUfAuoXpL8ofApymrBozFyUIU5rS0tFjde0RrnwOp2usbck54imFtWYz3E/+X
	 GS/distoUBK80lFPiJJzsHfP7NNsKAKepHnqkJDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0821/1756] perf/cxl: Validate the hardware-reported counter width
Date: Wed, 18 Nov 2026 15:49:08 +0100
Message-ID: <20261118150042.247823166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e5ce595a965d4..aec8bacd212c8 100644
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



