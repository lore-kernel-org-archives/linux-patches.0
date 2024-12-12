Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4682F44;
	Thu, 12 Dec 2024 16:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020498; cv=none; b=nTnTAfCJHzY5vo1btDZ0M+KrTgOCPy7zVf7g+KKm54J/wMcR2C2FaMcjWurcpo1bcvtzkPvjTq2FbOgCNQCx/wzH/ng+CKlqZZrGKOuwle+qmsM+bYc/k+yuPP4DgBN74ZW4HVrDpkgeaH5mhUtDy5fXUhYIymxUjjjxMD1FjKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020498; c=relaxed/simple;
	bh=gpRvmCpDSIY9qsAV06JMhwNg4sTrkMHpMjnBdpgl2VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X28mAonFf9llTcE4y89P9ojnzuIcQb4KktLVOFC4cIB4f8WCCj7Votit+oEvip31wJdTygyADknJooyq5d8Qld6h99bP+s5W0GLVDTTOj2gEAzDhc4FLmXs9MvC+DXbHJrVzrxG0mG9DXbxik2K3M9Hb559NkH1UVeYeJHT0S3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uEs5UVeZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEs5UVeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73E3C4CECE;
	Thu, 12 Dec 2024 16:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020498;
	bh=gpRvmCpDSIY9qsAV06JMhwNg4sTrkMHpMjnBdpgl2VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEs5UVeZ+sJk+JJfjEP6szniuYa/tYuAFUrqsXnZjzz5p2J5C3qfNvpQh+zeyp3ZP
	 Mbxt3mFUZaPmRrxj8apktWQNMXotcolWc+ehMKvwz2sCL2jM4ah30WKNtoGZdAWW4i
	 MpIrSFvTqdkXN1wVKhEwZOvV0fv3ebszELBpqbOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Jirman <megi@xff.cz>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH 6.1 455/772] arm64: dts: allwinner: pinephone: Add mount matrix to accelerometer
Date: Thu, 12 Dec 2024 15:56:40 +0100
Message-ID: <20241212144408.727057545@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Dragan Simic <dsimic@manjaro.org>

commit 2496b2aaacf137250f4ca449f465e2cadaabb0e8 upstream.

The way InvenSense MPU-6050 accelerometer is mounted on the user-facing side
of the Pine64 PinePhone mainboard, which makes it rotated 90 degrees counter-
clockwise, [1] requires the accelerometer's x- and y-axis to be swapped, and
the direction of the accelerometer's y-axis to be inverted.

Rectify this by adding a mount-matrix to the accelerometer definition in the
Pine64 PinePhone dtsi file.

[1] https://files.pine64.org/doc/PinePhone/PinePhone%20mainboard%20bottom%20placement%20v1.1%2020191031.pdf

Fixes: 91f480d40942 ("arm64: dts: allwinner: Add initial support for Pine64 PinePhone")
Cc: stable@vger.kernel.org
Suggested-by: Ondrej Jirman <megi@xff.cz>
Suggested-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Link: https://patch.msgid.link/129f0c754d071cca1db5d207d9d4a7bd9831dff7.1726773282.git.dsimic@manjaro.org
[wens@csie.org: Replaced Helped-by with Suggested-by]
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone.dtsi
@@ -202,6 +202,9 @@
 		interrupts = <7 5 IRQ_TYPE_EDGE_RISING>; /* PH5 */
 		vdd-supply = <&reg_dldo1>;
 		vddio-supply = <&reg_dldo1>;
+		mount-matrix = "0", "1", "0",
+			       "-1", "0", "0",
+			       "0", "0", "1";
 	};
 };
 


