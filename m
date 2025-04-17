Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C271CAA7D;
	Thu, 17 Apr 2025 18:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913424; cv=none; b=Ixu2AwKUsczwmc+HauZAX4pbB37yZYzrXc1OM5LaQwTPS1NZtSVNwhLRg2NNSkhIZmUvCs0S3Mdzhqf2VEjsgNkHMni5yyFYWiJ2AA5xGKltnixuma9FwI/czT9taY4vsPfPDvg3qCDywbUBX8H/mdlH6SPueBus0KdnpE2P/VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913424; c=relaxed/simple;
	bh=YeRP/gX0L6AzsFd6akOLoMRw5Ul42vpJiOznNkxrz/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jh7Zy4O14d4/oYYbE+Aa1kK27kT2OMtql2uduiMsJdfxzAniKfCZ9WK4C7jAv7t1N77kb8IfL7F11yOGaLW+C9i2/0FpBwQE8B8DSNhvshqpnEWYmSLxXX2N5ekjIXYehKAfFz6sS2TldFE7f4iaCUr0Kln023uuWA2kngdNUUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C14qtQuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C14qtQuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4BEC4CEE4;
	Thu, 17 Apr 2025 18:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913424;
	bh=YeRP/gX0L6AzsFd6akOLoMRw5Ul42vpJiOznNkxrz/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C14qtQuS0xgrqqe0Dj1Gr+Qhwk8ZQEhymmYHXKUwTkkQsexRpwgSu8/SCF24tRPgj
	 qdFBPkFLZGKe7PQYx4ZUPIjM3f5/fpr22YloGcaeSuARNWaW2ytN5T9rADT80P0hY7
	 2InXmpyRyvZSGwqieOWfF81dCHLJ50fA/osGPZKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ninad Malwade <nmalwade@nvidia.com>,
	Ivy Huang <yijuh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.14 335/449] arm64: tegra: Remove the Orin NX/Nano suspend key
Date: Thu, 17 Apr 2025 19:50:23 +0200
Message-ID: <20250417175131.665814998@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ninad Malwade <nmalwade@nvidia.com>

commit bb8a3ad25f098b6ea9b1d0f522427b4ad53a7bba upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767.dtsi |    7 -------
 1 file changed, 7 deletions(-)

--- a/arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767.dtsi
@@ -227,13 +227,6 @@
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


