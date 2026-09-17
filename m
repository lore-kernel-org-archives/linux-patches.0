Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA0152188E;
	Thu, 17 Sep 2026 17:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665882; cv=none; b=fKfGTEQuD8vIAg+7iMXymRbetw5kadq1+zSdbmRL3NCLGr8EIYDTilbBpLWoqq7H9f17h3PWH463qgUl+KKq97fzyVRRbeoRXs9oe7tnhdF4uUlCxKQSR5cuYFTdgFhS2qpCo73WEuddfQFzyoQuluoeTEBhuuSKj4b46Qz51Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665882; c=relaxed/simple;
	bh=RdTCs5a/TojWFRxnlAu50oBcjRu2d9htTyW9JIpUWgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsHRSUGtKAIL8RCF1yyvhRfZ4UijL5E7aoreC2OucKWAjxBWONK8yqnn3LbgOaTAWtbATC/acO0cchcP2xhIIpL1iqGXpubRyR+FAMWgl8pCigzl5gcEARHsRdyj1vh5Sn0tG/Ac/1WUmx/+JnjFxS9iFrLQceMYQuR+f53E4T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVhmrNnv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVhmrNnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82911F000FF;
	Thu, 17 Sep 2026 17:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665881;
	bh=LPCXtJQbsRbNyHdX2MY0CLbQFU3wHadXVFqJSBJcaLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVhmrNnvQ2DoethwOUz/EI3e599X7PzUgnKg4dxgphKUmHhxn2f+GoRT7soiHvQXA
	 MkJ/Y5B4TykdKUs2jMR7T42fbQCzNjUVUAWr4KgYAgBmIgTjB8CcN2CBJXZpY9WLsl
	 Wl1fRUtYq7+WhfyMeR7AgSlTIH22Elb/MCSrMOnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0850/1250] ASoC: mt6351: Publish the OF module alias
Date: Thu, 17 Sep 2026 16:10:45 +0100
Message-ID: <20260917151615.000716384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2a5e963fb2b57..401cb0b48c972 100644
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



