Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E851250C2B7;
	Wed, 30 Sep 2026 16:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785247; cv=none; b=hV1skycdvk/2FVCiAo4PzXMjzM56YDvihfQM9i+L8XtoF+B4HPD1HsTwBqPZ/XfEYI3WT+pNqP4EQ8eovZj1mnGCpqLenbk3cJCPUa/xKKXB0jOmh/suV7U1woldEoTnP1P2Wwou99kTReMhfaIqZoYKYatSFv3a01c82rnHa4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785247; c=relaxed/simple;
	bh=yrzc3/NUYvkaqoH2S8Eck8vvHLpm6S7+LALYwiptEdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ez2XH6z12HoLq5bSj1DYfqJa3F0U5c1oUaGulwpmIyc/FmIueiQi3fWp5ICu9Yrnrv5oXtTNdQgGdJ9eSBJ84w1KXvDXSZiTop5HxbbfT7OX6y5Kjq2zVAFLrbPhBjf+mfIEdr4lPNW+kSOyRweQh9QdBcuP4YYkPvkX8mBny94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnbE1yar; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnbE1yar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BDC1F000FF;
	Wed, 30 Sep 2026 16:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785243;
	bh=bxMmgnGmL1IcrCfn0ScUFskTfXStY3rh1QNgcvo0onk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NnbE1yar3Xk0sbYW6WIYjPYmiUSfTbAp85koeSRMLAotiauPfoUTYY6NKkUDtkV6s
	 dyIfHgB2T7uLt5ndV5pVD3pTkQdLPf7SvqXAWrQDR2kiYKGqIz3Dz38vUFjDDVibKt
	 DgKaM88buPivWR7onT7PygiNy8nFPlnRlIkqv8sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 438/982] ASoC: mt6351: Publish the OF module alias
Date: Wed, 30 Sep 2026 17:19:34 +0200
Message-ID: <20260930152426.201795923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d2cf4847eead1..c333393ce6f26 100644
--- a/sound/soc/codecs/mt6351.c
+++ b/sound/soc/codecs/mt6351.c
@@ -1479,6 +1479,7 @@ static const struct of_device_id mt6351_of_match[] = {
 	{.compatible = "mediatek,mt6351-sound",},
 	{}
 };
+MODULE_DEVICE_TABLE(of, mt6351_of_match);
 
 static struct platform_driver mt6351_codec_driver = {
 	.driver = {
-- 
2.53.0



