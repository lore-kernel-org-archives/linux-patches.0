Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590773;
	b=k6XNaqWnBh0OJaDqrE0Y+noxCD7XxRcqyLqy+eGthiqNDwQKzYn8Zndtv7sgXHBgUcPA
	 C76C3dqgt0RJiiol0O5cHFgyDKMnARbpcxM2yyVJeuvV98j3W+UVOKnPYZDBfIQRgMEqv
	 7DyR63op0gZ6ubr5QuxRlYMzizPLVJKsAyPF1BgV8W7OfSn6RUql2Mxojbv7wtvyTLF1C
	 nXs4Nb5D3jm8JGGt9WVmawnK4/78BfmTc2CVqEoQ7uRWAz8ENs6/2Na8YBGOkesfn1Jm3
	 db3TrPlH5BNc8reo7QlLbTX2GuRIIAgHBBWcC2nEXpiciQYwJPH2qj8gmBrPtCqOLqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zqeVhQDdgXfJ+eGDjEkxafoPdfIOtSjEaYp1A04iNLg=;
	b=rgQuPN/ALWjlShcnwHqn4oB/2BfEKIOxCXVuI7eSFB10znoRbyCOL2N0ChLoA0ZNF1rD
	 YXJJ7BGpxdt+4Qs9oe+X7O1fHfdWWcq85kfyhPhg/cg5OXD8ioLXRFErfrV0yuPE94YUt
	 28D2WX45wFQ+OKR8X+VBN43ZX58y02Y9dunTAQfuG51NZhldF9CePZogA4zHrvxFY2BeJ
	 p70oyQ+CUTqXxxMWeu2lcZU8gvTy+Mlq0EoXJNtICaEiVi/j56KZXZoNdGCUNVH5C3Tkz
	 /4fCg+9JZaOff6tr880Y15LPbqMPVWIyOk52R2/J2qYlJH3f1r/oodmhySTWnxqLHSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rj5etfc0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B77606E207;
	Fri, 13 Nov 2026 17:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rj5etfc0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545891F000C5;
	Fri, 13 Nov 2026 17:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590773;
	bh=zqeVhQDdgXfJ+eGDjEkxafoPdfIOtSjEaYp1A04iNLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rj5etfc0UBaOtDa8wPIupEtoxma6VPa04GFpX6uxrEFS7nxCGODCKtzNGh3CSrid4
	 O17Jxd+l3NNyqnce9BF/M5R2/1ChAzw5Lp2geQMMybsKcHa7npPYTe6SS/RzbR7aT2
	 zLL6KNlY8S41fT/HitFIFDcB7qb+UAMZGosrzcxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 670/686] crypto: omap - add omap_sham_unregister_algs helper
Date: Fri, 13 Nov 2026 10:53:23 -0500
Message-ID: <20261113153844.386836961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index ff8aac02994a4..7b3612d097700 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2041,6 +2041,20 @@ static struct attribute *omap_sham_attrs[] = {
 };
 ATTRIBUTE_GROUPS(omap_sham);
 
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
@@ -2158,10 +2172,7 @@ static int omap_sham_probe(struct platform_device *pdev)
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
@@ -2182,19 +2193,13 @@ static int omap_sham_probe(struct platform_device *pdev)
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



