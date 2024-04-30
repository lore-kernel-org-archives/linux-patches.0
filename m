Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692728801;
	Tue, 30 Apr 2024 11:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475826; cv=none; b=ndgUyazdh831vpWR8BWh1H+Y1r0nEt8l6NpKKsJVNR/ViT43ZtuJq3TCZpaUVV3AgyIX2il5T/rZjQgjOBj7adSx/SaNd9pT+pAf3+ynIS5xxVQ2SemMMO8D0XPsimIpfBw2qKlK7i3HFQnSLqm/V41AyMBKza8BeQ+RhrCbem4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475826; c=relaxed/simple;
	bh=5anNoHDfoMYdZxh72AmA/Rgb5D9Dz6sYbKagp6XAgZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGK8SFVkWUGJaO5yoq3e81hreXJxmK1lulnF31x7n1IN9dWdtqgi3B44l81T67GzfFKZU7Bu9FvlyMsxXpIaKNOIviMTOTv7lWcDB7ayoX65mTEcJm37bbQGarbsZaCMPbB44/usTBMbWJpKS7E4t72rgiHWrRx+gxHjnTDhkgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVukvf8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVukvf8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EF2C2BBFC;
	Tue, 30 Apr 2024 11:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475826;
	bh=5anNoHDfoMYdZxh72AmA/Rgb5D9Dz6sYbKagp6XAgZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVukvf8S2CMhdUwxu7wyHSub3hvTIDvMHK7PTuqjqzffK7OCIqyig9V8mBXXqEhkE
	 WG/4Pia0N8B7ifBoHqISnD7E7u1LHz9xqUYT2sPuHhdl182jU66TPFRS5nVQeMhFNJ
	 Bp2mYJJBpFhkKO+r7QFSMxndJsRJ0UKtPW2cngWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/80] arm64: dts: rockchip: enable internal pull-up on Q7_USB_ID for RK3399 Puma
Date: Tue, 30 Apr 2024 12:39:37 +0200
Message-ID: <20240430103043.560735912@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

[ Upstream commit e6b1168f37e3f86d9966276c5a3fff9eb0df3e5f ]

The Q7_USB_ID has a diode used as a level-shifter, and is used as an
input pin. The SoC default for this pin is a pull-up, which is correct
but the pinconf in the introducing commit missed that, so let's fix this
oversight.

Fixes: ed2c66a95c0c ("arm64: dts: rockchip: fix rk3399-puma-haikou USB OTG mode")
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20240308-puma-diode-pu-v2-1-309f83da110a@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index 7b27079fd6116..d9859fa4a7499 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -432,7 +432,7 @@
 	usb3 {
 		usb3_id: usb3-id {
 			rockchip,pins =
-			  <1 RK_PC2 RK_FUNC_GPIO &pcfg_pull_none>;
+			  <1 RK_PC2 RK_FUNC_GPIO &pcfg_pull_up>;
 		};
 	};
 };
-- 
2.43.0



