Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023540;
	b=FxJHVR/+JfhdRjViNFvfqE29URuS1rHUQz2gHqIYCwfKR6t5LWnptVK3EJOr9bk7PAD4
	 jy31uGc0yNKDzztajnI+gZl+zGfY5Rq6Fx5KyEKsH6X5VxoyDkNLFR20P3/mHT6p02nON
	 wKlZWuYtI1b1EKzkxTD+oIJsv9EM3gcElYcR3II5WOmHM2/cZUF03C4V3Xbyj34fVnUj9
	 BN49E5mL9yEL4PmD9dw8uNKPmXPp0NGhWax+JxjV8yuxesGjgIPVw4SJR77OvRXH+zSSk
	 ZRAOpooUmvWIV4MVpFK86SM1uA4BbGWVAMPiK0bNVfwJVPGjkzXNrMMiVk5i+cFUuaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8B/0Dkhpn9MzrAwnik9/XZM3M7Nw3Zg1CokMbK6jcvo=;
	b=o0xTcIVzfGPTL+qsbRASGXp5Vyyulaisn5meBSdTe0eel57SSXltr3a4WaLIpbSgzrco
	 K8GZOqyssUBvAMqhT2K5wtZ4vNmhE5KBQKm/hVnpxs5Oe54xsJflG6aJK6DdDg2GA3vxD
	 p6zoAi1Br2FbfweN93LLGsT/QpLFwdEegbh2Slc8SUZ+LgN8qOlUQN7qSKSprzgJ7JlYb
	 lRC18KGQo2AStJhKyQGOwOYlwP2W0YleoRzUU/FO114pNxICQjqC9mP9sIsD7udFhMMsl
	 pQOU1ek7Z6QIGS6NVQx9yDrjLE4l30PwkLmq/Eq8j6Yym3+DoGHmlts7/b7IZFyvAsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FmMOnwTR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73E6606A335;
	Wed, 18 Nov 2026 17:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FmMOnwTR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CE01F000C4;
	Wed, 18 Nov 2026 17:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023540;
	bh=8B/0Dkhpn9MzrAwnik9/XZM3M7Nw3Zg1CokMbK6jcvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FmMOnwTRWP7GQ8tZchmpXIVrkMFZUiqHZG+e1b97MwNSvvhO7eTJcG3kozOEJ9p+x
	 c6FGme08LQV/p92leV8M9gl0BKjInV1Dn9Rt0xzCeVdTNUIkypxjqqwJ1Rp57qjVhk
	 AzXzKTdcFSsXNyErZAqjujNXo2gnxKzF8aIy1EKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0406/2151] ARM: dts: stm32: fix vdda supply for onboard hub on stm32mp15 DK boards
Date: Wed, 18 Nov 2026 15:35:41 +0100
Message-ID: <20261118150136.852338544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

[ Upstream commit 8d8f88e0f3e602cd967bdd8d7bc218ac7613650a ]

stm32mp15 DK boards use Microchip USB2514 HUB. Since vdda supply has been
added, the regulator framework wrongly associates the 'vdda' supply
dedicated to ADC, so the wrong regulator is referenced.
Only the 3v3 regulator is used to supply both the digital and the analog
part of the HUB.

Fixes: 673655f7944f ("usb: misc: onboard_dev: add vdda support for Microchip USB2514")
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@foss.st.com>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20260821-usb_fixes_vdda-v1-v2-1-23cc919b59fb@foss.st.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp157f-dk2-scmi.dtsi | 1 +
 arch/arm/boot/dts/st/stm32mp15xx-dkx.dtsi      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/st/stm32mp157f-dk2-scmi.dtsi b/arch/arm/boot/dts/st/stm32mp157f-dk2-scmi.dtsi
index 89de85a2eff32..172347769e025 100644
--- a/arch/arm/boot/dts/st/stm32mp157f-dk2-scmi.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp157f-dk2-scmi.dtsi
@@ -180,6 +180,7 @@ &sdmmc3 {
 &usbh_ehci {
 	hub@1 {
 		vdd-supply = <&scmi_v3v3>;
+		vdda-supply = <&scmi_v3v3>;
 	};
 };
 
diff --git a/arch/arm/boot/dts/st/stm32mp15xx-dkx.dtsi b/arch/arm/boot/dts/st/stm32mp15xx-dkx.dtsi
index 8cea6facd27ba..30b1e6222b02e 100644
--- a/arch/arm/boot/dts/st/stm32mp15xx-dkx.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15xx-dkx.dtsi
@@ -709,6 +709,7 @@ hub@1 {
 		compatible = "usb424,2514";
 		reg = <1>;
 		vdd-supply = <&v3v3>;
+		vdda-supply = <&v3v3>;
 	};
 };
 
-- 
2.53.0



