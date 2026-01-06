Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F4C3491CF;
	Tue,  6 Jan 2026 17:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722050; cv=none; b=JYBsWJcU6Z1+LK68/2h+UtaZhxt0kFZ7bdCp3YQ4HdDxJ+a1ehHEG7B2uT1f8mNO6DNq/LRac0rC+oinLR4YXFfdNJDd9Wv41J+F6ICCRhrE6rnOKtBWSZAUCPTw2Us1UbcPCGmex6TYHimOoHIu0MvI936wV5QTb/45OoxKvU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722050; c=relaxed/simple;
	bh=yPUN1w/cZRX5d0MgtSePyaFyutWpp25vmv9Tby5INXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ql9U2sRxG1wcQ58Ph77w3RlUl6Lby1RKSOTqHT5W8f//4Xo3PTmOymFdBdDAxAZFZVrYyAlFi4KXQWpQO9FtRfEvaFj7zNfrKWPzm6D5Gi0UnUCYEqXGW5Ajk6jsV/sv3ASdEbIXpsD3h5MtYFcJH+veNIFJRbo6idaXqBWA0A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=no73WBZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="no73WBZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC460C116C6;
	Tue,  6 Jan 2026 17:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722050;
	bh=yPUN1w/cZRX5d0MgtSePyaFyutWpp25vmv9Tby5INXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=no73WBZmc0y4Wh9QjgGI5bcQ3h24m5/w0Wz00quDo1SY49391UugW2VMWrrxdpg1k
	 Bkqz8/YXOGFAUw+ns4n6PL75r8AP+lAIts5e1cua+pvOcYatPokEX5yKSxSAD1ZJhf
	 lUr6eqmF22/DQ+wteGn/19pOcZl+uOs56/ih1XpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.18 150/312] mtd: spi-nor: winbond: Add support for W25Q01NWxxIM chips
Date: Tue,  6 Jan 2026 18:03:44 +0100
Message-ID: <20260106170553.267230879@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -347,6 +347,10 @@ static const struct flash_info winbond_n
 		/* W25Q01NWxxIQ */
 		.id = SNOR_ID(0xef, 0x60, 0x21),
 		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
+	}, {
+		/* W25Q01NWxxIM */
+		.id = SNOR_ID(0xef, 0x80, 0x21),
+		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
 	},
 };
 


