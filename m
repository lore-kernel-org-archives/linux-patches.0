Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021494;
	b=SXR2RRakoa3YwGz5+srpP30i9sVpQzAVp7fJPjXtmcCCPKrtRmJSe9PgCisb0WdP+sf5
	 0Q5b3VPKAk4npsX0MGdi0340WUQvn50Dcr5vJgqYhkoFHtFR6UvRW/73V/E92vET7MZA7
	 q5oSI2f2FSyi5bYzwG6UVP7UUdZ8mUUrfBc1KSrus9krR/RoNaYVCzYSezmGJy7wKReWZ
	 M82Tu1rhccxKncT+9LxLzpaoQlp7770+9mnO4B0S8aCroJzeQpOWHI0c4tpdqMVT5qhwj
	 S53UiDpZe45W1bE6qXwcRtjbzwZfP2FBCMHIxBulbWJ4gozl7hq1Uu83BD/Gz5T5oDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6x6wKI5WsKQVsMJRLTjP/FzaxFtz/I/KNVU8jlEVOSE=;
	b=RCBECfX1NClwxh+bPVj+Wzqo27C8ioQ/1hRfdvOtRFYsS+HFRgyvJcRkIpd0V4UdrpGD
	 2Ff8WojcY7PUGGz5vVrkd51mnIlMXRYogLYALtsltAU9+FY4oofC14MyXm7d4pKrEAfkX
	 zGl3Pvo17KrDRNwGiTSPzN/rbrW/6Yu6k+MMmCC8k/EqJZsZ9A3B7M+IF7ajuK6tU6NRE
	 pHBkDAjL3Rq9NRyLXYfxm+G7yOIEEm/TGcC4G7OIzvcN+MdUTz2ndfgsx/jCX9Vc0zahk
	 9lgxXrJ01CRT/7ruDi5TR3Y2W4eoNrGH6QvoKc2XivgfHvqLS5DqN8lRGH2ZIH+8hnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UKY/y009";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA8D60A260D;
	Wed, 18 Nov 2026 17:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKY/y009
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C969D1F000C4;
	Wed, 18 Nov 2026 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021494;
	bh=6x6wKI5WsKQVsMJRLTjP/FzaxFtz/I/KNVU8jlEVOSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKY/y009Y9J22dmWGZVWtFtcKB3VeyhmJh/kkPy3+bB0PG2E83tskFx4TinfJnzqr
	 9rbBO3FH17PCQXwR1f0Fub0rI/cez46r9V52rGhq3TFGMqHUuhkuU/V0rvfhD2CtJ6
	 GreQjRDf5bWk3BKjn/cEjKmzgfS4K7YYxhMpEIQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2328/2651] perf cs-etm: Dont add global v0 HW_IDs to unformatted queues
Date: Wed, 18 Nov 2026 15:59:28 +0100
Message-ID: <20261118150408.950326863@linuxfoundation.org>
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
index 114b3cd2da495..1ac627d339828 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -309,27 +309,27 @@ static int cs_etm__map_trace_id_v0(struct cs_etm_auxtrace *etm, u8 trace_chan_id
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



