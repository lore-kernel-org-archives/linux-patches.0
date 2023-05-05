Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C044E156D4
	for <patches@lists.linux.dev>; Fri,  5 May 2023 12:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F29DC433D2
	for <patches@lists.linux.dev>; Fri,  5 May 2023 12:44:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=inbox.ru header.i=@inbox.ru header.b="sxzMg9Y6"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Fri, 5 May 2023 21:44:45 +0900
Resent-Message-ID: <ZFT6PcM4g28evm2W@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 05 May 2023 07:28:40 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=4qAs=A2=inbox.ru=fido_max@kernel.org>)
	id 1puovk-00EjYf-TD
	for broonie@sirena.co.uk; Fri, 05 May 2023 07:28:40 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id EB06060A0F
	for <broonie@sirena.co.uk>; Fri,  5 May 2023 06:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 6F2ACC433EF; Fri,  5 May 2023 06:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC98FC433D2
	for <broonie@kernel.org>; Fri,  5 May 2023 06:28:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org DC98FC433D2
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=inbox.ru
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=inbox.ru
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail4;
	h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=w19r/bnmeQETgryQv1iIi3iN09PWER6hP3yMlsCH8eY=;
	t=1683268113;x=1683358113; 
	b=sxzMg9Y6F0Uzs6Mb5g61bVdI8N4fMUPqqoxaYfVsuFHnLiWEMqoIVjZBIXeOa34R2pJ2NmbEAqC/dX33gRJdgcwjRzrSBGUw1gpYi/u/tBeuk+hS4VObdNFHSfmxi9V8zAx3Y+NBDlFy8+LgA6gNj4s+60Q9eEC09ZXDsKaHO3IaCV7FEUARZsTdswoarvqInW5O7L8lb1C1jarNL9glHu78Cu+Bxzzl5htia3Aok9b61GHgseA0YTjaBqvnJ4c8t+wRVmCtZluJjpfLEl7AMvDfFlEK1dd1uuEtmMPCs5X/Tto24eVQyIdjTXP6ZflKsA2SGUgGB804WZzEeKOIuA==;
Received: by smtpng1.m.smailru.net with esmtpa (envelope-from <fido_max@inbox.ru>)
	id 1puovW-00028V-MP; Fri, 05 May 2023 09:28:23 +0300
From: Maxim Kochetkov <fido_max@inbox.ru>
To: alsa-devel@alsa-project.org
Cc: lgirdwood@gmail.com,
	broonie@kernel.org,
	perex@perex.cz,
	tiwai@suse.com,
	ckeepax@opensource.cirrus.com,
	nicolas.ferre@microchip.com,
	u.kleine-koenig@pengutronix.de,
	Maxim Kochetkov <fido_max@inbox.ru>
Date: Fri,  5 May 2023 09:28:20 +0300
Message-Id: <20230505062820.21840-1-fido_max@inbox.ru>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtpng1.m.smailru.net; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-Mailru-Src: smtp
X-7564579A: EEAE043A70213CC8
X-77F55803: 4F1203BC0FB41BD9CDD72DB02570E1E69F65CF5A383CA60943DD864320CF4B411313CFAB8367EF908E2BE116634AD74D4F6BBD8AD64DF50C24F29287ACC5C24655FADD5F4B5A515B7B9585C59A2DDEF7
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE716FAD50E497B9C14EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006376AFB9B40001E44068638F802B75D45FF36EB9D2243A4F8B5A6FCA7DBDB1FC311F39EFFDF887939037866D6147AF826D802F15FF47CBB9EA07155B019091615D06F9789CCF6C18C3F8528715B7D10C86878DA827A17800CE71DD432BB81541BCF9FA2833FD35BB23D9E625A9149C048EE0A8783F69A4C1398BDFBBEFFF4125B51D2E47CDBA5A96583BD4B6F7A4D31EC0BC014FD901B82EE079FA2833FD35BB23D27C277FBC8AE2E8B3066B9820929774A389733CBF5DBD5E9B5C8C57E37DE458B9E9CE733340B9D5F3BBE47FD9DD3FB595F5C1EE8F4F765FC8C7ADC89C2F0B2A5E2021AF6380DFAD18AA50765F790063735872C767BF85DA227C277FBC8AE2E8BD00653D74F80EC5F75ECD9A6C639B01B4E70A05D1297E1BBCB5012B2E24CD356
X-C1DE0DAB: 0D63561A33F958A56E546AF34195C6F10E2829C2CF38B811FE7B195693D6E021F87CCE6106E1FC07E67D4AC08A07B9B0A6C7FFFE744CA7FB9C5DF10A05D560A950611B66E3DA6D700B0A020F03D25A092FFDA4F57982C5F4CB5012B2E24CD356
X-C8649E89: 1C3962B70DF3F0ADE00A9FD3E00BEEDF77DD89D51EBB7742D3581295AF09D3DF87807E0823442EA2ED31085941D9CD0AF7F820E7B07EA4CFC6C1A3D38B6795CE317A5A611E1D04D2960524E4A57BBC48CC3F3EFA9E2777E3B9228B76B87D064D14EE98CD8E9D35FCC3674DFEE1CD913126CA9985D1D297CD0CB5B17375C3CAE6
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojAeDCk4EFldEolkEDguM7oQ==
X-Mailru-Sender: 689FA8AB762F73933AF1F914F131DBF590C713BA32C72AB5C7F0208CF814589798CC072019C18A892CA7F8C7C9492E1F2F5E575105D0B01ADBE2EF17B331888EEAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: Ok
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=4qAs=A2=inbox.ru=fido_max@kernel.org
Subject: [PATCH 1/1] ASoC: dwc: limit the number of overrun messages
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: X4t256zwp05k

On slow CPU (FPGA/QEMU emulated) printing overrun messages from
interrupt handler to uart console may leads to more overrun errors.
So use dev_err_ratelimited to limit the number of error messages.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
---
 sound/soc/dwc/dwc-i2s.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/dwc/dwc-i2s.c b/sound/soc/dwc/dwc-i2s.c
index acdf98b2ee9c..ca20cade6840 100644
--- a/sound/soc/dwc/dwc-i2s.c
+++ b/sound/soc/dwc/dwc-i2s.c
@@ -132,13 +132,13 @@ static irqreturn_t i2s_irq_handler(int irq, void *dev_id)
 
 		/* Error Handling: TX */
 		if (isr[i] & ISR_TXFO) {
-			dev_err(dev->dev, "TX overrun (ch_id=%d)\n", i);
+			dev_err_ratelimited(dev->dev, "TX overrun (ch_id=%d)\n", i);
 			irq_valid = true;
 		}
 
 		/* Error Handling: TX */
 		if (isr[i] & ISR_RXFO) {
-			dev_err(dev->dev, "RX overrun (ch_id=%d)\n", i);
+			dev_err_ratelimited(dev->dev, "RX overrun (ch_id=%d)\n", i);
 			irq_valid = true;
 		}
 	}
-- 
2.39.2

