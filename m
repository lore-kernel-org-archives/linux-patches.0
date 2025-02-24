Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8E01519A5;
	Mon, 24 Feb 2025 14:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408658; cv=none; b=nzv8cdOJtg0eB1x+ZIN9vOywUQWrL+JwudkQzI950ZDIKMz8wcHBVAeieTNY7c13PRLZuYP75+kOn1zQC37TC+nzE1EnrPC0Vow7o3bTIg0o9Mwzu3HWRxB78Ji04c0qZcLp0rVbODDL8n8N7DPta0mEgXSXRH8Qz8GRJdD7/uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408658; c=relaxed/simple;
	bh=y8K9xCeXCS0OuvPiz1YFL8Wqr+gJVn7Jgnlh5N29Cm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E81z1MYRpAFw5sb82zi9iA+phMqm125byUmmUqHaICs03oweRHcHChUXCiUtG7i8w4L4GxBqpVnJZqVEWsMp6SUgCUybnJYDPs7t1oTApGYgX+dvLlKWMhK9ReYYVWCMOAbs3o7gZTbW58mCekwZcrldcVw/xeSy3ZnTbuiL68w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FoXZSebj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FoXZSebj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F57CC4CED6;
	Mon, 24 Feb 2025 14:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408657;
	bh=y8K9xCeXCS0OuvPiz1YFL8Wqr+gJVn7Jgnlh5N29Cm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FoXZSebjKsIt0kzKCZiqLRQGxEzQVzGQX8KL5IiA/gzPvhciYSQOldXUCEk5w7LgL
	 j5Lu+X4AKEVE2UsumegknEJtnepG9fEf8xhVMK6Cj+kMCn34sJZgTji1DIp8qrsLY0
	 anQwKsE92bB9kKN6dCte+cYy83uJ7sdXpVO1dLNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Lukasz Czechowski <lukasz.czechowski@thaumatec.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.12 121/154] arm64: dts: rockchip: Disable DMA for uart5 on px30-ringneck
Date: Mon, 24 Feb 2025 15:35:20 +0100
Message-ID: <20250224142611.791200658@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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
@@ -374,6 +374,8 @@
 };
 
 &uart5 {
+	/delete-property/ dmas;
+	/delete-property/ dma-names;
 	pinctrl-0 = <&uart5_xfer>;
 };
 


