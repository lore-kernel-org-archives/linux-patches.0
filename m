Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036045;
	b=4V/GNKl+Dij+yY4UkvypqvN67zO5em6ecJhKlQJlVCrwikLPFOm+R4WwDDLvISGiTHAy
	 f6xoFTvag17qWL3QiZ10Pcr6x1Upu3QjgXbDBLMs7/VsYJ90+6aZ1Mo8Nv3EF7+2DUuA1
	 OiR5SIxT7TxcDIPqj8lR8U1y/gtaOeGTxn43DcOGbi2tmblFN2LcAWhyV/qrBAojPnIYP
	 rJEPgTmZf41V6rjOL19Q1rvciKnQHYxSCHepTYj1vyF9HC9ty60KMIQ7ckijkNyBGajnk
	 tq8OE3noF0IJzmmZ9qBsSYYRvBsZyjF//e/v3v7r2k9ECu8zehAJ58DO3kIrhbfWRLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UMbSZB/WKMWXCUj1TtgslxrIcl0ME+VKrSHTX2zPZkQ=;
	b=IoVjIe8QKV+AbyzhU58MPGwsr7azNTXOooRFjK83sU5kKliqfE9pI9JZIdRrsV1D/mQ9
	 Eioac7V9x6sBoJnwZwTW265qKgjX0AWCeoXEnCDN88bctMsig31lGLSSgLHiKBu11qIp7
	 458p6X0dXr7tYEMUqNtf2Tufiay2qhKDL2jFMJZrGd13Qv7+UgYM5RLYGEMiPIDC2ccF7
	 kiP0RqF82i2SGEeAMiDmmlF14Cuuzo3h/buA3DHOmLKXKr1aEfWL9lLWhRkxRC/yCm49i
	 gnjJxwGL7BJapj+7HHAnw2YsT1/PpYknDBOdLM94VJ5e4KPKONw0AQQVP13WH02n7Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BnWd+/Qu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FDC606A320;
	Wed, 18 Nov 2026 21:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BnWd+/Qu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AF91F000C4;
	Wed, 18 Nov 2026 21:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036045;
	bh=UMbSZB/WKMWXCUj1TtgslxrIcl0ME+VKrSHTX2zPZkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BnWd+/QuPiy0tqawGKF8GNvy/JwEef76NjbiThXp+bQ0Mbp1o0uvicF3eZouL3yWv
	 LWzMxVY/APIB1UhS8BicMIC5WnnFNT5Bg0jhEedQsnPKAWRXFE1YARMJWVsWzCRP7U
	 Q2Jn+6OO/m7qwj4Y0RyK6sAn77nNOWSImAzr0+U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0917/3318] media: marvell: manage the MMP camera clock provider
Date: Wed, 18 Nov 2026 15:25:39 +0100
Message-ID: <20261118150347.035127546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/platform/marvell/mmp-driver.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/marvell/mmp-driver.c b/drivers/media/platform/marvell/mmp-driver.c
index f8d595c0687f7..8c6f80674f405 100644
--- a/drivers/media/platform/marvell/mmp-driver.c
+++ b/drivers/media/platform/marvell/mmp-driver.c
@@ -25,6 +25,7 @@
 #include <linux/list.h>
 #include <linux/pm.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 
 #include "mcam-core.h"
 
@@ -268,8 +269,8 @@ static int mmpcam_probe(struct platform_device *pdev)
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



