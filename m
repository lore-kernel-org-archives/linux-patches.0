Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCF3417353;
	Thu,  2 Jul 2026 16:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010511; cv=none; b=i1het1LEPcKzzR5Bm7kSvRwkrT7nloTBua4BQ124F7c0idV9XX+nR1NlRwkHaVcUab0HP73cMxw2rn2fzQWtzrjQkFETdEWYSSTRU+5xTF6qWlcBQsE0kbwmOy+Jwj8/KvzzoET68rhnqzxrVEL1DxfudUlivDh5c+aYQmlqn28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010511; c=relaxed/simple;
	bh=Z7KLsAfBgZ7vDFQPVrAfA7IKpYpHVyZ/Z/PQVpgS/70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o41FwGGOEoJskb5DLzvaqM6Pl5N3X/aQvQbu7lRYLm9AB05Z+krbQwA94as8tZ9RgHTnKmLdXUl7h/jgvw4Npgp8JZvZ8MiP8jQbRHgcul7mlxhsBAfgZy2mzlR6/vy8AngjokGumumY0ieiEeE/MASA8qPoe5dwyLlWZMWY6hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Luywm3c0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Luywm3c0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B831F00A3D;
	Thu,  2 Jul 2026 16:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010506;
	bh=bnJmFhCgEwMERhVYibrR1Ipa+4rWAy1CTs7/Vn0oTi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Luywm3c0Ga+R+F4ABoDG4+ou/PlWixtdSaYETjjdn9c1OFVyBiUMQd9+A678gQOYE
	 MI/TTsbS+lXtwlOqwn9OzKz/IyS0dTKz2wuXODn97pmVrAX6nHza8gsb3/HVGMy3Dk
	 hNDc5HID0XKW8yPGnkRWqFCjwsWJ9xCZQTOIzNf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Ming Lin <chengminglin@mxic.com.tw>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/204] mtd: spi-nor: macronix: add support for mx66{l2, u1}g45g
Date: Thu,  2 Jul 2026 18:19:52 +0200
Message-ID: <20260702155121.488780025@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Cheng Ming Lin <chengminglin@mxic.com.tw>

commit 797bbaa7531f75985b199e484451fa3f954382b3 upstream.

Due to incorrect values in the 4-BAIT table for these two flash IDs,
it is necessary to add these two flash IDs with fixups.

Signed-off-by: Cheng Ming Lin <chengminglin@mxic.com.tw>
Link: https://lore.kernel.org/r/20250211063028.382169-3-linchengming884@gmail.com
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/macronix.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mtd/spi-nor/macronix.c b/drivers/mtd/spi-nor/macronix.c
index 678ebaa220ca98..6127565372c529 100644
--- a/drivers/mtd/spi-nor/macronix.c
+++ b/drivers/mtd/spi-nor/macronix.c
@@ -110,6 +110,10 @@ static const struct flash_info macronix_nor_parts[] = {
 		.size = SZ_128M,
 		.no_sfdp_flags = SECT_4K | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ,
 		.fixups = &macronix_qpp4b_fixups,
+	}, {
+		/* MX66L2G45G */
+		.id = SNOR_ID(0xc2, 0x20, 0x1c),
+		.fixups = &macronix_qpp4b_fixups,
 	}, {
 		.id = SNOR_ID(0xc2, 0x23, 0x14),
 		.name = "mx25v8035f",
@@ -165,6 +169,10 @@ static const struct flash_info macronix_nor_parts[] = {
 		.no_sfdp_flags = SECT_4K | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ,
 		.fixup_flags = SPI_NOR_4B_OPCODES,
 		.fixups = &macronix_qpp4b_fixups,
+	}, {
+		/* MX66U1G45G */
+		.id = SNOR_ID(0xc2, 0x25, 0x3b),
+		.fixups = &macronix_qpp4b_fixups,
 	}, {
 		.id = SNOR_ID(0xc2, 0x25, 0x3c),
 		.name = "mx66u2g45g",
-- 
2.53.0



