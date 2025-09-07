Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8245C1A0BFD;
	Sun,  7 Sep 2025 20:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277220; cv=none; b=G9fyUIvUt+z6A/OWQVuNXQWTTbpeamnKP3uVScg3uADxmehx9D1teOC8OR4H8yaUZapt0GeXqFYwOmz5Uc4yuGSEsqIsUgoT/dwBadh61zamprPpTikEX1K9JC6SBVBjfvPN1FAXcW7TqwyjbegON5zurq9Zc47Sd5/1pPlirGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277220; c=relaxed/simple;
	bh=gJxVOj3zgu9y0zSJJwO+3vrwHZDHWNDTLxqPf3XcfCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFmCvOQd2iIEXjWAV4BXaQUqCcxJ4OMPD6ySCtal0RDEMHpQuzLIO2CWociADkCM88bYorpXKBlDlM4lLzdQMf2qLhoQLXDb/6yxx3NCPhEkqx7Wnd2rlwLhlC6pkCSpCeFnxbU2gGYrCBdI15m/WCme+1AKsbGiPrcp8r4Wah8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUsVoL/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUsVoL/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B1FC4CEF0;
	Sun,  7 Sep 2025 20:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277220;
	bh=gJxVOj3zgu9y0zSJJwO+3vrwHZDHWNDTLxqPf3XcfCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GUsVoL/XB6E7tkFe32FFt0FcukZkp9sXp+7AbX4Q9kKhdmKslIUih1RfwBupsYErg
	 EdAGcCsx49MvV9Bt7M8gcYVsM26ue/gdCt5wcIdfo2CDWC/W4j+TsCSFpERwa+udbi
	 aBBNYzylbb617WmFLB0X7TWvnTAU3BYNRse8nRjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	stable@kernel.org,
	Andrew Lunn <andrew@lunn.ch>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 121/175] microchip: lan865x: Fix module autoloading
Date: Sun,  7 Sep 2025 21:58:36 +0200
Message-ID: <20250907195617.722079371@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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
 drivers/net/ethernet/microchip/lan865x/lan865x.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan865x/lan865x.c b/drivers/net/ethernet/microchip/lan865x/lan865x.c
index 84c41f193561..9d94c8fb8b91 100644
--- a/drivers/net/ethernet/microchip/lan865x/lan865x.c
+++ b/drivers/net/ethernet/microchip/lan865x/lan865x.c
@@ -423,10 +423,11 @@ static void lan865x_remove(struct spi_device *spi)
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
@@ -441,7 +442,7 @@ static struct spi_driver lan865x_driver = {
 	 },
 	.probe = lan865x_probe,
 	.remove = lan865x_remove,
-	.id_table = spidev_spi_ids,
+	.id_table = lan865x_ids,
 };
 module_spi_driver(lan865x_driver);
 
-- 
2.51.0



