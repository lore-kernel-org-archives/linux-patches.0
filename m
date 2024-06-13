Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9986144D3C;
	Thu, 13 Jun 2024 11:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279882; cv=none; b=RL8xi01/TLereLRTbjSxv1nlZa7EJWPpCpPvAWkZytsh96VbXGJqATMMycnn/m6ml9OLyGwLRt5G9Ris/IgyDnjkh9wnutHGm1G1HCiOvcOIJHRFSfMFjcpZoTUPvV3ymjEl59vq+l8Nm9gWb+HiQyljktns5o39jeapTYfn5qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279882; c=relaxed/simple;
	bh=Xyq13UPwCvcsIf35pKAcRm4rWP5NeXwkwYf4d7G7VJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXt5hpkAyTMwvr2DNQL5DU2uIlmvNLce/Hb+pnNaw09ergccdQGiQCOCo/aoRa2LH718EvQyhSsTnCYP3P6YZpMJNmCEwWtJvasBxnSy1zV4l/pmGFd3KD8skVd54xX3fMhU9OCx7fdKb+VKY+5JFAVwMpcK2zS446HryHnsCr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3pGCr6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3pGCr6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52179C2BBFC;
	Thu, 13 Jun 2024 11:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279882;
	bh=Xyq13UPwCvcsIf35pKAcRm4rWP5NeXwkwYf4d7G7VJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3pGCr6wKGbLIxTy+FlG6WVUQSnMV9onDCuaGLOREwsFtoF+SQQr6vEzO2f+OE7u/
	 TQTjWVbSohAKDXDUyJzVv5SrIplc+hRf/M6nYaIhOImBEL5KpuPCTS12R3vDXiBEM8
	 rNjp1Bmh0BT5IZen7fmSYcsPEdkcdYmOx0PRg2jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Korotkov <korotkov.maxim.s@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/202] mtd: rawnand: hynix: fixed typo
Date: Thu, 13 Jun 2024 13:32:47 +0200
Message-ID: <20240613113230.440874425@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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
index 194e4227aefe9..15131e5953127 100644
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



