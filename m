Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACED215E8B;
	Mon, 30 Dec 2024 15:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574164; cv=none; b=cNWJVOcoHSWEoHe+HVgrAJ0sHBRuNA3bnV9kQQNjW3XWPVj8056Nu93FCdtfxSEC52a+977j6O5Jx3ZuO/19eB/htu1VK5Lfb6CCu++V8Ib4gz3TlXtb1gnh1pWSkNR09wRwrFyDUnbCRLhwJAG8qrGRjg7ehla4QuH82Ky8WPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574164; c=relaxed/simple;
	bh=RrGOu+t+Kiih6f+Rj0LnP8XU88JiDLs7tmkyUBmsD1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7wDX7cE6uSmi9An4HPlYADNId5ARoJOErLDyDYPQ988yl75hA4DPPgPuk11uY6jJ90t5+ovPaHwaYavUDgfWOPIi2YpzN4v0PS1dmJKsTiEkRAoGi2zRGyxO7CwN4jiKlQE92u0a5fVzKjGzBms5VomHKasvTL8B+UdEJIdLio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6SXk557; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6SXk557"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B4AC4CED0;
	Mon, 30 Dec 2024 15:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574164;
	bh=RrGOu+t+Kiih6f+Rj0LnP8XU88JiDLs7tmkyUBmsD1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6SXk557j8YbTzY6wH5cPoB3tAb+i+G9OwlXaFIAj5z6Y5WQhZKiZt+0M5tnFRB+n
	 5f0dh7b2hESw33cTjQxN/GLwxAYTs7onS9sD9UbNU11kHq3xjxua8SdKB2FULH4uE2
	 4xhfaLFRRwm1E3PshGmiUmF18qhzAvQg2n0aD1fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 025/114] phy: rockchip: samsung-hdptx: Set drvdata before enabling runtime PM
Date: Mon, 30 Dec 2024 16:42:22 +0100
Message-ID: <20241230154219.030500309@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

commit 9d23e48654620fdccfcc74cc2cef04eaf7353d07 upstream.

In some cases, rk_hdptx_phy_runtime_resume() may be invoked before
platform_set_drvdata() is executed in ->probe(), leading to a NULL
pointer dereference when using the return of dev_get_drvdata().

Ensure platform_set_drvdata() is called before devm_pm_runtime_enable().

Reported-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Fixes: 553be2830c5f ("phy: rockchip: Add Samsung HDMI/eDP Combo PHY driver")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241023-phy-sam-hdptx-rpm-fix-v1-1-87f4c994e346@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
@@ -1116,6 +1116,8 @@ static int rk_hdptx_phy_probe(struct pla
 		return dev_err_probe(dev, PTR_ERR(hdptx->grf),
 				     "Could not get GRF syscon\n");
 
+	platform_set_drvdata(pdev, hdptx);
+
 	ret = devm_pm_runtime_enable(dev);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to enable runtime PM\n");
@@ -1125,7 +1127,6 @@ static int rk_hdptx_phy_probe(struct pla
 		return dev_err_probe(dev, PTR_ERR(hdptx->phy),
 				     "Failed to create HDMI PHY\n");
 
-	platform_set_drvdata(pdev, hdptx);
 	phy_set_drvdata(hdptx->phy, hdptx);
 	phy_set_bus_width(hdptx->phy, 8);
 


