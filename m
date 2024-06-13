Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4478CDDB1;
	Thu, 13 Jun 2024 11:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278660; cv=none; b=tVE5FkD+K46PhFSfvPVVJrp75DHq1IsLV0i+lMuT6znBgUaXlevs5JMVw0lNlWHvjnKWoi1jH5wCpGBpd7PAGkagKgHavTFeLCXjBTLmZ2oJVXBH+s2iEAXoM+7D92dUHjL4W4yVvnGNWILg7Dv93aw8xT1neKe+1unevr7rHUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278660; c=relaxed/simple;
	bh=GRoualKNiCZ9xYmYcP4NLSV1PSXxZ4qLl73UUmK8HKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JltuulaHBcBalm+FpponEaR/F2uFL6KMQ6R+B/SSiSTTw7rHnLlvNaUj6yxST54ScWD0C6BRhrwxwVt9fTuRDd0i3ZSB7MsC9IunxKLg/64lmtuUIDIwblfgm3xU5G7toCPqZyGzMtSPzun2Q5zQLRGXkvVeEGntm8+q4vpa2dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yxwp2wl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yxwp2wl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B02C2BBFC;
	Thu, 13 Jun 2024 11:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278660;
	bh=GRoualKNiCZ9xYmYcP4NLSV1PSXxZ4qLl73UUmK8HKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yxwp2wl9laCJaGMduOztVNbZgBLkKmCbxJSN7hs4TJDxb+sbpqxqFmY2IdLMd3Vk+
	 DwVt6nV6wjLtySVwoQnUgUjEPGZ2SN58S/RszQ+iF7dEBXFIl7+Hc1sXEEzy39EW0C
	 BiaN6jESMVg/pTU4UGt8a5O/epeXYkHL0w2k50Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 027/213] HSI: omap_ssi_port: Convert to platform remove callback returning void
Date: Thu, 13 Jun 2024 13:31:15 +0200
Message-ID: <20240613113229.044400869@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit c076486b6a28aa584b3e86312442bac09279a015 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/11e06f4cce041436bd63fb24361f3cee06bd2d59.1712756364.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/controllers/omap_ssi_port.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hsi/controllers/omap_ssi_port.c b/drivers/hsi/controllers/omap_ssi_port.c
index e6149fd43b628..2de7e54ddcca0 100644
--- a/drivers/hsi/controllers/omap_ssi_port.c
+++ b/drivers/hsi/controllers/omap_ssi_port.c
@@ -1259,7 +1259,7 @@ static int ssi_port_probe(struct platform_device *pd)
 	return err;
 }
 
-static int ssi_port_remove(struct platform_device *pd)
+static void ssi_port_remove(struct platform_device *pd)
 {
 	struct hsi_port *port = platform_get_drvdata(pd);
 	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
@@ -1286,8 +1286,6 @@ static int ssi_port_remove(struct platform_device *pd)
 
 	pm_runtime_dont_use_autosuspend(&pd->dev);
 	pm_runtime_disable(&pd->dev);
-
-	return 0;
 }
 
 static int ssi_restore_divisor(struct omap_ssi_port *omap_port)
@@ -1422,7 +1420,7 @@ MODULE_DEVICE_TABLE(of, omap_ssi_port_of_match);
 
 struct platform_driver ssi_port_pdriver = {
 	.probe = ssi_port_probe,
-	.remove	= ssi_port_remove,
+	.remove_new = ssi_port_remove,
 	.driver	= {
 		.name	= "omap_ssi_port",
 		.of_match_table = omap_ssi_port_of_match,
-- 
2.43.0



