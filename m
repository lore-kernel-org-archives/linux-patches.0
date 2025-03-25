Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2D629CB49;
	Tue, 25 Mar 2025 12:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906204; cv=none; b=MAIqFVlQwnVKYcsfhQe7iyY1xJaZoVLsHIUpBmathrR7W1Wq2bch0axMMdHsYoImDLKf43At7mzZp1PF+ZQxVZ1lmG2Hpj3QrFVg4hXOzZaQOHgaQyv3UYb/RBCYk7t1L+cXSdvlIkXrzHgr0yKLch82A3WNgDJD4rOlLT/aiEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906204; c=relaxed/simple;
	bh=gjtAJYjmO79nW3Wv5ZKd09XJnrhH75nOYzABsYNIQ/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mY0bxofs+l7g9/9y9tJV8z9SjcUYhC9NZ5LNgz7djoCeuMq+y68FQEAAgdExQxNfEtPdF8uAK6Fx/jq3zCq+JG4vX2VPL+1GNjE2ciF4P+/xgN7Y44drQ84vBZbZZa3CwM80euE8PBfmcJDVXPq0Uo/4kut26SBkuoDPMwNW3xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JF/dV8OQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JF/dV8OQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EDBC4CEE4;
	Tue, 25 Mar 2025 12:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906202;
	bh=gjtAJYjmO79nW3Wv5ZKd09XJnrhH75nOYzABsYNIQ/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JF/dV8OQwtKhwOp/coxvXM1gqmFwXrOqWfYHIGPvr0jkWFg7vHYaCvnVuxvLOm/RB
	 dEVpnhQB10j9wOgAcoEVyp5863ma6YvGvGFmRgoDBSI5bQPAP3ZtjoaUCyZnvENimo
	 LV0KwrAzJYtOwjlflaSsnH/UAQjw4m6qEH4bcweQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.6 41/77] arm64: dts: rockchip: fix pinmux of UART0 for PX30 Ringneck on Haikou
Date: Tue, 25 Mar 2025 08:22:36 -0400
Message-ID: <20250325122145.426427077@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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
@@ -221,6 +221,8 @@
 };
 
 &uart0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart0_xfer>;
 	status = "okay";
 };
 


