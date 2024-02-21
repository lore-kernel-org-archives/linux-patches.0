Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB6F7EF03;
	Wed, 21 Feb 2024 14:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524973; cv=none; b=mWNJb03vaY8NB8jzJBnM1tX6S4aqzzUqvTrbjIGAy5tePd2iJcUWSt7aXzJ9O61C2k2hpdc2Mq5UmXtv4sCt7dPBBBSbOOHtzZVpVDqw/TyvBnF88XP6Lik+VIvShGbjnk9KQXtKrwIKyftQXhCh/Eb2any8KcVLHTMWUFot1xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524973; c=relaxed/simple;
	bh=p+qmro4wLYy8I7mIwEN6VhhQ+Iz/rob+tKbyCniXvfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XibQpnb8x5R5FnErCJi9SQ1/KGMG1kjwYgbN5ZGdVAwVgWccvwLGmUk9OUQBVepSarPWJIfJNzHMvAGL4LgQG/nHzwUrMfgf2eJYBuoW8FnuM/uehN+BJc90ZPG9MCOfZlgauZV/J6dez02UKC4HFcP4IqKEwVdnC+Y8XlVl/f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYHIZKrX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYHIZKrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE03C43394;
	Wed, 21 Feb 2024 14:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524972;
	bh=p+qmro4wLYy8I7mIwEN6VhhQ+Iz/rob+tKbyCniXvfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYHIZKrX6gFheNn3XEXM84wHFlKlNAGY8cvLSHJHNeqeGt1OD0kpeHd/1CRxqIi+7
	 JH1nyxvtje3vqikAxZhS8VV7jFO+LtU3Jnzq6qUtfN1j7cJWH7fWV2PixgbRtuq9sY
	 ly24/9yU3pAjR0Zg8bw8XS9OfpiiY9xmy9idUi9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	miquel.raynal@bootlin.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JaimeLiao <jaimeliao@mxic.com.tw>
Subject: [PATCH 5.4 021/267] mtd: spinand: macronix: Fix MX35LFxGE4AD page size
Date: Wed, 21 Feb 2024 14:06:02 +0100
Message-ID: <20240221125940.713244616@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

From: JaimeLiao <jaimeliao@mxic.com.tw>

Support for MX35LF{2,4}GE4AD chips was added in mainline through
upstream commit 5ece78de88739b4c68263e9f2582380c1fd8314f.

The patch was later adapted to 5.4.y and backported through
stable commit 85258ae3070848d9d0f6fbee385be2db80e8cf26.

Fix the backport mentioned right above as it is wrong: the bigger chip
features 4kiB pages and not 2kiB pages.

Fixes: 85258ae30708 ("mtd: spinand: macronix: Add support for MX35LFxGE4AD")
Cc: stable@vger.kernel.org # v5.4.y
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: JaimeLiao <jaimeliao@mxic.com.tw>
Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/macronix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/spi/macronix.c
+++ b/drivers/mtd/nand/spi/macronix.c
@@ -125,7 +125,7 @@ static const struct spinand_info macroni
 		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&mx35lfxge4ab_ooblayout, NULL)),
 	SPINAND_INFO("MX35LF4GE4AD", 0x37,
-		     NAND_MEMORG(1, 2048, 128, 64, 2048, 40, 1, 1, 1),
+		     NAND_MEMORG(1, 4096, 128, 64, 2048, 40, 1, 1, 1),
 		     NAND_ECCREQ(8, 512),
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
 					      &write_cache_variants,


