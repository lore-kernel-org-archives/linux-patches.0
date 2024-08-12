Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E32183CA6;
	Mon, 12 Aug 2024 16:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478918; cv=none; b=P1358o3bNnWU/sd00Shfrj8+xJauZK2yCLhWV1duC4EGg8rt16CvnqiLTuPkGGzDMj55uku4WjLs4gao5kj3t0oOLX2YK4U1jTVdqdE1gHC950nuGGzF4kkaDzN9OR2NDpjMmRGMUN88SC7ymiSwXB/024jHq1nv3fYOkYZ/CjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478918; c=relaxed/simple;
	bh=XrBU8yjTwWOgOFpJQukV/XeR6Y7yaQgtCdwjxE3pKNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0dzecMHfp/fETaqESlG1qNZK8bFjpVFKnh235+6Y9KPCGmbXXoWTRjc4GgHDEwEr+29dc7hMvWadtaJLaVHySe6QtYAYgosefu2OcTI2gC8V/AWGHRIqiPGs26Hu0JyK62RcIPx81TQIhcVR/j6598w65YeomFTtg/6e++w7+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HlHWBiuf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HlHWBiuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A53C32782;
	Mon, 12 Aug 2024 16:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478918;
	bh=XrBU8yjTwWOgOFpJQukV/XeR6Y7yaQgtCdwjxE3pKNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlHWBiufQIuHelAXR2mA3JQ+LAaanyAwbk9sjK5WIZfqGkm8J4uxqLq2u7uPBfFXW
	 0WSiAd/AbDs7wERaPkywEAnOh1fxwx3qtqKa2fp2s87woUj1EaLektul8xtI5UclmP
	 QCJdrfWM1H/PYaAsoWczWTHRgF0mD0+R4Mk6pqgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/150] spi: spidev: Add missing spi_device_id for bh2228fv
Date: Mon, 12 Aug 2024 18:02:37 +0200
Message-ID: <20240812160128.108687530@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 00612efc2277f..477c3578e7d9e 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -692,6 +692,7 @@ static const struct file_operations spidev_fops = {
 static struct class *spidev_class;
 
 static const struct spi_device_id spidev_spi_ids[] = {
+	{ .name = "bh2228fv" },
 	{ .name = "dh2228fv" },
 	{ .name = "ltc2488" },
 	{ .name = "sx1301" },
-- 
2.43.0



