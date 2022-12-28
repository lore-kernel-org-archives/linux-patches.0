Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD1F1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00952C433D2;
	Wed, 28 Dec 2022 16:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244059;
	bh=1aiuqXzAUbXCXR6zYgO47XOSzuBiFFmc+yBqMG/3uyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gur/YqBEPEdcEfOdalcp4qWcWtrjXbXoCtTxHsfTonq4h3nPoygEgnqw3/ZxF4Uwr
	 x+31yKSqDanZVmLCrCfmFCXPRIINWYS29nVw+tV/pPpqQgQDXPJotPJh02/2No5Vgv
	 By8C8tLKOLCyGKb66Baj19WqSpWJ6m3W8/bd/F9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Mark Greer <mgreer@animalcreek.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0639/1073] crypto: omap-sham - Use pm_runtime_resume_and_get() in omap_sham_probe()
Date: Wed, 28 Dec 2022 15:37:07 +0100
Message-Id: <20221228144345.397208004@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 7bcceb4c9896b1b672b636ae70fe75110d6bf1ad ]

omap_sham_probe() calls pm_runtime_get_sync() and calls
pm_runtime_put_sync() latter to put usage_counter. However,
pm_runtime_get_sync() will increment usage_counter even it failed. Fix
it by replacing it with pm_runtime_resume_and_get() to keep usage
counter balanced.

Fixes: b359f034c8bf ("crypto: omap-sham - Convert to use pm_runtime API")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Acked-by: Mark Greer <mgreer@animalcreek.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-sham.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 655a7f5a406a..cbeda59c6b19 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2114,7 +2114,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
-	err = pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
 		dev_err(dev, "failed to get sync: %d\n", err);
 		goto err_pm;
-- 
2.35.1



