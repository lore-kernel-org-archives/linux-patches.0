Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B108214227;
	Thu, 12 Dec 2024 17:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023564; cv=none; b=NR6pypeBICiHqpyJ8GnCV1NGPUf04KcLLhdBSElTLmihCUXz2frdzWSr/wRoVWFTQfFONJyg0J9JTXWh1sGEIAd7e0SsA3UZOpCDcmRs0+Fq1ATk8n1cHUa9M5gEIrdbqn2DyUg9ctkLLgq68J7rOCYSTZrlqLUDT89S791sq2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023564; c=relaxed/simple;
	bh=UXTPZ/pFaabT6l06MlbQ0kJ9GAuIwVgBFELBX5TSUxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptPYOp/FXUcnPwG+sY3j1mXNaoSJC0WD4qvZD0P3x5MZbFewDlvQBZXrkWmf/PWQAZtoJgwBRAcIp1C1WIt9Eg0e5AK5Ouwqyivr+is7YysC0kRkL9nXCdJpEEcvW7kPAdmrRJu2Sh9HQJded3GSGqtu2HKuqYsJWTSCLQAJyc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiRPZi4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiRPZi4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B519C4CED4;
	Thu, 12 Dec 2024 17:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023563;
	bh=UXTPZ/pFaabT6l06MlbQ0kJ9GAuIwVgBFELBX5TSUxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiRPZi4nbqJrGP+R5edcLIQXP3SyeiZqgbXuv0dipwryBygsZmQZX+PEDANsZllem
	 +8MKXoZiMc2BYXAvvNLd4IWdZtMrtHDx1kMc2oGpYF8aXLf/PfHlCdK1kSo78tid1E
	 QLDvD9hL8Vuqc6SVnPwbYPYQwXV+OBej6AC99VJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Jirman <megi@xff.cz>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH 5.10 001/459] arm64: dts: allwinner: pinephone: Add mount matrix to accelerometer
Date: Thu, 12 Dec 2024 15:55:39 +0100
Message-ID: <20241212144253.577185836@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -157,6 +157,9 @@
 		interrupts = <7 5 IRQ_TYPE_EDGE_RISING>; /* PH5 */
 		vdd-supply = <&reg_dldo1>;
 		vddio-supply = <&reg_dldo1>;
+		mount-matrix = "0", "1", "0",
+			       "-1", "0", "0",
+			       "0", "0", "1";
 	};
 };
 


