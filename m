Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57B0151988;
	Wed,  5 Feb 2025 14:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766241; cv=none; b=DdmQiXehkL+D+vI8i8RmWhM8wvVaOxUSBi2wvPS634smdTlSj/PYjbrywR6Xb0l4n45kDFcRCGry6sw8fh6R9dpTjOway3zlQ2b0al+EpmxEwwMJbZoc7xHPxSeatR4RWhorv0Jbq1vAHi7rNRqKZ7RXfmV1trJDbaT9dizT0ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766241; c=relaxed/simple;
	bh=cBgMKxViKgOerqMd3sFJg+7Ae9mZWjXuV/Tqz2u3SjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrCDlM8o82o6ZoRjeMteAmAKg5f4CbxaIDRir3MH/8p7cIC0HYXEoOZfsT4LwxvxyTEDQRQk62ZnI4vX4O3YsTIIX0uCEItEIyfnoYMaXRDDB7HzTwUNu36VNxg/kkUdN5D9/JJ9UD8yiSZ/0mk9JfLWZEblA5RNsZykp61z5+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMUbX74h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMUbX74h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BABC4CED1;
	Wed,  5 Feb 2025 14:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766241;
	bh=cBgMKxViKgOerqMd3sFJg+7Ae9mZWjXuV/Tqz2u3SjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMUbX74hLIMFaboo/eVRU2R33dY0OxKvL2d1o7Q0StrJeNNZq8+30QFL2ugGnDXck
	 vCkjssKdcKAq3Fbc1NYzchnb+Uin+cSv8qePvLc66DbOE9uzBPKw2WyiNvJJZRLDmj
	 RkjB3Qr90oElEntcy0aa+hBQiRMbYXybL/6t0eZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Markus Niebel <markus.niebel@ew.tq-group.com>,
	Bruno Thomsen <bruno.thomsen@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 303/590] ARM: dts: imx7-tqma7: add missing vs-supply for LM75A (rev. 01xxx)
Date: Wed,  5 Feb 2025 14:40:58 +0100
Message-ID: <20250205134506.871016672@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 78e08cebfe41a99d12a3a79d3e3be913559182e2 ]

Add missing supply for LM75. Fixes the kernel warning:
  lm75 0-0048: supply vs not found, using dummy regulator

Fixes: c9d4affbe60a ("ARM: dts: imx: tqma7: add lm75a sensor (rev. 01xxx)")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Markus Niebel <markus.niebel@ew.tq-group.com>
Reviewed-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi b/arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi
index 028961eb71089..91ca23a66bf3c 100644
--- a/arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi
@@ -135,6 +135,7 @@
 	lm75a: temperature-sensor@48 {
 		compatible = "national,lm75a";
 		reg = <0x48>;
+		vs-supply = <&vgen4_reg>;
 	};
 
 	/* NXP SE97BTP with temperature sensor + eeprom, TQMa7x 02xx */
-- 
2.39.5



