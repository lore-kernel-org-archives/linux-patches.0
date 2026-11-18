Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046212;
	b=QxTzD758g8bgAxQRWHEVhGsKN2X+mEj5uyZb0YDDIEnF/Xjr0BcNnG+PznEJBT6G8JdC
	 9ZaOtXIdQ3offLBJxnvQSu+JpXDpoj1vjaq39qGXNNZfduZJdMmViClq18xLnNTuhAB2q
	 e7LXap9i2g6wBacsRn2jGYI4ry7rVOXhj9Fdff3PeNOeruVk+UnfYaVNgJgsrgrOjAiUV
	 31jHBtcCwLSX+pAPwTolRfUmbGWQmP7Le9+C1ZaEwlzfmIOWm+m0xHSNKlICjNhqUSCF6
	 YayT6XPuNgnsOoFAMi+M9PppGrIzILqUZPnNtbP/ETsmaLl4X1CgrLhwMzI9jhOMIeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EMwNqfXPnHhkJQyWjSc5ovJvikmM79pEdT41/Rp2z80=;
	b=uAeUTLzC+OWufltd2Ra5qpmaYABKAzDdbaU93bh8WSpvSFLecXzpG5YctokPCc+inAir
	 UwcJjSuQ1BzAkeXOYLh0JTtXOOlX6/QccGyOicPQOlBHO0utEQiwJ8PjPROvXgXOVyeIR
	 buHKISgVKT5y9WXEXnwcGMZx+jhC5AycXufa1ENionFDSbjZeNMVDm57XFXYe1cOY23yg
	 BAr0z1kPpZHQb1u4HFDuLc6JP7+Mz0EUAJlnKEZj3IZmYWkzALzwpENup24nO+o/m8oYq
	 YjyL0ci9Grlr1VZfYIjaMiRZqMPMEhxwSxtAOmFCNeVC31Az9xU/QJCv268LbHZ1W3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eR+rHAqg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1366606A325;
	Wed, 18 Nov 2026 23:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eR+rHAqg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5130E1F000C4;
	Wed, 18 Nov 2026 23:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046211;
	bh=EMwNqfXPnHhkJQyWjSc5ovJvikmM79pEdT41/Rp2z80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eR+rHAqgsE124DckmsgV2OEtoisdp49E4dmTodWqrap1NzHC9AoOOPjFIbPBcxU0r
	 PlZE92aOSa368QcsHehUfZw4jwluRohFIA28/Xcpa/JdXuXSjKJ02c1A4VAYOddmJ3
	 sWOHuVSwW7W4Bz1JlR8PD/bPmeeL6EmC2dRjyLw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1163/2857] mtd: rawnand: ndfc: fix gcc uninitialized var
Date: Wed, 18 Nov 2026 15:36:37 +0100
Message-ID: <20261118150243.464242807@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit cceca8cb776b03e83985578f84bd730c30d57f70 ]

Now that this can be built with COMPILE_TEST, an unassigned variable was
found. Set to 0 to fix the W=1 error under GCC.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606141301.iyVdFgl7-lkp@intel.com/
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/ndfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/ndfc.c b/drivers/mtd/nand/raw/ndfc.c
index 7dfb7b2f2f3cf..47f6ef0c5d9bd 100644
--- a/drivers/mtd/nand/raw/ndfc.c
+++ b/drivers/mtd/nand/raw/ndfc.c
@@ -187,7 +187,7 @@ static int ndfc_probe(struct platform_device *ofdev)
 	const __be32 *reg;
 	u32 ccr;
 	u32 cs;
-	int err, len;
+	int err, len = 0;
 
 	/* Read the reg property to get the chip select */
 	reg = of_get_property(ofdev->dev.of_node, "reg", &len);
-- 
2.53.0



