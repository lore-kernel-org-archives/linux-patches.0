Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CD413C9C4;
	Wed,  5 Feb 2025 14:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764833; cv=none; b=P00Mb47CXQWnxMafwIGHtf2UVXbBXsEeneKTgwAUFXb415ll293hXNjl2NmVGiWSd1U1NT3zeTFlu9aQZ8ykLJ1Lg4viynJ8PnRE+yjYzzrXh7g5ulafe+Er/Uo/55jG/rIUl3l3VNjSsXRBjrpqMDKphtoJZ8/ZygVROGDk/4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764833; c=relaxed/simple;
	bh=LHIqRIIcl6uyaBH24IGa7u+WLNQcfGZUU2wWJspicsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRIZ/QNe+3nLoVh5WNdEiTYdwaFiP+LMgwE+BvlrJmdRJFIKF/k7MbgW+EonuBmDrPYb17plMFjqi76HmvGn2exS0WShN84sGUJ56Q+HoD0oZr5xmLfTDYOVkrrfcUCX7RqCjr9m1Fc8DBP9n59SQdt9AI7s48EqdLUgZ//CyvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5c8Dd+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5c8Dd+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DAEC4CED1;
	Wed,  5 Feb 2025 14:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764833;
	bh=LHIqRIIcl6uyaBH24IGa7u+WLNQcfGZUU2wWJspicsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5c8Dd+IlMOEyVj6RoJ0Qwxj6uJ07VbLhNT7dFHu+ZhjIVFTXAJVglyQb4Hbk2ZZt
	 nc9/WkxN5AwA7rIQBUJNtePtb1YYgiEFx75jEFREwYIxUwN0yRFVBa5dC9H69T6Kcu
	 9ryr7nrG5j7X9eW1AKAw0OiOOcdtpoQ6XNxZV9KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 208/393] arm64: dts: mediatek: mt8195-cherry: Drop regulator-compatible property
Date: Wed,  5 Feb 2025 14:42:07 +0100
Message-ID: <20250205134428.260085530@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 4dbaa5d5def2c49e44efaa5e796c23d9b904be09 ]

The "regulator-compatible" property has been deprecated since 2012 in
commit 13511def87b9 ("regulator: deprecate regulator-compatible DT
property"), which is so old it's not even mentioned in the converted
regulator bindings YAML file. It should not have been used for new
submissions such as the MT6315.

Drop the "regulator-compatible" property from the board dts. The
property values are the same as the node name, so everything should
continue to work.

Fixes: 260c04d425eb ("arm64: dts: mediatek: cherry: Enable MT6315 regulators on SPMI bus")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241211052427.4178367-6-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
index b21663b46b519..e3b30543c2c64 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
@@ -1203,7 +1203,6 @@
 
 		regulators {
 			mt6315_6_vbuck1: vbuck1 {
-				regulator-compatible = "vbuck1";
 				regulator-name = "Vbcpu";
 				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
@@ -1221,7 +1220,6 @@
 
 		regulators {
 			mt6315_7_vbuck1: vbuck1 {
-				regulator-compatible = "vbuck1";
 				regulator-name = "Vgpu";
 				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
-- 
2.39.5



