Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047789;
	b=n2zN5aDa9JGBTibPTAZ7SLD93dBeeDRvUCjC0/syLsowmnfuK7RPdNMb7yDEWcPXk9KJ
	 C3L4/FygLM9dDZMgDMYU+uj2F11rTLbZsa7b4S07it1R6SRHp+R9M3PE5jHo09ULSKJHk
	 VYY4JTNiEd0GU7YMeXTaQ3ypCOhCzGZ0X9h4kzop3DuX8l16pt8S4rn3ceZsg3SoMql82
	 rEIzuqXWgfz5eVm8V5X1t2IJbEVpzdDJDl9vNJkSsWR+IxSPDCIaN6pSlwvBk0nJzFkdD
	 8CXoUrNcBSeUM137nAdsU9Up8lv10sd2/p3Sq3mHtAN7rx4uTlR1T3vVGOyW13z2dfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2QwMTXcTvRueetcfxr4DqQXcnmtU4gF8EhZ3+62c3SE=;
	b=TJbMvjTffQa0yGidA9nrWf+KB6N/P/RmMDRUu8q01uDlvuBrwtkq+NaK94wtALWcU2Sa
	 Zjb7ATbx0mFEOzBTqKl7SD/+VDQPeKrMd4qfDNuGPjOkmiNEjzcfN3U0eHwRimCTJgZii
	 SleMmkxh3b4aKnlYum98HIHwPEuQMZDdwRQ6cwBqZrjg3LU+WocM5X6n+Kk+hJ8zMtxgG
	 JPwqEBjSRRUF3J7u5G0wqOjie7L1u3E4XSTCDkMpxUX/MGYnG+dt6buwxrkW6CnHv22XC
	 ZTI1soauXSUg7FFjZgRL4CJbgOZSD0ZRMZ2y/vOZkPKWueeCrnAAtCMOX3/0//hP9ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gl29WECN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C52C606A330;
	Thu, 19 Nov 2026 00:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gl29WECN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F00B1F000C4;
	Thu, 19 Nov 2026 00:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047789;
	bh=2QwMTXcTvRueetcfxr4DqQXcnmtU4gF8EhZ3+62c3SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gl29WECNVk9VVwxpSMcAKvE7Sk22pyd9sLYs2xw8gGWBqh9xQqBd4BNhitzVg0pM9
	 FGCpykTRKVlPYLiyPoqidp6LHUKE0056Vcnrn2S7h83j2WExTn3JANMgXq0PT0jQ5S
	 t0TUkLyIEQhxCmDpEPwjP/f9BfYIm2bntnZeImSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1763/2857] soc: qcom: apr: clean up failed service registrations
Date: Wed, 18 Nov 2026 15:46:37 +0100
Message-ID: <20261118150304.763894478@linuxfoundation.org>
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
index d51abb462ae5d..13698e8c6aa6a 100644
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



