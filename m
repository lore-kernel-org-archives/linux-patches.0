Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE0C3EDE66;
	Tue, 12 May 2026 17:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608186; cv=none; b=BU20xfzA4KqskRNDrdvBl+CPsmFHliwofJrdgSZxn7iUO5QS7ArN0272mlxytPXs/M+rM2bDj9pQXCYr/oebbUchN+YAIm/xBHzwFv/5S5I21VZm0DoBgo8zZ7Fq6ey7KmGPOxUSpY9c2a0ST3kCV2U9L++wUSuIYBQoCQgRWaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608186; c=relaxed/simple;
	bh=gzlw+KUuTmaJWJ1Vk1WouWVM9+5PX2PPiTwSG0sVKzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3NDTYkTBB4O2FGd6Sg/E0JQXlOk8ypDBNVz68VYRotmKHV1vz3yBGRjWoF5Ak1xKEFiU/3Xf+fmu3KPE8q1NuVMQqlNa5mu0JjiNMyyFSNswbVW14SXNB+4bzvtzRxa+Ekq3RqRe7qxFQTsWiW5rc+bcZw8ucoPGIhsE0jKUOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Una/zLJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Una/zLJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E88C2BCB0;
	Tue, 12 May 2026 17:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608185;
	bh=gzlw+KUuTmaJWJ1Vk1WouWVM9+5PX2PPiTwSG0sVKzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Una/zLJ4jZp9wB9BLPbVY9YJm+wpj9a0gDqvHyz+ttCZrR+7fF/5myirgQ1+bi+eL
	 eoTv1zyacPNR4NTwfMouUyPP9tZnMD6MCYj6JMGiB4I1bBrT9TC0iLZpfbGuIMVD/g
	 BI78Y5IoSkfqsNFIGUkWCyDboGHhN5ff19g0p1jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/206] mtd: spinand: winbond: Declare the QE bit on W25NxxJW
Date: Tue, 12 May 2026 19:40:39 +0200
Message-ID: <20260512173936.826184970@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

[ Upstream commit 7866ce992cf0d3c3b50fe8bf4acb1dbb173a2304 ]

Factory default for this bit is "set" (at least on the chips I have),
but we must make sure it is actually set by Linux explicitly, as the
bit is writable by an earlier stage.

Fixes: 6a804fb72de5 ("mtd: spinand: winbond: add support for serial NAND flash")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
[ adapted chip name W25N02JW to W25N02JWZEIF and applied flag change via read_cache_variants context instead of read_cache_dual_quad_dtr_variants ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/winbond.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/spi/winbond.c
+++ b/drivers/mtd/nand/spi/winbond.c
@@ -240,7 +240,7 @@ static const struct spinand_info winbond
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
-		     0,
+		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&w25n01jw_ooblayout, NULL)),
 	SPINAND_INFO("W25N02JWZEIF",
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0xbf, 0x22),
@@ -249,7 +249,7 @@ static const struct spinand_info winbond
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
 					      &write_cache_variants,
 					      &update_cache_variants),
-		     0,
+		     SPINAND_HAS_QE_BIT,
 		     SPINAND_ECCINFO(&w25m02gv_ooblayout, NULL)),
 	SPINAND_INFO("W25N512GW",
 		     SPINAND_ID(SPINAND_READID_METHOD_OPCODE_DUMMY, 0xba, 0x20),


