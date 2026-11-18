Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018474;
	b=W36pFdWcJf+j4hUDdteiaqsVzoQaPC3Yc/Icltp81ZUdsCQY2wF54WP/iqUC+le6G0ut
	 IHS5ZhQ2E/lU33SpwoU+5a4YQENzIH6+94Q9wkYCtnYDb+r1+JYKCyhSQvC9xUsgc3IEr
	 5sC0Qofssv98HlUL3Qf11weQ/TbIUAoCkIQttCn3nqJfMNhsuLKmkMXLC/K0AQCp1H2/F
	 MWMT9kUK+JYKHiov801//GxHNt9CHUM1YlJJtIYNxS8JtpkVUItDxUXkkurUv+JlIGvbl
	 SwhPqW81v0JlxDy1xQQ5POsEzgl90C3gJMmp2pXS9UjL+HZTIPvBXXrsjbHEwP91a/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OcXkSM1L1Vrq0TB4qS25wdxTrKiYqmYgiBZAENSnheM=;
	b=Ut4VLkXuFuA2ryN4HKQZs9DSeLY4qBdjz0H8ihQMWuxYgTeAwKtkh9Efy8vI0CSTjXXC
	 2sV9yz6nezaKSfhoeKDnoP0vtj+nn3d8dJgUYdtrngJdRnm6s09KS+BUdZ5bAk+XLPANL
	 Z3d7ilt+YOMXjHWH9VSCYCuGgY/i7opLDNtG6P1x07g8patff4hCsnu4p4eZjXKOiMIY4
	 /VfNn4ZE7NN779FN45C3w93YhxWojufitnZiNeFCwhSJ5AIJxSeHgxOZfy4BQBPv66ibY
	 2j+TgiCqjRCdlsKEBMRMJhIHBG3zv/rlB+vffnOoC6/uUvdX2pBerijeDMyCJj9yS5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dfp7jhzc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BF1606A334;
	Wed, 18 Nov 2026 16:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dfp7jhzc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC5F1F000C4;
	Wed, 18 Nov 2026 16:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018474;
	bh=OcXkSM1L1Vrq0TB4qS25wdxTrKiYqmYgiBZAENSnheM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dfp7jhzc95givDG3ZT3sts0Y8dmCiBSYP+72tilc1u72Aah3lqnh1/37ervaNZ8JA
	 TU8bK0T9il5Fox9PqHOU6lA+nfxGLyKNYTBO7pnNLRgFfYpnDUNnUud5ACegGVhE9f
	 IbSLkLSDdMqMLgw0uW/Ral6olG2jLXN8ElRGR7z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1252/2651] perf/cxl: Program the requested event group on configurable counters
Date: Wed, 18 Nov 2026 15:41:32 +0100
Message-ID: <20261118150333.051003364@linuxfoundation.org>
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
index 2c8a03cc11e4d..2a5635e4e39f8 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -588,7 +588,10 @@ static const struct attribute_group *cxl_pmu_attr_groups[] = {
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
@@ -616,7 +619,7 @@ static int cxl_pmu_get_event_idx(struct perf_event *event, int *counter_idx,
 
 	pmu_ev = cxl_pmu_find_config_counter_ev_cap(info, vid, gid, mask);
 	if (!IS_ERR(pmu_ev)) {
-		if (!counter_idx)
+		if (!counter_idx || !event_idx)
 			return 0;
 
 		bitmap_andnot(configurable_and_free, info->conf_counter_bm,
@@ -627,6 +630,7 @@ static int cxl_pmu_get_event_idx(struct perf_event *event, int *counter_idx,
 			return -EINVAL;
 
 		*counter_idx = i;
+		*event_idx = pmu_ev->event_idx;
 		return 0;
 	}
 
-- 
2.53.0



