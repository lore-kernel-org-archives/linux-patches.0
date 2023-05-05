Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533E1156D4
	for <patches@lists.linux.dev>; Fri,  5 May 2023 12:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E65C433D2
	for <patches@lists.linux.dev>; Fri,  5 May 2023 12:44:38 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=inbox.ru header.i=@inbox.ru header.b="ktH6z2pC"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Fri, 5 May 2023 21:44:35 +0900
Resent-Message-ID: <ZFT6M4dbg2w7PpJZ@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 05 May 2023 06:35:33 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=4qAs=A2=inbox.ru=fido_max@kernel.org>)
	id 1puo6N-00EjKy-0l
	for broonie@sirena.co.uk; Fri, 05 May 2023 06:35:33 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 599C46379E
	for <broonie@sirena.co.uk>; Fri,  5 May 2023 05:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id D279AC4339B; Fri,  5 May 2023 05:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D42B2C433D2
	for <broonie@kernel.org>; Fri,  5 May 2023 05:35:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org D42B2C433D2
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=inbox.ru
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=inbox.ru
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail4;
	h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=iB4veIE04qlq+o6e8JdPfI+S36A1iZyRUb8yqoc1RPU=;
	t=1683264926;x=1683354926; 
	b=ktH6z2pCWgc/SP7YpK7t1wy3rma+s+mOPhC2+JTIEhhLI2A3e4RipuUU9pGnAHay+IUBYcuXy1hbldfpilRTY//5pLwwDoBtB+ijJHM+F/BW5GzyqhrDm5+3zSOQkR6USQQIYjWEacccPmEdSv+ryjMAP6KsaF5Oo2uuVO9LdOAeYm5dgsqXCYyQsKhT9gjVPM/tKb4MZ54TkMu+gvS1WfGvhtH0XG4j6HSS2y5aLCLz84rQ5V/AWt36V9mQFESnW/XiOOSiJKJn2NxoYzzpgqajTzyJa5e9R9D9rVp2OgNotp+KXrKljYPISAKJZKNcZaxYIYQoFOhAk6FcgdiAQQ==;
Received: by smtpng3.m.smailru.net with esmtpa (envelope-from <fido_max@inbox.ru>)
	id 1puo6F-000568-Dt; Fri, 05 May 2023 08:35:23 +0300
From: Maxim Kochetkov <fido_max@inbox.ru>
To: alsa-devel@alsa-project.org
Cc: lgirdwood@gmail.com,
	broonie@kernel.org,
	perex@perex.cz,
	tiwai@suse.com,
	ckeepax@opensource.cirrus.com,
	u.kleine-koenig@pengutronix.de,
	Maxim Kochetkov <fido_max@inbox.ru>
Date: Fri,  5 May 2023 08:35:21 +0300
Message-Id: <20230505053521.18233-1-fido_max@inbox.ru>
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
X-77F55803: 4F1203BC0FB41BD9C20EA97715EAF8CF12914BC8161E7FAEBC06EA0E3DEA8393182A05F538085040F0C7F744115303847D0E05FA629826BE224241915F72843130E24F1DDEAEC03E
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE75C861DE789AAB134EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637B84F9009663064BD8638F802B75D45FF36EB9D2243A4F8B5A6FCA7DBDB1FC311F39EFFDF887939037866D6147AF826D802EB1F2133D70E6179F86CF651ABB5146F9789CCF6C18C3F8528715B7D10C86878DA827A17800CE7934314F73869482B9FA2833FD35BB23D9E625A9149C048EECCD848CCB6FE560CE5D25F19253116ADD2E47CDBA5A96583BD4B6F7A4D31EC0BC014FD901B82EE079FA2833FD35BB23D27C277FBC8AE2E8B4AFB60FD1831C04CA471835C12D1D977C4224003CC8364762BB6847A3DEAEFB0F43C7A68FF6260569E8FC8737B5C2249D082881546D93491E827F84554CEF50127C277FBC8AE2E8BA83251EDC214901ED5E8D9A59859A8B6E65F1423C7F32903089D37D7C0E48F6C5571747095F342E88FB05168BE4CE3AF
X-C1DE0DAB: 0D63561A33F958A5AA53C095C839A22718381EA27369C64BE4DD6423920E207EF87CCE6106E1FC07E67D4AC08A07B9B062B3BD3CC35DA5889C5DF10A05D560A950611B66E3DA6D700B0A020F03D25A0997E3FB2386030E77
X-C8649E89: 1C3962B70DF3F0ADE00A9FD3E00BEEDF77DD89D51EBB7742D3581295AF09D3DF87807E0823442EA2ED31085941D9CD0AF7F820E7B07EA4CF191CF55CFBE191A95C10028AC61AA2B7E9884F261DA6A03A7433C1C9C65F6F5F265F63FF884E79B314EE98CD8E9D35FCD014637F4AC7B58D6EFA560FE5F33D21FF926C0F406FFAF7
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojAeDCk4EFldEdjwcLGy5RqQ==
X-Mailru-Sender: 689FA8AB762F73933AF1F914F131DBF5AA9918DF0B7E4A009A5E1FF6ADF1D2A598CC072019C18A892CA7F8C7C9492E1F2F5E575105D0B01ADBE2EF17B331888EEAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: Ok
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=4qAs=A2=inbox.ru=fido_max@kernel.org
Subject: [PATCH 1/1] ASoC: dwc: extend supported formats
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: fnOGu3SMJh+Q

The COMP1_TX_WORDSIZE_0/COMP2_RX_WORDSIZE_0 fields in the comp
registers indicate the maximum wordsize supported. DWC I2S controller
can operate with any smaller wordsize. So extend the formats to let
I2S to operate in any allowed modes.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
---
 sound/soc/dwc/dwc-i2s.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/dwc/dwc-i2s.c b/sound/soc/dwc/dwc-i2s.c
index acdf98b2ee9c..1f782752ea0b 100644
--- a/sound/soc/dwc/dwc-i2s.c
+++ b/sound/soc/dwc/dwc-i2s.c
@@ -480,9 +480,9 @@ static const u32 bus_widths[COMP_MAX_DATA_WIDTH] = {
 static const u32 formats[COMP_MAX_WORDSIZE] = {
 	SNDRV_PCM_FMTBIT_S16_LE,
 	SNDRV_PCM_FMTBIT_S16_LE,
-	SNDRV_PCM_FMTBIT_S24_LE,
-	SNDRV_PCM_FMTBIT_S24_LE,
-	SNDRV_PCM_FMTBIT_S32_LE,
+	SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
+	SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
+	SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE | SNDRV_PCM_FMTBIT_S32_LE,
 	0,
 	0,
 	0
-- 
2.39.2

