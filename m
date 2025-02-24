Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6562571CB;
	Mon, 24 Feb 2025 14:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409126; cv=none; b=CVeJuYvIMajJHxhrj4cS9IIXpR+7D71sl2wc7+6xf9G7pS8hYwqJo5PssYUJR1H5Om6sDsR3meoC9ZXjo9vOGMGdL5tlRrDKIwm/26ColIFI07DwE/XkepSn3c1qriliu0Add0tAU7/1YsxWfEoZU++FHPvQuaIUxFm04nUBjmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409126; c=relaxed/simple;
	bh=LVzhJGAM969XXvLqOXSXGZ9FgrDJYZhcUNhr15PqEJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tIcQueAyVDmbVvJRhlHE+EthUOLwrqGyPq5C7Y7r26xJmmHEldZ4m5PJCm8CSO3/iN1FcmIBieRuSizFt9/TsPsnsxAeSC5HdaWBdycNGBNL1Lbd+wog9T3G9Ve2iVs41ian5tka2ltJnQmF+mqdwpKj9GV+r8qoHzOsLJHO100=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vn2bAuBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vn2bAuBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE48C4CED6;
	Mon, 24 Feb 2025 14:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409126;
	bh=LVzhJGAM969XXvLqOXSXGZ9FgrDJYZhcUNhr15PqEJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vn2bAuBXc9qxre72fJLCoHV4G5YxsCro/NW2TCzRQN9twMuaMREYdToQO7xqtQMNZ
	 gsajgMk7wEn23/kZPUNdrJNdWQcgKdE8tVnFxJ4nfRU5A1PlbXR3yBWpWdYf5aII35
	 9Ddlh4QbSM+UDwuQrtXoZ2VHGk76UeJeq+n7mUic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Lukasz Czechowski <lukasz.czechowski@thaumatec.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.13 105/138] arm64: dts: rockchip: Disable DMA for uart5 on px30-ringneck
Date: Mon, 24 Feb 2025 15:35:35 +0100
Message-ID: <20250224142608.607794546@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Czechowski <lukasz.czechowski@thaumatec.com>

commit 5ae4dca718eacd0a56173a687a3736eb7e627c77 upstream.

UART controllers without flow control seem to behave unstable
in case DMA is enabled. The issues were indicated in the message:
https://lore.kernel.org/linux-arm-kernel/CAMdYzYpXtMocCtCpZLU_xuWmOp2Ja_v0Aj0e6YFNRA-yV7u14g@mail.gmail.com/
In case of PX30-uQ7 Ringneck SoM, it was noticed that after couple
of hours of UART communication, the CPU stall was occurring,
leading to the system becoming unresponsive.
After disabling the DMA, extensive UART communication tests for
up to two weeks were performed, and no issues were further
observed.
The flow control pins for uart5 are not available on PX30-uQ7
Ringneck, as configured by pinctrl-0, so the DMA nodes were
removed on SoM dtsi.

Cc: stable@vger.kernel.org
Fixes: c484cf93f61b ("arm64: dts: rockchip: add PX30-µQ7 (Ringneck) SoM with Haikou baseboard")
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
Link: https://lore.kernel.org/r/20250121125604.3115235-3-lukasz.czechowski@thaumatec.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
@@ -397,6 +397,8 @@
 };
 
 &uart5 {
+	/delete-property/ dmas;
+	/delete-property/ dma-names;
 	pinctrl-0 = <&uart5_xfer>;
 };
 


