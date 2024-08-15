Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4791919F49A;
	Thu, 15 Aug 2024 14:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730439; cv=none; b=hfzaCU1M4+GbkOHCO7nDsExXd/F1laeaxjeyF7bXjmT+zmLcVHRtJNc8XeSMn7jUvFfSGW7hkSDeDVjGAVMaP2o0iiEMaVFUe+CX2WpStO3Zq23I9l0MT4NAaQduLgHii2VPCbCgn/Z7rYmhdLLoeH57Iq+GhYOhAUUxXu7z1ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730439; c=relaxed/simple;
	bh=4DckLGljM6cplnp+Qb+e2mW1bH8km3HXxGRlqPwD8YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvbKv1fX17OnwMZ7zfz/ycxQoqvZA/cPX1XSBeiEDJ3Xr7rmgmYXTDjzCkvrB9W9ukPkaz/Z87TdG5mfoBugAWkxcbnOFd+iD2gflqdawpCN/IOpUDviFYQKkN+HNbnRe+wCxEQosYHat/8zMIUnnL23sbAUiuCrepU4DuQVLvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVxQjHB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVxQjHB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F4EC32786;
	Thu, 15 Aug 2024 14:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730439;
	bh=4DckLGljM6cplnp+Qb+e2mW1bH8km3HXxGRlqPwD8YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVxQjHB462iXgsgKp6SqyUb/pkMU7tOyoudC1IqTM883iCLq8/d58z3m/M2wP/hPW
	 JTIc3SSro9tDFxB7gF239S3l6dHrareLJRH0xIvSUMB74pUyBPdcgkYYZOm9esdiUl
	 8h9q8PaMtkgyCGWSoVvF0NJnFjeB8NlO2aGSw04Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 409/484] spi: spidev: Add missing spi_device_id for bh2228fv
Date: Thu, 15 Aug 2024 15:24:27 +0200
Message-ID: <20240815131957.247622597@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 99bdbc040d1ae..0b97e5b97a018 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -682,6 +682,7 @@ static const struct file_operations spidev_fops = {
 static struct class *spidev_class;
 
 static const struct spi_device_id spidev_spi_ids[] = {
+	{ .name = "bh2228fv" },
 	{ .name = "dh2228fv" },
 	{ .name = "ltc2488" },
 	{ .name = "sx1301" },
-- 
2.43.0



