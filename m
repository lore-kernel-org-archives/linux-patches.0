Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F43366546;
	Tue,  6 Jan 2026 17:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722057; cv=none; b=aD7eLdbWjzSyaYR7rubX7ir1VWQFtIAAs/wI/lD3W1ZK2Ct1L4uNJVv/VNsR5eU5ZJf5SHWQr3UQegxP8P6ndpLJcghPdZ8r1Ck+qUkxPo7+r4TnLsphYZfhS6e4+Sc30c9CiKCdLeboBm5UQoqJN7EjQ7xhV83DF7M7A8kxXVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722057; c=relaxed/simple;
	bh=y6reuywCC2SkW7eE7Z6SDOIL7ZZ6xFbaEQR9AOUA9oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MljsEBOTIo3neIWTLN9GTTEecw16Nzz/xD6ZLTBCbDglukHtzi8WVLneM4amhBEryK+YvQnrYpi3XH0WZx58UX7ER1lJPBbHb6VL02W3TQtOuugYWDezXt37RttMyGElNxqm9TDRP82vfAbds0xFHUfulfYlb0y4roRGFndDf4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvzI7Dyu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvzI7Dyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C909C116C6;
	Tue,  6 Jan 2026 17:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722056;
	bh=y6reuywCC2SkW7eE7Z6SDOIL7ZZ6xFbaEQR9AOUA9oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GvzI7Dyul+FRGJFASJimhu3uxURuL0pTUe8brxDqentzz/5m5HrtWR0JVsEuHhGSv
	 tFkr4k9cZmKqJUrRcvvzvUgCi3gnPG56yBJzS2C8arre47v9x7Jxkmrx8troqnYpuq
	 HKmrXpnGDRWK6Gi9nGNG0rDGF0meDxzjuyih69cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.18 152/312] mtd: spi-nor: winbond: Add support for W25H512NWxxAM chips
Date: Tue,  6 Jan 2026 18:03:46 +0100
Message-ID: <20260106170553.338388056@linuxfoundation.org>
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

commit f21d2c7d37553b24825918f2f61df123e182b712 upstream.

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
@@ -355,6 +355,10 @@ static const struct flash_info winbond_n
 		/* W25Q02NWxxIM */
 		.id = SNOR_ID(0xef, 0x80, 0x22),
 		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
+	}, {
+		/* W25H512NWxxAM */
+		.id = SNOR_ID(0xef, 0xa0, 0x20),
+		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
 	},
 };
 


