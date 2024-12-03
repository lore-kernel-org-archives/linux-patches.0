Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3751F7070;
	Tue,  3 Dec 2024 15:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238329; cv=none; b=pSbX+MqWlVnrrA1nEXrXSsT5iVfcEg8PKjIKLaUJjFxICELClnwAfZd9yrZ6C7BAP6WSgt7llUPs0mjIFXAz89hBau+BTvxUVStKryoAgDbORTmfyXbXAz31HFfFK1tKs3V+E60i60U6IXWADoMK3oyEA/dks3G2wXEI8q6QfXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238329; c=relaxed/simple;
	bh=THsQmTLAZN09O8IzC/y5SLltSI7vJonIfOgMfGYxxQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ks9fMUoLcQDpjemWsBQDEki/H5ZG+6S3KoKTlL5t3JAu/Dg0+Lakzfav/AmhYrALU2bbXvjYXFomobkAsFpQR5bChiuv8lce1de2T3UVL8+h7rAhtWyZIqMYbYzjUmYpX88EZh1zg8tjnJ8yTCVsQU2nh555Bf1cl6zw3A+AaQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYom7K5j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYom7K5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F0AC4CED6;
	Tue,  3 Dec 2024 15:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238329;
	bh=THsQmTLAZN09O8IzC/y5SLltSI7vJonIfOgMfGYxxQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYom7K5j9M3LXy/2zrNkl6/kGFT5li46+WuJwVhELbm54nrJ7MpuW02JFDoQG3WRk
	 WckyDPJOQsLkTv83AyuZI4t1XINDkqEn4Pwx/qVmbbtl2CFz61wcgz1QSOfSYYJMzu
	 UiwI5lauda3UGL2KORdGWIDWouyaSJSZSvb8xRpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 211/817] arm64: dts: rockchip: correct analog audio name on Indiedroid Nova
Date: Tue,  3 Dec 2024 15:36:23 +0100
Message-ID: <20241203144003.986310192@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit 42d85557527266804579bc5d20c101d93f6be3c6 ]

Correct the audio name for the Indiedroid Nova from
rockchip,es8388-codec to rockchip,es8388. This name change corrects a
kernel log error of "ASoC: driver name too long 'rockchip,es8388-codec'
-> 'rockchip_es8388'".

Fixes: 3900160e164b ("arm64: dts: rockchip: Add Indiedroid Nova board")
Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Link: https://lore.kernel.org/r/20241031150505.967909-2-macroalpha82@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dts b/arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dts
index d8c50fdcca3b5..a4b930f6987f4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dts
@@ -62,7 +62,7 @@ sdio_pwrseq: sdio-pwrseq {
 
 	sound {
 		compatible = "audio-graph-card";
-		label = "rockchip,es8388-codec";
+		label = "rockchip,es8388";
 		widgets = "Microphone", "Mic Jack",
 			  "Headphone", "Headphones";
 		routing = "LINPUT2", "Mic Jack",
-- 
2.43.0



