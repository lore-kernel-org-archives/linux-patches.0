Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058259;
	b=hOROz70xMaZN2xNa7pk12UrIcFZWHIMFWlLYeONDQj9AIDjW4Bhz5zYHrBU9EVyWJUSL
	 hW7nSeb5HuPPEDVyjhymi+G94Hg+Y/3I4SdLx4nQnGd/lNkUFI3647MYJFsTr6XdDsQff
	 cISGJFB8ckRxGC/PgHpwjquj9JW4AKKkRXKTDAbaFWw99ncJhDjUGr5equBm7jKPQeYeW
	 2DtNS3MvH/JQSjGlMZH5SeyOuVDMhf95/6OFd+qcOgXQ1PE9XJOiaQaFI2uxU8MdCpObO
	 NGrLIwL+thyQAp0DpCvMytEojRupWvhrAyrdhhZvu/kWzPWunxhCHF8AwyBnj6hYVfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DjxLKEjsi/3BwVwoZxzTbm4xXAeamAZXx+LIjWsCvkY=;
	b=PAu0D0PnE7aI2nGgUy/RGw0Oy2i/VYwjgCipKpo2tD4BaJ8+Myog/qG//gsEAaTpXOfU
	 yJ/tLwNKcGroWgK3fJb7l+JM6H0FidJjtPq4KC2G8cbxVd0lnlS8nG+LxOW4MtwlNlhRU
	 sIUYZ8hQwXyPQxkKeOsGxq2qS8rkEbmQzfAcO4Ym6evs7xOWosI+IGZnOjgCVEaFH83ZH
	 OhvXMzqkk0s9nMAtFa7vXikkL9pvTQHeOR9qZagQYoTh5f1QET7O8R2NCBawg8sz5gw3m
	 98M4ouQGD/JNe5dGwcDQiMwrsisbbxGiHSN6GXbNgcCEutwSL9ZFaBAy0fxIAKFGW4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MeZhg0bm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FEF606A31C;
	Thu, 19 Nov 2026 03:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MeZhg0bm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9EA1F000C4;
	Thu, 19 Nov 2026 03:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058259;
	bh=DjxLKEjsi/3BwVwoZxzTbm4xXAeamAZXx+LIjWsCvkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MeZhg0bm4eD7b4UqKyxSzMlLk7GSZQSpEjHAmHCY3WKxNNXtXnaQjC2kQFRgyntqm
	 LM6td8rFFqoxOYWDaq8ISCXYDKKdJfSY9TUMwPksg6LthsVs8dDM5kobhVuUmSw4EA
	 awtpjyRQsefg+h2WPublZvYb/daauQQAWjiPVlaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0422/1848] media: marvell: manage the MMP camera clock provider
Date: Wed, 18 Nov 2026 15:41:00 +0100
Message-ID: <20261118145931.782180719@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 9887716132d6c3c58cc67841dfb441c5a4a0d209 ]

mmpcam_probe() registers an OF clock provider before requesting the IRQ.
Neither a later probe failure nor driver removal unregisters that provider,
although the underlying clock is registered with devm_clk_register().
This leaves the provider referring to a clock whose lifetime has ended.

Use devm_of_clk_add_hw_provider() with the existing mclk_hw so the provider
is unregistered before the managed clock and camera storage are released.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 81a409bfd551 ("media: marvell-ccic: provide a clock for the sensor")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/marvell-ccic/mmp-driver.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 63fce1b85d266..774b3c731daee 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -25,6 +25,7 @@
 #include <linux/list.h>
 #include <linux/pm.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 
 #include "mcam-core.h"
 
@@ -253,8 +254,8 @@ static int mmpcam_probe(struct platform_device *pdev)
 	/*
 	 * Add OF clock provider.
 	 */
-	ret = of_clk_add_provider(pdev->dev.of_node, of_clk_src_simple_get,
-								mcam->mclk);
+	ret = devm_of_clk_add_hw_provider(&pdev->dev, of_clk_hw_simple_get,
+					  &mcam->mclk_hw);
 	if (ret) {
 		dev_err(&pdev->dev, "can't add DT clock provider\n");
 		goto out;
-- 
2.53.0



