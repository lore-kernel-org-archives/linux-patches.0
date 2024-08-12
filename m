Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75CF16D9B8;
	Mon, 12 Aug 2024 16:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480277; cv=none; b=uvsbi8OY0kVI5YeEcLKBSmgeXez9htlxHDrwAifhrZwKEqiJQ+50cGADNP02r4RSrLqNqpXaZFAYFQQzl/sGKU3lS5Rm92o5xc/NltbmmroLaG1mfh89YmJP8bucWTsC8AIT2dbilqj0HIF0POElYPkBYzXrVjwBGBKJR+bFkKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480277; c=relaxed/simple;
	bh=8YR1dW4uptcFJSxqTIh82hly3BXQpy+vL7TYwBgWojc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxKEAxX9X95nQlRaYbKKO+dj2/JpHw3H3aaMfbddeVpqFNVBGtde+qmPKquOkhm9TFPNz5t0RRjyYMVJ5yTkP7Q2wQDCFPW5UqxzZTs8So4xLcs5HfjfdpjuDNCfFkH7KO13mWWr0yrTTGBdaAqjcVkC4ykOWtkDiOw/3DpioYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNULceeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNULceeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F08CC32782;
	Mon, 12 Aug 2024 16:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480277;
	bh=8YR1dW4uptcFJSxqTIh82hly3BXQpy+vL7TYwBgWojc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNULceeR7dQJ1m2LLxQgBUcNiyV8nc4Hr7RHqPg6y+xtG6nqwesWbbNZeJUhs3qKX
	 /ovq/D4jN6TJ2IQhmIokFY/kMiPiIorfPtPMhtJYrtChPQ73DiSe9CX+4O4qqvq05P
	 J7APwHt/RG7oPIhxeMmDqyZE2n1n0YEEe3BdU7vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 147/263] spi: spidev: Add missing spi_device_id for bh2228fv
Date: Mon, 12 Aug 2024 18:02:28 +0200
Message-ID: <20240812160152.175523944@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit e4c4638b6a10427d30e29d22351c375886025f47 ]

When the of_device_id entry for "rohm,bh2228fv" was added, the
corresponding spi_device_id was forgotten, causing a warning message
during boot-up:

    SPI driver spidev has no spi_device_id for rohm,bh2228fv

Fix module autoloading and shut up the warning by adding the missing
entry.

Fixes: fc28d1c1fe3b3e2f ("spi: spidev: add correct compatible for Rohm BH2228FV")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/cb571d4128f41175f31319cd9febc829417ea167.1722346539.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 05e6d007f9a7f..5304728c68c20 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -700,6 +700,7 @@ static const struct class spidev_class = {
 };
 
 static const struct spi_device_id spidev_spi_ids[] = {
+	{ .name = "bh2228fv" },
 	{ .name = "dh2228fv" },
 	{ .name = "ltc2488" },
 	{ .name = "sx1301" },
-- 
2.43.0



