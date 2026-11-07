Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061408;
	b=gj/abSL7cC7sxNrh0ZGz6EfravpGUlHS/b5AKIFZeti16uzf0MICLLiWXR/G8Fxz/+Hd
	 Sm3dNMKHGpniTcKaxvRzhcJARpN5b/bQjusaro9F0c0Go0jQ7hb679/xmVGWQTiBEMfyj
	 V6ttFiVhhJt68DAWG96N3lHoPnHfEZkJslEKg+X3NZxGVq3LmW7tQaaUd2tsifzKj45Bf
	 96jSOmqRMp5MOhO5g3rzun7JuRfabkdcWQNqeXtSf62t4IRZT7GzX4DB3pBA6IK8yZX/v
	 r4lfOFBZgPz19GMX0lgRbA3FT/oDhV7CZsRVI83pGTy9WaF9FR09x1EdzxjklvILSdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8XkhRO2VJd4lo1P6n0tWGSvZUddO/armP62IOoiyjBI=;
	b=ACH0URojVSxfiOXg2F7hWfLRkLOilK2xEK2WJtV8YC4XUyf538I3ADYEMc1NDOo3dS11
	 HVtRdK5iOwfA7bMvwW1cb6LQ3yeSg6lM3w8V5b2ku3q2RDP0UxNMze0NL0KV3Qq+acFXD
	 wyaDwMNbq2YzKUzuAgTruAsC9LnIbZmu+fLjii6PbOj/QRDHPkAur7wA0JEPJG/XrXTGQ
	 KwBpIwM66i5DUuhMHdbUlKFjuFAEm792aToaKy5RCktAql4II1EUbbkO/1ycp/Kc3VTkN
	 J84xzEt/57Va3kWQdV7xmJhMF8+tDS7lc3TCSaSSsUZ+RRl/RnxfQhBiR+UD5n3UZBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WDQVF90D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CA5606A332;
	Sat,  7 Nov 2026 14:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WDQVF90D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C8C1F0089F;
	Sat,  7 Nov 2026 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061407;
	bh=8XkhRO2VJd4lo1P6n0tWGSvZUddO/armP62IOoiyjBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WDQVF90Ds8A1UFiavyLtmj+yDOYeO6Kv5vHD2uBnSvcBkKioAxehEzb43uHoPa/pU
	 CMGpOkHQ5U2XlJ1ygGPFedbHUJshEfZuGfwpATH3AaRY5zDBzqgPjdmCRoH7vgfC3o
	 KmEtvC4WFVJ+FsNRVk/aPa9fPHPIx8EfBNXyv+uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0497/1536] i2c: qcom-cci: Remove overcautious disable_irq() calls
Date: Sat,  7 Nov 2026 08:41:53 -0500
Message-ID: <20261107135011.418009783@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit f0285c286bca5a1e018ba25040cef6c7806c31ef ]

In cci_probe() the controller's interrupt is requested using a devres
managed API, and in cci_probe() error path and cci_remove() it'd be
safe to rely on devres mechanism to free and shutdown the interrupt,
thus explicit disable_irq() calls can be removed as unnecessary ones.

Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260515234121.1607425-5-vladimir.zapolskiy@linaro.org
Stable-dep-of: f98d49864821 ("i2c: qcom-cci: fix autosuspend cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-cci.c b/drivers/i2c/busses/i2c-qcom-cci.c
index 5215a003869df..f1fafa426ca90 100644
--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -620,7 +620,7 @@ static int cci_probe(struct platform_device *pdev)
 
 	ret = cci_reset(cci);
 	if (ret < 0)
-		goto error;
+		goto disable_clocks;
 
 	cci_init(cci);
 
@@ -648,8 +648,6 @@ static int cci_probe(struct platform_device *pdev)
 		if (cci->master[i].cci)
 			i2c_del_adapter(&cci->master[i].adap);
 	}
-error:
-	disable_irq(cci->irq);
 disable_clocks:
 	cci_disable_clocks(cci);
 
@@ -668,7 +666,6 @@ static void cci_remove(struct platform_device *pdev)
 		}
 	}
 
-	disable_irq(cci->irq);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 }
-- 
2.53.0



