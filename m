Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040691;
	b=2ayTTuJOT7SS4wPXpI9u/zkh6hAmTExx+10KrcGXyuVz7N7FqUoPgFmXLbya5vm+x1y4
	 eyIz9fbzHWQfTM7jxmI9LpRt0QGG0YFmZMlNAm6tHQeUjfiIvooRzNgmen0p/9rrK4QcN
	 M7dR4aVGrYfhKxbPMNXTdN/luBitqJe4Tc3vGfbkr3OrGnRJcwUSasNCPpN97ez5xhEiK
	 pSs6rPqHoeuh8LF5jJ/t5fUTj4mVajwK5hYZiHkRjBegTORKH/3QX2lI0pspRB1iU7HeQ
	 xrKabodP/yyLlbKBOrGgjn5RU2eNigAUcLzM0nQom812OdP0296i2cvK9iSNejbM30A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=92sOR57sXqn8V+bBzRGNfS+D/0q0axDcvrokKcR/XmI=;
	b=4O3jEYilYoFha1Q5D/qpFMMmPeYvbmB2OfgraQENq+g2uPZ2ZWy0ZH/gE0em2JEw++6D
	 17onTZB7Vc89G6cQSbeFs2krmNvY36Nl5d5LoHS/rq2pgfOAv1iqXMCEWfv/gyKtMvm6i
	 s0WmmFy1+guCdIERv4S+4DCAz+IJi7KJ5GzmjJoGn4dMnT7kArz3KihMyE1upJGSjk9Cw
	 r8yQCj0HIoTvfGsXp/DesiJ55MQF952oaktVWDjzjOcBF+staYHMIO1MOf+bGjx5Wfot7
	 8zK4aC92yEWm/F+K/IOkVpWrvxzFZKpqsgXtUj1WauO32/STY87X+KvasqvEft3xuRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NrNjfK58;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CFB606A32A;
	Wed, 18 Nov 2026 22:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NrNjfK58
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274B11F000C4;
	Wed, 18 Nov 2026 22:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040691;
	bh=92sOR57sXqn8V+bBzRGNfS+D/0q0axDcvrokKcR/XmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NrNjfK587i83V1qwfd48/qwVHQ97Ug2Fa5Wptv23RT/1IFzUHNLiMrepznYswKPox
	 DzMNdVQobVDItW5R9aoT85iR4GKBpFfmGijXq6imbYxj7gXWGIVVABoUfKFKWxuaNZ
	 R6NWccfU0eXVjie6+sLJRorAmOmLRhtCFb0L4ymY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2548/3318] perf/cxl: Validate the hardware-reported counter width
Date: Wed, 18 Nov 2026 15:52:50 +0100
Message-ID: <20261118150437.735739589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4ee39a80e73ac..261311dd47f57 100644
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



