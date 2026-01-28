Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8092857CD;
	Wed, 28 Jan 2026 15:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615678; cv=none; b=fwHTowmfETD5cNCd2+LSWzT8Yunc06vpGAKqEMOklVtQ8365fOZ3GnF8irnLoPO5yLRrw0dzOmZEKWd0yJHgiqDxTVE6jTLAWaThjykNWKniEkkSxlmyYa65w4EppTJDz4rmldkkTMUY6ZrMjQPfBMzrJljjdCB743smrado7rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615678; c=relaxed/simple;
	bh=06VOZPNSo0B7Ujb7CIIhIXuG/+nv1GZWlGQ3dgsHBOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XknvcTfoPYb6kcckZe+S03oGWV3yrmcbreHM7ukQMCvYhpc6pHUpSkBsEsmLzyJvHqiZh0uMM6DLPErUkZgXU8E/gZIKORXeGnt+1H0iIx2MDgxG8riykvOt5l3iEIy2w+miv7THaKNZcsuZ079Cw9em9zyuiaUHqD/HZYVyfjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpYbK68x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpYbK68x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44987C4CEF7;
	Wed, 28 Jan 2026 15:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615678;
	bh=06VOZPNSo0B7Ujb7CIIhIXuG/+nv1GZWlGQ3dgsHBOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JpYbK68xgrkq+XxApjs2b4ILv4Q8R51QtVQkXRkNTMNsWXBs2KNhPhOtZCXz56Ieh
	 8PY1Q6VnBfAv0HBYnrTMX8Ib+WZs7TUrCDx2fHid0zVhRC9I9uUcb2IP15dIORW5nE
	 X6pdiKa7+pyb875WQKYbkHIRq7M+1OgS9kC0C1YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Jirman <megi@xff.cz>,
	Rudraksha Gupta <guptarud@gmail.com>,
	Pavel Machek <pavel@ucw.cz>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.18 064/227] arm64: dts: rockchip: Fix voltage threshold for volume keys for Pinephone Pro
Date: Wed, 28 Jan 2026 16:21:49 +0100
Message-ID: <20260128145346.645020168@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Jirman <megi@xff.cz>

commit 5497ffe305b2ea31ae62d4a311d7cabfb671f54a upstream.

Previously sometimes pressing the volume-down button would register as
a volume-up button. Match the thresholds as shown in the Pinephone Pro
schematic.

Tests:

~ $ evtest
    // Mashed the volume down ~100 times with varying intensity
    Event: time xxx, type 1 (EV_KEY), code 114 (KEY_VOLUMEDOWN), value 1
    Event: time xxx, type 1 (EV_KEY), code 114 (KEY_VOLUMEDOWN), value 0
    // Mashed the volume up ~100 times with varying intensity
    Event: time xxx, type 1 (EV_KEY), code 115 (KEY_VOLUMEUP), value 1
    Event: time xxx, type 1 (EV_KEY), code 115 (KEY_VOLUMEUP), value 0

Fixes: d3150ed53580 ("arm64: dts: rockchip: Add support for volume keys to rk3399-pinephone-pro")
Cc: stable@vger.kernel.org
Signed-off-by: Ondrej Jirman <megi@xff.cz>
Signed-off-by: Rudraksha Gupta <guptarud@gmail.com>
Reviewed-by: Pavel Machek <pavel@ucw.cz>
Link: https://patch.msgid.link/20251124-ppp_light_accel_mag_vol-down-v5-4-f9a10a0a50eb@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
@@ -40,13 +40,13 @@
 		button-up {
 			label = "Volume Up";
 			linux,code = <KEY_VOLUMEUP>;
-			press-threshold-microvolt = <100000>;
+			press-threshold-microvolt = <2000>;
 		};
 
 		button-down {
 			label = "Volume Down";
 			linux,code = <KEY_VOLUMEDOWN>;
-			press-threshold-microvolt = <600000>;
+			press-threshold-microvolt = <300000>;
 		};
 	};
 


