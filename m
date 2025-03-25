Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B27729DB77;
	Tue, 25 Mar 2025 12:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906404; cv=none; b=T13L0TIE+mtBKcPdaHnDjtNwrseYYWmWj2x3bzgVO59+R1SzXgyJmmR8XSiigWpBmKKjkOAzW82m+z5kW3wjpVXVMGxMj/AbD2RAgJ+afv6T4RvXB9ydt/CzJhtBL2fLW1ImihBauvsvgkCUuBwCgPy78d2VBiulCzo7L3Glp8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906404; c=relaxed/simple;
	bh=HUIsFRDIzHRMS4/AiGf3B/XKDVgw6AyD/qKjN4HwleA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XmcLZRoJPFpogAdtKAs0A3abyApSofrvWkYZsibB8C8FT1ZDNbCwBd6M5Lz7C3mv4X30tSSvXneS+hAmx/Qb3Ox7DqqFSAdARa2crnGKo8DyA0gghZTQ3IsOQNqUrHKfSvnWHlUxMsQW+eHKFe0g9ND9qEkn0K88dK+3oTIn06Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEAxy6q3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEAxy6q3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D375BC4CEE4;
	Tue, 25 Mar 2025 12:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906404;
	bh=HUIsFRDIzHRMS4/AiGf3B/XKDVgw6AyD/qKjN4HwleA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEAxy6q36taNQShf4shlyV6dDJfh3Src6zYlUSGhK5xlR22OoB9Vj7Y6NNC/5OqwM
	 WUDj7aN56mWAsMFrAohfKDpnOJnnCxuS7/YbySudOoqEDW8MqA+aUwk1KylpXypcoc
	 Jt5z8d9KwqB10l5lIdqxY9WLYygNAyLCgh/aHE6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.12 069/116] arm64: dts: rockchip: fix pinmux of UART0 for PX30 Ringneck on Haikou
Date: Tue, 25 Mar 2025 08:22:36 -0400
Message-ID: <20250325122150.972275275@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@cherry.de>

commit 2db7d29c7b1629ced3cbab3de242511eb3c22066 upstream.

UART0 pinmux by default configures GPIO0_B5 in its UART RTS function for
UART0. However, by default on Haikou, it is used as GPIO as UART RTS for
UART5.

Therefore, let's update UART0 pinmux to not configure the pin in that
mode, a later commit will make UART5 request the GPIO pinmux.

Fixes: c484cf93f61b ("arm64: dts: rockchip: add PX30-µQ7 (Ringneck) SoM with Haikou baseboard")
Cc: stable@vger.kernel.org
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://lore.kernel.org/r/20250225-ringneck-dtbos-v3-1-853a9a6dd597@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts
+++ b/arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts
@@ -222,6 +222,8 @@
 };
 
 &uart0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart0_xfer>;
 	status = "okay";
 };
 


