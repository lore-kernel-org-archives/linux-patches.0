Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043111;
	b=0ssIlHE2D5jEYOU+6MK5MTrUYWhcnXkY/wBghYm71AZHI3tHBNoFhu7rvfPQolwMTowR
	 tsvT7nB8XLD1yyHquWD+8wqZetADEN62vDF8OdUpfHzcC/HTak8n49zSzolqcG+p38eYg
	 GO3Sp32L/zkWhz6/hDWFxhV1XQeVN2OOXdagSB/ht5evoHV0aXsikg6WWznQa7izSiJcA
	 lXS61nDFciW8LzN82lkvzEukVoEamwe3OlGstLGgQCfKDNFjNDIjujzr+xcsQ0FQV0ZQe
	 +AckmqKBlU6Yx7uuxy7KKTCAMIFmG7IO2kkDX2yHDcCWw6tBaDS/UTyYKk5Argv0uHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yem/rdwkZgjEuv1biFUv1TSR5m3ZfPmX1g/5vJ9+FwE=;
	b=WOwDcbIky09rK5I5N9Owfs6Jw9uy+R/kwWX3n8qRrkjHiPKGQSP7/YXmM2xavuwlDNbW
	 O0bOeq+N6CX641V6oYiD+BlGy2c/DDVk4zcCMrYvjhXcEH9KuyMUxwWfL0HQqcHfrJj7g
	 mt5yGRsNhPD2hOgEihxMoVs6s+uSvumVaUNOq8JB3KDSt6FpdLxEDdCY2Apsg22LFWxhX
	 gFJ5SbBQ0U00bs9qHvnQK3asXU+exODiHSY33JqawlhK+/xsaISRH0N8k2tJIQ30TqqMQ
	 fI7DOyuF5rb5o4I+bzW/SYAa3NzJeMmobjv9EOqDjkUyZCa88Qa7ArDwoGFIoFfLXcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hPzw1KvX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62350606A31C;
	Wed, 18 Nov 2026 23:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hPzw1KvX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76301F000C4;
	Wed, 18 Nov 2026 23:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043111;
	bh=Yem/rdwkZgjEuv1biFUv1TSR5m3ZfPmX1g/5vJ9+FwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPzw1KvXzSflfT+Wwgsn7kaShchXmfBr95B52jNeVocQOoLOXUXoonU3Dwqtaaeaw
	 Fnu8HHfKpt3v5q94PUupMH4U+10uy3xOFH0ezuboyQU9yXdwyY9uwvahrahXQ81iwg
	 28ZgbD7pB1kCuOCkisEdOpCZ0nam5WLokDDVnUBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0093/2857] remoteproc: core: cancel crash_handler work in rproc_add() error path
Date: Wed, 18 Nov 2026 15:18:47 +0100
Message-ID: <20261118150204.623727326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>

[ Upstream commit 0ec167625b4fea30b26da33c188e853ff25d5583 ]

Ensure crash_handler work is cancelled before tearing down rproc resources
to avoid accessing freed memory.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260623-rproc-attach-issue-v3-3-8e24310707ce@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 328a41051c77d..ac6ec64f7db66 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2337,6 +2337,7 @@ int rproc_add(struct rproc *rproc)
 	return 0;
 
 rproc_remove_dev:
+	cancel_work_sync(&rproc->crash_handler);
 	rproc_delete_debug_dir(rproc);
 	device_del(dev);
 rproc_remove_cdev:
-- 
2.53.0



