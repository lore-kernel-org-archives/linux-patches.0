Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018493;
	b=K1CMsB4GcYRtZq6iMM1TowXdpAn/Yr9udU3PSJa91jDpAZ0lYD8GH+9FJApkc19/CFOi
	 APFLpzTCWcTnmFN4lQ+G4G0q1DcLGaJF2/hZU8Rg4PTE52a/dgl6a+MIiL9M/3huGIT9h
	 OdzKTQNXhJulRMZfEQ9JQ3cF408qBHhYSvR+J2HMHsgxi8JXnfNybdOV0DnNsjpIanrF9
	 iQrFiJ9eiKk4DYN5DLWaWSqJStuHd22p/OxMn82x8pzqHWIy6MRiWEeojzSwAH+AcdaeM
	 ld+OWTAUtspF2pvrE9JZUVXfk9c/1TF0b45LsfZj9WwW56uq2wMXMbmDB8kz1MKXOIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hxbOyzSN8eIdvpIMinb2t6LZLE0CseubakHCtp+yfxA=;
	b=FnBlcaZG4zub9zAeMBXacaOoTtLVjr+l705VIhCrBQf2FQ39vG73BLJizsuRQoOcipRL
	 CaaV5DZaB/shJSIwQaydXqQEptSHWjPo+5hAs/IET0locKELmDXavqurwcxcnOtYTrYJE
	 dfZ9wpVZ9yQEzQaegBu60q+N4EepENOYX0mFbdkM8AOX8Imo4NKQdMLuY8SBpV+fFO1d9
	 34NMrxdK1P1VZlpXRILohPepv2WIXFrbibJWbB8glrXYcO+QMrs7CITpoE7tDHfnXc0RH
	 H5ZgMQKRBCEHka7mG0q+OV5KM1FFgpz4XUg4UhoDJSweaWLkCo/FfEtcPWJoKJkviFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g34eR9ag;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6568606A325;
	Wed, 18 Nov 2026 16:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g34eR9ag
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B411F000C6;
	Wed, 18 Nov 2026 16:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018493;
	bh=hxbOyzSN8eIdvpIMinb2t6LZLE0CseubakHCtp+yfxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g34eR9agrTvXp+IqTKkhfnIEx1zO7mMpC1iC1neKTrj87H87/1b1HusGYNVmeDuOy
	 4K8qATPU/81utWVAQUjcrQrGehNrWzY5WpmxrY83O7gvXOQSai5+xO154r5YkHw6mO
	 7WnfiXD5fab/RdLlL2YMY+h71KzSXaFmL8+PpRfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1258/2651] perf/cxl: Validate the hardware-reported counter width
Date: Wed, 18 Nov 2026 15:41:38 +0100
Message-ID: <20261118150333.271708875@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index a351fe79fe962..99a1ce471acbd 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -146,6 +146,15 @@ static int cxl_pmu_parse_caps(struct device *dev, struct cxl_pmu_info *info)
 
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



