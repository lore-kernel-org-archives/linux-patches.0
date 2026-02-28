Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910F933A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301898; cv=none; b=h5w1yAILkd4Dm0sSxty03wSEzSHVUR+DW8EZwB0C/jq+CbV8klF5aVGihZF3gffhcRCF5/qcec3smK3fTfrMIRvbi6rslR7K4SYFYG8w38g7FDjhDSCvxZT/5S1rQbOpISz9W9g4zw5rJ+Gc4Fs3uanwKqrn8Fx+y1Hlw4gz/Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301898; c=relaxed/simple;
	bh=NBkSPAqt5/m1QkA8NdtXUd0KSDqZs8reSPq17+mhANE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMlyAilEbioqq45KO1HUakPAVxw0uaN5yXP1WzhgdAGLcwxUcbUesVoYtl3zktqzOYS1Bbrbj24jOoBZF0bQMqjNq5F/FM1JPAaBSueJLKxjHFgM2aQnjH7cCkIBXUA6CmuNarm04PHHKcTLsFU8hUk5Bl/FqLW6s09Mw5+NDNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vJ9vFzAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vJ9vFzAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DCBC19423;
	Sat, 28 Feb 2026 18:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301898;
	bh=NBkSPAqt5/m1QkA8NdtXUd0KSDqZs8reSPq17+mhANE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJ9vFzADg2Sy9kaaeqtFLHCznW8eTnGyh6Zpa5fEVuugGWVqpi9al7DBdFvdPZ84o
	 uiAVnQ7+43VEFT8YOVfSmRgeDNo8llUpsbA94dOwxrfCSbHOL4e2mrmqFhgiO+AXZ8
	 4WXqOd3VHZTntclUCQYzTY6QeWLqATVcaBzBRgXGhqfH7yySl+DWNT/WSP/TWLxR9h
	 6xeKGRWi9ZiymMZjRXPybzRbvHPDiGgI70EQ2dh1qxkB0tTxUcZrxSZYRlhcrJeghm
	 4H/LoTyYRebArKnBlNaT7qotRmu23RQbe3MnCDa8p6EnSZ0yNjGAisglFq0T6jWPIo
	 M0AEZEYFxcB/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Petre Rodan <petre.rodan@subdimension.ro>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 327/385] iio: pressure: mprls0025pa: fix spi_transfer struct initialisation
Date: Sat, 28 Feb 2026 12:59:09 -0500
Message-ID: <20260228180011.1568201-327-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Petre Rodan <petre.rodan@subdimension.ro>

[ Upstream commit 1e0ac56c92e26115cbc8cfc639843725cb3a7d6a ]

Make sure that the spi_transfer struct is zeroed out before use.

Fixes: a0858f0cd28e ("iio: pressure: mprls0025pa add SPI driver")
Signed-off-by: Petre Rodan <petre.rodan@subdimension.ro>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/mprls0025pa_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/pressure/mprls0025pa_spi.c b/drivers/iio/pressure/mprls0025pa_spi.c
index 3aed14cd95c5a..f4807dac61e0f 100644
--- a/drivers/iio/pressure/mprls0025pa_spi.c
+++ b/drivers/iio/pressure/mprls0025pa_spi.c
@@ -40,7 +40,7 @@ static int mpr_spi_xfer(struct mpr_data *data, const u8 cmd, const u8 pkt_len)
 {
 	struct spi_device *spi = to_spi_device(data->dev);
 	struct mpr_spi_buf *buf = spi_get_drvdata(spi);
-	struct spi_transfer xfer;
+	struct spi_transfer xfer = { };
 
 	if (pkt_len > MPR_MEASUREMENT_RD_SIZE)
 		return -EOVERFLOW;
-- 
2.51.0

