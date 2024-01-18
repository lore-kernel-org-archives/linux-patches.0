Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4A222F09;
	Thu, 18 Jan 2024 10:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575018; cv=none; b=SNYED+YmZPtAESBGc4/k/jE5+F2xpW62QZg/p0gaIqu72iICIGngWTLS7PwaGoaXFdxAWPfDLQddLndl9P393ZtWUm+33QhmQyWM69hNtW5Qs2FY0/jgaLJac54kA/3qaR9iPfHTkLZmNZJDJtUXd9JmN67Su3bWVfKEMQSext0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575018; c=relaxed/simple;
	bh=ShYEC4kgVUuSRF7Svu18ab+UDaaezVEZug9qODp4BkY=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=cT9XIh2NU1jOvs99eemL/uGPj0/THaxhQiOl7nNpHV7afM/ZOYZDHW/0IvJcgeymE/O7hp+Rmnu/E/ItH6Dy0+vQ5wnoBoQsNuUT063zo7ICN5EqMzcpGYWkQy4ipZPhxJS2GFSLARgwoqDt4mEMaqtEoO1WuEqsy5XawNTFVd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Womgizwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Womgizwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8ABFC433F1;
	Thu, 18 Jan 2024 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575018;
	bh=ShYEC4kgVUuSRF7Svu18ab+UDaaezVEZug9qODp4BkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WomgizwvuNFKOaCiqNjluJ68st+DMn25KRoi7Cgl2OeDYI2DSIvXVLknnWHwzYidQ
	 g8JbaxjPSKA7iZC+QZaPoOoxj5KaqsbPI1osX/aOOeOw22TI02nxnJKONXErkvJvhB
	 nAzpmx+4tUQ1QrbP9JiQFZu0vJe8FbL6MTu/1F3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sjoerd Simons <sjoerd@collabora.com>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 6.7 11/28] bus: moxtet: Add spi device table
Date: Thu, 18 Jan 2024 11:49:01 +0100
Message-ID: <20240118104301.630377962@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


