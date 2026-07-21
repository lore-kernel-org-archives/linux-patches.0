Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A4D449B2A;
	Tue, 21 Jul 2026 17:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656013; cv=none; b=ODVonecVe4dRIU2GskTgAgem+pmbUzLN22mpQqwSpuT7GoNahh2CdRbn7S7mxbiZLW9+vYMEQKrHbxcjpEGEsDHbLyS+g+V2pqI4/v2mavflpzRwb8hbdLG9Url8geYwwt8Ynifl/T9rBOTsVcYl8kvjX3FMdYXmq50M8KnKcqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656013; c=relaxed/simple;
	bh=xnj/XoVMhZ+sGvuLwFDKIuHzoZnxxUNpbSrVLCnBmMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScdAPfvrvK2oAhqnXFJ4Aficdkjr3CAQN+9WnWp/3PD0LjGLPsYYYUA2mI18Q00KVZ9YekXer6ejlVqzT9tySsTYowb8mOKIodGAW3Q0naaZdXPCZSj8ce04l0peLKeWrJLcq1/SjkkQG+2TbJomshh+1WR8r7ii26/yH7lP4jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soBqloy0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soBqloy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924D91F000E9;
	Tue, 21 Jul 2026 17:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656012;
	bh=RiIjMXlKgF/XNqQUSI1omQxKez127jTaV8ORX31z9XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=soBqloy0JKyCIDsnzbmtsSd95Gso5kR0M3uFwSF0Iq/DJ7dwmp4xpsB4v4Ags8yVG
	 nIxBuZccPk0+lDxOg7Hr3n+D31gTHd3mful6lfapp8HmVRd5XMgDGWn6l0b2VJE1st
	 41FKw+o3Fsl4pQVgqsDDt6VcL4ThZhelCNyN44D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0225/1611] mtd: spi-nor: debugfs: Fix the flags list
Date: Tue, 21 Jul 2026 17:05:41 +0200
Message-ID: <20260721152520.066850163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit 829dff83597615208aedf0f5abb3878b47f2314d ]

As mentioned above the spi_nor_option_flags enumeration in core.h, this
list should be kept in sync with the one in the core.

Add the missing flag.

Fixes: 6a42bc97ccda ("mtd: spi-nor: core: Allow specifying the byte order in Octal DTR mode")
Reviewed-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/spi-nor/debugfs.c b/drivers/mtd/spi-nor/debugfs.c
index 14ba1680c31547..c0bd8f1149a51d 100644
--- a/drivers/mtd/spi-nor/debugfs.c
+++ b/drivers/mtd/spi-nor/debugfs.c
@@ -29,6 +29,7 @@ static const char *const snor_f_names[] = {
 	SNOR_F_NAME(RWW),
 	SNOR_F_NAME(ECC),
 	SNOR_F_NAME(NO_WP),
+	SNOR_F_NAME(SWAP16),
 };
 #undef SNOR_F_NAME
 
-- 
2.53.0



