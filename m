Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CB04F85C5;
	Wed, 30 Sep 2026 18:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791506; cv=none; b=ElDokXvjBkcBCaahjIvg/fCFnice3pwi1Bg6z4d3w+jUQyvR5PkvIB66EjcbDZCjpHGZwMXlV1mUpfKauei7pcYgiQMopnKI5ZlM99KHSjVVtnFFhT9K4ZbbtSvA52ITljWHcMp8IDb4Mgd54uC++YYKLj/dMchaRfIB3c9Bwys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791506; c=relaxed/simple;
	bh=A+n99xzESRO3Q9YNX1h+hWd8Mp9q9VTN8rn82/yoMl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8/o023Yd8RRVW8J9elkeegryzQ4V70A1thkE0Z2BW/TmF80n91oihK5CLRXc40pGHzc5E4OeyKohtz0B2QcMMz/8DGNaTWHdpkltmup/uB6zlwLykcIxLs4375D+fm8i3ThL+q5oUU4hInXus2zlRyeUiczAsIC04OuWNJPdCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EM1EEBuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EM1EEBuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A1C1F000FF;
	Wed, 30 Sep 2026 18:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791505;
	bh=K3S/ekqgkEe652ZRAEWOR5gA4zkbbYIVDH2Zt34Go+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EM1EEBuf9umjF/PBlCTFoPF6GbL/7xT2UjFxnfDbToXSewWt9IsL4tqE+f0MhFbX7
	 G12pRM+anJCY/w7y5mdiIiV6AcW0FGQ74lRBfrwGVOpgh/XYT8W/psP+03iWxEr7BH
	 P/P5JduLfEq/14w2UZQOQUDPrVt0lPKWkQ/aSrfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 327/752] ASoC: mt6351: Publish the OF module alias
Date: Wed, 30 Sep 2026 17:23:17 +0200
Message-ID: <20260930152405.372016783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit 9c3882ec10399c14c59b7e4599d33c4395367c37 ]

The MT6351 codec platform driver uses mt6351_of_match to bind devices
with compatible mediatek,mt6351-sound. The codec can be a separate
module, but the OF table is not exported to module alias metadata.

Publish the existing table without changing codec matching, register
access or the machine-driver configuration.

Fixes: a74d51ba0e17 ("ASoC: add mt6351 codec driver")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Link: https://patch.msgid.link/20260905133210.63803-1-hppiscas@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/mt6351.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/mt6351.c b/sound/soc/codecs/mt6351.c
index 5c0536eb1044f..cb6c5bd7a233b 100644
--- a/sound/soc/codecs/mt6351.c
+++ b/sound/soc/codecs/mt6351.c
@@ -1481,6 +1481,7 @@ static const struct of_device_id mt6351_of_match[] = {
 	{.compatible = "mediatek,mt6351-sound",},
 	{}
 };
+MODULE_DEVICE_TABLE(of, mt6351_of_match);
 
 static struct platform_driver mt6351_codec_driver = {
 	.driver = {
-- 
2.53.0



