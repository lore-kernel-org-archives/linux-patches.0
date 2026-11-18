Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018138;
	b=vRw4CNCKeusGi5oR7HNvXEI7iFebE7zq/sRIWIYHyiUEiLtP2ZCoRzPKtk/5O0N7yuo8
	 HYPeMC6Ry+cvxsu7rChVqk9OYqKL2fVuaLXKObro2rbEVfzaRVCatyO+fL4evZW3SZfox
	 lOI/ZAsXrL9KEBSn/TLgasTfEk2E6xMUWszu4haxcJX5m7cOQN1Z/H0qNLUd60GlwAq/N
	 0lcgBR/+majtn1ZK6SEt2d5IKOgfaenWCXD3pUmyDBqD1ac+GEq8tOZG9LypBqoc4s5xj
	 dR+7wkUgyZuGrBcPjktJ7I4nyKSSXMGJ6Y06Bu7wUDNwtDW6gn9K5GUobmQM+x4H2Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BJFMNO679uWuiav4lXtLJroMgCejosyC0eZ0ec9u9ck=;
	b=lOpv5+/DUlQBVJ72nv62YPxrfHvEmElqbW4cMW0BrIIxKPDgEZuDohQV1ObAWW+cCbgz
	 yGeMvUg09BNhbQNAdvYxL0bp8DFLsojb0ErSEO3//7t3w//z4oQNBz4+chhQmIdIn/5Wk
	 9D4BIm+eoyFFkLoJMyhBbCGkl83Oq8dwS8CPboc/byR+rURPNW1kLpRRXbEuJKKryPpSz
	 BNyx+5iK6ZfDyAiTBKD9gWG+5tLIrcxJac+yNDdKBTkDLSWin8Zoib8XuR5uZnuHO9zPB
	 Ber8J10bBThpMgsQOYnxPyBILBtREg4HtZuCUgf2y84F5zwtUrzW0ii2WekXgiAOgRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ssvi55NH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CF460A2609;
	Wed, 18 Nov 2026 16:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ssvi55NH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA7B1F000C5;
	Wed, 18 Nov 2026 16:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018137;
	bh=BJFMNO679uWuiav4lXtLJroMgCejosyC0eZ0ec9u9ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ssvi55NHvuK2DoiKg0DXr+zCWawmLQFwneJ7rQPe59olCcoh4LzCy8XY7sbDs2/WG
	 MFQx3AEth4GISLsPqw1Ypi2maG49QLtPKtJomXlDudTCAPDlOX4yNyYs+VC/+/ErrX
	 ur203Dlgy5tI7XudhARK+M0zEgVVmgO+X6C+AjF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1119/2651] mei: vsc-tp: initialize IRQ state before requesting interrupt
Date: Wed, 18 Nov 2026 15:39:19 +0100
Message-ID: <20261118150328.293977691@linuxfoundation.org>
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
index ce877cb957574..5410ec1c93286 100644
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



