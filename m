Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF58858039C;
	Wed, 30 Sep 2026 17:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789938; cv=none; b=mmyS8KBYeWLaChu1LntFma3E6heCzhlXapPJOC/Z1fvnaZYHgOc8bwrozFo0yaFOTrwhW748M/e8tt7dVKk2z6Ku6t0fBeoRGjrsd8AQ/crcxj75G9ks2DeeyxkotBafGlWAolu7Olh1T8qedJxOPjQW+rRef7k355T/+huHwMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789938; c=relaxed/simple;
	bh=aWBQ42a2ecAu278IZ22XKzWIG983lmKRVCinCnmA/yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfVj86fp1RAypZZzCVtWjECiGDb264/z3gTpy0YYJok/q9HMKUHYz5Ay2AMsh9dkcdLgL/sTKQ0VFjRNDMV72JYH+gjrhe+43ewwvjQe3pdYxI7/7shfe88watzwJsL86HMKbUht/iED6NKkj160Km4azskDqJiOI6d59oAgaSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BO7HD3SO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BO7HD3SO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECE81F000FF;
	Wed, 30 Sep 2026 17:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789936;
	bh=nZ6EYdFKY++9YrTjDzvKxkquqfu/yakoLGYQq0c4YU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BO7HD3SOu8DD9wAFr7qgYstXMfY+zu05vEZbZAtfvXqBPEWX7HFGFU08l0RzdOSUQ
	 KXRkVyCqDLATueMdRtNZasCDVo2SQZQJ4LUPWheXoJN6W9pWVxiS+OjtgnVYp9MFdA
	 0LBOSWGDvCmf5u9I4mdmGzclyRoNAXjKSgyMWZq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Scian <andrea.scian@dave.eu>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 654/877] mtd: rawnand: pl353: Add message about ECC mode
Date: Wed, 30 Sep 2026 17:26:05 +0200
Message-ID: <20260930152428.775695325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Scian <andrea.scian@dave.eu>

[ Upstream commit 1e06dbfdfb851170b243d6498e442b449324c664 ]

This just add some information on kernel log about the selected ECC

Signed-off-by: Andrea Scian <andrea.scian@dave.eu>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Stable-dep-of: 80ecacd054ff ("mtd: rawnand: pl353: Make sure we use the monolithic helpers for raw accesses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -973,15 +973,18 @@ static int pl35x_nand_attach_chip(struct
 
 	switch (chip->ecc.engine_type) {
 	case NAND_ECC_ENGINE_TYPE_ON_DIE:
+		dev_dbg(nfc->dev, "Using on-die ECC\n");
 		/* Keep these legacy BBT descriptors for ON_DIE situations */
 		chip->bbt_td = &bbt_main_descr;
 		chip->bbt_md = &bbt_mirror_descr;
 		fallthrough;
 	case NAND_ECC_ENGINE_TYPE_NONE:
 	case NAND_ECC_ENGINE_TYPE_SOFT:
+		dev_dbg(nfc->dev, "Using software ECC (Hamming 1-bit/512B)\n");
 		chip->ecc.write_page_raw = nand_monolithic_write_page_raw;
 		break;
 	case NAND_ECC_ENGINE_TYPE_ON_HOST:
+		dev_dbg(nfc->dev, "Using hardware ECC\n");
 		ret = pl35x_nand_init_hw_ecc_controller(nfc, chip);
 		if (ret)
 			return ret;


