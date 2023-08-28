Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD30111C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500C8C433C7;
	Mon, 28 Aug 2023 10:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219675;
	bh=4KiIUM5PPj/q4jYLxIoGta5tvLYskZm82enTk/tFfcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0T5o7ThSnwggngQscHo8k0s+O/DyOZfKedyKwTYQbfFCb66DBKh4EHvUEIkFKKK4W
	 ngnbZOAizeBj+Pm3S3Wr1Qy2EFt2JurpufHfx2qisDaSLHRZBCGMWqPREXTdzpnKAr
	 IwF98BEWGXg0LzYH4wVIKmE6f8xO1pNG71MclpjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruan Jinjie <ruanjinjie@huawei.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/84] net: bgmac: Fix return value check for fixed_phy_register()
Date: Mon, 28 Aug 2023 12:13:48 +0200
Message-ID: <20230828101150.314754580@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruan Jinjie <ruanjinjie@huawei.com>

[ Upstream commit 23a14488ea5882dea5851b65c9fce2127ee8fcad ]

The fixed_phy_register() function returns error pointers and never
returns NULL. Update the checks accordingly.

Fixes: c25b23b8a387 ("bgmac: register fixed PHY for ARM BCM470X / BCM5301X chipsets")
Signed-off-by: Ruan Jinjie <ruanjinjie@huawei.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bgmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index ab8ee93316354..a4f6143e66fe9 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1448,7 +1448,7 @@ int bgmac_phy_connect_direct(struct bgmac *bgmac)
 	int err;
 
 	phy_dev = fixed_phy_register(PHY_POLL, &fphy_status, NULL);
-	if (!phy_dev || IS_ERR(phy_dev)) {
+	if (IS_ERR(phy_dev)) {
 		dev_err(bgmac->dev, "Failed to register fixed PHY device\n");
 		return -ENODEV;
 	}
-- 
2.40.1



