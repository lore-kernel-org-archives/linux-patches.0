Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A5933DED6;
	Tue,  6 Jan 2026 17:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721053; cv=none; b=BbH3bjXATU08TKrAAae39dKKVv2Hs/V4FJACERvrJgscvZ13WMOlRE7+qxlQd8bmRjJqS5tDWLE/hWDzyhNl0ODHyiC6twd5RGFbH/jDWrSaxnozdRqpULOq+0pWLEjoHfBLulMkNTOIifqrkG05BhMTcbMfyCjj98CskEGqfv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721053; c=relaxed/simple;
	bh=8ltwSHPLAjZUdznmbVFMWho1hDb16bUfGPWc5T0t0uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fX2OkoOh+G6Qe/OpO32j0B592VXk+yWoFlKenBvFy04VvuwVYN9I9dyzXb2fxQ8eRcjRj31H8lPq958Qo1tlH46lVxJIiW6QmgDeqzmkow0NbiCyOjGv/rrepcevQyHjSMgTQiCsnrlyqeKx4V2OBS0cvj2r3yCTbVVmt542U+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQJUaD4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQJUaD4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41744C16AAE;
	Tue,  6 Jan 2026 17:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721053;
	bh=8ltwSHPLAjZUdznmbVFMWho1hDb16bUfGPWc5T0t0uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQJUaD4BeDnZDn1bgj08C2mKY4dTUOriGswStbtZvIlERZlFOaAGEoBGyGE7R5BrQ
	 fXD2LzcyOehNYknS/thSAHG3IhbhNPLhJ+56/1xggCPd/J+gwTbFZZENImyf0MhTxs
	 8XB7BTiIWIJomUF9HHNv6DGgGC57Gp3MWriO3FtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.12 389/567] mtd: spi-nor: winbond: Add support for W25H01NWxxAM chips
Date: Tue,  6 Jan 2026 18:02:51 +0100
Message-ID: <20260106170505.730667675@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 1df1fdbc7e63350b2962dc7d87ded124ee26f3ad upstream.

These chips must be described as none of the block protection
information are discoverable. This chip supports 4 bits plus the
top/bottom addressing capability to identify the protected blocks.

Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/winbond.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mtd/spi-nor/winbond.c
+++ b/drivers/mtd/spi-nor/winbond.c
@@ -270,6 +270,10 @@ static const struct flash_info winbond_n
 		/* W25H512NWxxAM */
 		.id = SNOR_ID(0xef, 0xa0, 0x20),
 		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
+	}, {
+		/* W25H01NWxxAM */
+		.id = SNOR_ID(0xef, 0xa0, 0x21),
+		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
 	},
 };
 


