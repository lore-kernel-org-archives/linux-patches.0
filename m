Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9823248F57;
	Tue, 21 Jul 2026 15:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649361; cv=none; b=oB/5QGy3mAHgcmKTtznRHMxFIAbGhLvc21K6NuoHj0sgJ72Vw7zLiH8PvyohQRiwYUpcvR3Un59iHcVR8gvgWmHcPzvGnOEfBwHs4XJPH4sA66bknXes+CW70FUyyvtqw+2Jf0545WqHSkQsGVhLz4Lp5zqe6LgK8c/Aaruj2s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649361; c=relaxed/simple;
	bh=88teEp5L7cBCTpw6IYdnZco7HsJcm2LW6iVuA7xLIs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRadiiYeOJXjG4U9RVhz10YR9oY5b4verWANXCtoP3+q1uN4kxJ7oVrS+HmlMtWax+d27fEbgXbY1g4kjTMxKjRemEFz00xGIhgHT9Z+g0OUIs3XvANehCfqnxCOznnbQ3N0vmoY/ZIGozGlCL7sbqOmMB3v96ZO05BuuJuAaLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2RmEtBG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2RmEtBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB201F00A3A;
	Tue, 21 Jul 2026 15:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649360;
	bh=Rnik00LWKvs50JmF8s4GaUWhiQJAY4YS/vkqZX4RINk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2RmEtBGyYLpxji6RvUMV4lqhIwnx+SFLS4tZM3rh++EsWerYPSLTd4FYSK/8+aVf
	 75dtTwtDx6qUTRcPT+2b8lLzAPQA8rqZUmpZ8rBffOAzhYmYdGUwCuwqlyvbLdXimh
	 2ODWERqHaejkdl01Z97eT0qZJldLS/8+1ND8zt5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0506/2077] arm64: dts: tqma8mpql-mba8mpxl: configure sai clock in audio codec as well
Date: Tue, 21 Jul 2026 17:02:59 +0200
Message-ID: <20260721152604.749330423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 890d1e525a4896..6b0f944095e7c4 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
@@ -609,6 +609,9 @@ tlv320aic3x04: audio-codec@18 {
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



