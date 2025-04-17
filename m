Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DCD256C65;
	Thu, 17 Apr 2025 18:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915977; cv=none; b=UFcksaYPY220mw9C42YOtQjVXZvu69WX1U1AR28a/a8TLdziJFJ1b7cWSWBygwz44F7N+0TixwnbUMzZcdGWTkLRFZ0VVF5pDq3J+uYYkA6EuoE6Hig1//OtS9VUpZa1202hsob0JTTr5ZWQVro2jsffYd+5A3fDUfvZzK+QG/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915977; c=relaxed/simple;
	bh=izSzAxxhDsU+bTYLBak/mAtr/ZdLiHyaCcxml5M8IJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAC18EiooT0L70jZrpmOQ/twKUmCDUmmSNJHgDTLGleWzr7cq98wRDyRFzGBFy+dXPtSVVMozdIncyW3Jk1yX7LO87l6PM31+oTWyGbz0kDxIQNokRDyQ1xKynnLrBfApoaNINgJlqE6GlD5jolRBFFbW8gSmazcsnc3eB3tH60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBJF+TM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBJF+TM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E630C4CEE4;
	Thu, 17 Apr 2025 18:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915976;
	bh=izSzAxxhDsU+bTYLBak/mAtr/ZdLiHyaCcxml5M8IJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBJF+TM4szY02uamfe0T9abv+PMIGF/qsC5CxgWRGaEQ/8vQOwoN5R2IaawI/qr33
	 m0oGAhcxJ5BV5ot4TxCpsIOhcfeWfB+dPc8S5czQf5kq1nTKxnwRGji5dtPr/6tmIg
	 BCficZMlWOimzPs+7qhUbKjngZJaCKZmqVaFhDs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ninad Malwade <nmalwade@nvidia.com>,
	Ivy Huang <yijuh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.12 285/393] arm64: tegra: Remove the Orin NX/Nano suspend key
Date: Thu, 17 Apr 2025 19:51:34 +0200
Message-ID: <20250417175119.075220866@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


