Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032701;
	b=nHEBd28TXDD0AyEwBBU3XBAMQrTcg9wdTeGUtA8KIOtGUFmf4pBdMuxjXpQidllcZr1h
	 ggFbvF9Kuifg3sV/OJZulCD3n7/BqRapMpCmORZpB9UfBfKpHRL7JbaxRSEWgXQKJpgfU
	 laV1hFeXf6Nvxjbu4ZZJEHCQYqSROFZcVXVsi1TKqfQgiGzeFWIL4WBxTPluPhWdPIcTX
	 2gSQhb2GD3G1VBC1MBeOLNyc+xa5JwgwPBM2lGelMdmD2Naqt05Ft9UoYHibyH3dIejpr
	 xeGHazrfcuhGBcFn0bm9qaqHw00Y449RQy8MDFm1vdbpKA2vM3zXEM7Ge+QS6wBCSTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tvsCxDyPnzE+eyc7s5F35ldRfUWHw4ZjorhQ4PgEkrY=;
	b=YgJ/H+Xg6mo9X3uLjFnNlNpO87tQxw1RfofAlga8peK+j/FNYNJab0yriX7l/1pSxsMG
	 0TZYbCVresOVNucSx4VCiNByIalZxIJkA73NkEdcCdOM6i9Oen28V/T8XEPpP0blx3Prj
	 11+d8EpgxF8YoMB4UD3hVbux9XZFUtMUOcrXxDK2cIY38nf00Ssvd5rq55P4JuzSwTFt0
	 5E/rhUHeinI33RDgGMBHz1SL1k5IN50mhB+txMbGVqIwOD6iKLWhPrSke0qgIFtIfXv2u
	 NuhuM0UyM4pn270b0TsC8R2NOx2tGXMNwKPJuCRx2WT2/SmjUfpWfI4oPOQ5z8fP5gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMIMOJbC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604A2606A320;
	Wed, 18 Nov 2026 20:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMIMOJbC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E45F1F000C4;
	Wed, 18 Nov 2026 20:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032701;
	bh=tvsCxDyPnzE+eyc7s5F35ldRfUWHw4ZjorhQ4PgEkrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMIMOJbCAOph02uMg+w0Icf//BFEkJ8SJqFos5GGHEUrEPZ0D7eBjeN2nfhwBwUI/
	 +0iyKPNAyBxavRDm/NpkPAo5fcqmBC0Ef7qvIloBUglX9xrwllq8gA71BprvII4AWf
	 Ro16xksUp/3FxRPURNxqJViz1yaJEZarmQdjCgnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1503/1756] perf cs-etm: Dont add global v0 HW_IDs to unformatted queues
Date: Wed, 18 Nov 2026 16:00:30 +0100
Message-ID: <20261118150108.754616383@linuxfoundation.org>
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
index e8eac34911032..f1939ce68627a 100644
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



