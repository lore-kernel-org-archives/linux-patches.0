Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C25303C88;
	Tue,  6 Jan 2026 17:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720956; cv=none; b=oVk8OB//QikgR80vCn+a1wI0jxO5hcJjYENTT1QuWboNbeMsfZZQl3kGZRaLpqdHuhcOaqTPcKQ5z/XZn50a2J6LkruC2MKj1W7YIyqVc1QfwT0hXhq9Nh83xk3xmMx9CgfkeGOHon+SPXHuYYkcPM/skep+/6N3+E3UMeY+wGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720956; c=relaxed/simple;
	bh=Tq6dwyOJZVcR07Gg1rHSJGkFd0EkGL9QigU8ca5EeRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofUa2Up1rvpC+F57gCq+VTuAX96BYoJmZDAIk7wMaUAIg/g0OrRrQ9Rnmt59o0k6s5shLIhufhmkmZYEfccTkSkVbhdHk5C/kHPo0haGBU2lvNUw6YMrYlb3Az19pQ3aSdzAIWx9L272tltfIo6Q7mU3RXyAsBRbrqtbl0k6JbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cd64YkQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cd64YkQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43E2C116C6;
	Tue,  6 Jan 2026 17:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720956;
	bh=Tq6dwyOJZVcR07Gg1rHSJGkFd0EkGL9QigU8ca5EeRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cd64YkQJhKyE2Rmw+93dj0Y/qoiPjHec8o3g0JjyPGtYCe/J1nSPskro34g7A9fSx
	 JYZ8WWKhuxEqOuKxwnJpWxWqdKq4aoetf00k2lVvD9NKOsG2wEqhAL34oTcCUzwL79
	 1bASLx+j7oEpACN946F5T/VEiWfZcvPYA61bdrDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.12 385/567] mtd: spi-nor: winbond: Add support for W25Q01NWxxIQ chips
Date: Tue,  6 Jan 2026 18:02:47 +0100
Message-ID: <20260106170505.585127362@linuxfoundation.org>
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

commit aee8c4d9d48d661624d72de670ebe5c6b5687842 upstream.

This chip must be described as none of the block protection information
are discoverable. This chip supports 4 bits plus the top/bottom
addressing capability to identify the protected blocks.

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
@@ -254,6 +254,10 @@ static const struct flash_info winbond_n
 		.id = SNOR_ID(0xef, 0x80, 0x20),
 		.name = "w25q512nwm",
 		.otp = SNOR_OTP(256, 3, 0x1000, 0x1000),
+	}, {
+		/* W25Q01NWxxIQ */
+		.id = SNOR_ID(0xef, 0x60, 0x21),
+		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
 	},
 };
 


