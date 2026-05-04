Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98B03A2574;
	Mon,  4 May 2026 14:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903444; cv=none; b=L8nHrlQJiKDM/0mGoF7uK3MgCgz5LfQcctd8cy1NAWTvccloHvc8uIZsDb9Cr9h4q3mC3np2wRbKMRB7Cb/BDOE3QORNOev89MqMqw9lXEb9NZgpyFvGL57aOUv4zWJUJ/YYzq/tAcwjd62VqwiBxau1oKZtqeyH8l4E9RJpEBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903444; c=relaxed/simple;
	bh=+Wh/+MwbNh5T5GUQq3dv/axpZ23H+Jgc/Ki8eRQKOXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mcl3QInhbYGbEH2mL8Zk6lRNNyyJv0rCrxlE0MG6+32MSpJEW+pZsy3glMH7AUsOpE0Bqsthv0VJiRLGpDv3MzFiDBFKHSfAhUVNf3nnU0LTw/UG8HequcFSH5CIewsZi5VVcLaSIibPoqcDmIzfl3831luGGJTVbPY42nmy8+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDAt9Llk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDAt9Llk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C94C2BCB8;
	Mon,  4 May 2026 14:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903444;
	bh=+Wh/+MwbNh5T5GUQq3dv/axpZ23H+Jgc/Ki8eRQKOXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDAt9Llk8ah2AP2s87YUZYKI28TCDLPGPUbGTIeWpkgDxOxBGuxpPVds8sLn4RDG3
	 vQ3N0+wVCX6v7uCczf0P8+7vK41tdVnIbfLMlBEW8pC70vfkSrNoSLJMSmhV2T2ubP
	 GOJfArvdz7IgE9Pfke5jWdYUYEAm9qLtNcdZiphY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.0 235/307] mtd: spinand: winbond: Declare the QE bit on W25NxxJW
Date: Mon,  4 May 2026 15:52:00 +0200
Message-ID: <20260504135151.686734269@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -485,7 +485,7 @@ static const struct spinand_info winbond
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_dual_quad_dtr_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
-		     0,
+		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&w25n01jw_ooblayout, NULL),
 		     SPINAND_CONFIGURE_CHIP(w25n0xjw_hs_cfg)),
 	SPINAND_INFO("W25N01KV", /* 3.3V */
@@ -549,7 +549,7 @@ static const struct spinand_info winbond
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_dual_quad_dtr_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
-		     0,
+		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&w25m02gv_ooblayout, NULL),
 		     SPINAND_CONFIGURE_CHIP(w25n0xjw_hs_cfg)),
 	SPINAND_INFO("W25N02KV", /* 3.3V */


