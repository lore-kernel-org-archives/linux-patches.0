Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C6419AD6E;
	Thu,  6 Jun 2024 14:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683342; cv=none; b=t1Z6C9D6T8mcaN7lxWatQXvT058iEA5F2HlGKbBHmlVPnTABIToDN62R06AM3kqRDEb6BloIx6b8BlZNqhjR0CtZoigL0lTvP3vAt5mo7LYvNymlYY0UWoXs0qajfcFAfUiFaoKTuQrU+1tpslMAg3Zw+d72BGobW6qoOGqmDJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683342; c=relaxed/simple;
	bh=rcmd5zQiv9CFqjbqVr5EWiAHAuTvZjBENjosAfumik0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiAG4w8zjiz0grZgbYtfw8QqYa5y2oHY80ae/QESXl9hXY7G4d3Gmehz8+QhBx58TlUm8HmnJ9ZkavbsHOYwA0IyRKjIFN0eiQr9TJz8SrA/pL3iOsCnMs6VXXbF2CvByTOc3zxQLExq44n95mIRDoqPTiD0bJiJzygSkSLvCGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wv5BVG3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wv5BVG3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539ADC32781;
	Thu,  6 Jun 2024 14:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683342;
	bh=rcmd5zQiv9CFqjbqVr5EWiAHAuTvZjBENjosAfumik0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wv5BVG3OSt5d/hWawI+Im+cEbqcsTYdBncfPJNxWUq4NcFNogXK6hG79bg0I+I64r
	 ZzTtP1HDE1a2TbhKQ2t63vsUyVUiPkJ2SLLLsmak0AgxqoWZt08FZVbAwIc8QPG4zl
	 q6H4pf++vDCREH45t3mTWw7Cfb2Xarp9hdzQnVZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Korotkov <korotkov.maxim.s@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 283/744] mtd: rawnand: hynix: fixed typo
Date: Thu,  6 Jun 2024 15:59:15 +0200
Message-ID: <20240606131741.486181539@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 39076735a3fbb..9695f07b5eb26 100644
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



