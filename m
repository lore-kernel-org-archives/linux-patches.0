Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10834482F6;
	Mon,  1 Apr 2024 16:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990714; cv=none; b=n24USqQT1cNn+BPt2kYGNigjFtTpPQIhAfsY8wAV6CGulD7gr/Bm6iBddOh/9fq8ZFmJ8b4L46tiOBaPnjzaQL01ZZcQ0ZeKxD7sUzesjNQnuHGXnkDWrHSAsky4IgmZG+94iPHvVhtC2x2ecTdSgTz/MKY6PoR+1BBkDfTAB+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990714; c=relaxed/simple;
	bh=PiEbMEJLmNyx4V5zf5m4q9tR6TAbC3MDCl03gNybDok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suv3Y3uowSXKXE5cEe1cR4GDLWg+jqezt3o4E01CU8hm3xmMXFUVaArOYHU4xOMff6FA3PtbJAZmZBoO4Ra/3iFUHFL43P8NFZwAdm2Z6SjNWhf4cm7kY3BAQj2hv6qNyx5K/y2bxFkJGB2BUcSyMyFELyDVS2Q+6kdKKQxAbak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnSy4G4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnSy4G4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B138C433C7;
	Mon,  1 Apr 2024 16:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990713;
	bh=PiEbMEJLmNyx4V5zf5m4q9tR6TAbC3MDCl03gNybDok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnSy4G4ltMyiAlmoiLZdT0f4JfFILuT1XxNFP9OZsNnSlUSkD9dSRaPUUlHnrcnu0
	 i/S42A6TiPDXWNb+Gg71G5w3XErTqR7V+iQAGmvYvBf3zwUWsiPK5YD1N8jvxvWlom
	 SHears7Q1WR0yFMKRGe+bV0oUlF+JLpwK6JjmLxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Stable@vger.kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/272] mtd: rawnand: meson: fix scrambling mode value in command macro
Date: Mon,  1 Apr 2024 17:43:53 +0200
Message-ID: <20240401152531.746616243@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0aeac8ccbd0ee..05925fb694602 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -63,7 +63,7 @@
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



