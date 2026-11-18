Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030878;
	b=Xux0rb/7MYEmWxXRTfs/MSC2whs2Cw2rbi5k+QEA3+NuOYK2p+sc7/0vZ5UDymAqlJxh
	 hpJPjntVuic/XhT8IJ43pjWIBZX1kBAWmsDKXj9zn2Wt/D9FFZzqH7kck6yMCEGYtKI9w
	 tjgWH8xIHD5KiRZouKjg0cp5ZZd5Pi6INDqWneOg3eTajQm1rJocCmhQLSBwEngVOAO6J
	 IWW0eO/xOuuIA2O5wonXwJgPpWThNQleGCq3DinYeolTESFa/wOCztIMKhvWfA50VLVNi
	 GvBmtqkafvExmTadULhZVdoDd4T6hK+JAZABGeFacm05j9ssmQVGSVGvR5wE2jgoeEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/6vvjxgVrphcDNisdm8uXB7HMSTGA0t/m/dZGUMSiOk=;
	b=EtYwPG1nw3MuWPzwoz2SkVrjZqEZPDQaMrQeB1zqelIDXXKrTtB67CHxYmcUppMoPO/j
	 rrZvS5gfmX9gslfijv5VFCSxz4JcSDC5AKDyL0kihNEX+37qxrpHrLr/JOYdv37UbSgKH
	 f4Wp7LuUXObH2ksZk4QpEjZ0LVzmwduo1J35jxQXapfLJl991UTm/gDkB+pTDgeS0mYP9
	 Pogt9BsNpav6ksw4Vmz45rMFjCFVaD0mzvQqtwy2UhYm9VX8RmlsTIOlbAxc+scQkgFXh
	 NVB32YwGpsOxertGhe2OJN/eBGx4w8i9Ut0//hNo8XbQr/dAO5RhljizUgvRDsqeM0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zSiMOFZm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C4A606D356;
	Wed, 18 Nov 2026 19:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zSiMOFZm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89361F000C4;
	Wed, 18 Nov 2026 19:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030878;
	bh=/6vvjxgVrphcDNisdm8uXB7HMSTGA0t/m/dZGUMSiOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zSiMOFZmZVQuoklVvOsTYwfDFWnznP3qp0rNH9E9uG49XZR4lkcqGFg9RCR0zSwuB
	 QDIy4vKXMx8k25heb1gbjxLDCuOqCWX/+z6kAUy0MJL3b3Ha+TFNCrYqViCcj3Zofs
	 CcV+4ucPm401KJTtVcsnCoYpsNosYz3sB2ZHXxj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0860/1756] soc: qcom: pmic_glink: simplify locking with guard()
Date: Wed, 18 Nov 2026 15:49:47 +0100
Message-ID: <20261118150043.588595841@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit e9f826b0459f1376b9c8beba019b84f9878419c6 ]

Simplify error handling over locks with guard().  In few places this
elimiates error gotos and local variables.  Switch to guard() everywhere
(except when jumps would go over scoped guard) for consistency, even if
it does not bring benefit in such places.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240822164815.230167-2-krzysztof.kozlowski@linaro.org
[bjorn: Rebased ontop of v6.13-rc1]
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 0c79a829af36 ("soc: qcom: pmic_glink: Avoid losing early rpmsg probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pmic_glink.c | 70 +++++++++++++++--------------------
 1 file changed, 29 insertions(+), 41 deletions(-)

diff --git a/drivers/soc/qcom/pmic_glink.c b/drivers/soc/qcom/pmic_glink.c
index 22b81b9758b59..be64a4ce8e0ca 100644
--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2022, Linaro Ltd
  */
 #include <linux/auxiliary_bus.h>
+#include <linux/cleanup.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -100,15 +101,13 @@ void pmic_glink_client_register(struct pmic_glink_client *client)
 	struct pmic_glink *pg = client->pg;
 	unsigned long flags;
 
-	mutex_lock(&pg->state_lock);
+	guard(mutex)(&pg->state_lock);
 	spin_lock_irqsave(&pg->client_lock, flags);
 
 	list_add(&client->node, &pg->clients);
 	client->pdr_notify(client->priv, pg->client_state);
 
 	spin_unlock_irqrestore(&pg->client_lock, flags);
-	mutex_unlock(&pg->state_lock);
-
 }
 EXPORT_SYMBOL_GPL(pmic_glink_client_register);
 
@@ -119,26 +118,25 @@ int pmic_glink_send(struct pmic_glink_client *client, void *data, size_t len)
 	unsigned long start;
 	int ret;
 
-	mutex_lock(&pg->state_lock);
+	guard(mutex)(&pg->state_lock);
 	if (!pg->ept) {
-		ret = -ECONNRESET;
-	} else {
-		start = jiffies;
-		for (;;) {
-			ret = rpmsg_send(pg->ept, data, len);
-			if (ret != -EAGAIN)
-				break;
-
-			if (timeout_reached) {
-				ret = -ETIMEDOUT;
-				break;
-			}
-
-			usleep_range(1000, 5000);
-			timeout_reached = time_after(jiffies, start + PMIC_GLINK_SEND_TIMEOUT);
+		return -ECONNRESET;
+	}
+
+	start = jiffies;
+	for (;;) {
+		ret = rpmsg_send(pg->ept, data, len);
+		if (ret != -EAGAIN)
+			break;
+
+		if (timeout_reached) {
+			ret = -ETIMEDOUT;
+			break;
 		}
+
+		usleep_range(1000, 5000);
+		timeout_reached = time_after(jiffies, start + PMIC_GLINK_SEND_TIMEOUT);
 	}
-	mutex_unlock(&pg->state_lock);
 
 	return ret;
 }
@@ -232,51 +230,42 @@ static void pmic_glink_pdr_callback(int state, char *svc_path, void *priv)
 {
 	struct pmic_glink *pg = priv;
 
-	mutex_lock(&pg->state_lock);
+	guard(mutex)(&pg->state_lock);
 	pg->pdr_state = state;
 
 	pmic_glink_state_notify_clients(pg);
-	mutex_unlock(&pg->state_lock);
 }
 
 static int pmic_glink_rpmsg_probe(struct rpmsg_device *rpdev)
 {
 	struct pmic_glink *pg = __pmic_glink;
-	int ret = 0;
 
-	mutex_lock(&__pmic_glink_lock);
-	if (!pg) {
-		ret = dev_err_probe(&rpdev->dev, -ENODEV, "no pmic_glink device to attach to\n");
-		goto out_unlock;
-	}
+	guard(mutex)(&__pmic_glink_lock);
+	pg = __pmic_glink;
+	if (!pg)
+		return dev_err_probe(&rpdev->dev, -ENODEV, "no pmic_glink device to attach to\n");
 
 	dev_set_drvdata(&rpdev->dev, pg);
 
-	mutex_lock(&pg->state_lock);
+	guard(mutex)(&pg->state_lock);
 	pg->ept = rpdev->ept;
 	pmic_glink_state_notify_clients(pg);
-	mutex_unlock(&pg->state_lock);
 
-out_unlock:
-	mutex_unlock(&__pmic_glink_lock);
-	return ret;
+	return 0;
 }
 
 static void pmic_glink_rpmsg_remove(struct rpmsg_device *rpdev)
 {
 	struct pmic_glink *pg;
 
-	mutex_lock(&__pmic_glink_lock);
+	guard(mutex)(&__pmic_glink_lock);
 	pg = __pmic_glink;
 	if (!pg)
-		goto out_unlock;
+		return;
 
-	mutex_lock(&pg->state_lock);
+	guard(mutex)(&pg->state_lock);
 	pg->ept = NULL;
 	pmic_glink_state_notify_clients(pg);
-	mutex_unlock(&pg->state_lock);
-out_unlock:
-	mutex_unlock(&__pmic_glink_lock);
 }
 
 static const struct rpmsg_device_id pmic_glink_rpmsg_id_match[] = {
@@ -383,9 +372,8 @@ static void pmic_glink_remove(struct platform_device *pdev)
 	if (pg->client_mask & BIT(PMIC_GLINK_CLIENT_UCSI))
 		pmic_glink_del_aux_device(pg, &pg->ucsi_aux);
 
-	mutex_lock(&__pmic_glink_lock);
+	guard(mutex)(&__pmic_glink_lock);
 	__pmic_glink = NULL;
-	mutex_unlock(&__pmic_glink_lock);
 }
 
 static const unsigned long pmic_glink_sc8280xp_client_mask = BIT(PMIC_GLINK_CLIENT_BATT) |
-- 
2.53.0



