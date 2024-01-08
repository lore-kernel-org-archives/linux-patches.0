Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F91C4B5AB;
	Mon,  8 Jan 2024 15:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqGxJqeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9496C433CB;
	Mon,  8 Jan 2024 15:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726923;
	bh=NVr7WTis0jStWBtfMhYY1/DdF8Bm+X8OHNjun09GMvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqGxJqeIF3OorkVKyn/f0jY+qG4vb9TVpsduvLCoXDJwboTAy5LPlGPqyPptLHaYI
	 sj8rL5DzDRP9iK1c6Oa/Cm4ZcGTbUcWAhmcAhRO1MVe9+vJhC38mLi2kqiJT3kXAV0
	 2xI0Bmih9eY31Flki6M5aaIqMGLKUd0LnzQUDktM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/124] phy: sunplus: return negative error code in sp_usb_phy_probe
Date: Mon,  8 Jan 2024 16:08:38 +0100
Message-ID: <20240108150607.210303643@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 2a9c713825b3127ece11984abf973672c9779518 ]

devm_phy_create() return negative error code, 'ret' should be
'PTR_ERR(phy)' rather than '-PTR_ERR(phy)'.

Fixes: 99d9ccd97385 ("phy: usb: Add USB2.0 phy driver for Sunplus SP7021")
Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20231120091046.163781-1-suhui@nfschina.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/sunplus/phy-sunplus-usb2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/sunplus/phy-sunplus-usb2.c b/drivers/phy/sunplus/phy-sunplus-usb2.c
index 0efe74ac9c6af..637a5fbae6d9a 100644
--- a/drivers/phy/sunplus/phy-sunplus-usb2.c
+++ b/drivers/phy/sunplus/phy-sunplus-usb2.c
@@ -275,7 +275,7 @@ static int sp_usb_phy_probe(struct platform_device *pdev)
 
 	phy = devm_phy_create(&pdev->dev, NULL, &sp_uphy_ops);
 	if (IS_ERR(phy)) {
-		ret = -PTR_ERR(phy);
+		ret = PTR_ERR(phy);
 		return ret;
 	}
 
-- 
2.43.0



