Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE051487F4;
	Tue, 30 Sep 2025 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244797; cv=none; b=pxU71VIHT5OgUw14kS4k+FRO2zCCMlFXZdYTMpMzfb06vnBFkjpjK7gxqx6DgYiOPoFjEsok76nMRuaVhePu11L96/E2IeFwiokBHOAPzCORCyZ5Owv7l3BNBQA78cZFD1OyBsxcIihrLHYtZs8pufPSONudrIU91S13Gl/qP6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244797; c=relaxed/simple;
	bh=PbPoiT0gEnRxgy5pXeFipt6ejA0tfyyBPbOzcGtQg24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWe/4RdIrvfRkGsQMbARIsaGj5oopUNIcASUA4zJd5M/d0PgQZf8+/mvn99eX7nbosCt9u2pZhXVO3RwnWdoiN3EL1nyPXJdHBESCzbLnMrgC7ioE8BjX0SBlWHKVPQNTxQjLsvIvcOTXfcWlm/tvfamxcfeQXYs5lLaKFepzoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBPfqJ3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBPfqJ3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4962DC4CEF0;
	Tue, 30 Sep 2025 15:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244796;
	bh=PbPoiT0gEnRxgy5pXeFipt6ejA0tfyyBPbOzcGtQg24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBPfqJ3MV8PDlrLZ4BKmnWHI3G4rwYhnkb2AotawhEUqd1vNQbnxvkkcKhBU0Zw4K
	 1rBDyynZwDdUxgA+R6MTsNbOnW3D2nIoj2KqDnh82RIUPCIONQzzftgrsFSzCXHE8T
	 eZEHR1tiw5JLLdS26FcxktGK1rEPl4sJQrJMyggk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 6.16 116/143] arm64: dts: marvell: cn9132-clearfog: disable eMMC high-speed modes
Date: Tue, 30 Sep 2025 16:47:20 +0200
Message-ID: <20250930143835.855007681@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

commit 48b51799a5461707705454568453618cdd7307f4 upstream.

Similar to MacchiatoBIN the high-speed modes are unstable on the CN9132
CEX-7 module, leading to failed transactions under normal use.

Disable all high-speed modes including UHS.

Additionally add no-sdio and non-removable properties as appropriate for
eMMC.

Fixes: e9ff907f4076 ("arm64: dts: add description for solidrun cn9132 cex7 module and clearfog board")
Cc: stable@vger.kernel.org
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/marvell/cn9132-sr-cex7.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm64/boot/dts/marvell/cn9132-sr-cex7.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9132-sr-cex7.dtsi
@@ -137,6 +137,14 @@
 	pinctrl-0 = <&ap_mmc0_pins>;
 	pinctrl-names = "default";
 	vqmmc-supply = <&v_1_8>;
+	/*
+	 * Not stable in HS modes - phy needs "more calibration", so disable
+	 * UHS (by preventing voltage switch), SDR104, SDR50 and DDR50 modes.
+	 */
+	no-1-8-v;
+	no-sd;
+	no-sdio;
+	non-removable;
 	status = "okay";
 };
 


