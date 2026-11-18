Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022924;
	b=MHJeu+cKCm4+FHdC20IkT2xedAPWT+kRxzgFuEn7iRcSwdVE9wmb9BjbN9hDOC81c292
	 WlTrFLw21LuwgFKQ1Zlq1U5Nk3Q2hQLv99D0adhDN4b/dxOn9WRFTxXCDAiVcYEtHy+vl
	 L9r6v5EZAV1g75UbbgH9qRTrqZTrBHVFtb2VEhFGWiVJgi7EOLSfVkWaPsASQ9ieB6u/1
	 3LzzPgrJUkiTFOt+VETqecNLZWG9SMfjbF1kbgGVZasD+KTOtiGJeez91rYoFQ8N2z5o4
	 PTk7aVKA6jt2kik7aahQRVnF9CLurRlDbjgE6aakLrBFQgmmpAP8LDj5QCizPq+uctw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ABQCJOJPuz6zgZN8uCGuivXWo98WdXqP2qcQgy3+Yd4=;
	b=vDwqDSo8AKkPiIYqsak0lz/UWSG1lGiTprE4KKyfQ/d5UiVFD8I6BYxn2JfD7ZCBUFAZ
	 ahimBlzmTHwiVKQ2TKLlRt9m+iUDdulSCOsrDlEXDHCh4OZXUBXAf6zTJUKYBDr+YcSB3
	 MA//uej1wCCqC6eubX3Lziu+D8TQqkgaUFtTEYbhiBEHN+spZe5jMIjJ7jUSWaH3b3db5
	 CF4vBWzL2GGqB/lmuiXDpgAwOxp4W4I2L23v7/BAtoWePLNSAvc/TOkHGYUsPgEEnYPSy
	 NqFN48Q/Ez4ZjHjDqZg/+jhRsZOpiBK7E7E/W6Ok3gOqTipFSBlcLE0vYpZka1Dni3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e1AGFVa2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F248B606A331;
	Wed, 18 Nov 2026 17:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e1AGFVa2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149471F000C4;
	Wed, 18 Nov 2026 17:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022923;
	bh=ABQCJOJPuz6zgZN8uCGuivXWo98WdXqP2qcQgy3+Yd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e1AGFVa2lKknsLToESNQTCkHsBM7rCYAfx4T+LXzQNW8asTNO/FWQuGhzbvol5PgS
	 pshihaEcxbiWOxl9mAG0f6uaM+1yJtSFgt2JDQ6qsfS4GwZd/E91V9a2vTdWxU3dPI
	 L10+JOLkfwunnr27XqcW9uJnXYWXXo26ermx+0II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0184/2151] soc: qcom: apr: clean up failed service registrations
Date: Wed, 18 Nov 2026 15:31:59 +0100
Message-ID: <20261118150128.432241356@linuxfoundation.org>
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
index a956c407ce030..b80cf8f417b03 100644
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



