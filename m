Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BB2408039;
	Tue, 21 Jul 2026 19:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661930; cv=none; b=fY+x3zBjFxekdsYKAOnm63fQWeSQcnlvUqpPNDQ5C3OFrtPSfLWYijYqT7cQYm3pwgGuFZCuq06DCemHOYIObdDVcTsv2o3pfZ7qB+4cAWQtRNVZDcVFfok4Qba4NTzxbjBDRdO9oleKNgenOXqkStV6/acB3JK7+WwXrWoWI2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661930; c=relaxed/simple;
	bh=KDpVe2EkVdmQXFNHUI9AtgLejBfVhaGaCFMwEQKjMV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tveBYgiGKSPW+IYvcZqfdGYt4Jc/Et3IsxwzfWzchQzN0v04mViwVLTEkJV+z7eOwMJb40tT/RQyLLBsxwT0/Wxv7BjCkqcO770dWzF24mKElBGRqOu7l/43m/FmB2RuMZ9KX31koS60qRWZxhBfuwRB6kE0xu+2Tt63/eyqxdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFcLfVWM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFcLfVWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054691F000E9;
	Tue, 21 Jul 2026 19:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661929;
	bh=C/CKAlAB24/2m+Sr4gcWMwucRbFckQ4jebSAumWkR+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZFcLfVWMOkzBXugDfZfIxo/079rvHRNiuyZe9zNzGReGqcqFlUwr5dQcl7hAGSsAk
	 3Y+XcuG/V3hktPxy3O6agMGmd2IX1pA7CTITC6odCZsSCqY8wwFpUWoZRfaq3A3VFo
	 8Cu7rDDrBiUg7lPnKfqam4KYSPdhdqVruHZ3aL6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0252/1276] arm64: dts: tqma8mpql-mba8mpxl: configure sai clock in audio codec as well
Date: Tue, 21 Jul 2026 17:11:35 +0200
Message-ID: <20260721152451.727063556@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 748835fcb2eb2120234aef9556d282272501b96b ]

With deferrable card binding the sound card driver tries to
get the mclk configuration before it is setup in sai3 node.
Fix this by setting the sai clock config for the audio codec as well.

Fixes: d8f9d8126582 ("arm64: dts: imx8mp: Add analog audio output on i.MX8MP TQMa8MPxL/MBa8MPxL")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
index 773282002e6c67..2f52e32608861f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
@@ -518,6 +518,9 @@ tlv320aic3x04: audio-codec@18 {
 		reset-gpios = <&gpio4 29 GPIO_ACTIVE_LOW>;
 		iov-supply = <&reg_vcc_1v8>;
 		ldoin-supply = <&reg_vcc_3v3>;
+		assigned-clocks = <&clk IMX8MP_CLK_SAI3>;
+		assigned-clock-parents = <&clk IMX8MP_AUDIO_PLL1_OUT>;
+		assigned-clock-rates = <12288000>;
 	};
 
 	se97_1c: temperature-sensor@1c {
-- 
2.53.0



