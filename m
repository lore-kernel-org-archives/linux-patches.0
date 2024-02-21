Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CFD3CF42;
	Wed, 21 Feb 2024 14:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524801; cv=none; b=t1WIkxqxj45MTrcNz6SNy5Uz+qM8XAUAcIuif5beroc/S/vmU/3daMBFgSB2i2n1kvy4UaAzg4/McuKqGePCKv33PCQ4C4gYLkCgYM63GyiSvIq3whQ/UDNcqN0SeKIIWM8R7H+huN95S0wO8qOrly65VNAQzD5a2TSavy9GCDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524801; c=relaxed/simple;
	bh=5L2zd43X8K14JHfLr84h1+wM89FuvwSV0hZ6DqAlW/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W5IMO5GVfwwc8w3BYXn3YTluetom7rNyJJhftVItxKYOcTvdMOZ8Q4C/baYi60+QSvSQXZZJlw8oGS05MPt+nXvv/ptR1AJCjNW6bU8jogphKDMS7lXUJIsOr8ndDoLS5tQDAAx/cJIABZp8rXu0DxurmFFyg8zEctd0WjDkzis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+gNfntZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+gNfntZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED053C433C7;
	Wed, 21 Feb 2024 14:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524801;
	bh=5L2zd43X8K14JHfLr84h1+wM89FuvwSV0hZ6DqAlW/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+gNfntZf1RUdqc8KC7jd0aW2457oeYjlXTvAf6JoC3jXijf3SYRFdLewebMXR1mn
	 E29D/9gLQ0oJBkIyit0BEjV9TxlVvUXWoPoY5fOs9O50/9WYmm5/kDRi/jc9+MnFyy
	 I2UsG3Nndvt879EhPdj9c2FLwX/iZzJQ7VTI+DN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sjoerd Simons <sjoerd@collabora.com>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 353/379] bus: moxtet: Add spi device table
Date: Wed, 21 Feb 2024 14:08:52 +0100
Message-ID: <20240221130005.472240451@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sjoerd Simons <sjoerd@collabora.com>

[ Upstream commit aaafe88d5500ba18b33be72458439367ef878788 ]

The moxtet module fails to auto-load on. Add a SPI id table to
allow it to do so.

Signed-off-by: Sjoerd Simons <sjoerd@collabora.com>
Cc:  <stable@vger.kernel.org>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/moxtet.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/bus/moxtet.c b/drivers/bus/moxtet.c
index b20fdcbd035b..34377195bf87 100644
--- a/drivers/bus/moxtet.c
+++ b/drivers/bus/moxtet.c
@@ -832,6 +832,12 @@ static int moxtet_remove(struct spi_device *spi)
 	return 0;
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
@@ -843,6 +849,7 @@ static struct spi_driver moxtet_spi_driver = {
 		.name		= "moxtet",
 		.of_match_table = moxtet_dt_ids,
 	},
+	.id_table	= moxtet_spi_ids,
 	.probe		= moxtet_probe,
 	.remove		= moxtet_remove,
 };
-- 
2.43.0



