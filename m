Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14AE280327;
	Tue,  6 Jan 2026 17:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721029; cv=none; b=P60GQJSWhuyKTuiXuUkL+xDNxa/fM8NK2PQ3FFnR66VKyRpd1fmGdLk5SZ9oPq4nlR4UYLL0YirWQkG6uuABp0+6xTmffXLaTWYX739xwOMw69TZsXNJe6P9/1qFASZfHhPBSNK5prA9TQa0Pj2hAyc73+xef+GsIxgX4rjRecQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721029; c=relaxed/simple;
	bh=4dagcf/ImojDKwavont0DygMhYP1D4gKJaWcXipjeZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqXXDiuXA4HYxpq2hr3S7qtj02hcNRVmTXCMVqwWfgcvcxDenUW43lbLrn4YgS2i9TMsRNpKsmIh9jObJ2Chha2zOA29ctzY2dxHh+h81XcXwLQTk2I1MHuXc8rxj9MURYV3U4khT6fR9uus2azR66dv25YaYUvVWKK6Tt2p1/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5P0GsPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5P0GsPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31047C16AAE;
	Tue,  6 Jan 2026 17:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721029;
	bh=4dagcf/ImojDKwavont0DygMhYP1D4gKJaWcXipjeZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5P0GsPHR0iqCj65JVGUuISzQD5PT1zKp+6RzFB7KqcetzU3kO2WJb6e3kNdgG32U
	 q7M+bkkU9AkBjwTSfzZ52zeMkLjhiJTmaao16CFlEcABrAz0Zt8xPu5e1SVKEv9lWT
	 NzPiG7QLxI7fI0NZWoEssO5IWx6qOsDTVpFWmOuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.12 387/567] mtd: spi-nor: winbond: Add support for W25Q02NWxxIM chips
Date: Tue,  6 Jan 2026 18:02:49 +0100
Message-ID: <20260106170505.658311885@linuxfoundation.org>
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

commit 71c239348d9fbdb1f0d6f36013f1697cc06c3e9c upstream.

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
@@ -262,6 +262,10 @@ static const struct flash_info winbond_n
 		/* W25Q01NWxxIM */
 		.id = SNOR_ID(0xef, 0x80, 0x21),
 		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
+	}, {
+		/* W25Q02NWxxIM */
+		.id = SNOR_ID(0xef, 0x80, 0x22),
+		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
 	},
 };
 


