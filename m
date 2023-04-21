Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248B02CA2
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 15:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B19BC433EF
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 15:21:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=permerror (0-bit key) header.d=inbox.ru header.i=@inbox.ru header.b="lXmskqq7"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Mon, 24 Apr 2023 16:21:50 +0100
Resent-Message-ID: <ZEaejlnZbM/pIuEQ@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 21 Apr 2023 22:20:03 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=wsCX=AM=inbox.ru=fido_max@kernel.org>)
	id 1ppyAi-00D6E7-94
	for broonie@sirena.co.uk; Fri, 21 Apr 2023 22:20:02 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 8D176638DB
	for <broonie@sirena.co.uk>; Fri, 21 Apr 2023 21:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 108DCC4339E; Fri, 21 Apr 2023 21:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C181C4339B
	for <broonie@kernel.org>; Fri, 21 Apr 2023 21:19:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 2C181C4339B
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=inbox.ru
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=inbox.ru
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail4;
	h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=mkBPQpT2uDxwxYBa8lzR7tPgzhfW+0Cg4P9/VNOLqkU=;
	t=1682111996;x=1682201996; 
	b=lXmskqq7hQbpafPGqakK1u8khFPDQ5St5EY92ANoeQ/1SIwND356tjmK1pnLkFyJHD2MR4iE9ZCv1CDD4KZok91Dz41yy7fHomg1s5UMQj8f8RT3DHHzkDgylCvtODj7QbqEHKbt3l6uk4xKTRr68/ZRCLkKKUgrMIvaK2MQRU6bvU2lm1L0TY2qK+ZI1Gjs9M3mR3CIO1RlvwljayvqgKPOxEL6fED3xkYSOWlfXsWc6pfQ0nY/nroPOlgsG5Ih4w1UWYE86b68obGTdACqxbg+7h0wzZlRAWfNmiO15vyAeKxsWx1blEoq6bw+ZXs+Gw2XVYwXmZaqrc1Q4PUqBA==;
Received: by smtpng3.m.smailru.net with esmtpa (envelope-from <fido_max@inbox.ru>)
	id 1ppyAb-0007fo-6Q; Sat, 22 Apr 2023 00:19:53 +0300
From: Maxim Kochetkov <fido_max@inbox.ru>
To: alsa-devel@alsa-project.org
Cc: lgirdwood@gmail.com,
	broonie@kernel.org,
	perex@perex.cz,
	tiwai@suse.com,
	krzysztof.kozlowski@linaro.org,
	pierre-louis.bossart@linux.intel.com,
	rf@opensource.cirrus.com,
	ckeepax@opensource.cirrus.com,
	shumingf@realtek.com,
	ryans.lee@analog.com,
	herve.codina@bootlin.com,
	wangweidong.a@awinic.com,
	ajye_huang@compal.corp-partner.google.com,
	Maxim Kochetkov <fido_max@inbox.ru>
Date: Sat, 22 Apr 2023 00:19:50 +0300
Message-Id: <20230421211950.20972-1-fido_max@inbox.ru>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtpng3.m.smailru.net; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-Mailru-Src: smtp
X-7564579A: B8F34718100C35BD
X-77F55803: 4F1203BC0FB41BD9D2463843EA06979D4923782C71F503BD5FD0CB5EA03BBE6C182A05F538085040897E8460EA5BFD48E58EBCDBA8257DB6C9035EBA01E2AAF0ED3A9DCD78103F7F
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE75C385DEB91CEC222EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006375FE8AD9F0D2764EB8638F802B75D45FF36EB9D2243A4F8B5A6FCA7DBDB1FC311F39EFFDF887939037866D6147AF826D8D31C4A7601E1FFD751569911C20E60E86F9789CCF6C18C3F8528715B7D10C86878DA827A17800CE77A825AB47F0FC8649FA2833FD35BB23D9E625A9149C048EE599709FD55CB46A6CB629EEF1311BF91D2E47CDBA5A96583BD4B6F7A4D31EC0BC014FD901B82EE079FA2833FD35BB23D27C277FBC8AE2E8BCD8DAA7A11EFD9E5A471835C12D1D977C4224003CC8364762BB6847A3DEAEFB0F43C7A68FF6260569E8FC8737B5C22494854413538E1713FE827F84554CEF50127C277FBC8AE2E8BA83251EDC214901ED5E8D9A59859A8B65D56369A3576CBA5089D37D7C0E48F6C5571747095F342E88FB05168BE4CE3AF
X-C1DE0DAB: 0D63561A33F958A57CAC927ECD9E36548924936084C36666DA065E124E547C8DF87CCE6106E1FC07E67D4AC08A07B9B06A1CB4668A9CA5FA9C5DF10A05D560A950611B66E3DA6D700B0A020F03D25A0997E3FB2386030E77
X-C8649E89: 1C3962B70DF3F0ADE00A9FD3E00BEEDF77DD89D51EBB7742D3581295AF09D3DF87807E0823442EA2ED31085941D9CD0AF7F820E7B07EA4CF076D43E4B70E59512F934BB212E1E1C5F18277E75E8C258795EA9BD1FBC1427442A4A3B3B141354EF42790DB0C4B6428CBC098EC20143AA0289735F80CBCFD6309F6894F2AE0026643082AE146A756F3
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojr0si6YxBz7SnpGaumsYvHw==
X-Mailru-Sender: 689FA8AB762F73933AF1F914F131DBF57B2B9E294042580675C1FDBA28D1CD9698CC072019C18A892CA7F8C7C9492E1F2F5E575105D0B01ADBE2EF17B331888EEAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: Ok
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=wsCX=AM=inbox.ru=fido_max@kernel.org
Subject: [PATCH v2] ASoC: max98090: make it selectable
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: VyWH9/EOBJJV

There is no way to select max98090 from menuconfig right now.
Add a Kconfig menu description to allow building the driver standalone.
It will allow this codec to be used by any other I2S master without
adding extra sound card entry in Kconfig.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
---
 sound/soc/codecs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 79d2362ad055..8020097d4e4c 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -1090,7 +1090,7 @@ config SND_SOC_MAX98088
 	depends on I2C
 
 config SND_SOC_MAX98090
-	tristate
+	tristate "Maxim MAX98090 CODEC"
 	depends on I2C
 
 config SND_SOC_MAX98095
-- 
2.39.2

