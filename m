Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D76B13C90B;
	Tue, 25 Jun 2024 10:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309650; cv=none; b=Thxgh7H79n/58+Pa6hbS0AeNQunYGeeNijxgV3wZjOGv0f7TVKE9tplIOXeKnhOxeKgFY3OX+AJADe81LTo7E71eHoYvXCKOFtGs84F65kv83FLAVGer3k8+1OTOyMW51bGf+rae0dxhB2CcUhDywxgzTW6WwZD8AK2c7BBqMz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309650; c=relaxed/simple;
	bh=Oa90Ww4WDFB0uSjPuORQTByuAyUP1xjbtycKld6CKQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOrngKxiBhyVuulu2FYsc0g3Qc7nKqt98M1lTFCVIQQCYuMzgH7+8jYEOiFGepqpYyStxWRqbQNoO0lsO48JmyYyCV7rILRYrPZr/euwcxRZ5yVU1KlYAxT48VsMVqItj49D/9j20H0R9OfsWruilReafv6f9xOV59ZPKI/NhdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUHHsmHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUHHsmHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4536C32781;
	Tue, 25 Jun 2024 10:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309650;
	bh=Oa90Ww4WDFB0uSjPuORQTByuAyUP1xjbtycKld6CKQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUHHsmHRAF4YXctEYsIEkECbNszh8+xfndk/JAHka/hIz73VZsZC4ug5iE/b1mlp6
	 KDpkV7W4LcgiXmm3dzifhd4jCtdwIlVozBszvuR7rvahL4KThZ2ZAwtC79SbdPcLIo
	 QBamt0GLv6dOmknT3cYPNUQpNkT9JpwaOYMjuuoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/131] arm64: dts: imx93-11x11-evk: Remove the no-sdio property
Date: Tue, 25 Jun 2024 11:34:02 +0200
Message-ID: <20240625085529.245860781@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit a5d400b6439ac734a5c0dbb641e26a38736abc17 ]

The usdhc2 port is connected to the microSD slot. The presence of the
'no-sdio' property prevents Wifi SDIO cards, such as CMP9010-X-EVB [1]
to be detected.

Remove the 'no-sdio' property so that SDIO cards could also work.

[1] https://www.nxp.com/products/wireless-connectivity/wi-fi-plus-bluetooth-plus-802-15-4/cmp9010-x-evb-iw416-usd-interface-evaluation-board:CMP9010-X-EVB

Fixes: e37907bd8294 ("arm64: dts: freescale: add i.MX93 11x11 EVK basic support")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts b/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
index 27f9a9f331346..5a212c05adc67 100644
--- a/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
@@ -60,7 +60,6 @@
 	vmmc-supply = <&reg_usdhc2_vmmc>;
 	bus-width = <4>;
 	status = "okay";
-	no-sdio;
 	no-mmc;
 };
 
-- 
2.43.0



