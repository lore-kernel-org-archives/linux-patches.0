Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E221774B;
	Thu, 18 Jan 2024 10:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575438; cv=none; b=A+2O0m4M64u4lcjTrhEhdDFsIUNQ92hEAW4vOHE1tew/Xe4Rh/W7q1g2H17f/ue2peusgB5RHAiQu4sHJePOhmSBs/FlXZCrqg0fc7M/Bj5YortTzeOT73yWhyM1Ucl0fF/1j6G4HONKVv/z5veLW+DRGLwPqTmIv2oaMoeK2Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575438; c=relaxed/simple;
	bh=L6kYeAgTDkVHYc6cQuRb17A7Mf2i11np2WMJTB4hjsw=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=GClQo8LX4/TAhoVOSGe46nOhCWKNEhGTpXbIubO4a4VBCgx3Gr8jNakHeLqhT/hvIjBqLGAVNqfMW4DdgUvBT6E/XUapU1rMTZ6O3Kh143aQBsO77X9QrbEIwH3NmhqO88O+XW/dMUj+TQyxX1XfVuBWC3VGGInbUemASGcMkM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7p73kcT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7p73kcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0075C433F1;
	Thu, 18 Jan 2024 10:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575438;
	bh=L6kYeAgTDkVHYc6cQuRb17A7Mf2i11np2WMJTB4hjsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7p73kcTTdMfz4/hTHXEPwD+5Ke+dvwr54ufXcqwwzdOQ0AsK9g6q7k0i5vhGwbDk
	 23nuDXOWmGhVJ0RXH/5+F15v+R7P/uLzWAlzr9MVU6hpmVZOOY1aczYsR1JrrYCFL1
	 sxTDkd2ASOQGlsUG33ZHciCVubReUNiyr2U4uwkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sjoerd Simons <sjoerd@collabora.com>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 6.6 133/150] bus: moxtet: Add spi device table
Date: Thu, 18 Jan 2024 11:49:15 +0100
Message-ID: <20240118104326.212678792@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sjoerd Simons <sjoerd@collabora.com>

commit aaafe88d5500ba18b33be72458439367ef878788 upstream.

The moxtet module fails to auto-load on. Add a SPI id table to
allow it to do so.

Signed-off-by: Sjoerd Simons <sjoerd@collabora.com>
Cc:  <stable@vger.kernel.org>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/moxtet.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/bus/moxtet.c
+++ b/drivers/bus/moxtet.c
@@ -830,6 +830,12 @@ static void moxtet_remove(struct spi_dev
 	mutex_destroy(&moxtet->lock);
 }
 
+static const struct spi_device_id moxtet_spi_ids[] = {
+	{ "moxtet" },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, moxtet_spi_ids);
+
 static const struct of_device_id moxtet_dt_ids[] = {
 	{ .compatible = "cznic,moxtet" },
 	{},
@@ -841,6 +847,7 @@ static struct spi_driver moxtet_spi_driv
 		.name		= "moxtet",
 		.of_match_table = moxtet_dt_ids,
 	},
+	.id_table	= moxtet_spi_ids,
 	.probe		= moxtet_probe,
 	.remove		= moxtet_remove,
 };


