Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025141;
	b=VT52+vKift8Yg2vtsACIYtshEqPZONpENLp3TJMYYfnEUMIzRyPXJxRsQiQnJE0WCaTg
	 9AT9DogsJX4dm+Ie2sr5QTTOF7gcCpFIJP2yEIhuPb8QHM52mAu2Xj7PTP7JzsHxEVlrz
	 17puXmiLHC57nVgUDX25/oq+gbtwNVIPxLDiPpz8EGAE125t1gj7KPcx2G80A7NxlVe0w
	 TB8ibEwhC/YZFehSG2ggepKiqrFNXDDS5rPHz9xscCCMDIi98Az+rmYGSf1wnyW/gFddQ
	 Rsk8qVvfI9YsJzpo2N8HvHLKEpRv9JTREbajiyoe27hLOZlvtju7JNdEp7K4JN05Cug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cTBHed0GBp0bymMzaRWOqYL9Nxi5Z53JifUVdhveLWI=;
	b=R7OPJFN/CnNjcrByHbfXPRKfA75MwWfnqP3RMgHQd+Ru/h1A6Kx5dNWyNU83H2wAgdqI
	 L6adv2ORWOC5HxcSvqLYZKjIJmptUyzG0Iu7C+Op1fsNbvV0ss2MUL1UAe1d+RYqURgN4
	 nCDeGjkvFjnk23WmmQc0r+1j8VK8q7s8PvQ7wFpXUKvIFTyuub/B5iMomNEO7Y2rLbw0G
	 DAoxzfFaM7LlA2E/4KzUHMtEqks7oSz78LbvhKGI2cN/t+ot0zB8X6Nc/lyZ+Bg+boww/
	 5CN6dSJsA0LKbeb2MMk27Q2RRZg3vkEZHQgrgd72VyetlNMueBPat9dW9F/DNmBzbJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sLYhYR73;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34845606A320;
	Wed, 18 Nov 2026 18:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sLYhYR73
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890BF1F000C4;
	Wed, 18 Nov 2026 18:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025141;
	bh=cTBHed0GBp0bymMzaRWOqYL9Nxi5Z53JifUVdhveLWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLYhYR73spA79LB6ez4XN7AMjnXnjfvWrEgNFdrm8ycRoEgcPbjrlCp3g3PRZFyJ0
	 mEYViZntuMDpj39gCC/KqtmyAI6QhYNyhPyP4CnC3pW0sDTLO/BuLpLnOCcRbBifT0
	 3abW9g/IkJsIXTyV3fyUBiz/GaEjO+5X+IlAAuzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0933/2151] mei: vsc-tp: initialize IRQ state before requesting interrupt
Date: Wed, 18 Nov 2026 15:44:28 +0100
Message-ID: <20261118150156.475882007@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 7754a2924604ea442ef03ed8fc12ccc9221a2e98 ]

request_threaded_irq() enables the interrupt before returning, so the
threaded handler may schedule work while the probe is still initializing
its mutexes and work item. Initialize that state first and only free the
IRQ on paths where the request succeeded.

Fixes: 566f5ca97680 ("mei: Add transport driver for IVSC device")
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260929132245.2152433-1-runyu.xiao@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/vsc-tp.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/mei/vsc-tp.c b/drivers/misc/mei/vsc-tp.c
index e70c07aa0d604..7ffa353f87d39 100644
--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -496,30 +496,30 @@ static int vsc_tp_probe(struct spi_device *spi)
 	init_waitqueue_head(&tp->xfer_wait);
 	tp->spi = spi;
 
+	mutex_init(&tp->mutex);
+	mutex_init(&tp->event_notify_mutex);
+	INIT_WORK(&tp->event_work, vsc_tp_event_work);
+
 	irq_set_status_flags(spi->irq, IRQ_DISABLE_UNLAZY);
 	ret = request_threaded_irq(spi->irq, NULL, vsc_tp_isr,
 				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				   dev_name(dev), tp);
 	if (ret)
-		return ret;
-
-	mutex_init(&tp->mutex);
-	mutex_init(&tp->event_notify_mutex);
-	INIT_WORK(&tp->event_work, vsc_tp_event_work);
+		goto err_destroy_lock;
 
 	/* only one child acpi device */
 	ret = acpi_dev_for_each_child(ACPI_COMPANION(dev),
 				      vsc_tp_match_any, &adev);
 	if (!ret) {
 		ret = -ENODEV;
-		goto err_destroy_lock;
+		goto err_free_irq;
 	}
 
 	pinfo.fwnode = acpi_fwnode_handle(adev);
 	pdev = platform_device_register_full(&pinfo);
 	if (IS_ERR(pdev)) {
 		ret = PTR_ERR(pdev);
-		goto err_destroy_lock;
+		goto err_free_irq;
 	}
 
 	tp->pdev = pdev;
@@ -527,9 +527,10 @@ static int vsc_tp_probe(struct spi_device *spi)
 
 	return 0;
 
-err_destroy_lock:
+err_free_irq:
 	free_irq(spi->irq, tp);
 
+err_destroy_lock:
 	cancel_work_sync(&tp->event_work);
 	mutex_destroy(&tp->event_notify_mutex);
 	mutex_destroy(&tp->mutex);
-- 
2.53.0



