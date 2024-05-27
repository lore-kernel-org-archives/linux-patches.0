Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4326617727;
	Mon, 27 May 2024 19:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838364; cv=none; b=WzhGslTGPNpzH4+p2x4q0/u/fUFS7Q9SvlKOdE/ua8XziboQvyYT3n2xlSthc8FxqrH71Q0HaxIRkVuRrzAsjLmzFbWwyGv8eUnAE7L0m5nIh/u2tuApowvYXfA6Y4WBHx7kSdv9U6lJ1UJEzAlAaF9EXwaHqaoBdub7Y9Km/uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838364; c=relaxed/simple;
	bh=TSMDJNRk4fVMfzCEDh0/5WHj/ckIyngr2RE01IAhcZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0dNhG9ypCXqko+TBz2p4/H6PAnTycLeCQx6LQ9d20LbEBuT9VjYBuqdtX/VEkr6keMHz6j3w0fB8IKzxzEb4RgmEggpnF6Kf0cYCyRKOCsbbXB0ti52Xj/c8zI3PqNTGffj8rs5zNiTDo7ZGwatSDPMG+dMcDsKQh84ER3o9Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDTezE+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDTezE+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C9BC2BBFC;
	Mon, 27 May 2024 19:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838364;
	bh=TSMDJNRk4fVMfzCEDh0/5WHj/ckIyngr2RE01IAhcZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDTezE+nOVgzIadKgXJ8JxoaVjUxswfbi5hmrzj/c2wPWHd4SqK4N+RqPxgcmkIl1
	 OEV/8iTIBI/60LgnS4EMkjGzpfSFBYFKsJVqlC1i3P4PsC3iWmSH8ff9R7JO99PyWD
	 fI464cL+RvmsNvjColANx9UXNnObTII007R7OXm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Korotkov <korotkov.maxim.s@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 365/493] mtd: rawnand: hynix: fixed typo
Date: Mon, 27 May 2024 20:56:07 +0200
Message-ID: <20240527185642.220955564@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



