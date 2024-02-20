Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E95714AD12;
	Tue, 20 Feb 2024 21:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463226; cv=none; b=FP5c15fETuQWc2tAwXk5I7y67BjTbhykePjWaZPaYnpgPkxHiPpJ+F8RFYTaPzn+C6dwvDLi+cvd3JNyR0XZbTV2MIuKHAlvDUBv47RTbyatPIMpnoXc2NtLdb4T4LELQzif1V7FXhVrXwUWH1GbTMU7MQL0IFBxuYA9L/y/q4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463226; c=relaxed/simple;
	bh=udQFmW+yil6KQjllneiyuc9S1DO5V6ks07oEls8WepU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZUNBiYI6BZhsZNhSc0d7FfDkIwpbqth3EQlxrpAj/wFjSdvWQDlEuT3G9ocKCpn9Kq9lRGyQQvaf/bZZy7JeUVI7G98j80IXj+tMWrv2r+mRQDh4uugV0+PEoSCJiFrz6ZSqFKUMMdJq/nM2T9aUwk6f8CH88yPXFIJfUdlDMPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjVqXBJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjVqXBJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B66C433C7;
	Tue, 20 Feb 2024 21:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463226;
	bh=udQFmW+yil6KQjllneiyuc9S1DO5V6ks07oEls8WepU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjVqXBJJ3SdAjx19fjma9gX0ebgbMxDhuXrrPurn4MfAXCqse1wnJu6rdQJwhS5wE
	 eobJRm9mQkgpm43HRlurS7StjgCpSTbe9RPnbXy14mtRpqBpQUxLr7hlNpyabvKRlc
	 E9PKAZXea9aYxi/j1iXBwK7AQnTATC/wZm0M+B3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sjoerd Simons <sjoerd@collabora.com>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 176/197] bus: moxtet: Add spi device table
Date: Tue, 20 Feb 2024 21:52:15 +0100
Message-ID: <20240220204846.336838887@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5eb0fe73ddc4..79fc96c8d836 100644
--- a/drivers/bus/moxtet.c
+++ b/drivers/bus/moxtet.c
@@ -830,6 +830,12 @@ static void moxtet_remove(struct spi_device *spi)
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
@@ -841,6 +847,7 @@ static struct spi_driver moxtet_spi_driver = {
 		.name		= "moxtet",
 		.of_match_table = moxtet_dt_ids,
 	},
+	.id_table	= moxtet_spi_ids,
 	.probe		= moxtet_probe,
 	.remove		= moxtet_remove,
 };
-- 
2.43.0



