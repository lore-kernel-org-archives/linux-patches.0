Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21461335577;
	Tue,  6 Jan 2026 17:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721057; cv=none; b=sMIB8bTM71BI/JA0hMaNSxxeLvy5W/TIkNPfFk3JL2AqDJxNmZW+g2j25u5hLakbK3Fa+ZE2dTP8+lRkn0A+9VqJ3iOg80WMJUkFQ7waBVHeAFrkJk0+fDkr6NLlPCy3v+oW1dl+Y6qGxIVld9JeXzMTKldyXNsXtnijLghsxGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721057; c=relaxed/simple;
	bh=SVgug7BYBwnAedDmOyOLLgQuDmhtXSb4G7GiymEuekk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvDSc2cyCFBe4gfpVuD94n+ftpp78rttmwpNuf3SJFG4c0rF/XyxUf307eJpJOp5v4yvXC4ntwNt8L2a2pnNRaK4ibMW4WpHfovKcuG2bi1D081bCwp8PMomgMp+zlIxDGWuSpXvrp/JLJIii8U2wVBZ13fe1lzIncmnYzs3MAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJhGt9+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJhGt9+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C12C16AAE;
	Tue,  6 Jan 2026 17:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721057;
	bh=SVgug7BYBwnAedDmOyOLLgQuDmhtXSb4G7GiymEuekk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJhGt9+ZKuJ/oZk/lGXwly0u08XLknRjsy6ei6eFKe2CkfqYKgGkPcDcIvcv7Ricp
	 ZgXEhm744SOEgvVEnYhxPPgCrjg7f4otWj/XAVFmiST2rLf/6xURSB5B7mDOlHL7eZ
	 DUbrMQgFkji0u4HPzBKAu/GNIhHbt/pcEQ1pnNW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.12 390/567] mtd: spi-nor: winbond: Add support for W25H02NWxxAM chips
Date: Tue,  6 Jan 2026 18:02:52 +0100
Message-ID: <20260106170505.767283097@linuxfoundation.org>
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

commit 604cf6a40157abba4677dea9834de8df9047d798 upstream.

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
@@ -274,6 +274,10 @@ static const struct flash_info winbond_n
 		/* W25H01NWxxAM */
 		.id = SNOR_ID(0xef, 0xa0, 0x21),
 		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
+	}, {
+		/* W25H02NWxxAM */
+		.id = SNOR_ID(0xef, 0xa0, 0x22),
+		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
 	},
 };
 


