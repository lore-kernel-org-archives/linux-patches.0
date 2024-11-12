Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF5122EE69;
	Tue, 12 Nov 2024 10:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407964; cv=none; b=uvHnYk02E6LKaFpxd/eVJON2VT19a6yG00RjScLGygpLMlXHErUE5gYgkKNLTaeHAHr+pIHzP7GhnAQqQGIT2o5FVkOUF1BXHKSz7/5KPaMKQ8PV/xxNfGW/6MpU5wofWxVKI8mTbKkhmaKep/Js8xi6ocq14MMKnIV6trnZ9HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407964; c=relaxed/simple;
	bh=ma7OkM9LhcjV9bnjUELLOYSn1YUMpWe5c9pzqTRlG2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQ/zSPVALmmRrxwtMgUJJLluFMg9y3kiuN7WZArFWYc57sI6L9hRUSwUJ3b2lCMZQiystlzeB7wXvwgdpGOL500ehXOQ3VvOvZ98oZ0y9NgqF2732hwiNXm3XlmR+UoqGamB0Ht8ffrud+mMge+3gt5SRLtpL6dA/4NScckECt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eg/jcCfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eg/jcCfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A1FC4CECD;
	Tue, 12 Nov 2024 10:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407964;
	bh=ma7OkM9LhcjV9bnjUELLOYSn1YUMpWe5c9pzqTRlG2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eg/jcCfdjXYuPBvIkvLSXcVTDqVw/vLYOTIAEUrOmkINxo2zAqcR/QwMshdO5ACqa
	 ilpwsa7NaM8njQaAmedgGeUNrGVXRLWCs40sZVqS33z8MLbalBqPrCSfe5onbwuzSZ
	 kryAPxpAXI1q9q1cewunNDYpkCs72rXk81Ms6VdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 018/184] arm64: dts: rockchip: Fix LED triggers on rk3308-roc-cc
Date: Tue, 12 Nov 2024 11:19:36 +0100
Message-ID: <20241112101901.569262526@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 3a53a7187f41ec3db12cf4c2cb0db4ba87c2f3a1 ]

There are two LEDs on the board, power and user events.
Currently both are assigned undocumented IR(-remote)
triggers that are probably only part of the vendor-kernel.

To make dtbs check happier, assign the power-led to a generic
default-on trigger and the user led to the documented rc-feedback
trigger that should mostly match its current usage.

Fixes: 4403e1237be3 ("arm64: dts: rockchip: Add devicetree for board roc-rk3308-cc")
Cc: Andy Yan <andy.yan@rock-chips.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-8-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
index 9232357f4fec9..d9e191ad1d77e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
@@ -36,14 +36,14 @@
 
 		power_led: led-0 {
 			label = "firefly:red:power";
-			linux,default-trigger = "ir-power-click";
+			linux,default-trigger = "default-on";
 			default-state = "on";
 			gpios = <&gpio0 RK_PA6 GPIO_ACTIVE_HIGH>;
 		};
 
 		user_led: led-1 {
 			label = "firefly:blue:user";
-			linux,default-trigger = "ir-user-click";
+			linux,default-trigger = "rc-feedback";
 			default-state = "off";
 			gpios = <&gpio0 RK_PB2 GPIO_ACTIVE_HIGH>;
 		};
-- 
2.43.0



