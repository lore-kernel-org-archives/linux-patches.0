Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A161B33DED6;
	Tue,  6 Jan 2026 17:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721050; cv=none; b=l/ZKK78AJjAoplH1MvjQc2Ol8SALXB3TeCHvOlzXB5fB9Rrddr1rZyqGbelNnoGHnh0Zx6Aa+STx+2g6uU+Q3hO4ZXibTmoOJtGNucw7lnAlUTAuhMovBX1LvC0ZNKWyITWW6xdRMMN788bK1P/NPistY+h5jKFfwrYzlelFkHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721050; c=relaxed/simple;
	bh=y4Vh/Q6Z9oU0pvVEEuwL//iBo7TaYRezgUsrsjFbvGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oq3h8YJLW5sUeIDIMS1sJcP7thDub5FvtwKTM3DsvQnUJMNyc6lxqe/dPckASlnJNX8R2J5TE9dGzTjuJwMaIO0TEwtP2poTdBEY+VIsLUAdlgcGihXN6Bhcqsv/ApwySh7S/LLL6QW6l+YYB0UMLIhRqt5T71Z7vycAIqacHqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8E9QywB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8E9QywB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152F0C19424;
	Tue,  6 Jan 2026 17:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721050;
	bh=y4Vh/Q6Z9oU0pvVEEuwL//iBo7TaYRezgUsrsjFbvGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8E9QywBqxrKvTqlegB1Ba/ZSYV+w2nl7rm/kvZwi4GDTtMH7YPp1paGNlxsFycq1
	 /DvN8JIA3iX49NibM4dk5mzoDjY+RuARAhKjPnIrifPvqoWQjYIP9R+Q/Z5V9gfMOS
	 8xL3sfD8+9qP0ewYORB4bVg0L6RkSeck+CrqjJjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.12 388/567] mtd: spi-nor: winbond: Add support for W25H512NWxxAM chips
Date: Tue,  6 Jan 2026 18:02:50 +0100
Message-ID: <20260106170505.694485090@linuxfoundation.org>
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
@@ -266,6 +266,10 @@ static const struct flash_info winbond_n
 		/* W25Q02NWxxIM */
 		.id = SNOR_ID(0xef, 0x80, 0x22),
 		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
+	}, {
+		/* W25H512NWxxAM */
+		.id = SNOR_ID(0xef, 0xa0, 0x20),
+		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
 	},
 };
 


