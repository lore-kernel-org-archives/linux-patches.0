Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DC126F2BD;
	Tue, 16 Dec 2025 12:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887676; cv=none; b=lYLGHdIgQFCggdz/fyVDZmnqaLMP1JtKU+s9zn3jpf05KB38Dr8+H+9pFYazIk8QC8OQSN9zn0mYW/6fL05hzXcdMjavEdLu8V3t1MA8lbeVpqWF8Faa70Ls+Qpx2JUC5nyp0w5hnX4f0zL8oAiPzirJrbdWWQv+OsRNslA4Ygs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887676; c=relaxed/simple;
	bh=pNHnxVF7qr9enlU9+hvX7kzvPdCCWFPJeDtTNB9oqxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlUHtCYsCuARQ8RpfR8J+ARlb5SVqPhKE3NVVGzbCL6qOlziEabEj4EEG6tyhrxMCSDOsTDZTel4I3xepm7PtOtTCjqFtv3UWUp2q1bgBVb16AF5daNPuNKXlTHATsqIpjzvQfuWZRSrtPLZVYpyIg40I1xC0lCjm89ZVcsBoo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtOYTcMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtOYTcMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE66C4CEF1;
	Tue, 16 Dec 2025 12:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887676;
	bh=pNHnxVF7qr9enlU9+hvX7kzvPdCCWFPJeDtTNB9oqxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtOYTcMJfA1Y0Q0hDbHO00USvSCZq6nTnEgVKFJl2NNLNewld3hRfYqQsBgDRRgKO
	 hMG3UXz4CU5Ve59j4W8ahSMBy/LQpnNSMA7OcJVnuYHSkyAgBcFTW53YmZ+FbEWrUt
	 2HPVrE3bZa/eWZSVpvQ+asgBdqK0+Zv4A1/Eu8MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 277/614] arm64: dts: rockchip: Move the EEPROM to correct I2C bus on Radxa ROCK 5A
Date: Tue, 16 Dec 2025 12:10:44 +0100
Message-ID: <20251216111411.411695395@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit 92e6e0b0e595afdda6296c760551ad3ffe9d5231 ]

The BL24C16 EEPROM chip found on Radxa ROCK 5A is connected to the
i2c0 bus, [1] so move the eeprom node from the i2c2 bus to the i2c0
bus.

[1] Link: https://dl.radxa.com/rock5/5a/docs/hw/radxa_rock5a_V1.1_sch.pdf p.19

Fixes: 89c880808cff8 ("arm64: dts: rockchip: add I2C EEPROM to rock-5a")
Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://patch.msgid.link/20251112035133.28753-2-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts b/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
index 19a08f7794e67..428c6f0232a34 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
@@ -228,6 +228,12 @@ regulator-state-mem {
 			regulator-off-in-suspend;
 		};
 	};
+
+	eeprom: eeprom@50 {
+		compatible = "belling,bl24c16a", "atmel,24c16";
+		reg = <0x50>;
+		pagesize = <16>;
+	};
 };
 
 &i2c2 {
@@ -249,12 +255,6 @@ regulator-state-mem {
 			regulator-off-in-suspend;
 		};
 	};
-
-	eeprom: eeprom@50 {
-		compatible = "belling,bl24c16a", "atmel,24c16";
-		reg = <0x50>;
-		pagesize = <16>;
-	};
 };
 
 &i2c3 {
-- 
2.51.0



