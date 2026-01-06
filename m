Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE633366556;
	Tue,  6 Jan 2026 17:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722064; cv=none; b=hIcKV4yoX+9TLQk0dhxD9SG+AZytotGtpsttOz6t3sYhgP8VoCGV+OtKNktD4B3CM5l7d/Gmb4pp61ipy/832Nwztx2rr+Z9WnzOm/1KYE1jduQ03d9qv1ArtI1f7zHriF4imIehIAnLRISKOL9Dg7XuEe4RWauXrEM987ch7pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722064; c=relaxed/simple;
	bh=SbpbXYrUe5jqN0OBajCFvfnVQmv2xb+lFY8paUmBgUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpZMmNqDNTIn5hjXXO6dMLMeyJDDi2oDy9cWX1S3AUBzHF0Pv//YEQRQXkq6LHa+GkJoLwnFXtBVhVC+Xg1Eo0Bh5Lgvp1QO0lH0No76HZ+Y48Ivq+wSTYpDTkYLdAOXoikg6g6jBrgRNjxiZWplhNa7xOAWK1ihYns67aszz2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHSbjTGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHSbjTGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D428C116C6;
	Tue,  6 Jan 2026 17:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722063;
	bh=SbpbXYrUe5jqN0OBajCFvfnVQmv2xb+lFY8paUmBgUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHSbjTGoBWxh0iQOkNT+IxYlknQcdunKqYspy7gtvUDnAdmbdFtMm+IlMWVSOGMX5
	 7LolI7sKro9M/rjbzgoB6hReQIlkM8B+6HnjN/qqANd800vch3ypHCxn9mOEjRcWK6
	 FoG7XgL33PItNjH1h4k+1SrkvrBbC6XVb0My1n30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.18 153/312] mtd: spi-nor: winbond: Add support for W25H01NWxxAM chips
Date: Tue,  6 Jan 2026 18:03:47 +0100
Message-ID: <20260106170553.374221143@linuxfoundation.org>
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
@@ -359,6 +359,10 @@ static const struct flash_info winbond_n
 		/* W25H512NWxxAM */
 		.id = SNOR_ID(0xef, 0xa0, 0x20),
 		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
+	}, {
+		/* W25H01NWxxAM */
+		.id = SNOR_ID(0xef, 0xa0, 0x21),
+		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
 	},
 };
 


