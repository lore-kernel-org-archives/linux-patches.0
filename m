Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030856;
	b=Scx3iF46BNTr/24EHj7/hxVbPVSVcCyEJvxsR1CZTOJArMhJuDdmAwSyJQhnaUd/o0A0
	 U/ZFjcxzNu0sfAfoD3fiyUwgmuHwRNj1AG88p6emPF0Z8kwjfqJeHDA0ibhtLVjQV43we
	 93+lLyb2QFd0Ktp5q/KoSVOyJcFEYAejFsIQV/fU84cSSlAmJ/n05wp+/GGPmjkMfjpTV
	 B8ztItzSE9QmCfPde8th8ZGVnM8FZqlK/NsaGf/PEmn3ZZTcfD2K8zEuip27htyIywZtB
	 /mEkTm8UHeirpAzX4Lz3E1y+jMO5IAXSYTLOKNtHOhVhoGKY3naM8/op5UsVF1jwVLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ml3dOcjEup9YkN1r2zNwQWj5nOCvRTvsMFU6G4gDMYk=;
	b=a+21Xtz42ANX4BMxbBSjjkhctexAgZDMyhukmNS8aWF5YQ3QgltRb1Em0w9ekEm8gODx
	 hi2PzORfybLfYIVhQe73V0Ep4FaoLx/WXkA+xUL8MCU1tKqwe+W/CaO/WU2b6AsWq2pVq
	 v4X/PCmEE73OFAuNIXguDyqMOI8pOCPEkiNupgbaCxg2w3nSvSaj5YJQ0hfVxv4gHYEDX
	 2pT7AUS7KIFz1P4O7YWmbVLWyaY2F2LgEX/M6lgWE847WLMAWfxk1tnNNgj2HGssHQZLt
	 jXen/ZsB87TcX7eBUJcYuVOTo9EPbHfIL+Jk/hP07MEVFkDLqML9+VgI+0lnta5DNzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DZTPVjk7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC41606D344;
	Wed, 18 Nov 2026 19:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DZTPVjk7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47861F000C4;
	Wed, 18 Nov 2026 19:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030855;
	bh=ml3dOcjEup9YkN1r2zNwQWj5nOCvRTvsMFU6G4gDMYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZTPVjk7ZywcRxdbYKyjRocF6WupkPT/zLDn0Dk1wxauS3FG3yEpW7fZi07tY/brT
	 99kBKWWJoIykotWOZNj7PryYBmIICJO8iiKwKNbu1pLsTYI1ibDgrwhancb5OW0uxe
	 3lc7YKr6a06STxGfnxTkJ6kyrFqxc/XZ6O00EjkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0852/1756] ASoC: mt6359-accdet: manage private workqueues with devres
Date: Wed, 18 Nov 2026 15:49:39 +0100
Message-ID: <20261118150043.298784024@linuxfoundation.org>
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

[ Upstream commit 9a773d9d21fa909e8babbe11e93c811cf1a6d22d ]

The threaded jack-detect interrupts queue work on two private
workqueues. Neither queue is destroyed on device removal, so queued
callbacks can retain pointers to devm-allocated state after it is
released. Probe error paths also leak the queues.

Create and initialize both workqueues before requesting interrupts, then
add a managed cleanup action. Since the managed IRQs are acquired
afterwards, devres releases and synchronizes them before draining and
destroying the workqueues on both removal and probe failure.

Fixes: eef07b9e0925 ("ASoC: mediatek: mt6359: add MT6359 accdet jack driver")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260928134054.312-1-getshell@seu.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/mt6359-accdet.c | 50 ++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/sound/soc/codecs/mt6359-accdet.c b/sound/soc/codecs/mt6359-accdet.c
index ed34cc15b80e8..daac670ab7600 100644
--- a/sound/soc/codecs/mt6359-accdet.c
+++ b/sound/soc/codecs/mt6359-accdet.c
@@ -919,6 +919,14 @@ int mt6359_accdet_enable_jack_detect(struct snd_soc_component *component,
 }
 EXPORT_SYMBOL_GPL(mt6359_accdet_enable_jack_detect);
 
+static void mt6359_accdet_destroy_workqueues(void *data)
+{
+	struct mt6359_accdet *priv = data;
+
+	destroy_workqueue(priv->jd_workqueue);
+	destroy_workqueue(priv->accdet_workqueue);
+}
+
 static int mt6359_accdet_probe(struct platform_device *pdev)
 {
 	struct mt6359_accdet *priv;
@@ -960,6 +968,26 @@ static int mt6359_accdet_probe(struct platform_device *pdev)
 	}
 	mutex_init(&priv->res_lock);
 
+	priv->accdet_workqueue = create_singlethread_workqueue("accdet");
+	INIT_WORK(&priv->accdet_work, mt6359_accdet_work);
+	if (!priv->accdet_workqueue) {
+		dev_err(&pdev->dev, "Failed to create accdet workqueue\n");
+		return -ENOMEM;
+	}
+
+	priv->jd_workqueue = create_singlethread_workqueue("mt6359_accdet_jd");
+	INIT_WORK(&priv->jd_work, mt6359_accdet_jd_work);
+	if (!priv->jd_workqueue) {
+		dev_err(&pdev->dev, "Failed to create jack detect workqueue\n");
+		destroy_workqueue(priv->accdet_workqueue);
+		return -ENOMEM;
+	}
+
+	ret = devm_add_action_or_reset(&pdev->dev,
+				       mt6359_accdet_destroy_workqueues, priv);
+	if (ret)
+		return ret;
+
 	priv->accdet_irq = platform_get_irq(pdev, 0);
 	if (priv->accdet_irq >= 0) {
 		ret = devm_request_threaded_irq(&pdev->dev, priv->accdet_irq,
@@ -1005,22 +1033,6 @@ static int mt6359_accdet_probe(struct platform_device *pdev)
 		}
 	}
 
-	priv->accdet_workqueue = create_singlethread_workqueue("accdet");
-	INIT_WORK(&priv->accdet_work, mt6359_accdet_work);
-	if (!priv->accdet_workqueue) {
-		dev_err(&pdev->dev, "Failed to create accdet workqueue\n");
-		ret = -1;
-		goto err_accdet_wq;
-	}
-
-	priv->jd_workqueue = create_singlethread_workqueue("mt6359_accdet_jd");
-	INIT_WORK(&priv->jd_work, mt6359_accdet_jd_work);
-	if (!priv->jd_workqueue) {
-		dev_err(&pdev->dev, "Failed to create jack detect workqueue\n");
-		ret = -1;
-		goto err_eint_wq;
-	}
-
 	platform_set_drvdata(pdev, priv);
 	ret = devm_snd_soc_register_component(&pdev->dev,
 					      &mt6359_accdet_soc_driver,
@@ -1039,12 +1051,6 @@ static int mt6359_accdet_probe(struct platform_device *pdev)
 	mt6359_accdet_jack_report(priv);
 
 	return 0;
-
-err_eint_wq:
-	destroy_workqueue(priv->accdet_workqueue);
-err_accdet_wq:
-	dev_err(&pdev->dev, "%s error. now exit.!\n", __func__);
-	return ret;
 }
 
 static struct platform_driver mt6359_accdet_driver = {
-- 
2.53.0



