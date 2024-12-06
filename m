Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F31014A4D1;
	Fri,  6 Dec 2024 14:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496067; cv=none; b=b0t1cC/WtJAhBBBko5yOsM54mmG8cAYphHMj5KHy+L6OaQU+gkgKg3u8CSUrd+tJR9b7sRqHIB+JGsxC7ubwV8is3crsmew3osQQ0BpZhdAIX9bujKKfAES/uwcZ6bnNcMkFCeIL3SUzOX0N8NMX+HmQqqP7F/TwLRfgUGg157w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496067; c=relaxed/simple;
	bh=/Zxua1gBqhexiPnGLBBAC59LjZJrsAUWSQUgfYLNo9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cl2IadizBK6sZWwNo1S2/lMAdQMEa4mM7kbjmD2iRuUzaXGT/pLYtXgc6VhZDjh1V8ceEhG7mdfw+7dyVV4Ida4AYtyrx7fzfICAVEGja9kR7U18AikJ0o2C4PYC57TK65EQjhizIcl0/f75ntG4RCcqoI8dsQ+xMgEXnwqZA6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABtWuOSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABtWuOSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C47C4CEDC;
	Fri,  6 Dec 2024 14:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496067;
	bh=/Zxua1gBqhexiPnGLBBAC59LjZJrsAUWSQUgfYLNo9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABtWuOSeyP0lHOMFWAbyKJ7AiiTSIqgt2nlcknqgczloOxzYcUFYjvaHW1UwDHdAX
	 htFIZkr+6jqen3GNUj8gOf9Com554kwR4lRyStCN91RSmZg1kcWTYuKQMaIDJWxNKq
	 y+WLqWrxflWS0E4qjTy3sZIG0T0oNI2eB0vAs1aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Jirman <megi@xff.cz>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH 6.12 014/146] arm64: dts: allwinner: pinephone: Add mount matrix to accelerometer
Date: Fri,  6 Dec 2024 15:35:45 +0100
Message-ID: <20241206143528.218168204@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -212,6 +212,9 @@
 		interrupts = <7 5 IRQ_TYPE_EDGE_RISING>; /* PH5 */
 		vdd-supply = <&reg_dldo1>;
 		vddio-supply = <&reg_dldo1>;
+		mount-matrix = "0", "1", "0",
+			       "-1", "0", "0",
+			       "0", "0", "1";
 	};
 };
 


