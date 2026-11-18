Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023543;
	b=i6M4KK8mGxs1J7SF8JFyMzjOItL0WMPGLYYOFyCwb6vx5bSszDZJVqovr0kF+oLVJgkK
	 PRw0DYzzU6oJzA4xys1P+fSp6fM3gj7i7F71UtMmtm23nUwr8PsLga99DRR3zla784xcR
	 OGCCYwrsGeCv7xunL79kUPUH+gxY3SyQLKOLmwICAzwyL5g1cQ7i8EmufCYrrqIwOs8YM
	 l+0Yk/pqZc3JCWIxBHkpK+PfKtUXCsftyBj/EtMuiVaCKIwJJKNROm2qC8r5wnXc63JSI
	 OzZp8WQjLSsuhHuSVNJ+nyoP2n/mj45KJSGaJyduGG0dbHAjoX1VFYyQwWN8yCidUUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UY4yirIQVbKP/QhTje7Li0XEsjMq/gC6asJ3b9hBM7U=;
	b=VlwJCJTBRMwC4gkIaQAvcL4a8YUwaJgMwsL8XqcDTF8JMpq8NrXgxF0FhJiVdrLsFjx9
	 nMypkdlCC+Mrz1cgc3gvFfd5ssKGmlEzd4BmVLJi2/8abZLxXTRj1Sm+PvIwm9H0SHrSy
	 FvZHN5H3ePprwVf6XZBruNxkzsjkzn3vYzTu7nxtztD2ANaOESFxzWow3j98q+bdBnz/9
	 UkcsvRUjhMZ3IWvn4gTLjXgfcJNeeimytRMoSqlJBP4eATdwQTanTzl8Ia4pulLq0IhTo
	 wDbjtGPavpGZZBXdT0yRr4aOLnB1xhTOk0hAB6+1xNz+UCGmC9G/qeHAhIMc4Dltt5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvGMN+p6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4A3606A333;
	Wed, 18 Nov 2026 17:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvGMN+p6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D101F000C4;
	Wed, 18 Nov 2026 17:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023543;
	bh=UY4yirIQVbKP/QhTje7Li0XEsjMq/gC6asJ3b9hBM7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvGMN+p6zIgv3+sz2NhvHvz9UXGSOEs79e/GlrxOwa3pX16sw/asoe5Z5W0lzzcYJ
	 JzYzw0Z1jjLlVKPeVyxt5Iqz8w7aRbwD0MVtFjBtjpp4jV1qnbYV/HsgV2ekI9ddaZ
	 G6hEtOIwSIS3qSv8XFCnUcMXkX/cWRst5UgMFLyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0407/2151] ARM: dts: stm32: fix vdda supply for onboard hub on stm32mp157c-ev1
Date: Wed, 18 Nov 2026 15:35:42 +0100
Message-ID: <20261118150136.889830453@linuxfoundation.org>
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

[ Upstream commit dae62eda0c987f3b80d622d00a45fb0cec854054 ]

stm32mp157c-ev1 uses Microchip USB2514 HUB. Since vdda supply has been
added, the regulator framework wrongly associates the 'vdda' supply
dedicated to ADC, so the wrong regulator is referenced.
Only the 3v3 regulator is used to supply both the digital and the analog
part of the HUB.

Fixes: 673655f7944f ("usb: misc: onboard_dev: add vdda support for Microchip USB2514")
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@foss.st.com>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20260821-usb_fixes_vdda-v1-v2-2-23cc919b59fb@foss.st.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp157c-ev1.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/st/stm32mp157c-ev1.dts b/arch/arm/boot/dts/st/stm32mp157c-ev1.dts
index 8f99c30f1af1e..bba43ad80222f 100644
--- a/arch/arm/boot/dts/st/stm32mp157c-ev1.dts
+++ b/arch/arm/boot/dts/st/stm32mp157c-ev1.dts
@@ -379,6 +379,7 @@ hub@1 {
 		compatible = "usb424,2514";
 		reg = <1>;
 		vdd-supply = <&v3v3>;
+		vdda-supply = <&v3v3>;
 	};
 };
 
-- 
2.53.0



