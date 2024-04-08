Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C267CF25;
	Mon,  8 Apr 2024 13:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581335; cv=none; b=qOl+l2AgV8YvajraUw30LMkQEYb1VPK590TKzTymMA+YBY19B0PD3V/5BcDKlShwGPvi+v6DIJRQE+q1QGpi7yg0OHpTGQWoXueBHfcnU4hVy0lJLCsorRyWbLhhUTH/MGwUZhrVn8100OWTqvXf6/N4PiD2S6ZPZ6sjPpHhdZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581335; c=relaxed/simple;
	bh=HqTyyEjIJlEDNh37qmKAtEyQJQgv8BNxpHvnPH/VFcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6N9O7bVA3pwwB5k1fefqI5/1URna33QKA3LUohq4nrIb23i7IDy1AVuv6MUZjXiEBCeU1+dnyORqrSRdZLZBLXRmQqc1zNVa/XGdIpnksf7CtPhysF0X/PcOlF61i1CEJ/MNhAxH1+YWPauf9meRJrxMI+RIKIATpsSkx0O25A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFhEqmeX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFhEqmeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED4AC433C7;
	Mon,  8 Apr 2024 13:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581334;
	bh=HqTyyEjIJlEDNh37qmKAtEyQJQgv8BNxpHvnPH/VFcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFhEqmeXAgfcx3fXzFp0k+2ISpPjK959SnWFyR1Fh3PqjkW/e+mUnRMMl4Q2pBKF3
	 WykiMctvQAxpngpD1kuE26qLkyRKuJAgtrhZvNnNxiymsWmCunFpHZFjLlmwQh1+My
	 PMEKbRtzoBwQK2qQSq0AgOio/nI/4ioZDTkwbP8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Stable@vger.kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/690] mtd: rawnand: meson: fix scrambling mode value in command macro
Date: Mon,  8 Apr 2024 14:48:20 +0200
Message-ID: <20240408125400.778451355@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Arseniy Krasnov <avkrasnov@salutedevices.com>

[ Upstream commit ef6f463599e16924cdd02ce5056ab52879dc008c ]

Scrambling mode is enabled by value (1 << 19). NFC_CMD_SCRAMBLER_ENABLE
is already (1 << 19), so there is no need to shift it again in CMDRWGEN
macro.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: <Stable@vger.kernel.org>
Fixes: 8fae856c5350 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240210214551.441610-1-avkrasnov@salutedevices.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/meson_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index 9d441965321ad..9198d54cb34ee 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -59,7 +59,7 @@
 #define CMDRWGEN(cmd_dir, ran, bch, short_mode, page_size, pages)	\
 	(								\
 		(cmd_dir)			|			\
-		((ran) << 19)			|			\
+		(ran)				|			\
 		((bch) << 14)			|			\
 		((short_mode) << 13)		|			\
 		(((page_size) & 0x7f) << 6)	|			\
-- 
2.43.0



