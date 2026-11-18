Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030750;
	b=0RiZ9w9T+YH3Nd+XivxAMv9DouwJKOVvkCmtScsNyWnBxJg9V9bZp6thH8zoZyL4ZTJK
	 guIGC/2ztWAa7KQfeCOoGNgZuMjK37RtCYuvaIevDQfQg+rIba+6MuAwCST07Mxx9N3oT
	 LfO+Xfi3j/Y4ZwbbdheeNxs91SZ1sntCzTPd5SnbENRS7X8bs4bu2grkXouoLMMELmZpt
	 aOdlr+640L05SpuW6z7g23hHHtknCA6zq1t5fDKMF0q9+GG87aG3XtVPViQvpL/wHK8pB
	 Xuj6/L/8WS6LlmpBJjiZ6i7OSHIe99DNHhcqez7WWaF+B1ifSq19+TVyfveAyBfBwhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iwC8qzofi5zHKZqbnC0WpVSCRmPyKgQ1iqJYgyIjCB8=;
	b=cWAnDUvUCftoLhFRHcME61zsDmxI38hKV7gU2/cbIrtzBOJdttWclRVKb7kSZEyv37cE
	 vZ5m3Kh3vvqQ6qMSmvE7oanWhWZluPggKook7GCZDMTmtjiDsU5UckmG9Npy5bstW8R6j
	 fhn+r1MdeWGMtYAeqFRfFk/GeFBouCG7vbIWYdqGS8xpEj4weZUBVq3/wWBYCrtImIe2m
	 B+o/wWa39JpnaXX97agnFUXSrM5Y03SLcfb7RnCntsJd31i297b7qJC9ApoYaUbXhGd2Z
	 og72Xjhe3tKfPJ626jgIdHkkXyCRfmSx/tWN7YL2iHn/AlXJvMF9IcNvTdCjiDntDPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U67xADTG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FDC606A918;
	Wed, 18 Nov 2026 19:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U67xADTG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3C01F000C6;
	Wed, 18 Nov 2026 19:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030750;
	bh=iwC8qzofi5zHKZqbnC0WpVSCRmPyKgQ1iqJYgyIjCB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U67xADTGkrQuKFOd8jgPrvAVTrsAiPpKdimOQ9GkND10ITyS/CAcTX/Ry4jRrGMOJ
	 d/31SUXUwV06y5mX6rhQSyH+SlXxy5zKaU8a0hDc9z/yScfni2EBbiXRByIO5QdiWg
	 LH1fGYybQH+ryamWSJ3rbARdn0rKXNqmsW5WcTmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0815/1756] perf/cxl: Program the requested event group on configurable counters
Date: Wed, 18 Nov 2026 15:49:02 +0100
Message-ID: <20261118150042.038361200@linuxfoundation.org>
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
index ce97062a66190..968b72dba88a0 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -510,7 +510,10 @@ static const struct attribute_group *cxl_pmu_attr_groups[] = {
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
@@ -538,7 +541,7 @@ static int cxl_pmu_get_event_idx(struct perf_event *event, int *counter_idx,
 
 	pmu_ev = cxl_pmu_find_config_counter_ev_cap(info, vid, gid, mask);
 	if (!IS_ERR(pmu_ev)) {
-		if (!counter_idx)
+		if (!counter_idx || !event_idx)
 			return 0;
 
 		bitmap_andnot(configurable_and_free, info->conf_counter_bm,
@@ -549,6 +552,7 @@ static int cxl_pmu_get_event_idx(struct perf_event *event, int *counter_idx,
 			return -EINVAL;
 
 		*counter_idx = i;
+		*event_idx = pmu_ev->event_idx;
 		return 0;
 	}
 
-- 
2.53.0



