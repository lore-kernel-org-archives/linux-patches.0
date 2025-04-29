Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1FF2472AA;
	Tue, 29 Apr 2025 16:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945586; cv=none; b=gxadIN2Vp8P/9NnRc26dZMxThlGAA5Y9x/iF2sJke4fCfxEg6bnCZ/wUfweedlGOk0Ohhh94asedHRY2AYidFaRkDxlaZcC8HDsmeUTr/j2moxMQ8/CYT1HUZwKLPRmRtN1B0ZqJZ8AadoE8OyxQcuWStie03BlH4YBn/ZVH32k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945586; c=relaxed/simple;
	bh=V1XsIeo8Qr0zGcEbL5o6gbLyoYGvRVzy7V3bL105bMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfD9FXWUuVuZw7vF4ErVW2iuD+e1BDOFhlK2Sctpo29dk3x8l4Y/RTKTjHWVMM3QCxR2Q3gHyktRWvYkfXDEydrn60q/pCZNgCUzg1Cfjhc8utmBe9tsFggWMU+50QRJchY1/FTe2gvtGDeY+H7qs2WVu9c3AzaKY7vnq/t6ZZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0shz3pC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0shz3pC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12F6C4CEE3;
	Tue, 29 Apr 2025 16:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945586;
	bh=V1XsIeo8Qr0zGcEbL5o6gbLyoYGvRVzy7V3bL105bMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0shz3pClnYl3oUroc8kqreiGqJfG9GZknPe4cQrfPJGVgHq8UrpACuDjHcu0N46u
	 6/7OLH/eCBXd5harMAeVqjLOo3QQGxWEhMQdVFVvGEswxOewLh3FOLFPkBu/gmjkTk
	 qVoPZpDf1G/el9IjS9ROGUlTvV7kGWewvfqfqfTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 163/179] usb: host: max3421-hcd: Add missing spi_device_id table
Date: Tue, 29 Apr 2025 18:41:44 +0200
Message-ID: <20250429161055.974936134@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0a5e0e6449826..5a21777197e95 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1956,6 +1956,12 @@ max3421_remove(struct spi_device *spi)
 	return 0;
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
@@ -1965,6 +1971,7 @@ MODULE_DEVICE_TABLE(of, max3421_of_match_table);
 static struct spi_driver max3421_driver = {
 	.probe		= max3421_probe,
 	.remove		= max3421_remove,
+	.id_table	= max3421_spi_ids,
 	.driver		= {
 		.name	= "max3421-hcd",
 		.of_match_table = of_match_ptr(max3421_of_match_table),
-- 
2.39.5



