Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED5F1F63CD;
	Sun,  7 Sep 2025 20:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277842; cv=none; b=sP6iZIqyIS4Qcw2NNrslZOYpu5CYs2Fd8J/OUwrTb+5k5TcHjOiKZh1WAvlkSgO6iq8gCmaOWFgHop8Uw0SfJctapOhDKhPocPOsH738D+C8CWLcfz/6uinZdijDrJoxmrIq5HobpZKgzy1WUNN7aJevxmoJxWHsapLpV7YsfwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277842; c=relaxed/simple;
	bh=kCIIGWRapwEXbyE3iIsdkY9JcthL5ynmZFHClmheo3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ludxJvjr67mh/mk2CxyO2r6QGHrbl9o/UqaQYkZaNTvmE+VQ8yvOXc+6N6i22Er0OwZoDdUGMxFtilX8MQPlIL+hb0Cvz0Bc/BjJaAUVU/Fy3ktMvRsGydJrP8v+CjMdA+Krhrwtu+fbU/6RVSE4HPxZ2LpI9TLAD98ZTVN2jSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ris66YOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ris66YOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B410AC4CEF0;
	Sun,  7 Sep 2025 20:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277842;
	bh=kCIIGWRapwEXbyE3iIsdkY9JcthL5ynmZFHClmheo3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ris66YOsbeHeGzqIiXQdavM1Nv7+rn9KzTdzRDnuWNw2hpN/TeQ2YumM8hXQXg2uQ
	 TWx/b24BeWHc++sp7fyHVuzum3ib4TKoie6kMLYOxrvBCYt67RSJ35XcGlonVA56Zv
	 YDevlijBFS4BWSBr5aZTkto/3XKuLWssFatwnmj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	stable@kernel.org,
	Andrew Lunn <andrew@lunn.ch>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 140/183] microchip: lan865x: Fix module autoloading
Date: Sun,  7 Sep 2025 21:59:27 +0200
Message-ID: <20250907195619.121723478@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

commit c7217963eb779be0a7627dd2121152fa6786ecf7 upstream.

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from spi_device_id table. While at this, fix
the misleading variable name (spidev is unrelated to this driver).

Fixes: 5cd2340cb6a3 ("microchip: lan865x: add driver support for Microchip's LAN865X MAC-PHY")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Cc: stable@kernel.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250827115341.34608-3-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan865x/lan865x.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/microchip/lan865x/lan865x.c
+++ b/drivers/net/ethernet/microchip/lan865x/lan865x.c
@@ -423,10 +423,11 @@ static void lan865x_remove(struct spi_de
 	free_netdev(priv->netdev);
 }
 
-static const struct spi_device_id spidev_spi_ids[] = {
+static const struct spi_device_id lan865x_ids[] = {
 	{ .name = "lan8650" },
 	{},
 };
+MODULE_DEVICE_TABLE(spi, lan865x_ids);
 
 static const struct of_device_id lan865x_dt_ids[] = {
 	{ .compatible = "microchip,lan8650" },
@@ -441,7 +442,7 @@ static struct spi_driver lan865x_driver
 	 },
 	.probe = lan865x_probe,
 	.remove = lan865x_remove,
-	.id_table = spidev_spi_ids,
+	.id_table = lan865x_ids,
 };
 module_spi_driver(lan865x_driver);
 


