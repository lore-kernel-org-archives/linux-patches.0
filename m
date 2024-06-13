Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56918DDB1;
	Thu, 13 Jun 2024 11:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278778; cv=none; b=bJWpnOOdhXnUttBi4oLK1BF10RbrHT0JK3nV2DUi4/XkGATcmwnRvXtElmpH5BUM+aHiRrLZAop+49Zl/RyX9xYUppJkAsy8Z6o0/X8tN9H7VNfY0J4kaNdbnffgByEuT9lFntDzauADz0QSZPQz28CbmHwKQ3iJDn98mSR/TCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278778; c=relaxed/simple;
	bh=RGsNVo7dsOVRtHf88KkvnlOQZ+EfIluz8NnyLkGdcYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9C6m3J4K1Q1qT2kq4CU523nlfjmiZDyBIc/hDWgTJ+P8RsJh9u070n+7IKXGIBqH/jf/WkSKUHNi4yFLx2gFi+X18SMPOOGlXUuPtip8CfHl6IRlRjGQzoysEwTDKbLQ2yQyBpZrAzXdBhbW9Sb1IzY+XIZmZ+w3Yo6+q3i+Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wl6dRyPt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wl6dRyPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49E2C2BBFC;
	Thu, 13 Jun 2024 11:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278778;
	bh=RGsNVo7dsOVRtHf88KkvnlOQZ+EfIluz8NnyLkGdcYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wl6dRyPtItB4aczunPfGebZ7mG2YSkJxKQxMQ8eLZa/DAtJAmXW74lec1VVn2PKsb
	 FEJik3wdJ6dSifpDVqj6Pv9ILdWJXFxDayKYz5EdrKdoqhRhtqtbLukqApE7eIpkav
	 iM2Wl9f9MM5VXrNg9heicS5NDFfnrYYomO03UeqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Korotkov <korotkov.maxim.s@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/213] mtd: rawnand: hynix: fixed typo
Date: Thu, 13 Jun 2024 13:31:54 +0200
Message-ID: <20240613113230.555079799@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 4ffbb26e76d6d..6f595455a8c23 100644
--- a/drivers/mtd/nand/raw/nand_hynix.c
+++ b/drivers/mtd/nand/raw/nand_hynix.c
@@ -414,7 +414,7 @@ static int hynix_nand_rr_init(struct nand_chip *chip)
 	if (ret)
 		pr_warn("failed to initialize read-retry infrastructure");
 
-	return 0;
+	return ret;
 }
 
 static void hynix_nand_extract_oobsize(struct nand_chip *chip,
-- 
2.43.0



