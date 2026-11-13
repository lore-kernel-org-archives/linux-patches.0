Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591618;
	b=MQKayPfq1xAl1LIZU1Aekx0DnKR/cqZ7CSSIvoJ6/gxaJoLGnOBko9TBKQiHI3vVPhlV
	 MEPcBCnGcKnFPQ+BdVRHb7WP3W4AwN4MVDsbEh26JEcJALUqE7GUAOx1187I9nToWmbYp
	 iWGKfupE+MiXVlyfmyEUmrYEiwwTFA01/IeSrQf+ROTHi9i2B0BU3TkpiNpofnStCzcb5
	 JHMdAIejAgg+qU62+RcYiqprTvqZR8OlGAmjjB3dbbykfmuajjFIIhSho2J0N1PVLZwYh
	 WzPrxVloGTwAAtd4/ObxeI/pZ3+lT3lh0CgldSJUqQoY8ldBqqxTvGSe3Mb+b/kD3Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wH5Rg5oiUex5TpMlkwDRMHbbAlQx1Ox38+vVIqN/fXM=;
	b=tPbzevswOczvYXl8FMqpOmGG5yJpO+BlHY8OdjsoS8LAvfLXZg24/IUheB+2MvlN5b1j
	 0j+3subeLDj9feYezXik8nOCRDeDJEKgeZqUrxO+7llMzTTa1UXaeKglPWadqIoqC/y1y
	 xae5lAz2OuV5G9UQvxD4Vy1ouqOjtYyRKcxYtcGZKBccUyUVuW9yIQhbXt0+USIrZzuCp
	 /jLcHLaTHD9BUl82vwcDgXak4k7jTaqd3qWhqLnzxY8/WRJpH/V3IC7tppulZL0mrB/Gr
	 fjM03e/nOeFlU15pMaPlDT0gSjKCtjBwIa/4q1RNH+HNb6KrJL5StP2CJDeRhv300UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h1uhBMyR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01474606B47A;
	Fri, 13 Nov 2026 17:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h1uhBMyR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A177B1F000C4;
	Fri, 13 Nov 2026 17:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591617;
	bh=wH5Rg5oiUex5TpMlkwDRMHbbAlQx1Ox38+vVIqN/fXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h1uhBMyR8+gcsmEpFB+ZmzKfvlbYmhvevGNPhOyuV7VNKtUt4242s0Usz5Fferw0l
	 wYSa7oJdgWWMsExNTEjw7mKfkX1dd4QK5Wnl5ONJOkPgql+UBTNGCmvblQnrBHJBzD
	 KBof4io/cMzRVmj9xwBg3XPYFc4WkOPjlR5hhkuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 651/670] crypto: omap - add omap_sham_unregister_algs helper
Date: Fri, 13 Nov 2026 10:53:35 -0500
Message-ID: <20261113153833.930605274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit c3494e6fbb35579a131de11369b658a59b1323e5 ]

Add a new helper omap_sham_unregister_algs() and replace two for loops
in omap_sham_probe() and omap_sham_remove(), which also ensure
->registered is reset to 0.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: be51ea091c65 ("crypto: omap-sham - fix crypto engine cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-sham.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index d17654c0410f6..51842cf61995a 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2045,6 +2045,20 @@ static const struct attribute_group omap_sham_attr_group = {
 	.attrs = omap_sham_attrs,
 };
 
+static void omap_sham_unregister_algs(const struct omap_sham_pdata *pdata)
+{
+	struct omap_sham_algs_info *alg_info;
+	int i;
+
+	for (i = pdata->algs_info_size - 1; i >= 0; i--) {
+		alg_info = &pdata->algs_info[i];
+
+		crypto_engine_unregister_ahashes(alg_info->algs_list,
+						 alg_info->registered);
+		alg_info->registered = 0;
+	}
+}
+
 static int omap_sham_probe(struct platform_device *pdev)
 {
 	struct omap_sham_dev *dd;
@@ -2168,10 +2182,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 	return 0;
 
 err_algs:
-	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
-		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
-			crypto_engine_unregister_ahash(
-					&dd->pdata->algs_info[i].algs_list[j]);
+	omap_sham_unregister_algs(dd->pdata);
 err_engine_start:
 	crypto_engine_exit(dd->engine);
 err_engine:
@@ -2192,19 +2203,13 @@ static int omap_sham_probe(struct platform_device *pdev)
 static void omap_sham_remove(struct platform_device *pdev)
 {
 	struct omap_sham_dev *dd;
-	int i, j;
 
 	dd = platform_get_drvdata(pdev);
 
 	spin_lock_bh(&sham.lock);
 	list_del(&dd->list);
 	spin_unlock_bh(&sham.lock);
-	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
-		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--) {
-			crypto_engine_unregister_ahash(
-					&dd->pdata->algs_info[i].algs_list[j]);
-			dd->pdata->algs_info[i].registered--;
-		}
+	omap_sham_unregister_algs(dd->pdata);
 	cancel_work_sync(&dd->done_task);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.53.0



