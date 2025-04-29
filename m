Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D7022AE68;
	Tue, 29 Apr 2025 18:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950219; cv=none; b=SDRQk5rddLh+HaoVrbgEbEbKbzPIvivB+pQCvLkLqbre5BbFg8vhSMvpJDL2h14Y2t8BNJGqeBDFC6x/XWJv14tMqQDefsXs7S8V07PJxztUmA+fgV9lGx9cHwT4YmWjFrfnFPN6roXmeTasihoxfg2tVtpSJSLlFsRfgTBmfuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950219; c=relaxed/simple;
	bh=OZaIftCPA/bbzS9+l4BTmxIVmGCMD8GrpLns/nn/YY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bi6f7CxTVrzKgHNpjvlH3Otpfujdjvm2EPf/V+ivXsgmCgMJp4j49LRef4G0Rhbggb7ZeNW6IElqdJ39wjqtzpJQBsIkC24V+sQf07IrZqj+HsiVUovDToCL7l6DsBKhxz4RaWg6rqBPAqxQbbs5KxuXI29YwvTgv4fynLRsQkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHaj5l6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHaj5l6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8DDC4CEE3;
	Tue, 29 Apr 2025 18:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950219;
	bh=OZaIftCPA/bbzS9+l4BTmxIVmGCMD8GrpLns/nn/YY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHaj5l6iryyJmwV9vF/TMpWzSfG1BvODeS0NJsNLBPNUdax+DgvGwGsHyPk4WamH0
	 w6sYWWbEEJlVubdAZ8eHwmLgbAzNR/DEuDF8Msf2tG4zzJQF/glJxA5mnhXN9iTlvM
	 iJ0O4jSBMTLNzUwFbY/CjK2+ZjYACW3RUdVVdEzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ninad Malwade <nmalwade@nvidia.com>,
	Ivy Huang <yijuh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/204] arm64: tegra: Remove the Orin NX/Nano suspend key
Date: Tue, 29 Apr 2025 18:41:53 +0200
Message-ID: <20250429161100.448661343@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

From: Ninad Malwade <nmalwade@nvidia.com>

[ Upstream commit bb8a3ad25f098b6ea9b1d0f522427b4ad53a7bba ]

As per the Orin Nano Dev Kit schematic, GPIO_G.02 is not available
on this device family. It should not be used at all on Orin NX/Nano.
Having this unused pin mapped as the suspend key can lead to
unpredictable behavior for low power modes.

Orin NX/Nano uses GPIO_EE.04 as both a "power" button and a "suspend"
button. However, we cannot have two gpio-keys mapped to the same
GPIO. Therefore remove the "suspend" key.

Cc: stable@vger.kernel.org
Fixes: e63472eda5ea ("arm64: tegra: Support Jetson Orin NX reference platform")
Signed-off-by: Ninad Malwade <nmalwade@nvidia.com>
Signed-off-by: Ivy Huang <yijuh@nvidia.com>
Link: https://lore.kernel.org/r/20250206224034.3691397-1-yijuh@nvidia.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra234-p3768-0000.dtsi | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234-p3768-0000.dtsi b/arch/arm64/boot/dts/nvidia/tegra234-p3768-0000.dtsi
index 39110c1232e0d..db10b4b46cca9 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3768-0000.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3768-0000.dtsi
@@ -196,13 +196,6 @@ key-power {
 			wakeup-event-action = <EV_ACT_ASSERTED>;
 			wakeup-source;
 		};
-
-		key-suspend {
-			label = "Suspend";
-			gpios = <&gpio TEGRA234_MAIN_GPIO(G, 2) GPIO_ACTIVE_LOW>;
-			linux,input-type = <EV_KEY>;
-			linux,code = <KEY_SLEEP>;
-		};
 	};
 
 	fan: pwm-fan {
-- 
2.39.5



