Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD28823A995;
	Tue, 30 Sep 2025 15:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246180; cv=none; b=rDAS/JgDAWCrkU1ZhNTmE7YqVJvlm8PPjrNkiaPde12nly8Gx6BAy+ZpzqKWZHqUPhF1apYaFgdLUV6swssROlPqZaXDZh4vDUltCo/9uxLzrqBxLovd3oa9cwR6O385bNRSno6RvkRHto8sMpVAUzi6LzcJNBrsAK6Pyy6YUMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246180; c=relaxed/simple;
	bh=Z2WWmLDcmG4dkeHIniZtgbDYB6oReLRNqbCKfZzy5Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlVIE4YX41GHsyxPfO+w0uCEj904dyjymsu7W7ohYc6fKfy/3an4L2k4j5WklSl7DEr/BLKpHwKadgdIThvAa5/VUB3byqIl3U/QwVWWYoiEWnCuk9ckjGUsLd0TO6hWRiiFNHmmniS9uiIp8ptlKclEcp1Wq/1FDUb+Fmw3Ads=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsjH7tnz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsjH7tnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CF6C4CEF0;
	Tue, 30 Sep 2025 15:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246180;
	bh=Z2WWmLDcmG4dkeHIniZtgbDYB6oReLRNqbCKfZzy5Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsjH7tnzv77gbTTnqUI8MVX+yCBU2Qid+Bt3BRLlwhC5z/kyK44Ejw7jqyQPeIP90
	 eHtmHM7U9cc2sN4sEjQElsrSXFo8DL8UTT5n2qyLaXDKvnsu1wp+DTtxyTbXx24maC
	 9fn9xlwsE2TxJfWb/WmKPKM0eGvWOpqVBtpdbIvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 6.12 78/89] arm64: dts: marvell: cn9132-clearfog: disable eMMC high-speed modes
Date: Tue, 30 Sep 2025 16:48:32 +0200
Message-ID: <20250930143825.127841062@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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
 arch/arm64/boot/dts/marvell/cn9132-sr-cex7.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/cn9132-sr-cex7.dtsi b/arch/arm64/boot/dts/marvell/cn9132-sr-cex7.dtsi
index afc041c1c448..bb2bb47fd77c 100644
--- a/arch/arm64/boot/dts/marvell/cn9132-sr-cex7.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9132-sr-cex7.dtsi
@@ -137,6 +137,14 @@ &ap_sdhci0 {
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
 
-- 
2.51.0



