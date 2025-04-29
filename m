Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3E121ABC6;
	Tue, 29 Apr 2025 18:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949938; cv=none; b=eIEcp+nWuxHgIkkpUDgBAKbvO1/zsR0f3PxNryYOMO21eiOSf7NwcB70sd0YHUpwqnMUdcdHBazZeb5E16Okgi/xaoMdYMrjIqaqNWGohpAuTeKAIqyUeMW6QQKkgrhe85ASo2MdVH8s+RnHTTisNSCYvTqO8T0ELtPNVsxt6XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949938; c=relaxed/simple;
	bh=O+bA6K/fspM+49XFcBCTVDjw+uKjNfhpw5320+5NNQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPC0ViQSjvIXpEsOdwrH3oM9MgxxY838f2WwRUbIkdL9+DuExRauQo00MWV4uIyGGDAuXM/al3WB5GBbtVoC+C2Zuo9XGGoGj/r0TsdoAhITEZ9icfL3ALC1HxQwpNSu5AQzQP5MrrGCTznwleIAxu5b9TRG5vtMkfubfyZ59x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxrX7SKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxrX7SKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F284C4CEE3;
	Tue, 29 Apr 2025 18:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949938;
	bh=O+bA6K/fspM+49XFcBCTVDjw+uKjNfhpw5320+5NNQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxrX7SKFmBpBTUf0lqerHnxijLWtyPPtOEhCJI6MudmKQGfbWffh0FvwdiPkveBkW
	 8qQgcdlapon3Ub7gc5cfDpQwS7jMYZXWVAwro0p4S0Te2o2gicXNzqgUQ2O3hN3JFu
	 ma+UENLH/zKTXYxBGlPtHXVnF6mJIi/xA4+1BqCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/167] usb: host: max3421-hcd: Add missing spi_device_id table
Date: Tue, 29 Apr 2025 18:43:33 +0200
Message-ID: <20250429161055.995553059@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ab12d76b01fbe..8aaafba058aa9 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1955,6 +1955,12 @@ max3421_remove(struct spi_device *spi)
 	usb_put_hcd(hcd);
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
@@ -1964,6 +1970,7 @@ MODULE_DEVICE_TABLE(of, max3421_of_match_table);
 static struct spi_driver max3421_driver = {
 	.probe		= max3421_probe,
 	.remove		= max3421_remove,
+	.id_table	= max3421_spi_ids,
 	.driver		= {
 		.name	= "max3421-hcd",
 		.of_match_table = of_match_ptr(max3421_of_match_table),
-- 
2.39.5



