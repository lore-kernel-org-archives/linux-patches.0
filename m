Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D381494D9;
	Fri,  6 Dec 2024 14:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496177; cv=none; b=MYjLB74z5gLIi24/CkQIqj4qvYhzBlVRXEph+G33JO92eMc1jzKWHHGGFCEwrzaT5ISrNA5QUpbqFMW09FyEBj1IWWqAw93YFan8W9sUgyJwboYLyOoW3SVlGnltprTvO9KR4rGM4kLptPOZFcfz9EaWN58AvurAasO78kK+QkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496177; c=relaxed/simple;
	bh=UKHiYk4JvjJrvusc3qYxlGLtRUoA2BVqWrSbwYL4Gjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzSCw5PuGUVCR+BEn1iqDlhjSkuZYLjU9D/25sVUsUC4bmh5HypO4L7mkw21pyZKBEdKR8oPBsEnHdr+07tJmzMQ5Kc7BwVGjysJqTOuy92N0zfTB1Ny7GJbSVxQ8zNAMBJ7+xiKOBOJ16CI3+hxc6pX5fWVWjL/yrUMeLip+p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfHXCOE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfHXCOE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC1EC4CED1;
	Fri,  6 Dec 2024 14:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496177;
	bh=UKHiYk4JvjJrvusc3qYxlGLtRUoA2BVqWrSbwYL4Gjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfHXCOE6qv0VhrktmHJOaUWl54uNJcYdu9JyoghOzu/7CioSjtHoBwEHsNpH4Heim
	 1AFPvmj30lU7A7DeapKlqliIsA0DlIGQx9chMxflkX5C8VUVTpjEQzznvYMSInzYaQ
	 8in8iNRjQuNZFfppiawwQHSyKvsKa+N8u4xB7Yxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frieder Schrempf <frieder.schrempf@kontron.de>
Subject: [PATCH 6.12 074/146] mtd: spinand: winbond: Fix 512GW and 02JW OOB layout
Date: Fri,  6 Dec 2024 15:36:45 +0100
Message-ID: <20241206143530.512925044@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit c1247de51cab53fc357a73804c11fb4fba55b2d9 upstream.

Both W25N512GW and W25N02JW chips have 64 bytes of OOB and thus cannot
use the layout for 128 bytes OOB. Reference the correct layout instead.

Fixes: 6a804fb72de5 ("mtd: spinand: winbond: add support for serial NAND flash")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Link: https://lore.kernel.org/linux-mtd/20241009125002.191109-2-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/winbond.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/spi/winbond.c
+++ b/drivers/mtd/nand/spi/winbond.c
@@ -215,7 +215,7 @@ static const struct spinand_info winbond
 					      &write_cache_variants,
 					      &update_cache_variants),
 		     0,
-		     SPINAND_ECCINFO(&w25n02kv_ooblayout, w25n02kv_ecc_get_status)),
+		     SPINAND_ECCINFO(&w25m02gv_ooblayout, w25n02kv_ecc_get_status)),
 	SPINAND_INFO("W25N512GW",
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0xba, 0x20),
 		     NAND_MEMORG(1, 2048, 64, 64, 512, 10, 1, 1, 1),
@@ -224,7 +224,7 @@ static const struct spinand_info winbond
 					      &write_cache_variants,
 					      &update_cache_variants),
 		     0,
-		     SPINAND_ECCINFO(&w25n02kv_ooblayout, w25n02kv_ecc_get_status)),
+		     SPINAND_ECCINFO(&w25m02gv_ooblayout, w25n02kv_ecc_get_status)),
 	SPINAND_INFO("W25N02KWZEIR",
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0xba, 0x22),
 		     NAND_MEMORG(1, 2048, 128, 64, 2048, 40, 1, 1, 1),


