Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887331E5716;
	Mon, 21 Oct 2024 10:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506464; cv=none; b=fFgBDBdtjeZtI5mQjLv4Qf91f2ZIQ5UpboBb9uehye2n8TTmtW5xOc154bMSRkYj0JRUgGCJfvT2PlNMZqmWgsRIv1+FpUJEUL9dGqjam+dLvoYgJAQeqP0vkKU+J05eQaBTc385ewZUGf4RvuF+WrhfKRm42GE0LuLQPwpD/mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506464; c=relaxed/simple;
	bh=FOV9K9OhJxRefzmVM4LojiepehUbk/7ZTCi0NN1p/lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueSvQFoxT5w+nPYWjCcc/GmRHtgdcxdKfAspueuqHHK8jhKYo+dgNIw8I53mTtchetkpb6uJmUbahwYAceN6K2/afE/2ZfyxzKbu6aqsfPyqtJx2sp2KCzd+O/ss6o9LAb1W9ZRYxuNpQw+QiBgk+HFPWmWZNUpxXuySxOu9gDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dTubKste; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dTubKste"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC97BC4CEC3;
	Mon, 21 Oct 2024 10:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506464;
	bh=FOV9K9OhJxRefzmVM4LojiepehUbk/7ZTCi0NN1p/lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTubKste3abEpRD4Z0MWbfUzEZgBXN0+m+eVv7tw/S7rzXrEvovvwX5zrx/KuodzE
	 Nk7fUuAHsPkOwZxaTrCayyRCnWeibsO+WxSOGRxt5jKltlM1xK9RXBsdllqiMA1VfR
	 Or4h7ovUq+IAXfWFkKNoZ6sjRMsGkbXY6LDwVqWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 6.11 014/135] arm64: dts: marvell: cn9130-sr-som: fix cp0 mdio pin numbers
Date: Mon, 21 Oct 2024 12:22:50 +0200
Message-ID: <20241021102259.896120862@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

commit 841dd5b122b4b8080ede69c5f72fd6057da43f8a upstream.

SolidRun CN9130 SoM actually uses CP_MPP[0:1] for mdio. CP_MPP[40]
provides reference clock for dsa switch and ethernet phy on Clearfog
Pro, wheras MPP[41] controls efuse programming voltage "VHV".

Update the cp0 mdio pinctrl node to specify mpp0, mpp1.

Fixes: 1c510c7d82e5 ("arm64: dts: add description for solidrun cn9130 som and clearfog boards")
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Josua Mayer <josua@solid-run.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/stable/20241002-cn9130-som-mdio-v1-1-0942be4dc550%40solid-run.com
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/marvell/cn9130-sr-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/marvell/cn9130-sr-som.dtsi b/arch/arm64/boot/dts/marvell/cn9130-sr-som.dtsi
index 4676e3488f54..cb8d54895a77 100644
--- a/arch/arm64/boot/dts/marvell/cn9130-sr-som.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9130-sr-som.dtsi
@@ -136,7 +136,7 @@
 		};
 
 		cp0_mdio_pins: cp0-mdio-pins {
-			marvell,pins = "mpp40", "mpp41";
+			marvell,pins = "mpp0", "mpp1";
 			marvell,function = "ge";
 		};
 
-- 
2.47.0



