Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB78F15D5A6;
	Mon, 29 Jan 2024 17:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548382; cv=none; b=MWje5FuUJW+orW0pLr1lYVL0YUXqxgdQtEcjykJ0LsDZE+g9hnYKeqVDbLQOmzlMLoPaM5HNEp1Kbog3pOQZisPZkobPRhiMvbpbGNKjn4kLC4PqKcc9H8egtud8Noujr1GMIyhtktGjURgbwvrCJx9Kmw1Gif3nzLGhr2WG1Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548382; c=relaxed/simple;
	bh=w8Y3+rjt3nNDgfZELEf/+Pg8lGDQhpal1qEjvsJ6bLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mlr2+KZW4hb3u4TuFvL2tt6ek763iojVJWItL/iagh2uOOWVxcL2lna1dZtCfsbo3/YU2PG4TKTbFb2ILNnue9Kc1WxxiclxMgJz74jGpO1efw1g0q4gNdK4RUPMZ+QUjwEBI/tklphvTts8bU0PS4cIacf6VBF4khdzGa/RjiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sA7JmH5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sA7JmH5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C652C433F1;
	Mon, 29 Jan 2024 17:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548382;
	bh=w8Y3+rjt3nNDgfZELEf/+Pg8lGDQhpal1qEjvsJ6bLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sA7JmH5TUzMDi8Y1dNdBA2/RDUmXxQUfeNimo60Dfn96iBbbI1KI1FJtUaWPp2SDn
	 lAHcmAL3BfCA4hIyR7oRC8uF982ZD988D/la2MVfeYCZ7uY0JsKfFyYXvA7UHopFlt
	 F4hS4aKLsL+YBeKrNi2O+8x8bzGL+G/xykuP34t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/185] ARM: dts: samsung: exynos4210-i9100: Unconditionally enable LDO12
Date: Mon, 29 Jan 2024 09:05:54 -0800
Message-ID: <20240129170003.546543133@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 84228d5e29dbc7a6be51e221000e1d122125826c ]

The kernel hangs for a good 12 seconds without any info being printed to
dmesg, very early in the boot process, if this regulator is not enabled.

Force-enable it to work around this issue, until we know more about the
underlying problem.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Fixes: 8620cc2f99b7 ("ARM: dts: exynos: Add devicetree file for the Galaxy S2")
Cc: stable@vger.kernel.org # v5.8+
Link: https://lore.kernel.org/r/20231206221556.15348-2-paul@crapouillou.net
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4210-i9100.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210-i9100.dts b/arch/arm/boot/dts/exynos4210-i9100.dts
index 53e023fc1cac..b4c7b642e456 100644
--- a/arch/arm/boot/dts/exynos4210-i9100.dts
+++ b/arch/arm/boot/dts/exynos4210-i9100.dts
@@ -521,6 +521,14 @@ vtcam_reg: LDO12 {
 				regulator-name = "VT_CAM_1.8V";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+
+				/*
+				 * Force-enable this regulator; otherwise the
+				 * kernel hangs very early in the boot process
+				 * for about 12 seconds, without apparent
+				 * reason.
+				 */
+				regulator-always-on;
 			};
 
 			vcclcd_reg: LDO13 {
-- 
2.43.0



