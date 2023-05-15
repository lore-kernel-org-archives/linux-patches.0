Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C48FDF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C49CC4339B;
	Mon, 15 May 2023 16:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168499;
	bh=lcQo//sOACpOP8JKGYVsifXaBziuDHQ098L2pTs2jPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awaWXTnmPsnUrNOzaCOMKQ+8kAPfo4vSEQo6GvPDUvLe9hEumIxIYRwZvdxaKBxHw
	 Kqw78aswXXHfu7zNEReOIPC5R93dnepwwtY+kY8wA8aaPqKhR9lkCKdcqpaa1aW3aP
	 geQChMc+JSzvPslrW4t5zEi6LQ2T8z/+B6wmAL/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Thierry Reding <treding@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 070/116] phy: tegra: xusb: Add missing tegra_xusb_port_unregister for usb2_port and ulpi_port
Date: Mon, 15 May 2023 18:26:07 +0200
Message-Id: <20230515161700.617268486@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit e024854048e733391b31fe5a398704b31b9af803 ]

The tegra_xusb_port_unregister should be called when usb2_port
and ulpi_port map fails in tegra_xusb_add_usb2_port() or in
tegra_xusb_add_ulpi_port(), fix it.

Fixes: 53d2a715c240 ("phy: Add Tegra XUSB pad controller support")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20221129111634.1547747-1-cuigaosheng1@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/tegra/xusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/tegra/xusb.c b/drivers/phy/tegra/xusb.c
index 9c55e0f45ea8a..d0483712637b9 100644
--- a/drivers/phy/tegra/xusb.c
+++ b/drivers/phy/tegra/xusb.c
@@ -596,6 +596,7 @@ static int tegra_xusb_add_usb2_port(struct tegra_xusb_padctl *padctl,
 	usb2->base.lane = usb2->base.ops->map(&usb2->base);
 	if (IS_ERR(usb2->base.lane)) {
 		err = PTR_ERR(usb2->base.lane);
+		tegra_xusb_port_unregister(&usb2->base);
 		goto out;
 	}
 
@@ -648,6 +649,7 @@ static int tegra_xusb_add_ulpi_port(struct tegra_xusb_padctl *padctl,
 	ulpi->base.lane = ulpi->base.ops->map(&ulpi->base);
 	if (IS_ERR(ulpi->base.lane)) {
 		err = PTR_ERR(ulpi->base.lane);
+		tegra_xusb_port_unregister(&ulpi->base);
 		goto out;
 	}
 
-- 
2.39.2



