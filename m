Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7422517A8;
	Tue, 29 Apr 2025 17:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948126; cv=none; b=LHDqj80koC5aWjBNGi8GWyi0H1vKXOUsVO2I4Xck08LxC3JlqkQaO6Yj7yQCVlr3AHdavU5xaDUBVbAj93lHZQUPtIr9w413ZdIXkjKkvmd4UzLOmdHbyJvN2sM22P7LdmRf9W5p20WAh3voi+AuDc9wvXD5QjrO7JCsX/mULyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948126; c=relaxed/simple;
	bh=H2k1bU6PpIDes/rquxx0KMw4jGo+iXvH2DUWfNPNEhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7CU1NwxbcARjSVkkm9HnZI0BHjDbE49EpmVaMQd/1obqcYavvx33m+k69OJA9PcAikTKeBP23ZZLJKR50CgLVVFbWJttvSfAkZcy+Ox9OmgvfCFF43waVDV0uDRIn25d9qVQ0XOEMpy9ts6mWFuK+gTTf2g1bfLUE5IcbuoRj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQ20uB87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQ20uB87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848CFC4CEE3;
	Tue, 29 Apr 2025 17:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948126;
	bh=H2k1bU6PpIDes/rquxx0KMw4jGo+iXvH2DUWfNPNEhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQ20uB87IOD+tHDkn18Z9/jFVkS8XGXZwEpDfeyCyXuSkG53C1F59QuPs7gc23FSt
	 x2MugAdoOq6Xje897jFmTq/T+ZnZGjkDEJdzA/Mw/Yzj1nePSdO94kDDeMzGGRP850
	 kKeeFldZshpwswLUB0cQSWcnAPOl/edgHaJGLoAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/280] usb: host: max3421-hcd: Add missing spi_device_id table
Date: Tue, 29 Apr 2025 18:41:51 +0200
Message-ID: <20250429161122.072796944@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alexander Stein <alexander.stein@mailbox.org>

[ Upstream commit 41d5e3806cf589f658f92c75195095df0b66f66a ]

"maxim,max3421" DT compatible is missing its SPI device ID entry, not
allowing module autoloading and leading to the following message:
 "SPI driver max3421-hcd has no spi_device_id for maxim,max3421"

Fix this by adding the spi_device_id table.

Signed-off-by: Alexander Stein <alexander.stein@mailbox.org>
Link: https://lore.kernel.org/r/20250128195114.56321-1-alexander.stein@mailbox.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/max3421-hcd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index 0881fdd1823e0..dcf31a592f5d1 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1946,6 +1946,12 @@ max3421_remove(struct spi_device *spi)
 	usb_put_hcd(hcd);
 }
 
+static const struct spi_device_id max3421_spi_ids[] = {
+	{ "max3421" },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, max3421_spi_ids);
+
 static const struct of_device_id max3421_of_match_table[] = {
 	{ .compatible = "maxim,max3421", },
 	{},
@@ -1955,6 +1961,7 @@ MODULE_DEVICE_TABLE(of, max3421_of_match_table);
 static struct spi_driver max3421_driver = {
 	.probe		= max3421_probe,
 	.remove		= max3421_remove,
+	.id_table	= max3421_spi_ids,
 	.driver		= {
 		.name	= "max3421-hcd",
 		.of_match_table = max3421_of_match_table,
-- 
2.39.5



