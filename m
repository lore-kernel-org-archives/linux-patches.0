Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015345;
	b=UDw4ONgUv1CMR+aZcTJMMfvLRAfk74emSQubWDhUaT+OA5M7wx9hQOaMgwFQS78jKimo
	 KTQ2PjLb0XCrQZEemEOzWq1pQJ0DFkapH7zKuO/Cznl8HRga0fWoo/i6/vJ8p9UZBUPhp
	 ugvNw5pnrOxDr/ujT2hE+LpZxRiMkzwiciIBvs0jXfurpnc/0ZaJ03aheFMt3DalKWtIp
	 NhkcYVv7WgqsHsHVanmm4QLjBhlvdUM3XN0fsoKqNcNQDxWpCL8wfP7IH26ZETK69QqX9
	 PymHrGXr+ijxzke0uzMME6lyngH5jjc9IuLUFM5rQZGAMOQ6wDIMuH/tEI+0GBkrFkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wrbJgrrvJhteIdJTt18fQb5B8iAUqlAH5NNNqz839gc=;
	b=SUp6D2wB7lmxQNhe6CEAxA631s8dYSkgM1UBOtGB9q+7OzVBzhLyn0eQOeuWOmFZd7OA
	 gzAPoWrdLB4W0rMPl0bvPQtmR4tkRXU1yZVYZwzd49t87djmjQylJBCYGreXGbk6Rgv7l
	 yE8BnlQorPyrn6ZOXereWzDoLePX62wsS8FLROWhwVcYu4PhT/Z6LJmewhoGQtqUzelm2
	 uBdBeakswcaHLZvnguCzeZTNjG1yyseTeAJJVv3Zy8QCl6L7ZjNiFN44O90eliVs2O9Q1
	 YTiVRTBOPZWX2hM79Smr308buJA/i/OXVf+bT9ob2FmQ0TvteFliZ/06R8ax4690eJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dA5rjaVN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191D1606A32F;
	Wed, 18 Nov 2026 15:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dA5rjaVN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5021F000CB;
	Wed, 18 Nov 2026 15:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015345;
	bh=wrbJgrrvJhteIdJTt18fQb5B8iAUqlAH5NNNqz839gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dA5rjaVNStzwRY/ELY613H20Jond3uHsE1QFBc3VQ0Y44lyaYwIxdOtnZW8759579
	 PxWkNnzfa1pLbInjXOcrAGmp3yfcRcuHnIXpnUanYMFzcbewKoqZSJCJ2kltFwkdXa
	 FTCbJy9Zy64gHoOFxaNf4aqMG5xalHKRJ9s7AbDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0140/2651] soc: qcom: apr: clean up failed service registrations
Date: Wed, 18 Nov 2026 15:23:00 +0100
Message-ID: <20261118150252.886652567@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit 7dc14f37ca4ee35040c67c4b0180dd7b32079caf ]

apr_add_device() publishes a service in svcs_idr before parsing the
optional protection domain and registering the device. If device
registration fails, put_device() frees the apr_device while its service
remains in the IDR. A received packet can then dereference that stale
entry. The property error path also leaves the service and allocation
behind.

Split device_register() into device_initialize() and device_add() so every
pre-registration error can safely drop the device reference. Remove the
service from the IDR on all failures after publication, then drain the RX
workqueue before dropping the device reference. This prevents an in-flight
lookup from outliving the device.

Fixes: 6adba21eb434 ("soc: qcom: Add APR bus driver")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://lore.kernel.org/r/20260806060541.820-1-getshell@seu.edu.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/apr.c | 44 +++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/soc/qcom/apr.c b/drivers/soc/qcom/apr.c
index ea7f83916d8d8..d72628ac09f1a 100644
--- a/drivers/soc/qcom/apr.c
+++ b/drivers/soc/qcom/apr.c
@@ -434,31 +434,35 @@ static int apr_add_device(struct device *dev, struct device_node *np,
 	if (np)
 		snprintf(adev->name, APR_NAME_SIZE, "%pOFn", np);
 
+	adev->dev.bus = &aprbus;
+	adev->dev.parent = dev;
+	adev->dev.of_node = np;
+	adev->dev.release = apr_dev_release;
+	adev->dev.driver = NULL;
+	device_initialize(&adev->dev);
+
 	switch (apr->type) {
 	case PR_TYPE_APR:
-		dev_set_name(&adev->dev, "aprsvc:%s:%x:%x", adev->name,
-			     domain_id, svc_id);
+		ret = dev_set_name(&adev->dev, "aprsvc:%s:%x:%x", adev->name,
+				   domain_id, svc_id);
 		break;
 	case PR_TYPE_GPR:
-		dev_set_name(&adev->dev, "gprsvc:%s:%x:%x", adev->name,
-			     domain_id, svc_id);
+		ret = dev_set_name(&adev->dev, "gprsvc:%s:%x:%x", adev->name,
+				   domain_id, svc_id);
 		break;
 	default:
+		ret = -EINVAL;
 		break;
 	}
-
-	adev->dev.bus = &aprbus;
-	adev->dev.parent = dev;
-	adev->dev.of_node = np;
-	adev->dev.release = apr_dev_release;
-	adev->dev.driver = NULL;
+	if (ret)
+		goto out_put_device;
 
 	spin_lock(&apr->svcs_lock);
 	ret = idr_alloc(&apr->svcs_idr, svc, svc_id, svc_id + 1, GFP_ATOMIC);
 	spin_unlock(&apr->svcs_lock);
 	if (ret < 0) {
 		dev_err(dev, "idr_alloc failed: %d\n", ret);
-		goto out;
+		goto out_put_device;
 	}
 
 	/* Protection domain is optional, it does not exist on older platforms */
@@ -466,18 +470,26 @@ static int apr_add_device(struct device *dev, struct device_node *np,
 					    1, &adev->service_path);
 	if (ret < 0 && ret != -EINVAL) {
 		dev_err(dev, "Failed to read second value of qcom,protection-domain\n");
-		goto out;
+		goto out_remove_idr;
 	}
 
 	dev_info(dev, "Adding APR/GPR dev: %s\n", dev_name(&adev->dev));
 
-	ret = device_register(&adev->dev);
+	ret = device_add(&adev->dev);
 	if (ret) {
-		dev_err(dev, "device_register failed: %d\n", ret);
-		put_device(&adev->dev);
+		dev_err(dev, "device_add failed: %d\n", ret);
+		goto out_remove_idr;
 	}
 
-out:
+	return 0;
+
+out_remove_idr:
+	spin_lock(&apr->svcs_lock);
+	idr_remove(&apr->svcs_idr, svc_id);
+	spin_unlock(&apr->svcs_lock);
+	flush_workqueue(apr->rxwq);
+out_put_device:
+	put_device(&adev->dev);
 	return ret;
 }
 
-- 
2.53.0



