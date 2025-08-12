Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B9026FA77;
	Tue, 12 Aug 2025 19:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025581; cv=none; b=NRD+5ZJEefaUvPjDhMAjNCYWjIOI4Md23SCVe9pGN8B0E80b7sy2jvd9sBTFAdx5YPsJVDBq41XrANqns8SpmLMW5fzWuiHEj1i4kHVh5jd2UPYGpKIbjMSQCjRqVypqFsYJHyvUxon6iEUY3Hyqa4JKT4fxgtYWdwXHA3XyymM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025581; c=relaxed/simple;
	bh=8AOco4iVg4ynueMB0/jJg8Tx1AtNlva+GqVZOTMQNFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syngs/k2hi+fiSYq5OVDTdnnsVNjpwYjmCPQPhRCgVPfsa/uHxOWeoqeA4OIgbwwiq16WMHPjZmTrXbnt7du3IYmQ4nmQ1q+YdzUfZK+Jo4/oCmO0fXRx3LvZDL0Y1r0k42L4Dx0fv1tSRzNHWO+wvVVlFZfLzzu2kPPyXyanlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFAH5cNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFAH5cNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C58C4CEF0;
	Tue, 12 Aug 2025 19:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025581;
	bh=8AOco4iVg4ynueMB0/jJg8Tx1AtNlva+GqVZOTMQNFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFAH5cNT7lb1lV9tiv6V9k/RRIApIS+5kJ4l0RGE9OWHfZKac8sa4DtLtV6D4qdaR
	 yCJuRQSyMeKtadShvUcHfMqxj41AGCbCwut7ubVPZ+vFUHeI1Loqx219g6MnD6bwKz
	 ZBSpl82lFRH8f1dEoTJBFG1VzsJrwjh5YsU8ZLOQ=
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
Subject: [PATCH 6.15 040/480] arm64: dts: exynos: gs101: Add local-timer-stop to cpuidle nodes
Date: Tue, 12 Aug 2025 19:44:08 +0200
Message-ID: <20250812174359.059256355@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3de3a758f113..fd0badf24e6f 100644
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



