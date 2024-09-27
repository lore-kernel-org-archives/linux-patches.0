Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492B418A95D;
	Fri, 27 Sep 2024 12:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440017; cv=none; b=BIGKPl0eyVXmwk8TgMPUrLA7DDbDrQJ1lIt2dZrkR/YZCQF6gHOgQItliNweMD3TuWS5+4jDphkcvfyZM5PBFbVcPm95Zywh7ojnKOUFkpEmjkGyrFprZSG1SPDmn9RdADJmcdUgjzLcowsWz47Ax5+KbUC4O1kELwUYSHnA1q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440017; c=relaxed/simple;
	bh=XJ67pSdugKAsh8ZVBhNG6REKgGbBFHCAx5Iq0F+05j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cA0vYcimbsUkc5pFXaemh1++DzZU05ZGzw7JMosd8jej20Xd4EwghDqdn4Txba5qfJ1+OFxTTpfGL1PkBk8IzSJk53tvMPNnAl3sPQYvvyLn0BTNvHWTe32GAAfdyxIO8cyrai4r1DsLZ5B0oA7Co/afsc66Ok7x0oLesmgT89Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Se45hHFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Se45hHFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23E2C4CEC4;
	Fri, 27 Sep 2024 12:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440017;
	bh=XJ67pSdugKAsh8ZVBhNG6REKgGbBFHCAx5Iq0F+05j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Se45hHFNecpu3SDwXIgY1HrtNIhGNfsYPn33OkUc7UjRe23JKip+1p0gWWMJoK1mr
	 V43q8vq4COAFsM0KTokvtPcIDimq9THc7Kqa1u9WjGFNO5p2KERZ4r8ZE5Co+rLO2t
	 sSM2TxKexcmXG/1pZPdSrWvZKnmr90CT8Sed8u9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 36/54] spi: spidev: Add missing spi_device_id for jg10309-01
Date: Fri, 27 Sep 2024 14:23:28 +0200
Message-ID: <20240927121721.208855594@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 5478a4f7b94414def7b56d2f18bc2ed9b0f3f1f2 ]

When the of_device_id entry for "elgin,jg10309-01" was added, the
corresponding spi_device_id was forgotten, causing a warning message
during boot-up:

    SPI driver spidev has no spi_device_id for elgin,jg10309-01

Fix module autoloading and shut up the warning by adding the missing
entry.

Fixes: 5f3eee1eef5d0edd ("spi: spidev: Add an entry for elgin,jg10309-01")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/54bbb9d8a8db7e52d13e266f2d4a9bcd8b42a98a.1725366625.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index edc47a97cbe41..16bb4fc3a4ba9 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -706,6 +706,7 @@ static struct class *spidev_class;
 static const struct spi_device_id spidev_spi_ids[] = {
 	{ .name = "bh2228fv" },
 	{ .name = "dh2228fv" },
+	{ .name = "jg10309-01" },
 	{ .name = "ltc2488" },
 	{ .name = "sx1301" },
 	{ .name = "bk4" },
-- 
2.43.0



