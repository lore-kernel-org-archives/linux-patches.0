Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025321;
	b=2yHOOilhMIU6hP25k6rYZzzFYA1y/G+804sLnbV7m3l4LCiAo9Plo3YmPAkvg4rlqIr+
	 DUfAqwiBGBKmXXU9qjqZ/vWUgZHRghUkTuEG0gS7lEAxoK25b824BRK3vVuvHO6ipyfTA
	 xB7yrGRiXu4pgCAXTYZgkepKOBWssud1QjYPXn76nDNhBf74AvvcjE59qVOT0ezBgn64m
	 1vNTkBl4lKhiuFEC8wwyAfMZ3sfKKj5ky7YQYXH1KLmAl62nl56H/9CAjmH89PbHK6Kp7
	 cEHCEFZWIWOkLfyJRR21rBgf31ApqY2ON98a0ujYpK7BGRQJxAUpwKdKrEvXgPy7PZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mdGZPT7bFDPk72iK1bWcYfxqeHV0dnjAWOFT3vXijbQ=;
	b=k26G669ZBdiCjkeqwvvZyVj2mwWLZ2tZUEoWxe+dpS6ViGAzo32w1xAYsMd6SFT/tH9R
	 SEOMSUvl7uFRw7q/h5EAsiasTPXA4cBCV0p08cCw7tKLpreR2oBXt+EbESqQPrMt/6qA1
	 kXWSNoX5aYhoLVcN+AJ03w5dsm8TbS9cXawgzc3ybgMlVtFRFywhU6w2Chh9H7wW/MIRb
	 rszg6iAim+fVjiUz3/2yC/+3y7P70x7eERpSByCcKAnuSb0tc2Kiwf2LdIVdnwiiolGU2
	 GicsbVvu5m+0yqABP4XwO6yNHXuGYNRu/jEQI4BGn/ylMcMfD+HKukOEt/u1VY9giFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zSbXuZfn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D789606A332;
	Wed, 18 Nov 2026 18:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zSbXuZfn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DC11F000C5;
	Wed, 18 Nov 2026 18:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025321;
	bh=mdGZPT7bFDPk72iK1bWcYfxqeHV0dnjAWOFT3vXijbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zSbXuZfnaknQq1dIbKp6jdEQk/4KYx4YjzT/pTElPednRhMdIO42DkpKN++6irtRg
	 IGuRM8ldL/D5GY9jk+CVpCi5CBAX164JTJLj/hepKXXLZL/dBzLnOUmqElYLcxlCro
	 E6IDwcIrSSsBTjuRNXZviQyGlWnvsrg4VyEqpak4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1038/2151] perf/cxl: Program the requested event group on configurable counters
Date: Wed, 18 Nov 2026 15:46:13 +0100
Message-ID: <20261118150200.157200089@linuxfoundation.org>
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

[ Upstream commit b22dcc11429866e07dc54299255e8ca13c26d38a ]

cxl_pmu_get_event_idx() sets *counter_idx for a configurable counter but
never *event_idx. hwc->event_base stays 0, so cxl_pmu_event_start()
programs event group 0 no matter which group the user asked for.

Return the matched capability's event_idx.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index 39b46550a5109..eedc94616531a 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -513,7 +513,10 @@ static const struct attribute_group *cxl_pmu_attr_groups[] = {
 	NULL
 };
 
-/* If counter_idx == NULL, don't try to allocate a counter. */
+/*
+ * If counter_idx == NULL, don't try to allocate a counter. Callers that
+ * allocate pass both counter_idx and event_idx.
+ */
 static int cxl_pmu_get_event_idx(struct perf_event *event, int *counter_idx,
 				 int *event_idx)
 {
@@ -541,7 +544,7 @@ static int cxl_pmu_get_event_idx(struct perf_event *event, int *counter_idx,
 
 	pmu_ev = cxl_pmu_find_config_counter_ev_cap(info, vid, gid, mask);
 	if (!IS_ERR(pmu_ev)) {
-		if (!counter_idx)
+		if (!counter_idx || !event_idx)
 			return 0;
 
 		bitmap_andnot(configurable_and_free, info->conf_counter_bm,
@@ -552,6 +555,7 @@ static int cxl_pmu_get_event_idx(struct perf_event *event, int *counter_idx,
 			return -EINVAL;
 
 		*counter_idx = i;
+		*event_idx = pmu_ev->event_idx;
 		return 0;
 	}
 
-- 
2.53.0



