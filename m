Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0912FABF8;
	Tue, 12 Aug 2025 18:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023325; cv=none; b=YatsS/higy7QCoPUUr11SqwXaTSG1ov9jM/lrDctst/VxuSp7QKvTStRf84BUyEbBEelghGcBPRTpOMRkPBXNpJDm7FldGUdzTKpkjdJblr+G6mqGjKlUVlb+x/w0kmeYqhgYoFLmaDg/83K4r9QoDowC3AsJo2LNLW06SJoY7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023325; c=relaxed/simple;
	bh=NQ4rHcU3S59cS5bWrH4yDSyEV3NS5VBfVNP/dWpgsU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zd2NnoIKpo2tFLeoIUwgrdeeWdTJlQ8U0SVkO0ZcQRiLZpw6/hSj8SrAxYEj3Sod/W0vTXUFMzxEpu0ncjORV9ToBHitahy+5Sb9JiHaHKcyToeQl17qNR7O+awgSVCMpXdsWs/yAHBq//2prQyBxMOH9wsB68E9C3rUJp5wLBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBzx7kKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBzx7kKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51668C4CEF0;
	Tue, 12 Aug 2025 18:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023324;
	bh=NQ4rHcU3S59cS5bWrH4yDSyEV3NS5VBfVNP/dWpgsU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBzx7kKp0CZScKCjqU8WPXep5iWZT2oNT0OGaF1Ur1l6tA1tw/KruQpSY/RGOOpI+
	 1ZvdbzHFXDIpQ5S0OgX66J+GNmQuHLfQpTQiDO66DibYBdp1+EEkwhVGftDuHMyxxc
	 wowE5akYqY2BT0EharKhq72z5otEu/4LZXOZ68bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <willdeacon@google.com>,
	Will McVicker <willmcvicker@google.com>,
	Youngmin Nam <youngmin.nam@samsung.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 046/627] arm64: dts: exynos: gs101: Add local-timer-stop to cpuidle nodes
Date: Tue, 12 Aug 2025 19:25:41 +0200
Message-ID: <20250812173421.089391531@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <willdeacon@google.com>

[ Upstream commit b649082312dd1a4c3989bbdb7c25eb711e9b1d94 ]

In preparation for switching to the architected timer as the primary
clockevents device, mark the cpuidle nodes with the 'local-timer-stop'
property to indicate that an alternative clockevents device must be
used for waking up from the "c2" idle state.

Signed-off-by: Will Deacon <willdeacon@google.com>
[Original commit from https://android.googlesource.com/kernel/gs/+/a896fd98638047989513d05556faebd28a62b27c]
Signed-off-by: Will McVicker <willmcvicker@google.com>
Reviewed-by: Youngmin Nam <youngmin.nam@samsung.com>
Tested-by: Youngmin Nam <youngmin.nam@samsung.com>
Fixes: ea89fdf24fd9 ("arm64: dts: exynos: google: Add initial Google gs101 SoC support")
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Tested-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20250611-gs101-cpuidle-v2-1-4fa811ec404d@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/exynos/google/gs101.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/google/gs101.dtsi b/arch/arm64/boot/dts/exynos/google/gs101.dtsi
index 48c691fd0a3a..94aa0ffb9a97 100644
--- a/arch/arm64/boot/dts/exynos/google/gs101.dtsi
+++ b/arch/arm64/boot/dts/exynos/google/gs101.dtsi
@@ -155,6 +155,7 @@ ananke_cpu_sleep: cpu-ananke-sleep {
 				idle-state-name = "c2";
 				compatible = "arm,idle-state";
 				arm,psci-suspend-param = <0x0010000>;
+				local-timer-stop;
 				entry-latency-us = <70>;
 				exit-latency-us = <160>;
 				min-residency-us = <2000>;
@@ -164,6 +165,7 @@ enyo_cpu_sleep: cpu-enyo-sleep {
 				idle-state-name = "c2";
 				compatible = "arm,idle-state";
 				arm,psci-suspend-param = <0x0010000>;
+				local-timer-stop;
 				entry-latency-us = <150>;
 				exit-latency-us = <190>;
 				min-residency-us = <2500>;
@@ -173,6 +175,7 @@ hera_cpu_sleep: cpu-hera-sleep {
 				idle-state-name = "c2";
 				compatible = "arm,idle-state";
 				arm,psci-suspend-param = <0x0010000>;
+				local-timer-stop;
 				entry-latency-us = <235>;
 				exit-latency-us = <220>;
 				min-residency-us = <3500>;
-- 
2.39.5



