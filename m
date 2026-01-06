Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBDF365A0D;
	Tue,  6 Jan 2026 17:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722047; cv=none; b=UjtTqAqf0EChSkzrVE7V4/NCgowmcsCRsAU/rlkeCek/766U/fQIthSR0jmbX3wpS1ivFF6p4Ib1zV6VcJbH2idiK+LO43DM1LIzMOnUqD5IFnXYX5JkRH+Y0bN/n3qJIq5XmpFbgniYtakg8GQIqcVhFaKcZ/0KtAjWpoL/ITw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722047; c=relaxed/simple;
	bh=VaFpaJ3tRGs4OZxuFRz5wz6edzMCIbf6NGvSTSLuAdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7xp+D4raPGMQ1noOiEV7EaEyTLjPsKt0lqMzswubgtAVAC0xUe4bJ8zKtJybkLTjt0HH/3nc+B1O/Kk/aovYvR3H/aecZafODvx7OaL9YYPVBwC31eXVL9lhG9iyNP9nV71i2glEMV3ykyjSLqhMnlrAweuU9bMs6OuH4U/Grw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRq529Ws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRq529Ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896ECC116C6;
	Tue,  6 Jan 2026 17:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722046;
	bh=VaFpaJ3tRGs4OZxuFRz5wz6edzMCIbf6NGvSTSLuAdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRq529WsJTgefy1wvXKXiW/3sHxYTEWfGF7uUJXJYSicrZi/FI3YB1bYZRBIoNsUj
	 eotv8J3GM/h2FMjMQVGX1iMYk1+hkebFM/nax/iBFoXDIrHEnEo9LzBer0weuSYNT+
	 Zv01yyZYDW0tJdMlNmE5lCPteJzjAa0aL2AxCL2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.18 149/312] mtd: spi-nor: winbond: Add support for W25Q01NWxxIQ chips
Date: Tue,  6 Jan 2026 18:03:43 +0100
Message-ID: <20260106170553.231458031@linuxfoundation.org>
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
@@ -343,6 +343,10 @@ static const struct flash_info winbond_n
 		.id = SNOR_ID(0xef, 0x80, 0x20),
 		.name = "w25q512nwm",
 		.otp = SNOR_OTP(256, 3, 0x1000, 0x1000),
+	}, {
+		/* W25Q01NWxxIQ */
+		.id = SNOR_ID(0xef, 0x60, 0x21),
+		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
 	},
 };
 


