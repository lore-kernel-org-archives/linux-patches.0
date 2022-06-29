Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72E8ECE
	for <patches@lists.linux.dev>; Thu, 30 Jun 2022 12:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D58C3411E
	for <patches@lists.linux.dev>; Thu, 30 Jun 2022 12:44:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Xeof59xe"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Thu, 30 Jun 2022 13:44:54 +0100
Resent-Message-ID: <Yr2axp1iKBhUtiAF@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 29 Jun 2022 19:43:00 +0100
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=7vLQ=XE=163.com=niejianglei2021@kernel.org>)
	id 1o6ceP-002TMC-OW
	for broonie@sirena.co.uk; Wed, 29 Jun 2022 19:43:00 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 7AB86B82652
	for <broonie@sirena.co.uk>; Wed, 29 Jun 2022 18:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 3A7CCC341C8; Wed, 29 Jun 2022 18:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTP id E4284C34114
	for <broonie@kernel.org>; Wed, 29 Jun 2022 18:42:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org E4284C34114
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=qTS3g
	DYmPcoSwjyI0lzESAMUolnWyllszb9nWUoOVyg=; b=Xeof59xelWbJ5QmAtYGuf
	vKL2I2D9cyJ9wB0GanWYwUv8Zd5adoJFSiZdaSCcUCpeNpgpD+J+9BmDSv86lz55
	UsF+yP8C9jxiueQoHA3WO9wIjDYzhjkZPQLq+hc7iPxUYBUEivX9/Nr9R8/N+Q4I
	VOjFfXGAaMxkgbrHvtNxbo=
Received: from localhost.localdomain (unknown [123.112.69.106])
	by smtp2 (Coremail) with SMTP id GtxpCgAXdggSmbxirfXlMQ--.63696S4;
	Thu, 30 Jun 2022 02:25:34 +0800 (CST)
From: Jianglei Nie <niejianglei2021@163.com>
To: srinivas.kandagatla@linaro.org,
	bgoswami@codeaurora.org,
	lgirdwood@gmail.com,
	broonie@kernel.org,
	perex@perex.cz,
	tiwai@suse.com,
	pierre-louis.bossart@linux.intel.com,
	dan.carpenter@oracle.com,
	linmq006@gmail.com
Cc: alsa-devel@alsa-project.org,
	Jianglei Nie <niejianglei2021@163.com>
Date: Thu, 30 Jun 2022 02:25:20 +0800
Message-Id: <20220629182520.2164409-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:GtxpCgAXdggSmbxirfXlMQ--.63696S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrZryDJFy3Xr1kKFWDXw43Wrg_yoWDWwb_KF
	yv9F93XrW5CFWkXws8Jry0kFy0vF4ru3WrJrnIqF1fKa4DGFWxG3Wjqr1fGF97Xr48K3y0
	qrn8Xr9aqw1YvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREBT5PUUUUU==
X-Originating-IP: [123.112.69.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiFR4vjF5mLiiohgAAs4
X-SA-Exim-Connect-IP: 2604:1380:4601:e00::1
X-SA-Exim-Mail-From: SRS0=7vLQ=XE=163.com=niejianglei2021@kernel.org
Subject: [PATCH] ASoC: qdsp6: fix potential memory leak in q6apm_get_audioreach_graph()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: +z5N9Yn6bdh4

q6apm_get_audioreach_graph() allocates a memory chunk for graph->graph
with audioreach_alloc_graph_pkt(). When idr_alloc() fails, graph->graph
is not released, which will lead to a memory leak.

We can release the graph->graph with kfree() when idr_alloc() fails to
fix the memory leak.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 sound/soc/qcom/qdsp6/q6apm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/qcom/qdsp6/q6apm.c b/sound/soc/qcom/qdsp6/q6apm.c
index f424d7aa389a..794019286c70 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -75,6 +75,7 @@ static struct audioreach_graph *q6apm_get_audioreach_graph(struct q6apm *apm, ui
 	id = idr_alloc(&apm->graph_idr, graph, graph_id, graph_id + 1, GFP_KERNEL);
 	if (id < 0) {
 		dev_err(apm->dev, "Unable to allocate graph id (%d)\n", graph_id);
+		kfree(graph->graph);
 		kfree(graph);
 		mutex_unlock(&apm->lock);
 		return ERR_PTR(id);
-- 
2.25.1

