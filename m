Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D246214813;
	Wed,  7 May 2025 19:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645141; cv=none; b=KqzGLBvxRV6x7d4E9BDMH7uxpv+1wOKEWgg9rSTocUrPPzttF6c4rWip+RsxrlQqXSoR0SdeYM7AvdQ0Bo82PTX0S56n9GZUlGsDnxb8iuKZI8C24WOgEb15G0OpoAyr68pIncFwVVKKrHs+nmi+PxOObM3cXLPrbgjt8omrI5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645141; c=relaxed/simple;
	bh=2rYB33sdWH+HRIvVdqOayW4rpGU6aZp7tArRJVppr7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kXiLyH8WnNrI/yvzULh/E4Uhe5xKVeBHcoIozwvi7DnXvnjupqqM9aC8T63Cl9FqN1p3xYXDviDKgB/a0QbGPswGJW6vmA450L+LwQfQOr3JVTwd9JfnynjGjznGdaPB4s6N7L8nk9Qtbinq5a/396oY+NBUD06a+rqqrU2xelY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlHas3OA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlHas3OA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10428C4CEE2;
	Wed,  7 May 2025 19:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645140;
	bh=2rYB33sdWH+HRIvVdqOayW4rpGU6aZp7tArRJVppr7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlHas3OAdZkY08JeN8lD3XWYsaht1F8xk6PAgw7fgTCf1XSMQr8hxbJHzMgnxuWYl
	 TDFprDlKbz3orBNB49GMPUN8MmZ7xsP1kMQJxP3vlsCC0XxRF5w/FNreU4yKf5rt8j
	 5vsgP6tXaHiH4Jh3iQVhBZglLo+qOZLX5VTXQJD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?S=C3=A9bastien=20Szymanski?= <sebastien.szymanski@armadeus.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/129] ARM: dts: opos6ul: add ksz8081 phy properties
Date: Wed,  7 May 2025 20:40:42 +0200
Message-ID: <20250507183817.790431968@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sébastien Szymanski <sebastien.szymanski@armadeus.com>

[ Upstream commit 6e1a7bc8382b0d4208258f7d2a4474fae788dd90 ]

Commit c7e73b5051d6 ("ARM: imx: mach-imx6ul: remove 14x14 EVK specific
PHY fixup") removed a PHY fixup that setted the clock mode and the LED
mode.
Make the Ethernet interface work again by doing as advised in the
commit's log, set clock mode and the LED mode in the device tree.

Fixes: c7e73b5051d6 ("ARM: imx: mach-imx6ul: remove 14x14 EVK specific PHY fixup")
Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx6ul-imx6ull-opos6ul.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/nxp/imx/imx6ul-imx6ull-opos6ul.dtsi b/arch/arm/boot/dts/nxp/imx/imx6ul-imx6ull-opos6ul.dtsi
index f2386dcb9ff2c..dda4fa91b2f2c 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6ul-imx6ull-opos6ul.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6ul-imx6ull-opos6ul.dtsi
@@ -40,6 +40,9 @@
 			reg = <1>;
 			interrupt-parent = <&gpio4>;
 			interrupts = <16 IRQ_TYPE_LEVEL_LOW>;
+			micrel,led-mode = <1>;
+			clocks = <&clks IMX6UL_CLK_ENET_REF>;
+			clock-names = "rmii-ref";
 			status = "okay";
 		};
 	};
-- 
2.39.5



