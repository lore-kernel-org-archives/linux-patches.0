Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BC7326938;
	Sat, 12 Sep 2026 14:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224188; cv=none; b=JDnq1Yoeg4CdjHGRZ0NuckaN8EW2RYcd3rKaYm/wuh+lwsfJXLjfdEV5rSZz0h+VGQPEt8l4INJbpOS220zrcckwSZl/lVpZbwrY8IJmfyRpaC38SR+vJSIY2IYOiaT/6ddAR6ZTV0xp0lZcDpddUKVq4uDXVlqeDpFWLNnuw1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224188; c=relaxed/simple;
	bh=wpWkpiYbmsKD4scxM0j9lXRW2Eyi0IOBQkHutOn5uJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNK0FlA3A2qUBD3QwXH9RpSvAcjdsNaS2iAVadnJqW3p2q5JrM1GWHskHjkF1imqYLCI2GG/LwTA4FDpJWp6uqpC+AmiyaNLc/bLDKDw4BUpPp+2hybvx/3n/qWY8mBCkWNIPGz0ziw7SMCBabZD9bBWR7ZHsCJFnbq+tnjPpZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAeITsUg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAeITsUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FB61F000FF;
	Sat, 12 Sep 2026 14:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224187;
	bh=tc/hn+TLi4qWc4LB3/pULEqA4ZKYISsyKCoaKr5L018=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uAeITsUgdciasoZZPnh85dDLhz8FpLBYFrkGhNUq+4rHO58IKIAvNQMnHJH+4peI8
	 +Ti5yfEYUsEc9wSJnIcNoTezaeVh5QGqOvb441LCtXg9djulLDIW1py4fFDMrZX1qF
	 xIeK8UkdxbqIhqFlYsV3rHRwSKQYnG79jVKKdxsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0941/1424] arm64: dts: qcom: sdm632-motorola-ocean: Fix LED default trigger property
Date: Sat, 12 Sep 2026 08:56:13 +0200
Message-ID: <20260912065628.394808274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit c82ea31fb783d9ce4080eca1a7bb855f4648fc28 ]

The correct property name is "linux,default-trigger", not
"default-trigger". Fix it to avoid DT checker warnings and let the OSes
consume the intended information.

Fixes: 3176c4d6b9be ("arm64: dts: qcom: sdm632: Add device tree for Motorola G7 Power")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260717-topic-june26_dts_fixes-v2-3-797cd46e5d9f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts b/arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts
index c82d6e628d2cb..f5728cc5a4535 100644
--- a/arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts
+++ b/arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts
@@ -130,7 +130,7 @@ led-controller@36 {
 
 		led: led@1 {
 			reg = <1>;
-			default-trigger = "backlight";
+			linux,default-trigger = "backlight";
 			function = LED_FUNCTION_BACKLIGHT;
 			led-sources = <0 1 2>;
 		};
-- 
2.53.0



