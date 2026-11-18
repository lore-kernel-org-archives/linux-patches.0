Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016143;
	b=g+42YFWj+HrRIIkHbYZPZ+5e/2T+Sgz/COCxW5gJBDSaUNRuBX0XuRfQMtaVQ+Dxson8
	 MM3QSESaNhNoGbeXHM0ylp6A4asc4ntMgm5v7WWsBmapnuQYLkAbXbFLLdw1sXQvwNk8R
	 evsaro/5N/ZrAnu9tIuLUxna3qrVATi2rFXe4LG3/xGU1dIzJO9DpRJ+Z/1ifP+v5nNtp
	 syDvifkNmLLRvJz6LK81fdeIMrQXq4WHKRUDZcPICqy6NiuDeRH9p5MUG/NAYB2XNnhp7
	 rFxDmuqB4cQrjI/RCwas1s7SWbJkxNFFRGNJ0vhFznsMXUOnH7aSJ2UEKmiSa122DUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VIbTxovdEkDYEplWPQwLGxzOhM6E1QrdfMDTwHICcDI=;
	b=xh0Y+2y1TTDjW5JmuZMfVE0wRDTvz/uQq6rf0QraNTqDbniqA3MjY2F65473/Zv+5jla
	 p5+9MFjIZ5/GlRhMnTOfJlq07BIp8xXi7qoI74sUwqsbzONuFU/YKCS1nX3zKAuaQZcJB
	 QMqJXbb6d/cYUnX6xhr00SIlqVcjp/5B/Nl4ZuDbYo4uhhzZk/kqeuDPxMLTICBgl/OFU
	 LHamfgCrO6+hXAoajrxDS5bwQFF+ECVkTO5AUW+1R0koO3BlzwA2uBIKxGb8C75yjXaeD
	 95kgAGt3wk/wfzbNkfV8cjPGt0J04PPX4zPUPdvxjcJvu0NxiLWHO75Yxf/gLETb4QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rXpEQ6gk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533EC606A320;
	Wed, 18 Nov 2026 15:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rXpEQ6gk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B971F000CB;
	Wed, 18 Nov 2026 15:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016143;
	bh=VIbTxovdEkDYEplWPQwLGxzOhM6E1QrdfMDTwHICcDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXpEQ6gk2/DdXWfxUIKn9i3ToY0nzn//TaRkBvmq8tf/DvBlGSyv3xsvXjLkOMW0K
	 IGR1lT4URdtaBtSceYKAu52jz3v9A5OsQ+NCBtEd6zM5+1uMaqvRaQ3wPDN52Me25F
	 MKCNHLxTgS9tk+oIfJgB2/+aW8iNHQ3u6OXm9YxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0422/2651] ARM: dts: stm32: fix vdda supply for onboard hub on stm32mp15 DK boards
Date: Wed, 18 Nov 2026 15:27:42 +0100
Message-ID: <20261118150303.021979827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 599ea07bdb19c..01ac3d7d6d0ef 100644
--- a/arch/arm/boot/dts/st/stm32mp15xx-dkx.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15xx-dkx.dtsi
@@ -764,6 +764,7 @@ hub@1 {
 		compatible = "usb424,2514";
 		reg = <1>;
 		vdd-supply = <&v3v3>;
+		vdda-supply = <&v3v3>;
 	};
 };
 
-- 
2.53.0



