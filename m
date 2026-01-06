Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AD833BBDF;
	Tue,  6 Jan 2026 17:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720993; cv=none; b=tzr8ZzvnceRNwfp0HqLm8ZRCdDP/KPu0KMD/qcWu7VvXcawkQf04M1Qx/gxl91+Fr4XJNUKk7mlScVd08wcIoOh9CmzVCJ/vxqOGgV94v/o4MJXM8kJYBKPcC4YccAm3ms+iiDxB2rCg7YMUeBmInSXL2X+siW5SKAAkyzA8qRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720993; c=relaxed/simple;
	bh=VDUYqLUALCPDY7DM8HBmyK3IMnw7YEzIj2PCqpO3eCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQB+nMTK2LhXRg6bfWYYyLzTy2JFsobvOs3vRegIj5NcxzwJ4YZJqujbcdvY0ujjipbfdWjmm+2EMnA83iDE+mnpjNnQwOx3ZUCLk06GFhv1eItiBvFfAAVEArdQ03vNTVDUdzVcw2GTYmFKSxtJnRKOOYf4PKjue+foOX+78jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMHQE9Y7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMHQE9Y7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FCFC116C6;
	Tue,  6 Jan 2026 17:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720992;
	bh=VDUYqLUALCPDY7DM8HBmyK3IMnw7YEzIj2PCqpO3eCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMHQE9Y7ABm+kJJOG7D+Nxbf8yMYTuq4TX5DVrkNe0Cu12SMsc1OUm2ellUUuQ5PP
	 mihbQ7FhmW3i39zLrZetl6/lotBnfb9BKWLKGF6ZSa7oxEYVUrWo6XQxA51cdlBJ4P
	 SpCTTa0i+uI91kCzaO2X8husme2Vi9aWDa3spTd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.12 386/567] mtd: spi-nor: winbond: Add support for W25Q01NWxxIM chips
Date: Tue,  6 Jan 2026 18:02:48 +0100
Message-ID: <20260106170505.621921123@linuxfoundation.org>
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

commit a607e676c8b9258eabc3fc88f45bcd70ea178b41 upstream.

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
@@ -258,6 +258,10 @@ static const struct flash_info winbond_n
 		/* W25Q01NWxxIQ */
 		.id = SNOR_ID(0xef, 0x60, 0x21),
 		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
+	}, {
+		/* W25Q01NWxxIM */
+		.id = SNOR_ID(0xef, 0x80, 0x21),
+		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
 	},
 };
 


