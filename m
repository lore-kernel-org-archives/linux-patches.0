Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAF4145353;
	Thu, 11 Apr 2024 10:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830635; cv=none; b=S6M0FPp4MleO1iBkKBOCk7WkeDJTepW6ALhagGOsYx1tsmAqL5OHUO4JrjBD0KDiP1DOPY6ERo2fI8Kf4Fz2QUM/y4e1NXiw2S+9PBKyw8bj5ETf+VDE3lLsOZwYykjUGI6I6YLukOVFVg1kb0/ElJYTIUk6hzGYfDMtt0m02Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830635; c=relaxed/simple;
	bh=3xVpsB/WoQtp8ZX6Csd0teTtW8PtmGV6ps2WjfYrHFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiVJuX72SZgO0mfHTokU4Ltt9ydpxwOFaXCrXcFtOCaQQ4+1ozdvDMzw1E+827qPmfmsSiSKX8LYhxnpg9Likh7lzd+mtR5X4dQGqC2IfiqzDwIB4vT8uUU6Pg6ku6Lur2tOuckWDGHJw6IATECdHNf4H178cjMWIDUE4ozuPRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGEpRs+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGEpRs+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883BAC433F1;
	Thu, 11 Apr 2024 10:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830634;
	bh=3xVpsB/WoQtp8ZX6Csd0teTtW8PtmGV6ps2WjfYrHFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGEpRs+H9PMD3YuVkbSqR2BZlJy3uLgVONdklopgDeVgeo7JLV83XUq4dC4WkRHLO
	 A6FmM6F2IUz0aXAHKWicSvTMwdq4TvCHy3GB2PAOoY6IajM9lHZp8IkhgJVZTyarZ7
	 pRGt1JnKLm8vPAE02eNn2rx9S5sunq9WOBj1K2PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Stable@vger.kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/215] mtd: rawnand: meson: fix scrambling mode value in command macro
Date: Thu, 11 Apr 2024 11:53:56 +0200
Message-ID: <20240411095425.699425882@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 29f3d39138e84..794c85cf22fa9 100644
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



