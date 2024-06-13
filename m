Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD391145A18;
	Thu, 13 Jun 2024 12:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280965; cv=none; b=aEWiobbf6XN8FTeke1mVuBNXUlAiRzUyjeHJRz2f899WfUpwES8p2mJAp07MNzdz12mSX0lJbzuXe4OiRV2Ov9O5AP1DYvRUcr0g5JltjG8vR+t4ceuzCRT3BmEPeV4B7GG1c2eBvf0HPxLOo2SjJbB0sj9C8I6Zh4gVuvOl52k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280965; c=relaxed/simple;
	bh=L4U3N5le8806V23sEF2ujXC8R3gLL9rdS80hK3ZAWis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmQSfg3dH3XZ94CEUj1OtEFGJOL8apoQk2akaOZxJescmPEHti2NOAk8Siuo2CgrhbgA9XhGe/jeIUB0H6WeWiPAvRXagKwI4p7fUqxqIBAcElXMVZeQGzrV5XZqjp4tBj/8NMaI8jd17FrRCU6N58sLIyP/MjfiDGw4e4LHAqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSonEztk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSonEztk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468D7C2BBFC;
	Thu, 13 Jun 2024 12:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280965;
	bh=L4U3N5le8806V23sEF2ujXC8R3gLL9rdS80hK3ZAWis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSonEztkt420orCtwZfUglAe+83ZnfSRAYQmkqBho3imUGerHhoAfBmqJcQ6zGShG
	 BJD4I9szSIUDIyuaYgwtxxtLi20iItlXq/KEzlbORYg+vPySQQ8a+ZVB0JCgBrSdW4
	 t0gH3JZE55wIS5OXHVeDbmD40IKwid2Pr1yKj5RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Korotkov <korotkov.maxim.s@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/317] mtd: rawnand: hynix: fixed typo
Date: Thu, 13 Jun 2024 13:31:51 +0200
Message-ID: <20240613113251.149015213@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Korotkov <korotkov.maxim.s@gmail.com>

[ Upstream commit 6819db94e1cd3ce24a432f3616cd563ed0c4eaba ]

The function hynix_nand_rr_init() should probably return an error code.
Judging by the usage, it seems that the return code is passed up
the call stack.
Right now, it always returns 0 and the function hynix_nand_cleanup()
in hynix_nand_init() has never been called.

Found by RASU JSC and Linux Verification Center (linuxtesting.org)

Fixes: 626994e07480 ("mtd: nand: hynix: Add read-retry support for 1x nm MLC NANDs")

Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240313102721.1991299-1-korotkov.maxim.s@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nand_hynix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/nand_hynix.c b/drivers/mtd/nand/raw/nand_hynix.c
index a9f50c9af1097..856b3d6eceb73 100644
--- a/drivers/mtd/nand/raw/nand_hynix.c
+++ b/drivers/mtd/nand/raw/nand_hynix.c
@@ -402,7 +402,7 @@ static int hynix_nand_rr_init(struct nand_chip *chip)
 	if (ret)
 		pr_warn("failed to initialize read-retry infrastructure");
 
-	return 0;
+	return ret;
 }
 
 static void hynix_nand_extract_oobsize(struct nand_chip *chip,
-- 
2.43.0



