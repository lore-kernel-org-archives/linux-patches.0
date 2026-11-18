Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027691;
	b=Y3uW2kHJ35N98Gi4oS3C9m5kyU8FNtZ2M2cetROIDrBJDXy65f0UJobrFPZbTKodjF6n
	 05ZVbtCWTUh8mEMlZ96uJPrFI81d34C9E/FO1jMeVbHXvNipL88nAUoroteAyYtEPf8vl
	 JhNjwbG/oyNwvHP54bSZjBpGhuC0dcfdCSciJ8YwkLdTRStozo5cdfrROlzNIRKl/K984
	 05+BjF2/N4BHRoyWGLHcouGbUxxR6BqSFS2x8rJn8evhKqa/JD7YvM+YgTidd5bgOr5UI
	 yUNIIhVvUbVOWj2nKdfnRAax+s+zfvNRJwaFU3hQ3UYMY6mBuom2wPEH1Z+F+iBHDNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CTq3abGXCRUsmnIwTTgb4J3eESAWGpzvZjV9Ky5FcJU=;
	b=K1JTVGL3V2zwWNdYJ6qxyl7O1vYLXfXpIZrWf2cpud/pp4x85XcJh7BhSrpMTA9NW5jZ
	 4dDSlTxLh7CdVamPOG4IWnlxFDP+u8V+OWA5cJVTnlcggpkPZsCASwLOlesjHPF3nLCRt
	 AELcVpCXe2jOS2q5EhnOU9zhB5rhH7aSkGFI5IxKrKS4kSYaVICow+meyo8O/f4oItF5+
	 Ro25VQROwvnIRtrGehlaHzeRnTbPMdiXvPL7Prujv5rOvDhwH8QYF9BqgQtx+2IyeCCOX
	 sd8xcpL5ejlPnPf7WOu1uDP3JsxFxvosRgsrquplS/lihp/BGFiGfSz9951dawguhVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qHBX96KT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86425606A335;
	Wed, 18 Nov 2026 18:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qHBX96KT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF9B1F000C4;
	Wed, 18 Nov 2026 18:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027691;
	bh=CTq3abGXCRUsmnIwTTgb4J3eESAWGpzvZjV9Ky5FcJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qHBX96KTglR4C1yENZ9g4lnbbOPsg528/f26xJvNrJ/kvfWLSZtBH6GzId2cSRxKj
	 SoOexw5wXKM70W5XTPdGKzHG/E+pc6OXrZCAKHuPCVzzywkDoc1Zp9WczuPs4wqNOO
	 bbtDRjjbYpN7FV6f+uYXSMPkzV4KvINdQ6Y9pr5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1880/2151] perf cs-etm: Dont add global v0 HW_IDs to unformatted queues
Date: Wed, 18 Nov 2026 16:00:15 +0100
Message-ID: <20261118150230.283429057@linuxfoundation.org>
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

From: James Clark <james.clark@linaro.org>

[ Upstream commit 31627cfb63ae4af5a233dc6ced04e5172789aa92 ]

In the case of mixed formatted and unformatted trace with v0 HW_IDs, or
no HW_IDs at all resulting in the cs_etm__map_trace_ids_metadata()
fallback, formatted queues will write their HW_IDs to unformatted
queues. This will result in an assert because of multiple decoders on an
unformatted queue.

Fix it by not inserting trace ID nodes on other unformatted queues. This
isn't an issue for v0.1 HW_IDs because they aren't global so will only
add to their own queue.

Fixes: 19c3e4db38c5bf30 ("perf: cs-etm: Create decoders based on the trace ID mappings")
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 15f99c2c2775a..525ba0860cb5d 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -304,27 +304,27 @@ static int cs_etm__map_trace_id_v0(struct cs_etm_auxtrace *etm, u8 trace_chan_id
 {
 	struct cs_etm_queue *etmq;
 
-	/*
-	 * If the queue is unformatted then only save one mapping in the
-	 * queue associated with that CPU so only one decoder is made.
-	 */
 	etmq = cs_etm__get_queue(etm, cpu_metadata[CS_ETM_CPU]);
 	if (!etmq)
 		return -EINVAL;
 
+	/*
+	 * If the queue is unformatted then only save one mapping in the
+	 * queue associated with that CPU so only one decoder is made.
+	 */
 	if (etmq->format == UNFORMATTED)
 		return cs_etm__insert_trace_id_node(etmq, trace_chan_id,
 						    cpu_metadata);
 
 	/*
 	 * Otherwise, version 0 trace IDs are global so save them into every
-	 * queue.
+	 * formatted queue.
 	 */
 	for (unsigned int i = 0; i < etm->queues.nr_queues; ++i) {
 		int ret;
 
 		etmq = etm->queues.queue_array[i].priv;
-		if (!etmq)
+		if (!etmq || etmq->format == UNFORMATTED)
 			continue;
 
 		ret = cs_etm__insert_trace_id_node(etmq, trace_chan_id,
-- 
2.53.0



