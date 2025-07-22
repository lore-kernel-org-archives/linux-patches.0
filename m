Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED162ED85D;
	Tue, 22 Jul 2025 14:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193458; cv=none; b=c9WU2/56Y6uyRY++EpfqbWMaO6cHYeqXKa6emBDWmWpeau5CxY6XjPSH6Mu+ejdnQTwp3vLXGZsJBjQaUgQzCuoWVSl/wYrHlLN3dvCeWtbx02TKrZXcERrepxyheKG/M/S+dhlGZ4p0g3dqolQTGS+jSL9MxHyGrq0qXmby5e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193458; c=relaxed/simple;
	bh=MRXHAVmLdKy7LaLGml6Pv/0Btz+rXXg73aY/O1q6alk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9DVgpbxodOV2q8C0ryEdwrBqG/kn+IJ1hOqX/UU+i3fe8A11PQS/uta/SyydmxRPXVCdHAY9noSGh+rM88AaCEWgv6o9DJ9cC70jvdqGvOzEPnvy5b9YNYgJbQXAubAKroBik62VI4wjBCPVcSf1iQ9orMBPkmF3Mg7OBzxVNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXdsp+4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXdsp+4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298AAC4CEEB;
	Tue, 22 Jul 2025 14:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193458;
	bh=MRXHAVmLdKy7LaLGml6Pv/0Btz+rXXg73aY/O1q6alk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXdsp+4xzVuFJSobRx58FyMehxk2BOSrP963aDWMSU+Koru0A32cMong5pnk7PLpM
	 PPLJP6G/zR+G34HFKAwS9aYNo7GMjFgup4mQI0kZ6UBn2Cf6ysAVqYv3AuFN9JfbVl
	 gCEJIAZxAQADOpcWBuCfpvbJFOSwGHpH05sL/hDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andyshrk@163.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 097/187] arm64: dts: rockchip: Add cd-gpios for sdcard detect on Cool Pi CM5
Date: Tue, 22 Jul 2025 15:44:27 +0200
Message-ID: <20250722134349.388613420@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andyshrk@163.com>

[ Upstream commit e625e284172d235be5cd906a98c6c91c365bb9b1 ]

cd-gpios is used for sdcard detects for sdmmc.

Fixes: 791c154c3982 ("arm64: dts: rockchip: Add support for rk3588 based board Cool Pi CM5 EVB")
Signed-off-by: Andy Yan <andyshrk@163.com>
Link: https://lore.kernel.org/r/20250524064223.5741-1-andyshrk@163.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5.dtsi
index cc37f082adea0..b07543315f878 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5.dtsi
@@ -321,6 +321,7 @@
 	bus-width = <4>;
 	cap-mmc-highspeed;
 	cap-sd-highspeed;
+	cd-gpios = <&gpio0 RK_PA4 GPIO_ACTIVE_LOW>;
 	disable-wp;
 	max-frequency = <150000000>;
 	no-sdio;
-- 
2.39.5



