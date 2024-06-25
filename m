Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8B2149C4F;
	Tue, 25 Jun 2024 09:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309242; cv=none; b=Iuc0V/jWW11YlmN4F1RoWpCgpJ5fvzZ5u67KK3T87p/USqTsiOiVJaKrPJ5ds2jGShf/fZmWCZouK1M5HmaAQ/1qlM2fvW4Q4iL+VlQxucbHiujQvdo3sdj9a/oeY91VJr6JyAzbya/Va/y0O0C415A713mcAhdLRnmGHupQ5lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309242; c=relaxed/simple;
	bh=VPN0MHHyyitlIwwP9Y1Nm3ctbTAnM3aU90eHYE6C/BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ji1mGCO+MT2vThZDdVL/+tCE2bD0iHv9WIGf9vvj+cfaQHX2P3Y854X+NaISPb3KYjloGRmA8PkN5TudofLt6lAONmuYhbkJNG5GngRKcXnR4IHXPiu33aK6eBmeWW8+TLhh+IH8GLuXUjgub3kpfwIn8VxGhr6a5SJnpEeL1kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yn5XO0DL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yn5XO0DL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24BBC32781;
	Tue, 25 Jun 2024 09:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309242;
	bh=VPN0MHHyyitlIwwP9Y1Nm3ctbTAnM3aU90eHYE6C/BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yn5XO0DL0wGE1Xg51v3dhEVADZXOdCL8OAmYFpPXZ7WjPumjDB0XU5baZZxg3MD3+
	 bpNETiqFIzpdrVqbTIj1aM7dz+c6wQ5BSH+U95tMoFtf/IsHaRxoFnWXTg3pcy//ml
	 25K4a0hKjefAjj0CbzYTkRgXIJPv4ZxSpPB6iX+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/192] arm64: dts: imx8mp: Fix TC9595 reset GPIO on DH i.MX8M Plus DHCOM SoM
Date: Tue, 25 Jun 2024 11:33:08 +0200
Message-ID: <20240625085541.625770731@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 418a7fc5397719c4b8f50eaeca6694879f89a6ec ]

The TC9595 reset GPIO is SAI1_RXC / GPIO4_IO01, fix the DT accordingly.
The SAI5_RXD0 / GPIO3_IO21 is thus far unused TC9595 interrupt line.

Fixes: 20d0b83e712b ("arm64: dts: imx8mp: Add TC9595 bridge on DH electronics i.MX8M Plus DHCOM")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: c03984d43a9d ("arm64: dts: imx8mp: Fix TC9595 input clock on DH i.MX8M Plus DHCOM SoM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
index cb1953d14aa90..eacf1da674778 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
@@ -252,7 +252,7 @@
 				  <&clk IMX8MP_AUDIO_PLL2_OUT>;
 		assigned-clock-parents = <&clk IMX8MP_AUDIO_PLL2_OUT>;
 		assigned-clock-rates = <13000000>, <13000000>, <156000000>;
-		reset-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio4 1 GPIO_ACTIVE_HIGH>;
 		status = "disabled";
 
 		ports {
-- 
2.43.0



