Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC0E6AD6;
	Sat, 30 Dec 2023 12:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szP0bysJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15327C433C7;
	Sat, 30 Dec 2023 12:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937875;
	bh=6kodKMV1phsSBbSQO6jbUUzA0i6Pa/wWlfGmvaLmwPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szP0bysJ27Snzse9sGDMh2jEKJ17hQzZ0nEBVesmguaZf7Zprfyg39AOZ1o+SCTWN
	 IYdHHo4zoHCQx8kVpV/+f0C/YsJG1TOmIprCvJjnOFk6UFUYVI1oO8hb9REhsfNP1Q
	 XzhdU4fFcpSVoe833OXs2D55+A2FetUoqIiwP09w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6.6 097/156] ARM: dts: Fix occasional boot hang for am3 usb
Date: Sat, 30 Dec 2023 11:59:11 +0000
Message-ID: <20231230115815.529217389@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Tony Lindgren <tony@atomide.com>

commit 9b6a51aab5f5f9f71d2fa16e8b4d530e1643dfcb upstream.

With subtle timings changes, we can now sometimes get an external abort on
non-linefetch error booting am3 devices at sysc_reset(). This is because
of a missing reset delay needed for the usb target module.

Looks like we never enabled the delay earlier for am3, although a similar
issue was seen earlier with a similar usb setup for dm814x as described in
commit ebf244148092 ("ARM: OMAP2+: Use srst_udelay for USB on dm814x").

Cc: stable@vger.kernel.org
Fixes: 0782e8572ce4 ("ARM: dts: Probe am335x musb with ti-sysc")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/ti/omap/am33xx.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/ti/omap/am33xx.dtsi
+++ b/arch/arm/boot/dts/ti/omap/am33xx.dtsi
@@ -359,6 +359,7 @@
 					<SYSC_IDLE_NO>,
 					<SYSC_IDLE_SMART>,
 					<SYSC_IDLE_SMART_WKUP>;
+			ti,sysc-delay-us = <2>;
 			clocks = <&l3s_clkctrl AM3_L3S_USB_OTG_HS_CLKCTRL 0>;
 			clock-names = "fck";
 			#address-cells = <1>;


