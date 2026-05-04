Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10FB3DE43C;
	Mon,  4 May 2026 14:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904229; cv=none; b=E67PB2emHSuKMX9WqxP7TcAjeE8hQxpuW2tsw5Gd5rI1lrgVSbu9oVWA0GmUR5m1MucbyWpW/QVfBiZMmOH3TE+q0dakfB4+MEoBlNeJEW7L0kQ7gjet7DHLjH1PeWlU1s5G7YuoJgOYxcje3NfH1gFBNn0Sq71YG73GVJYIBFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904229; c=relaxed/simple;
	bh=uK/IFjjpEivCWYSXCEFHYqbHR3/8HLERPMmGO6QGa4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3reOvCOw3+PFx898qlQY8/LfisB9LLpjpUhgWDQTfnUeP03cIGhsSEVKbCjqDquqH6Mw4jcAjzoXUZYw8N40+H335G6kUoOCatwMzjuR3pezwjoDsr6/1rCxcz4ow5RB9t18xCBv0bx9S3wajdQDA0EJ/c6NlBAmP01j4rI8N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ou9GHvcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ou9GHvcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8494DC2BCB8;
	Mon,  4 May 2026 14:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904228;
	bh=uK/IFjjpEivCWYSXCEFHYqbHR3/8HLERPMmGO6QGa4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ou9GHvcK04ZKbvlUuuPdIGpjwUgzj6tJp+sHnCO3FT5Ryme9Cuhbgry/LpB+RFSJw
	 gnb4C3JrBjqN4B9hVJu7XmrDZt91ma5Bsr+Y2XblS7BsF8YDd6Ih7IoRd6i6UnZeK2
	 tLcl+LJtbLLWWKdHLe52JsTz0csb6ctCasgcte1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 200/275] mtd: spinand: winbond: Declare the QE bit on W25NxxJW
Date: Mon,  4 May 2026 15:52:20 +0200
Message-ID: <20260504135150.505484322@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 7866ce992cf0d3c3b50fe8bf4acb1dbb173a2304 upstream.

Factory default for this bit is "set" (at least on the chips I have),
but we must make sure it is actually set by Linux explicitly, as the
bit is writable by an earlier stage.

Fixes: 6a804fb72de5 ("mtd: spinand: winbond: add support for serial NAND flash")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/winbond.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/spi/winbond.c
+++ b/drivers/mtd/nand/spi/winbond.c
@@ -428,7 +428,7 @@ static const struct spinand_info winbond
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_dual_quad_dtr_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
-		     0,
+		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&w25n01jw_ooblayout, NULL),
 		     SPINAND_CONFIGURE_CHIP(w25n0xjw_hs_cfg)),
 	SPINAND_INFO("W25N01KV", /* 3.3V */
@@ -488,7 +488,7 @@ static const struct spinand_info winbond
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_dual_quad_dtr_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
-		     0,
+		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&w25m02gv_ooblayout, NULL),
 		     SPINAND_CONFIGURE_CHIP(w25n0xjw_hs_cfg)),
 	SPINAND_INFO("W25N02KV", /* 3.3V */


