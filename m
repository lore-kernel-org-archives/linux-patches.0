Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625225;
	b=qxtxhZPXCR4slv3hUTHW5Kxt7ejXX9yVh//ob/cpfdhXXZ3tTRetTPO13ecpxqn7LIPm
	 3sUgcYaOhujIj0LMQog2cAyF287Yy+0v3XjS8LzgZvvlFVhuYQdtVwd7XS9f+bcUE6N5O
	 5K8IhYm2UZNq2w3kP5EDHrPdRdoiesWY0okEV3IA/eEe4vCQBi0g0pMSWyqVubPs7I5R5
	 DCvyGDqmCnQJxGI5/RPXDHmBhvPsb+IDZGion758/twQrAulf14nBn7hA7GHTUcYg7GsQ
	 +C0ELWe330sByIdjC/IeHZmz88Qjtkq6nQGHfF1fwwy1dINKcb2Ntyu3IIgl4WLGwwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YXHPLjw7o1zNu+XvOM5ls28hWrtKbGV9voK88O76FI4=;
	b=sKMNA1FCeRN1YQkWw6/QMnvv1Hgkkfrba7StvVXxnlEL1zFBwI1LLJpuTYsoaSZug4T9
	 LPbVn+lsESOWf7zCV43ekH1JwGr0HsaMN6dCKS+VhJAXVGjzGiORWR5SkSefmO0Lc/CHu
	 GYa52vP//fs9IrwIc2U3Lt2t82RIv9sFNdjEkeI0efK5x0DIgeqGYMwXyhJpTXC4G8o7c
	 2KP3kuwOWzpx/Y8z1BsHHHr7Ukg8JKvnEe2NxWWvygYcLe/2GFOqw2N5iVAOPKWLbZU5i
	 k/RSsLyuVuWGVBN1Q2Rvmmj/YSOuhbA3UkL/NxX1qkH60SRuugXpaVgOqouwG9uPZ7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kzCllIcU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AF8606A31E;
	Wed, 25 Nov 2026 16:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kzCllIcU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681E31F000CA;
	Wed, 25 Nov 2026 16:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625224;
	bh=YXHPLjw7o1zNu+XvOM5ls28hWrtKbGV9voK88O76FI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kzCllIcUw8udg2TjlxGD6dCIovedS3ZScUfoyQZ6tY84gzY74f7Wsn8zIqxWY2L3P
	 QePJnkxLL8fE3UB9UGFNUdN/9eYdfCRGYzNZsssCvTaPHA9aAOV+GHxhYpgsRvQyHl
	 rtaqUOXAAR6hajMQzPIcNJydS+zo48NRQLaSTNUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 446/816] mei: vsc-tp: initialize IRQ state before requesting interrupt
Date: Wed, 25 Nov 2026 15:33:14 +0100
Message-ID: <20261125143859.514378911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
[ sashal: Dropped the event_work/INIT_WORK and cancel_work_sync parts that don't exist in this tree, and kept the existing vsc_tp_isr/vsc_tp_thread_isr arguments, so only the mutex_init reordering and err_free_irq unwind were applied. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/vsc-tp.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mei/vsc-tp.c b/drivers/misc/mei/vsc-tp.c
index 1fe760adb2e4f..d351f8af976b2 100644
--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -527,29 +527,29 @@ static int vsc_tp_probe(struct spi_device *spi)
 	init_waitqueue_head(&tp->xfer_wait);
 	tp->spi = spi;
 
+	mutex_init(&tp->mutex);
+	mutex_init(&tp->event_notify_mutex);
+
 	irq_set_status_flags(spi->irq, IRQ_DISABLE_UNLAZY);
 	ret = request_threaded_irq(spi->irq, vsc_tp_isr, vsc_tp_thread_isr,
 				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				   dev_name(dev), tp);
 	if (ret)
-		return ret;
-
-	mutex_init(&tp->mutex);
-	mutex_init(&tp->event_notify_mutex);
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
@@ -557,9 +557,10 @@ static int vsc_tp_probe(struct spi_device *spi)
 
 	return 0;
 
-err_destroy_lock:
+err_free_irq:
 	free_irq(spi->irq, tp);
 
+err_destroy_lock:
 	mutex_destroy(&tp->event_notify_mutex);
 	mutex_destroy(&tp->mutex);
 
-- 
2.53.0



