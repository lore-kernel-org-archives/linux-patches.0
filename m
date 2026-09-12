Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C6A3932D3;
	Sat, 12 Sep 2026 10:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208209; cv=none; b=lg3ZJe1n8xcuUw1r0s+EB9iRmZ3Aw0mA4Wge2tiTXZTOhbfOYMbwV/FyDrM+Bk9j6Lt9mq+KZZOnpPm2tZhn16nzTrYaPunp58SIcuYnKfQha1+rAmSGm4/c7B1fOjT4Xes3g1j1librBcV+1cUode9kwZOXHLGQEvQDsQIq7iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208209; c=relaxed/simple;
	bh=9bQhBjdAkXe2vP1KiDM2W7ikL6mbquLrcsm3ThwSmcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GV5ZCKZ1vqvVg5SExw5jdEuUL8Xb3uo98MTEZnVcyP/zCwW85ZKMiWCgpgXHYkReG9v93t2+ZoeggtK11kGCTzY1hfhoIGGeR9cqpDU3bPbMAjPFAjPZ9veddBaH0V77o27rl7P0BgpVBmDAnHhLF0hLOhxgnnp9K4RRRqMZEI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gP6xZaa3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gP6xZaa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233141F00898;
	Sat, 12 Sep 2026 10:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208202;
	bh=e8v+9W4O1/y/8yIRpHbeh6LWMv18t4YZVK1j9TOibrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gP6xZaa3Utn2EZqcV7hxY03qc5Jpw4/wpHC6giuAZc/2cFehXiA/DR9B3P4BvSfBO
	 xUc2Q2CgycfGkYo+RZ1+qeNo/uX3o26f93UFNRmXBgWB/ByCtQath/KB76zcSmw6Jn
	 6nPAh+tzDp9mThXToU9WC7Mnjm+UJoUEkSEoB2no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0570/1518] arm64: dts: rockchip: Fix rk3566-bigtreetech-cb2 touchscreen property
Date: Sat, 12 Sep 2026 08:45:39 +0200
Message-ID: <20260912065636.325680715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 7707e4555cf1d52689621e3206df8ad2debaa0dd ]

The TSC2007 driver uses the ti,max-rt property to specify the maximum
touch resistance, but the rk3566-bigtreetech-cb2 device tree uses the
undocumented ti,rt-thr property instead.

As a result, the configured value is ignored and the driver falls back
to its default maximum resistance value of 4095.

Replace ti,rt-thr with ti,max-rt to preserve the intended resistance
threshold of 3000.

Fixes: bfbc663d2733 ("arm64: dts: rockchip: Add BigTreeTech CB2 and Pi2")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Link: https://patch.msgid.link/20260721135450.45286-1-festevam@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi
index b6cf03a7ba66b..04cf285e6c2af 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi
@@ -569,7 +569,7 @@ tft_tp: touchscreen@48 {
 		reg = <0x48>;
 		status = "okay";
 		ti,x-plate-ohms = <660>;
-		ti,rt-thr = <3000>;
+		ti,max-rt = <3000>;
 		ti,fuzzx = <32>;
 		ti,fuzzy = <16>;
 	};
-- 
2.53.0



