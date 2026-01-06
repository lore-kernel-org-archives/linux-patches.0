Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0C73659FB;
	Tue,  6 Jan 2026 17:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722067; cv=none; b=aNseyJUMfPw9Joo7zojWC+VnxZZnwJRVAwJMxQ/YE0BXBpRw8J12q4b4PBCzJmRk/cURJuSios0nNoU7zfjxe9KLJFFePcB7g24AATXMqemQEjHmvkqIc4OUHurfORVwux0Q37vodkZdj1TgrwGHrRzxu3MoEfGfnEBov+byom8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722067; c=relaxed/simple;
	bh=aiKQxB8XDxOcvP6Uiz6vXJOBtxLX/XIwM6lSKSt8Ln0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plDwTK66jMWwxfFLh7RRhJyqkbqPynE9mlNsrg4QUdmWGKaXx6b7vVchZmF+6PwCt5JkD2QFDAB17l2+zzXoNs6LKGpLTq5Z3i22fII0t/qVHnnu/z0SnqUrNrClsJJsXLcgpcH4BA1NoKInkheAr4eOm31sBxb84bTALfaQPQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4G4HRfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4G4HRfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A396C116C6;
	Tue,  6 Jan 2026 17:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722067;
	bh=aiKQxB8XDxOcvP6Uiz6vXJOBtxLX/XIwM6lSKSt8Ln0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4G4HRfjnQ1xJs0b4e+Wi7y09u3piSmuQHndfCPLxnaV/N7iFnNw4+7tPJpFLIehs
	 PCOUDa1Zo/4Gq4fZI/RRUIF1mT5zc6Gyy6OrEZjPmx9VkdzTlyCDZIpneaq5uIdBkw
	 TCFS9IGX9DbOkrAeLUiYJqcAG/INB6FxunLORILE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.18 154/312] mtd: spi-nor: winbond: Add support for W25H02NWxxAM chips
Date: Tue,  6 Jan 2026 18:03:48 +0100
Message-ID: <20260106170553.410075560@linuxfoundation.org>
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
@@ -363,6 +363,10 @@ static const struct flash_info winbond_n
 		/* W25H01NWxxAM */
 		.id = SNOR_ID(0xef, 0xa0, 0x21),
 		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
+	}, {
+		/* W25H02NWxxAM */
+		.id = SNOR_ID(0xef, 0xa0, 0x22),
+		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
 	},
 };
 


