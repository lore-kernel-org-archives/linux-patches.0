Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A46915A4AB;
	Mon, 29 Jan 2024 17:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548064; cv=none; b=Q8hwfBvdo/YiMe+tOej3aErB1Fk2HQQNgnU0XpziaD//Ftr5js+cfxJJVW7yVC95UT0P4PBsTA5Q1/TQ6KwKBumdc28LraFj9vzEuWub+Ayr6I/f4w4H7vE2CfMTJd73cFSj525S9GXY9r0ndPBJzpgMpMII59UM/rJbXCSoPwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548064; c=relaxed/simple;
	bh=yD1+wGRS7r5Sh/ZGEnPTd9kPJR8xfzpLYg0SwGL8nPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtnjJ3YtSRWQIlSuiCfJrx+ojHmB0q21zVIrJK5JnS4vFsa/k+WiJYxP41SYkuG7JFjimC8+ChsYJa+UjqEFX1hH79xS2JECa8FL83T+2BROQwtDwvn21AUjKyYMa/vpMrg8EpuGs+e/Et7bnDGA0pwKgXCZJA21p3Cf070fmwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpCH2Beb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpCH2Beb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414F0C433C7;
	Mon, 29 Jan 2024 17:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548064;
	bh=yD1+wGRS7r5Sh/ZGEnPTd9kPJR8xfzpLYg0SwGL8nPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpCH2Beb4Z+osUZXH8tYhK9zYpXMjdZ6/7h4j6J2tdwWGZ+lYiBc78H41Fba1peEd
	 bLzRhkROLFz9SSIGlGVbuPTtMceYUwA7NGugU5VVQGCkmrwJlVtP00bSmLm9u+RsDY
	 0FyPWtyRm3yvgGeF7Cyp5Dtr14XLRMuawME58bLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianling Shen <cnsztl@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.7 071/346] arm64: dts: rockchip: configure eth pad driver strength for orangepi r1 plus lts
Date: Mon, 29 Jan 2024 09:01:42 -0800
Message-ID: <20240129170018.475081121@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianling Shen <cnsztl@gmail.com>

commit fc5a80a432607d05e85bba37971712405f75c546 upstream.

The default strength is not enough to provide stable connection
under 3.3v LDO voltage.

Fixes: 387b3bbac5ea ("arm64: dts: rockchip: Add Xunlong OrangePi R1 Plus LTS")
Cc: stable@vger.kernel.org # 6.6+
Signed-off-by: Tianling Shen <cnsztl@gmail.com>
Link: https://lore.kernel.org/r/20231216040723.17864-1-cnsztl@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3328-orangepi-r1-plus-lts.dts |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3328-orangepi-r1-plus-lts.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-orangepi-r1-plus-lts.dts
@@ -26,9 +26,11 @@
 			compatible = "ethernet-phy-ieee802.3-c22";
 			reg = <0>;
 
+			motorcomm,auto-sleep-disabled;
 			motorcomm,clk-out-frequency-hz = <125000000>;
 			motorcomm,keep-pll-enabled;
-			motorcomm,auto-sleep-disabled;
+			motorcomm,rx-clk-drv-microamp = <5020>;
+			motorcomm,rx-data-drv-microamp = <5020>;
 
 			pinctrl-0 = <&eth_phy_reset_pin>;
 			pinctrl-names = "default";


