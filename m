Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675E447D93B;
	Thu, 20 Aug 2026 16:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244221; cv=none; b=EiICorwravylarEycg6Z5v8cLOM+9na4rs1zK30DgsnSujL6l2UeI7l8DOmlEiSwsmPqbdGLOnPCl8OSxgVAOR9DDo9QX/nbPpFDg8ZiYSiAWUcHLprqrI3jDtN8fdBSr2g0aGW69ZxUrNp3XkxT54Ss3ETzEjutOjId+hCcghA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244221; c=relaxed/simple;
	bh=VS6gIvQTbqEYUUtltPbq0l0AkZ3KS9nV1rCVUKK7ZcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTNkdUYbxBLP0BTknyO8sUk0woto2TtLvpggpn4oHXVrpDlNzK7BaB/YjRbhGAQ5S6fv5zexYOPwFvzcnClLr0wvsiFxmbQgPELJx3uVHhWe/z0or/XY/pajwb9hE3UmlN0AE1E6ACDBPkfkM3nguDMbrzIN23TgZ5eoD6Lw60w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjAgr2Hc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjAgr2Hc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E711F000E9;
	Thu, 20 Aug 2026 16:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244219;
	bh=zURsZDKuw0bvePQuPILY4Yd2y/Gl4mJvAT7l4b1BdAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zjAgr2Hcr4jtGK5hGFjJyaIUZYfk5qhqc4u2iDkf/i9SwLxN0Aa37mLyHBjpFeWrS
	 i5aYWMfRoWxqso1j5/Bpe18lTsj98aAv0MeECesCzHlmLMv4hmrRUM0e41sI70UgJu
	 UP+aokN9ybteSON16PkBhUgy/CK9g3s3gIVCNi6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/235] mtd: spi-nor: intel: remove global protection flag
Date: Thu, 20 Aug 2026 16:55:28 +0200
Message-ID: <20260820145219.244100952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <michael@walle.cc>

[ Upstream commit afcf93e9d63fc1e15935a2df9457f803394e4f20 ]

For the Atmel and SST parts this flag was already moved to individual
flash parts because it is considered bad esp. because newer flash chips
will automatically inherit the "has locking" support. While this won't
likely be the case for the Intel parts, we do it for consistency
reasons.

Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20201203162959.29589-6-michael@walle.cc
Stable-dep-of: e1d456b26bf2 ("mtd: spi-nor: swp: Improve locking user experience")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/intel.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/drivers/mtd/spi-nor/intel.c
+++ b/drivers/mtd/spi-nor/intel.c
@@ -10,23 +10,13 @@
 
 static const struct flash_info intel_parts[] = {
 	/* Intel/Numonyx -- xxxs33b */
-	{ "160s33b",  INFO(0x898911, 0, 64 * 1024,  32, 0) },
-	{ "320s33b",  INFO(0x898912, 0, 64 * 1024,  64, 0) },
-	{ "640s33b",  INFO(0x898913, 0, 64 * 1024, 128, 0) },
-};
-
-static void intel_default_init(struct spi_nor *nor)
-{
-	nor->flags |= SNOR_F_HAS_LOCK;
-}
-
-static const struct spi_nor_fixups intel_fixups = {
-	.default_init = intel_default_init,
+	{ "160s33b",  INFO(0x898911, 0, 64 * 1024,  32, SPI_NOR_HAS_LOCK) },
+	{ "320s33b",  INFO(0x898912, 0, 64 * 1024,  64, SPI_NOR_HAS_LOCK) },
+	{ "640s33b",  INFO(0x898913, 0, 64 * 1024, 128, SPI_NOR_HAS_LOCK) },
 };
 
 const struct spi_nor_manufacturer spi_nor_intel = {
 	.name = "intel",
 	.parts = intel_parts,
 	.nparts = ARRAY_SIZE(intel_parts),
-	.fixups = &intel_fixups,
 };


