Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B28175A66;
	Sat, 28 Feb 2026 17:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301374; cv=none; b=IhzKHdB+sDvyO9eineDK/4IZL3PxJsgKK43k1JmGGnfzX4JN2cbhI1KwJc3wglPCZh+RUuWBhptiq0zfQgRvnPuJwbwhQR9H6q+7yJSqt73TCdfO+A2+U/e/6EfchRLkBdW9THfGYqNA0YNvMDOZsr9RTsVpH06RJhQkNdvOc1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301374; c=relaxed/simple;
	bh=jxTGMT4SzWs+6kgFpvSL1FuyFBlWRxGMQO5evgt2JbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZtMes7IrYgQMvvN5vx++DKxvcHbeoaVUug0UL5CLSiEr+pylaaNXHQC+8ydMiqrrYWUuxng1bczrGCFkIvB/tcvYC3MoxmVlPoZZFTCaiQydYmai+L/cKliV/q9XvmvhCXr7CMHb9BpU97b+C7m1PFH3GcQnC6lg3L3GTd9VIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sUgQ0zt7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sUgQ0zt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4317DC19423;
	Sat, 28 Feb 2026 17:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301374;
	bh=jxTGMT4SzWs+6kgFpvSL1FuyFBlWRxGMQO5evgt2JbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUgQ0zt7/riaAfcl7dqvEXbdb/dt34QNOkgqRjs4GrYKo13kZ8aqcuBMhaQl17YJp
	 JAQZB5SzFn0BGmgmrUftNfdNFSb1bFd4sNSZSg+eg8jBklrB1qCyJVQmanzMROqXNz
	 wdY0rL+9ieXhW8EKHas9BmsYELx6NAyTBw5mRFPecc/bXyrnRT0iscJ2ykUdDyqYrH
	 gk7BiFBRQjujTVVg/79mzsf31XrsLiaz/8USwIuV8JkRuDrOIh1lLoEHC4bberzD1a
	 IUFi7P75iLTG2p5gYgXxTBgLB+ccsIERh+uQj7DUG6BS4OFM9WCblyu3nbZ060lRA+
	 ojSuhZ0+0nkuQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jun Yan <jerrysteve1101@gmail.com>,
	stable@vger.kernel.org,
	Peter Robinson <pbrobinson@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 563/752] arm64: dts: rockchip: Do not enable hdmi_sound node on Pinebook Pro
Date: Sat, 28 Feb 2026 12:44:34 -0500
Message-ID: <20260228174750.1542406-563-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jun Yan <jerrysteve1101@gmail.com>

[ Upstream commit b18247f9dab735c9c2d63823d28edc9011e7a1ad ]

Remove the redundant enabling of the hdmi_sound node in the Pinebook Pro
board dts file, because the HDMI output is unused on this device. [1][2]

This change also eliminates the following kernel log warning, which is
caused by the unenabled dependent node of hdmi_sound that ultimately
results in the node's probe failure:

  platform hdmi-sound: deferred probe pending: asoc-simple-card: parse error

[1] https://files.pine64.org/doc/PinebookPro/pinebookpro_v2.1_mainboard_schematic.pdf
[2] https://files.pine64.org/doc/PinebookPro/pinebookpro_schematic_v21a_20220419.pdf

Cc: stable@vger.kernel.org
Fixes: 5a65505a69884 ("arm64: dts: rockchip: Add initial support for Pinebook Pro")
Signed-off-by: Jun Yan <jerrysteve1101@gmail.com>
Reviewed-by: Peter Robinson <pbrobinson@gmail.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Link: https://patch.msgid.link/20260116151253.9223-1-jerrysteve1101@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
index eaaca08a76018..a6ac89567bafe 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
@@ -421,10 +421,6 @@ &gpu {
 	status = "okay";
 };
 
-&hdmi_sound {
-	status = "okay";
-};
-
 &i2c0 {
 	clock-frequency = <400000>;
 	i2c-scl-falling-time-ns = <4>;
-- 
2.51.0

