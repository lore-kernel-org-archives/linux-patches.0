Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4291C14AD2B;
	Tue, 23 Jan 2024 00:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969274; cv=none; b=oq0tIxbXQkwJJ4vZyNJSE1nWonbTWXyANPOB6G+rBdJwzfH0uhZ/EFTXTlft6z1GeoVivxD5cwGG3vvX3iqahIk9e0bQIwCRwcuHzoSjR4yMR9Xs+emR5830xlq2PLBW6XKwWxVpJigcHOf/aYOju1mEh2DrmS2CYp0FQVIn6P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969274; c=relaxed/simple;
	bh=r2PXfUpxg0FbmHCo3uYFJP6xV9QaeEXrmBx3k1Cplr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8ptrho0wYSTbifAYMdgqc07i/0FR2tvBTo3WUv8s5jG3GFlJIIuotFhkyCXnaF85opvrMvCHv48hBhx/t0ASvcf7dTLv6XuMzT363LZn22jHuLBzxcKHt+6Yqr0EHH66IBji5TjKE5EZ0UFok+NoQ96ukUzjwCKAJblZSChVoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+tL6/5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+tL6/5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C08C43399;
	Tue, 23 Jan 2024 00:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969274;
	bh=r2PXfUpxg0FbmHCo3uYFJP6xV9QaeEXrmBx3k1Cplr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+tL6/5PwxbEviZGTmm4cZ7A93GxnC9Yb5VcGDgCT2MOcAqy44+3vUWDhiAHZU2tp
	 P+yAUJbp//wEPMVma8zCaVPFLlnXv2g84yx0jw26LPUxN/8UaBtxjDze/1QamLuKaw
	 zHzF3KBZcMoUmEeRLwPdlFJjdMXLWSrntfWhNUpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 112/641] arm64: dts: ti: iot2050: Re-add aliases
Date: Mon, 22 Jan 2024 15:50:16 -0800
Message-ID: <20240122235821.542058507@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

[ Upstream commit ad8edf4ff37ab157f6547da173aedc9f4e5c4015 ]

Lost while dropping them from the common dtsi.

Fixes: ffc449e016e2 ("arm64: dts: ti: k3-am65: Drop aliases")
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Link: https://lore.kernel.org/r/1edbc1b56ed4ff2256d7afb7db3cab4b3a423692.1699087938.git.jan.kiszka@siemens.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi b/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
index ba1c14a54acf..b849648d51f9 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
@@ -14,6 +14,16 @@
 
 / {
 	aliases {
+		serial0 = &wkup_uart0;
+		serial1 = &mcu_uart0;
+		serial2 = &main_uart0;
+		serial3 = &main_uart1;
+		i2c0 = &wkup_i2c0;
+		i2c1 = &mcu_i2c0;
+		i2c2 = &main_i2c0;
+		i2c3 = &main_i2c1;
+		i2c4 = &main_i2c2;
+		i2c5 = &main_i2c3;
 		spi0 = &mcu_spi0;
 		mmc0 = &sdhci1;
 		mmc1 = &sdhci0;
-- 
2.43.0



