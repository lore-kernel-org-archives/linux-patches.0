Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E557C339B0
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/Odm7AE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FD0C433CC;
	Mon,  9 Oct 2023 13:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858769;
	bh=zv9LNt+6QfmAg2dQay6cQddcaewiIChmzsnJVMKE3MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/Odm7AEIbsASBnEZ0e49IhxYiG0tYYjvWQHD8KikmQkV9JQcDj/72rnqcL1FrQdn
	 66AJaxEgjtyIC1ZLvgdCmhJbaQ0QqWA4vxeuxRhHjEZnRb2II2qwGgTV3dehSak8H6
	 4IwbKOkJo8uMoUV3+VXxeNK6qlyEdGYjOuN6hOyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Merlijn Wajer <merlijn@wizzup.org>,
	Pavel Machek <pavel@ucw.cz>,
	Sebastian Reichel <sre@kernel.org>,
	Carl Philipp Klemm <philipp@uvos.xyz>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/226] ARM: dts: motorola-mapphone: Add 1.2GHz OPP
Date: Mon,  9 Oct 2023 15:00:56 +0200
Message-ID: <20231009130129.251353102@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

From: Carl Philipp Klemm <philipp@uvos.xyz>

[ Upstream commit 19e367147ea8864dff1fb153cfab6d8e8da10324 ]

The omap4430 HS HIGH performance devces support 1.2GHz opp, lower speed
variants do not. However for mapphone devices Motorola seems to have
decided that this does not really matter for the SoC variants they have
tested to use, and decided to clock all devices, including the ones with
STANDARD performance chips at 1.2GHz upon release of the 3.0.8 vendor
kernel shiped with Android 4.0. Therefore it seems safe to do the same,
but let's only do it for Motorola devices as the others have not been
tested.

Note that we prevent overheating with the passive cooling device
cpu_alert0 configured in the dts file that starts lowering the speed as
needed.

This also removes the "failed to find current OPP for freq 1200000000"
warning.

Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Carl Philipp Klemm <philipp@uvos.xyz>
[tony@atomide.com: made motorola specific, updated comments]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Stable-dep-of: ac08bda1569b ("ARM: dts: ti: omap: motorola-mapphone: Fix abe_clkctrl warning on boot")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/motorola-mapphone-common.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/motorola-mapphone-common.dtsi b/arch/arm/boot/dts/motorola-mapphone-common.dtsi
index 807042a293d0a..ab0672131c212 100644
--- a/arch/arm/boot/dts/motorola-mapphone-common.dtsi
+++ b/arch/arm/boot/dts/motorola-mapphone-common.dtsi
@@ -200,6 +200,21 @@
         temperature = <80000>; /* millicelsius */
 };
 
+&cpu0 {
+        /*
+	 * Note that the 1.2GiHz mode is enabled for all SoC variants for
+	 * the Motorola Android Linux v3.0.8 based kernel.
+	 */
+        operating-points = <
+	        /* kHz    uV */
+	        300000  1025000
+	        600000  1200000
+	        800000  1313000
+	        1008000 1375000
+		1200000 1375000
+        >;
+};
+
 &dss {
 	status = "okay";
 };
-- 
2.40.1



