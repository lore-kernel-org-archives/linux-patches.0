Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F70194094;
	Mon, 30 Dec 2024 15:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573657; cv=none; b=T6sbxo2W+dSA3LXvEhmhrLhPEQ0goTZRDbDMhaB7Bz1SfdsI7KnJFMxidYNyta6XGunwIgxMPfZ8TL8nLElxOSsb7yp/rsN8q3zdXXsXjHQrOoxFGCsS4A5r0DlFGgAsfngtLGPPqG0sEBmlapOFq9FqYZGqq4Kzlju8DNjIna8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573657; c=relaxed/simple;
	bh=Zznwo5dsxpvUJ5/UiYpRu2bLbSBY8NjqW7uJ594OSS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HP3SZhCj9wGGwAnCWQlK8/qkKBP9DOdq1vdLOXxL9+HrngBo+wCaWFkRUrOPIXeL9sErT8iP2JjrCIpvw/hMiBdITX6gKwX+z/LG+VJljH6Q6rfZlihWUOibJL5OWGV2GIqBC0NPRocA7otXR67OZOm3Fjv8aKWfbdG8ktU2fJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVesO5ZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVesO5ZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E80BC4CED0;
	Mon, 30 Dec 2024 15:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573657;
	bh=Zznwo5dsxpvUJ5/UiYpRu2bLbSBY8NjqW7uJ594OSS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVesO5ZMvOZJMoI87QdUjoqqU+XhYB7GQtU7XkFTbDRoGIIyAu+Kx6vtrl7qFP9JD
	 1tk4uZPrFclRT4EhAmPBQ/fCj9qvFT1us/Xb0lcAH0Zde/y/QAzannNTabMxLnwCfP
	 biydDDFOtseY9QPiFCu6Vb8AkiVkH+mx8gzkuQsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Michael Zimmermann <sigmaepsilon92@gmail.com>,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 17/60] phy: rockchip: naneng-combphy: fix phy reset
Date: Mon, 30 Dec 2024 16:42:27 +0100
Message-ID: <20241230154207.942622137@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

From: Chukun Pan <amadeus@jmu.edu.cn>

commit fbcbffbac994aca1264e3c14da96ac9bfd90466e upstream.

Currently, the USB port via combophy on the RK3528/RK3588 SoC is broken.

  usb usb8-port1: Cannot enable. Maybe the USB cable is bad?

This is due to the combphy of RK3528/RK3588 SoC has multiple resets, but
only "phy resets" need assert and deassert, "apb resets" don't need.
So change the driver to only match the phy resets, which is also what
the vendor kernel does.

Fixes: 7160820d742a ("phy: rockchip: add naneng combo phy for RK3568")
Cc: FUKAUMI Naoki <naoki@radxa.com>
Cc: Michael Zimmermann <sigmaepsilon92@gmail.com>
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://lore.kernel.org/r/20241122073006.99309-2-amadeus@jmu.edu.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/rockchip/phy-rockchip-naneng-combphy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
@@ -299,7 +299,7 @@ static int rockchip_combphy_parse_dt(str
 
 	priv->ext_refclk = device_property_present(dev, "rockchip,ext-refclk");
 
-	priv->phy_rst = devm_reset_control_array_get_exclusive(dev);
+	priv->phy_rst = devm_reset_control_get(dev, "phy");
 	if (IS_ERR(priv->phy_rst))
 		return dev_err_probe(dev, PTR_ERR(priv->phy_rst), "failed to get phy reset\n");
 


