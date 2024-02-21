Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F390779DBF;
	Wed, 21 Feb 2024 14:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525741; cv=none; b=is9xXjyEzJYbWHbO/1aKl0/IaLGsbYWdSjUuMtpZiug9i/7aN74G6EamYCSNdZYb+ZuDv54aobN1Y03IsXB2gEUVoQe2lGVR87RiB+Uta8CGBbSQ7PGWjNz/Ql0BuJhIAfLdYBfT42V1UtIByVap31jsV9rcwcp/HxFrE9eTjHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525741; c=relaxed/simple;
	bh=enNbqupyQ6cSiFGLpHmXSbk0fCELRbtOEXRk37oxuus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gGL9+Jn+/gyDAOlbjzj6ba0M9WmJcYGCzicQsOxdCfHCpXcD1FFbZOQHjWt068K01PSJZNoul4qxAv/YvxOsx51WcsCwdzpPkrLTDJooMe8cXKtEEf7q/p1mA3PnYCOs3xLGjvo27EGJvKxIfyDiCed4dp55nfZosz+oul/JtMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCuqiv6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCuqiv6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61611C433C7;
	Wed, 21 Feb 2024 14:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525740;
	bh=enNbqupyQ6cSiFGLpHmXSbk0fCELRbtOEXRk37oxuus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCuqiv6ju/7Pjs5Q9b9QzheAEb5/0xPrwDs0kdQA/CQTkQbqWQkUtmQxHt0E81g2S
	 Md/DUlP1GpId3xTbT0uTik/KdifJq8eENYqvjDAnNIHixCtX5zPhFgDSxpIBaeKeVa
	 jS/bW9M6aXCcYabBeDSkBN/sGD12qmvBDQcFHJZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sjoerd Simons <sjoerd@collabora.com>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 249/267] bus: moxtet: Add spi device table
Date: Wed, 21 Feb 2024 14:09:50 +0100
Message-ID: <20240221125948.067204336@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 68413bf9cf87..d87f698d38a3 100644
--- a/drivers/bus/moxtet.c
+++ b/drivers/bus/moxtet.c
@@ -833,6 +833,12 @@ static int moxtet_remove(struct spi_device *spi)
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
@@ -844,6 +850,7 @@ static struct spi_driver moxtet_spi_driver = {
 		.name		= "moxtet",
 		.of_match_table = moxtet_dt_ids,
 	},
+	.id_table	= moxtet_spi_ids,
 	.probe		= moxtet_probe,
 	.remove		= moxtet_remove,
 };
-- 
2.43.0



