Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9811ED39
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9DFC433C7;
	Fri, 21 Jul 2023 19:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966335;
	bh=ANLGkdDpxDlbTviO8xZqnyAGWvPOF9lsmS7nMSxlCrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzdU4tTFQkFsi9xs0tMgXPQNcVoV3i/K3DYSFgrVEkzAXCSpS9WQi7aB6GYRm+Oeo
	 5eW5tP+4PnVnvVr//jdhnlFUpUXrS3S78ri9t7M1txzDxtR46qBwGG9H43qqpYdYXh
	 f6nBW1ny4RTdHeUhbgRxL5nBHGZMfS12qA07yUi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Thierry Reding <treding@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 307/532] phy: tegra: xusb: check return value of devm_kzalloc()
Date: Fri, 21 Jul 2023 18:03:31 +0200
Message-ID: <20230721160631.063346191@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 44faada0f38fc333d392af04c343b0e23f8f5d81 ]

devm_kzalloc() returns a pointer to dynamically allocated memory.
Pointer could be NULL in case allocation fails. Check pointer validity.
Identified with coccinelle (kmerr.cocci script).

Fixes: f67213cee2b3 ("phy: tegra: xusb: Add usb-role-switch support")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20230531073950.145339-1-claudiu.beznea@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/tegra/xusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/phy/tegra/xusb.c b/drivers/phy/tegra/xusb.c
index bdcf217bf3f88..119e2c039225f 100644
--- a/drivers/phy/tegra/xusb.c
+++ b/drivers/phy/tegra/xusb.c
@@ -669,6 +669,9 @@ static int tegra_xusb_setup_usb_role_switch(struct tegra_xusb_port *port)
 	port->dev.driver = devm_kzalloc(&port->dev,
 					sizeof(struct device_driver),
 					GFP_KERNEL);
+	if (!port->dev.driver)
+		return -ENOMEM;
+
 	port->dev.driver->owner	 = THIS_MODULE;
 
 	port->usb_role_sw = usb_role_switch_register(&port->dev,
-- 
2.39.2



