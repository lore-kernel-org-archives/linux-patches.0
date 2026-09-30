Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680993B3BE1;
	Wed, 30 Sep 2026 19:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795454; cv=none; b=cbAEgH5DqMmCaKwd+BwYGtKfVeJb0GTQoabXlR5f8Gd8Q3Pb37So4MeyN/39L4vVPSCGG/ym3bSUWhfGrVZngNZ64fg3K+cU1oL8Z+YVAK8Wnklz++UrzQ66h9UqZ/8pN6ePvTctZRkdAKH4PLDTB6cx3jKnnh6tXO+uoLrH8qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795454; c=relaxed/simple;
	bh=ErmhK/NZv5yziFr+doac1QiLKxwVi3+2kQrEzsrRq4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4Q1BZLULy2U2j95ls+gyAoOMWgCvITeMIS56tb54H9hdsLWNz4iz35SccKFuuxHheyTowAvfRbCdmVPSbAY9VGNGMHSk/M7VONEP4sEeWA9HvTmLxP1lgTLzU9WkDVJD8cWtU7G25VPDi7ia/T4hhX5yOsI6VqJSBeH2y79CxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySBXKdM6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySBXKdM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8471F00898;
	Wed, 30 Sep 2026 19:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795453;
	bh=0dz9XPPiURZ76cc5OtHKLHt6lkGkhmEttm68NieY4JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ySBXKdM6ThZAXf/65L4pufM9AhER4kdmNaiq8/DfezcGlXu7TkAPA35ZTOMpte3Gt
	 8Q/kMC06QKbr8Yq8TNJL+s6rQCJGtwdEgE1eZGQDMml442IcoPdi+WKA1fEsUXs2Pj
	 PeYASm4XXpZAyf71qI/ECQ7QHxgGnuo8P3kD0n+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0522/1193] ASoC: mt6351: Publish the OF module alias
Date: Wed, 30 Sep 2026 17:20:06 +0200
Message-ID: <20260930152445.784812690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



