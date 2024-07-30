Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43450188013;
	Tue, 30 Jul 2024 16:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355469; cv=none; b=ZqZFqm1Tg2KWNa7cqgAXr3OJ6ypu9CIwcTXdcw9YpbhQAclHdQ1B4XtGBumJuds2AuJIlDGfm/qpQrlPRGDEJHdYcgQSBjLTsjzjasO3c24LnQ5RIE+UBPl4SbGRQEzgg7xDtqpe8qrsYOl5u9hKmovJYFMZsOHb+n5GArPEJ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355469; c=relaxed/simple;
	bh=rguCctayzjS5q5GH1w3ggBYFYqWFOFI65hMULtinD6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUeJ784i+DOdvnqZaxJFca5PV7vGTQEmPmTEt74DzJXBSs8Hbl8ZDc487hoKa1zwtGBMNqG6ltCb6xawxa8fviNxMHdf1weOVLPUiDbZJEVlLtLsDfXNUeoozoBfBiW4Hai5pe5YROISlDKPXbV6tzMfCr0lb66jVe/g4zLOY34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZA/73Uf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZA/73Uf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92A4C4AF0E;
	Tue, 30 Jul 2024 16:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355469;
	bh=rguCctayzjS5q5GH1w3ggBYFYqWFOFI65hMULtinD6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZA/73Ufv/aZfqhdWKjjpzbjDEfne6iERCG2wa5kTz2zcdT9b61ctP3iBUNc8nJuq
	 +tOlf+76GkmMpHqdjcKARKrGI3yZuXP6Isd0f2fVPJDvh4LQbSdQZ4A1QO0ABEOUzH
	 aMG6nueBUAmaD5a7O/ktcsrP2j5b5YjN41c8UxCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 058/809] arm64: dts: rockchip: Add sdmmc related properties on rk3308-rock-pi-s
Date: Tue, 30 Jul 2024 17:38:54 +0200
Message-ID: <20240730151726.935768828@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit fc0daeccc384233eadfa9d5ddbd00159653c6bdc ]

Add cap-mmc-highspeed to allow use of high speed MMC mode using an eMMC
to uSD board. Use disable-wp to signal that no physical write-protect
line is present. Also add vcc_io used for card and IO line power as
vmmc-supply.

Fixes: 2e04c25b1320 ("arm64: dts: rockchip: add ROCK Pi S DTS support")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240521211029.1236094-5-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
index 079101cddd65f..8ea9849064032 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
@@ -272,7 +272,10 @@ &sdio {
 };
 
 &sdmmc {
+	cap-mmc-highspeed;
 	cap-sd-highspeed;
+	disable-wp;
+	vmmc-supply = <&vcc_io>;
 	status = "okay";
 };
 
-- 
2.43.0



