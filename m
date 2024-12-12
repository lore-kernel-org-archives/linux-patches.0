Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4AB229692;
	Thu, 12 Dec 2024 16:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022036; cv=none; b=CL+FVUZM0iU/d1VAL88DbBfMGUVyQgzjpcn31MElwSiGauilHGFD6ldCeqFAwEfYYbNRYR0L84TX3yp3FDkL0Hp+pjMxMacN5iJjtfd1ki9zqWWqafXhpUYCbqVQkqMZ7d8rvT2Tz8KV0p/nOHbZRhgXb78YrGMXGwz36AKPzZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022036; c=relaxed/simple;
	bh=O0oivIJfB4+HkdoXFIrth/+Hg58/1oGl5osdVBRzkm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDddyc88sfGi4YTovdwNKnnec7kh4GJg8QHcafWAOcDvZrfXxxFmaJ6VRwhQOwgVf3+kanLZvIrKMiNzJxAfEf5lIkghUNXjgjAZP916lGTvHwYaBGI6jwVOA2aodalyGrDlcOoNl0o3zFWYL2rhhhq4jualQZaQnzTpe9VYymo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iouSFQZt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iouSFQZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C33C4CECE;
	Thu, 12 Dec 2024 16:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022036;
	bh=O0oivIJfB4+HkdoXFIrth/+Hg58/1oGl5osdVBRzkm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iouSFQZtESm6d9N5R2fVhifepbPC8zs9QYJJFFYR4de7YQ6IePSOWby/7FyIX9Dze
	 6AdVtRFUD4jjI95WHgShoosJj8G7q4/0a6CKg8EthjfrKaILrIouWwypOnMJG3F5G+
	 INHP3iMc38qRYvrjnDgzaq5pT6NmK7U5BpuwDY/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/565] arm64: dts: mt8183: jacuzzi: remove unused ddc-i2c-bus
Date: Thu, 12 Dec 2024 15:55:25 +0100
Message-ID: <20241212144316.621977180@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 2706707b225d29aae6f79a21eff277b53b7b05e9 ]

EDID is read from bridge, so the ddc-i2c-bus is unused.

Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Link: https://lore.kernel.org/r/20211110063118.3412564-1-hsinyi@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Stable-dep-of: c4e8cf13f174 ("arm64: dts: mediatek: mt8183-kukui-jacuzzi: Fix DP bridge supply names")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
index 13757d7ac792a..b9b7ddbeaabb3 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
@@ -11,7 +11,6 @@ / {
 	panel: panel {
 		compatible = "auo,b116xw03";
 		power-supply = <&pp3300_panel>;
-		ddc-i2c-bus = <&i2c4>;
 		backlight = <&backlight_lcd0>;
 
 		port {
-- 
2.43.0



