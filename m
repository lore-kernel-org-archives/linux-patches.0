Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025397;
	b=UQYmzuSBJI0Av3Ibz3us1+pnTfBNLSw54K+CQ1KW/XHjpxP9hv5wf4RjgQb4Iaz0089I
	 vMSpX4B5MseV+y1zrdhtMvZwYZAfKXpdA6n9kDMNrJEBhNBDax2h4UkteD1MLsWgN+MB3
	 Nyv+Lfhjx/oc9swGOLibcZ2ELjcg9rX972p2+GcV9a1IIQWOTuL3CXWvu7MI0mDypk9KP
	 hYSqYPNMdN+gGo6ggSvEy77DbTjdzVOThrQLsGgemZMKxLgGxpXJm5KwnK5A5AKgozI3O
	 pXZMcr0JCEdDGeBArrN6KUWJeLOJqGRDgUVQSLeMaAyrJNiVob2sF7KDjHwHlDxwA6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o4h0LD4MRuwFBwB/Rc9LkG4cLqYtCeBosA3OQZcROiY=;
	b=d291/90FEWx5MJLTFHSqkXVcpPitzMj8KXJ/LVGLH0pA90eaE+DtHPn0VRgH3L7IKAl6
	 hjiqeFrzvQk+vWjMyp5FFw3pMjIevvhoesM1JFxnWMWzIrgL6VBuNtWbBV4hZxTNvhXtX
	 6mkkpRdnBYlm/OAqqfLQSP0C/uY7C4GIn3DLrLUgbdt1rVi4QgnGroD/ItTib0hbX/rZz
	 W/LHz+F29bn6F2ozNexgG7tFjfPoAiE8CDVk56QiGMSIZw+UruRtFW00oT7Ir6RXf8sfL
	 AQRhCVry7y7TF3faGOLQd4UkT8NGbevwghkCqxUvoRK92ym4WMRojeoS+aNg/VAPqvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iXaTfzqY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB863606A31C;
	Wed, 18 Nov 2026 18:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iXaTfzqY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C881E1F000C5;
	Wed, 18 Nov 2026 18:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025397;
	bh=o4h0LD4MRuwFBwB/Rc9LkG4cLqYtCeBosA3OQZcROiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iXaTfzqYGBuW+3uPN97W3VZxwK/OILGDpV6V8eFQ+aj1Y9+a/+13GSO5PA62vu2Kt
	 tJgW2su0zfMVL/GFVb2AjN09dNGMCEnxLX5qTLDIFT1XGTFTYTA704TPzYnqxe2GgP
	 EAIMqmx9n4OCAT400b6kRR4DpQSYrKx1cowuYEuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Yang <jason98166@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1024/2151] phy: rockchip-samsung-dcphy: Enable runtime PM at PHY core level
Date: Wed, 18 Nov 2026 15:45:59 +0100
Message-ID: <20261118150159.698634044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Yang <jason98166@gmail.com>

[ Upstream commit 261e84f9278f4373970471ad71479df20d82ed4c ]

phy_create() only enables runtime PM on the new PHY device if the parent
already has it enabled, and this driver enables it afterwards. The PHY
device therefore never gets runtime PM, and phy_pm_runtime_get_sync()
returns -ENOTSUPP for every phy_init() and phy_power_on(). The block is
still resumed today, but only through the supplier link fw_devlink builds
from the phys phandle, which fw_devlink=off and =permissive do not.

Move devm_pm_runtime_enable() before devm_phy_create(), as done for the
sibling HDPTX PHY in commit 10ba8479f460 ("phy:
phy-rockchip-samsung-hdptx: Enable runtime PM at PHY core level").

Fixes: b2a1a2ae7818 ("phy: rockchip: Add Samsung MIPI D-/C-PHY driver")
Signed-off-by: Jason Yang <jason98166@gmail.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://patch.msgid.link/20260821-dcphy-rpm-v1-v1-1-a7db728b2539@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-samsung-dcphy.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-samsung-dcphy.c b/drivers/phy/rockchip/phy-rockchip-samsung-dcphy.c
index d4e49db6feeda..d9a542044aca3 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-dcphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-dcphy.c
@@ -1609,16 +1609,16 @@ static int samsung_mipi_dcphy_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(samsung->grf_apb_rst),
 				     "Failed to get system grf_apb_rst control\n");
 
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to enable runtime PM\n");
+
 	samsung->phy = devm_phy_create(dev, NULL, &samsung_mipi_dcphy_ops);
 	if (IS_ERR(samsung->phy))
 		return dev_err_probe(dev, PTR_ERR(samsung->phy), "Failed to create MIPI DC-PHY\n");
 
 	phy_set_drvdata(samsung->phy, samsung);
 
-	ret = devm_pm_runtime_enable(dev);
-	if (ret)
-		return dev_err_probe(dev, ret, "Failed to enable runtime PM\n");
-
 	phy_provider = devm_of_phy_provider_register(dev, samsung_mipi_dcphy_xlate);
 	if (IS_ERR(phy_provider))
 		return dev_err_probe(dev, PTR_ERR(phy_provider),
-- 
2.53.0



