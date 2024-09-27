Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A6518C02E;
	Fri, 27 Sep 2024 12:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440292; cv=none; b=i2X5nMd+mZ5269uT3XjaHwaGNvVNryPDD83beUzAPe9GJacBTWF5vCRXKijaNAvZVOsyCGMp4aQs8ygEZCof05dA9BaimkxSJnEDV2AB0sYPSwvVQdz9U+ZB/iZDIgGdcEp9QQwZzIVuvzwMFA73GIQ/Ae2LSKM8gnnT8A2ZdP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440292; c=relaxed/simple;
	bh=Z8hGBMz4Mr1ywwbp8RtcrShLl8zEHFvXTGdlzA/5XcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZK3DEOaJpofbmoYSRbTKs3hiqkRo/lAuGU5Bs965X29q4u4V1hJVPE1GcjopfuJoGoHil1GOvIEhPJa7GLXXh+Rugy8QqaatF10OwhKz9NedS4B1ReHM822nYm5cH1QHJkCFpz0z8MaBnlFgxYomRUDOTdILhZSgS6+xJn95FuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOLwFwZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOLwFwZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F774C4CEC4;
	Fri, 27 Sep 2024 12:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440292;
	bh=Z8hGBMz4Mr1ywwbp8RtcrShLl8zEHFvXTGdlzA/5XcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOLwFwZb0pjahkgg2tX0UsWO5M0gPniTfQoh/doYH9vtyW7i5wleQ0e86LPoTnCnk
	 DZW5+lgKBer83DwiT3+Lq5zSQcz8wI3uevmtP4TbmjLr4H0g840Dv0JiHm2en9IOe5
	 42ZZ7JRqU3mgC01iV7j9+jHuqhkxtM5HOIOC8YZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 29/73] spi: spidev: Add missing spi_device_id for jg10309-01
Date: Fri, 27 Sep 2024 14:23:40 +0200
Message-ID: <20240927121721.068503862@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 5478a4f7b94414def7b56d2f18bc2ed9b0f3f1f2 ]

When the of_device_id entry for "elgin,jg10309-01" was added, the
corresponding spi_device_id was forgotten, causing a warning message
during boot-up:

    SPI driver spidev has no spi_device_id for elgin,jg10309-01

Fix module autoloading and shut up the warning by adding the missing
entry.

Fixes: 5f3eee1eef5d0edd ("spi: spidev: Add an entry for elgin,jg10309-01")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/54bbb9d8a8db7e52d13e266f2d4a9bcd8b42a98a.1725366625.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 7ae032f8de63c..81a3cf9253452 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -694,6 +694,7 @@ static struct class *spidev_class;
 static const struct spi_device_id spidev_spi_ids[] = {
 	{ .name = "bh2228fv" },
 	{ .name = "dh2228fv" },
+	{ .name = "jg10309-01" },
 	{ .name = "ltc2488" },
 	{ .name = "sx1301" },
 	{ .name = "bk4" },
-- 
2.43.0



