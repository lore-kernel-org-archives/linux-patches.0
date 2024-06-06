Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AC1198845;
	Thu,  6 Jun 2024 14:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683321; cv=none; b=USuMXsK5bXVVWByK7eMCmBkpGtnOkMY4f7roe5x1RmZa4gIIRlEgEfI9+u3+He2/7zRm9XaGHaCLn3kugvvWaE/VzH/vSeqYce/FUl5iVZuCG0FpgK+uKBPep2NYP6m4vVl2gPqFoSEyNYpGte0BicwdGAgOp956fAwDtQUi1oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683321; c=relaxed/simple;
	bh=NAkNn/OVQlct4FRMVbvfrkzHePV84IVLIVHxjEwMIP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0mQ8MdAvGw7vmHVOBepMnBCHwZLpdKV+7Zr+kFX5MPejy/+KFNkXFyLuv8I7qeCIOGTtJbivcXC/+3ORzoz6vK+/6HbvgArywUvNhA+S1GrPZi2/AMPdNzdT6Cs8nQoOxYBDgNeZ9o8h172YgT7eA8cA48NEc6G+0oZlWzqeMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zYJptKJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYJptKJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE223C2BD10;
	Thu,  6 Jun 2024 14:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683320;
	bh=NAkNn/OVQlct4FRMVbvfrkzHePV84IVLIVHxjEwMIP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYJptKJD4wH4CcvNxCtGjKJl1riM2W4eTWnMwp3sla86TWEOrEsQ+ngU0wbgEWkcp
	 XujFLB4fF7Jv6+4VKXfrKAYNUPNwDyibZQgvPwHJSX1taO5GqPqdUi1a+VEUKprgwQ
	 s3NP/PYcBouZZbET167UNrngrtut9UbM2AOzYJf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Korotkov <korotkov.maxim.s@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/473] mtd: rawnand: hynix: fixed typo
Date: Thu,  6 Jun 2024 16:02:09 +0200
Message-ID: <20240606131706.553829592@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index 0d4d4bbfdecea..49e36767d8f76 100644
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



