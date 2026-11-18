Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028971;
	b=a7Pen1H+2EggSsusCbOH2LOCA9HZiSKFMkRT9uwl4FvTvPXqlmuegMCjIHlqKPvO9Edw
	 lANZEcZUZGie5Cwb7OQ6e//bx6rA75WQkGEB68axoU2qlZedWGYV1/7iP8zrlonrb2RPI
	 e6wS04YzGhEJ5/98QttHLSPPSMA0Osan2bg0CaYZ0EPFUc7lr+5WkZg0cFQdLBYpBOi3X
	 zPTOGu4xjKBvDBcyqbWk/mLR9GwIhV0yASdUekvNY/+mc01lL3Ugu2BnJZp/ccltXzSpC
	 3lIWQp+WfkTFwB+M2C3dIfsSKcuQEVRFVZq2tP0GDiF1PZdSotIwsYdzWSdq7cZ7yWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7FaQoNh5aRvVTq7FKByTVpIc5eC6QA1AJvLrfYOg4ek=;
	b=y7DmdSUK5J8aA56/QBb38ZUEk9yh2menNOp5uRZT5MoAdpcnofRb0L09USB/o8NY5oFe
	 mG8cx8MNImcruXddzGTBcP4bgOH4hAsfCMgDyihLKTO8ZGvY7/CGMM05YIxn/xw4/GNp/
	 VFzeuALKpGWqSwuA3Qldyj5xu9T3nJ+XIIbcNMOiTkLF7/mSODk/sc99zXnZui15139wf
	 SXuowBMkru72tAYjMToys7ZoGAr21auLyevyYzguP/VxZzUF/I8vPDkt4Z+52Xs6ofDcN
	 TjUkkma5cHxHatbX25aJcZnr4LeF4FsEfiURkOzyPhKJcbZsNCr/qvYKHVf2GE59Z9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c2uzBzTa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3461D606A333;
	Wed, 18 Nov 2026 19:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c2uzBzTa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42ABD1F000C4;
	Wed, 18 Nov 2026 19:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028970;
	bh=7FaQoNh5aRvVTq7FKByTVpIc5eC6QA1AJvLrfYOg4ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c2uzBzTa/UBBN+ryxLXmujFPBq2RNbVCDwSG7DHFUAmwCHfGVUoESCCsHUsIg3FMR
	 0zpVpc2h382HXm4ZedtrLZVD3+NaAl/uvJpWDmUxx5rJPXkeLWCcc/Jqf4zZ9jNE8v
	 eXJEbbjFUHSW1c1gtKo3UzuaX3zrW1PYKWHb8WJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0184/1756] soc: qcom: apr: clean up failed service registrations
Date: Wed, 18 Nov 2026 15:38:31 +0100
Message-ID: <20261118150015.741245610@linuxfoundation.org>
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



