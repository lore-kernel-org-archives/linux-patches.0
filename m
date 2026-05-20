Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D6C3D8129;
	Wed, 20 May 2026 16:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295793; cv=none; b=Gar3KbD8eroBYOH+hZLkPrZ+Qye7EoB/+M0S+ygv558AyVRHdvwOEWmc6AlrkzVNMYBmT7PCHyluwG9F28vyxt9kvBeJZm4XxoNt7wKZIhCdbTK0zcYkStm9DbpZrYTtq6P4LUT6vKndseqyPpHRROxurYugWXeCqt+auedoI1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295793; c=relaxed/simple;
	bh=Aq3ABlbJiOp9hrqGveJQFZu3XTfIA/ep5mwOBoSw5WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGFlArEJN3twHD5wvRVKeBnzds1ZuGNk45SAVApEKEfS2QBgCFzP1w14V30Rhw+1dNlN0inRufFs9ty9L5j7EMpOvWm8e5WjoJqdxp96v8wjb2SUkpDuWaVjwmh+3i9moo+hlWR1tmQ8t4CePZGQ9mNS3XgSZHz/9hLK0EFX3bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JJnV7az; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JJnV7az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22C21F00893;
	Wed, 20 May 2026 16:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295790;
	bh=SngIPOWVT7jY+2RkHFpkz67aUGlhoLJs+g80suHuW1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JJnV7azsUfOeJCu/xFPDK+u4KyVZ6l8oTxls/okck26yXmhROd3r7Ct/lOaY4sbM
	 D/DeIc45RCGPdp5NGrRpONUsGazOJHPrxwdJPCQQp3lyd2uNEaxhYDCC7qGj51a4Te
	 EohvuhNUaJvt3rjplebYSHzhncL+jKTTlC1J/bDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0552/1146] arm64: tegra: Fix RTC aliases
Date: Wed, 20 May 2026 18:13:22 +0200
Message-ID: <20260520162200.671408259@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 69ec77b3f1074f3000d28f67f7629303e7999b84 ]

The following warning is observed on the Tegra234 Jetson platforms ...

 rtc-nvidia-vrs10 4-003c: /aliases ID 0 not available

This happens because the 'rtc@c2a0000' device is registered before the
vrs10 RTC and so is assigned the 'rtc0' alias. We want the vrs10 RTC to
be the default RTC because this RTC maintains time across power cycles.
Fix this by adding a 'rtc1' alias for the 'rtc@c2a0000' device.

Fixes: b1806f2b4e78 ("arm64: tegra: Add device-tree node for NVVRS RTC")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra234-p3701.dtsi | 1 +
 arch/arm64/boot/dts/nvidia/tegra234-p3767.dtsi | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234-p3701.dtsi b/arch/arm64/boot/dts/nvidia/tegra234-p3701.dtsi
index 58bf55c0e414c..c10d041c183be 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3701.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3701.dtsi
@@ -9,6 +9,7 @@ aliases {
 		mmc0 = "/bus@0/mmc@3460000";
 		mmc1 = "/bus@0/mmc@3400000";
 		rtc0 = "/bpmp/i2c/pmic@3c";
+		rtc1 = "/bus@0/rtc@c2a0000";
 	};
 
 	bus@0 {
diff --git a/arch/arm64/boot/dts/nvidia/tegra234-p3767.dtsi b/arch/arm64/boot/dts/nvidia/tegra234-p3767.dtsi
index ab391a71c3d33..9e9e80d57623c 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3767.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3767.dtsi
@@ -8,6 +8,7 @@ / {
 	aliases {
 		mmc0 = "/bus@0/mmc@3400000";
 		rtc0 = "/bpmp/i2c/pmic@3c";
+		rtc1 = "/bus@0/rtc@c2a0000";
 	};
 
 	bus@0 {
-- 
2.53.0



