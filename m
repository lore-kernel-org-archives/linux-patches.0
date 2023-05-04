Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88A57E
	for <patches@lists.linux.dev>; Thu,  4 May 2023 13:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27234C433EF
	for <patches@lists.linux.dev>; Thu,  4 May 2023 13:58:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=inbox.ru header.i=@inbox.ru header.b="m//zc95D"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Thu, 4 May 2023 22:58:09 +0900
Resent-Message-ID: <ZFO58Si5QOyTym3Q@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Thu, 04 May 2023 08:16:49 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=KLAT=AZ=inbox.ru=fido_max@kernel.org>)
	id 1puTCp-00Eaj0-3q
	for broonie@sirena.co.uk; Thu, 04 May 2023 08:16:49 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 6676362CAC
	for <broonie@sirena.co.uk>; Thu,  4 May 2023 07:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id E2C68C4339B; Thu,  4 May 2023 07:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2C45C433D2
	for <broonie@kernel.org>; Thu,  4 May 2023 07:16:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org E2C45C433D2
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=inbox.ru
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=inbox.ru
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail4;
	h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=CJN5+m1KNeYBxu9b+ut5Y+Z5hkr1WgvRPiVXKn5htjo=;
	t=1683184603;x=1683274603; 
	b=m//zc95De/RfIEYca+0ZsebRpIup4ArdIk6KSESgO3T6OX9ZBfH0eUkXXso36RDLS1ApTZXpFu5h8nkX6zqhguU/V1WEbZ8xVFEvXZNUvgmV7GN/6S8mYkPizMO4tkqba/wKt6t1Nzfgm0cGZKy99pqlNprxsl2I0GCHOOpQgKiLWUpU4+BikE60ZL7BtAC140jJc3L/nvqQqOPyl0FCRRoX8386O4ur4pHvhzmK6L4aMIj3GzwXCBaNsQNgI38U/zqhG27aSpI/31k+wn3teqtyzgVpuxkUfwLCC0NhOoq1Xq9zJ+CS8ryymBz7JQlTovAbl4+7WzINc53H/CmFmQ==;
Received: by smtpng3.m.smailru.net with esmtpa (envelope-from <fido_max@inbox.ru>)
	id 1puTCa-0007k3-R7; Thu, 04 May 2023 10:16:33 +0300
From: Maxim Kochetkov <fido_max@inbox.ru>
To: alsa-devel@alsa-project.org
Cc: lgirdwood@gmail.com,
	broonie@kernel.org,
	perex@perex.cz,
	tiwai@suse.com,
	p.zabel@pengutronix.de,
	ckeepax@opensource.cirrus.com,
	u.kleine-koenig@pengutronix.de,
	nicolas.ferre@microchip.com,
	Maxim Kochetkov <fido_max@inbox.ru>
Date: Thu,  4 May 2023 10:16:18 +0300
Message-Id: <20230504071618.52012-2-fido_max@inbox.ru>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504071618.52012-1-fido_max@inbox.ru>
References: <20230504071618.52012-1-fido_max@inbox.ru>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtpng3.m.smailru.net; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-Mailru-Src: smtp
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9EB47717F7D2952927A96D7029F65AB07806C062B08BE12BB182A05F538085040D0B941AFC31CF3232069EADDF4C704C887D8DF0C5E877116333F29171445C099
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7548C33FFD72831AFEA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637838376990962B7D5EA1F7E6F0F101C6723150C8DA25C47586E58E00D9D99D84E1BDDB23E98D2D38B6F1F7B995052D5CE53BA037779EF86EDF175DAE5101D1CF320879F7C8C5043D14489FFFB0AA5F4BF176DF2183F8FC7C04CF195F1528592878941B15DA834481FA18204E546F3947CB645AEB2D65EEA52117882F4460429724CE54428C33FAD30A8DF7F3B2552694AC26CFBAC0749D213D2E47CDBA5A9658378DA827A17800CE7C4448250843310C09FA2833FD35BB23DF004C906525384302BEBFE083D3B9BA71A620F70A64A45A98AA50765F79006370669898C38A383F16D1867E19FE1407959CC434672EE6371089D37D7C0E48F6C8AA50765F7900637AD0424077D726551EFF80C71ABB335746BA297DBC24807EABDAD6C7F3747799A
X-C1DE0DAB: 0D63561A33F958A5DDD583A1A1FC91162658D2C8601A3F543F09C2D513307342F87CCE6106E1FC07E67D4AC08A07B9B06A1CB4668A9CA5FA9C5DF10A05D560A950611B66E3DA6D700B0A020F03D25A0997E3FB2386030E77
X-C8649E89: 1C3962B70DF3F0ADE00A9FD3E00BEEDF77DD89D51EBB7742D3581295AF09D3DF87807E0823442EA2ED31085941D9CD0AF7F820E7B07EA4CFB334A04A0A29473D4A27C4CE95E0A46CDCBE2C60DED4EFA3D51FE52412DAA6218FF2D56E53A0872814EE98CD8E9D35FC312A0230C2E403E253558665F9EFD7356E346BF9FA413E5543082AE146A756F3
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojtUGOBMG7VVPLiMA+KLyLdw==
X-Mailru-Sender: 689FA8AB762F73933AF1F914F131DBF54D9D4B6315CAD0F1CFAB24B71DD3744698CC072019C18A892CA7F8C7C9492E1F2F5E575105D0B01ADBE2EF17B331888EEAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: Ok
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=KLAT=AZ=inbox.ru=fido_max@kernel.org
Subject: [PATCH v2 2/2] ASoC: dt-bindings: designware-i2s: add optional resets
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: y1dKk/zxoput

Some SoC may have resets for I2S subsystem. So add optional resets support.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
---
 .../devicetree/bindings/sound/snps,designware-i2s.yaml         | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/snps,designware-i2s.yaml b/Documentation/devicetree/bindings/sound/snps,designware-i2s.yaml
index 56e623d4e168..a970fd264b21 100644
--- a/Documentation/devicetree/bindings/sound/snps,designware-i2s.yaml
+++ b/Documentation/devicetree/bindings/sound/snps,designware-i2s.yaml
@@ -36,7 +36,8 @@ properties:
     const: i2sclk
 
   resets:
-    maxItems: 1
+    items:
+      - description: Optional controller resets
 
   dmas:
     items:
-- 
2.39.2

