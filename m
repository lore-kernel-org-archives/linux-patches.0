Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E515F207670;
	Fri,  6 Dec 2024 15:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498512; cv=none; b=KV32FI5xIv12p6+3TDJB1Ek379MbAoXNmH6e0MsH2f5XU0joujxKQU7LcWgxoumX+LWP4BAYFZ3fP2mLZC4lbfY06b3BvHnOWfqrz3WKOuMnkc9lyRN/o+bCYLcPfKkG1dB4ghXuVMIk1XhbiqPsegKvRsbdCn131qbBlbL5rFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498512; c=relaxed/simple;
	bh=bXzbPA7NmRuvbAG0H2TH00PCrkvaQyjbg/EeFDkEHPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlvFnkx1GATHMBxzLbzjipbbmStugb9nAZ1DdJvniLjFmyd5otZbczAIhQVVWVIZOo9ARvJJ0EITlP28ea/rR7dL5eYxJgH6S6wZrLExGzRYBHKqZgXYDXt3zHmeZiatLJAYhzs1h/CkFXG7YRi5QnMH2pVjCqK5uvU20kQvSwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zYvAOjA2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYvAOjA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F453C4CED1;
	Fri,  6 Dec 2024 15:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498511;
	bh=bXzbPA7NmRuvbAG0H2TH00PCrkvaQyjbg/EeFDkEHPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYvAOjA2k1niikxjZ5LGKp7NZQ7fnYc4nNAORGGZJxaJ2KB8DY1FDXfMTsICf79IA
	 QVk/tOmVNcEWh0HoSuDgYeob6a0JtvySkqduOLLmcZ17F70QCBAOqslrJsNc+7JX+p
	 KTRICx2ckbqWEq23Ik8IJ7gfge0MHLdT9C+6SonI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Jirman <megi@xff.cz>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH 6.6 606/676] arm64: dts: allwinner: pinephone: Add mount matrix to accelerometer
Date: Fri,  6 Dec 2024 15:37:05 +0100
Message-ID: <20241206143717.045225291@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


