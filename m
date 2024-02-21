Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CAE78B7C;
	Wed, 21 Feb 2024 13:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523416; cv=none; b=e7JVdSUwrsPPscvmK7woukeSVuHr00ZYfCTQtI5Ptwhcr5GpDkoi/H9Pg9yDEghriOOm6h96MnER06lRUceQ68i+b9PPFY+gmQGE/3QR1ftYJkxp5InBkAVIDc/lwuz8p1uBgSYTL2lzvjvdy3VhJgYiwTTSh1BkpEY5DkrQZT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523416; c=relaxed/simple;
	bh=Psdqdni1z+6LpQUzWYUCD4w2yUrclVLIeat9vazyWKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VUeoPOQtQzVTfzAJCQRIH/+l7pTyBHske/MWbmNOvaBwvspZHUmd/UJW579TiYSqvVACpUfY5xqeciRbAVYPnINLik6sAAC2pNUs0tmd8Hy7yyJfJFGxLKxDZlZZMkZVJYoUHNeGlvrDmo2qTWreAvP6aOJppleyJ5A7/B9c0UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bo94B5GE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bo94B5GE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E789BC43390;
	Wed, 21 Feb 2024 13:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523416;
	bh=Psdqdni1z+6LpQUzWYUCD4w2yUrclVLIeat9vazyWKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bo94B5GE4AsAEPQ2c99sQXyu7t20BWmGy3hKHuyt5FaYHh7D92D3vkI/IJSvbztxp
	 G4B+F5sHTV2lVQQJ1D+me8K7Z0D+vLUOUqxWy/Tgad5TS0yrE8+PsfYnDlCu2j6/w3
	 2WeYiiwR3nZZvQUHKyZptzFYFTIHqBL2T2v1j/kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sjoerd Simons <sjoerd@collabora.com>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 430/476] bus: moxtet: Add spi device table
Date: Wed, 21 Feb 2024 14:08:01 +0100
Message-ID: <20240221130023.922634417@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fd87a59837fa..fbf0818933be 100644
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



