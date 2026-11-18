Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016148;
	b=b5aMUxGBPtc0irjhl/U7M58FI7XPwswqJTutwdHU1KSq2HumLBeucKlzpCP0QH48Pe1f
	 HTLovtgGht6nBTF62zzckZeFQOg1Y8Z4tQ0DKx6RxqEO0C5oJa8lxPln3YIIossj6Ladg
	 HF/wEbqSur0PyCurrckcB6FeTM+t8+F9RJifjWyc5CjLgCiwaEFSJqQyOumrTX2BnQRVr
	 lW7+xTajkwNVA6YCfVn8nAyYBGbBSUjlvq1GwmRxOgGO1jkwkxqxrD71ZZHTf/zheM4c1
	 Ey6CsNY8FBXHeOd3JMZ+R0wm5I9P1S8C8rroAEI0JBiYpJV9KMuUpLCeKBSk/O9JEpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cYaNt2cOQwYJSlc3ZfoFrFmCZNwFWsRio1Cw/M5FvbQ=;
	b=KsJErcDFwx1kK5Wh43Tsb4MqWu+5WnQA7cIpjH2IhdN5EXYTFWv7nqkahF/qRq1Pq9Q3
	 tKGozu4kCaYP+WQ7vLcI2qzDwR8k0pf/ASqsHw920fBGls6a4iUZ8rLp7ZBkLzpsTIS+Q
	 /2aU9dYsACQlfIQ40xCRq2Ie7ZyXMaLoPPClrV+sfqWDdEUVB3hx+jeGariJX7savcGoe
	 H/fx6RQXF3ZbZMDtRvxvO0QpzCmaP6hADKYCpLgsNETwIQkSkMZb+kWe8gmGwXR+dJjxs
	 vflWvj4/xq+BAje+UyGKY3iU+fOAO9+zL9yqSDh2ooT4u3Gx0FwajIVXX3S1+ThuPVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ht9eOjTI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927FC606A325;
	Wed, 18 Nov 2026 15:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ht9eOjTI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92761F000C8;
	Wed, 18 Nov 2026 15:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016148;
	bh=cYaNt2cOQwYJSlc3ZfoFrFmCZNwFWsRio1Cw/M5FvbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ht9eOjTI68Zjpzyu0Q8QpP47dDEQzApA0aI9dLDyLelNbaGF8dAWwaaBb2SNaWmm7
	 uT8Uvloss4usA0daQR/OgjNIEy5ESyPw0twdmgXg9c4S+t36corNvV/k3sWv1YgVw9
	 CRz07c9m+TYkawbO8Cz+JfoefY52Nvm3yxbd9pm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0424/2651] ARM: dts: stm32: fix vdda supply for onboard hub on stm32mp135f-dk
Date: Wed, 18 Nov 2026 15:27:44 +0100
Message-ID: <20261118150303.091008593@linuxfoundation.org>
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

[ Upstream commit 2f92d900f262a16c8ae02daf53ae2910d07185f5 ]

stm32mp135f-dk uses Microchip USB2514 HUB. Since vdda supply has been
added, the regulator framework wrongly associates the 'vdda' supply
dedicated to ADC, so the wrong regulator is referenced.
Only the 3v3 regulator is used to supply both the digital and the analog
part of the HUB.

Fixes: 673655f7944f ("usb: misc: onboard_dev: add vdda support for Microchip USB2514")
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@foss.st.com>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20260821-usb_fixes_vdda-v1-v2-3-23cc919b59fb@foss.st.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp135f-dk.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/st/stm32mp135f-dk.dts b/arch/arm/boot/dts/st/stm32mp135f-dk.dts
index 1d6435c59096a..bd5d6818d7ba9 100644
--- a/arch/arm/boot/dts/st/stm32mp135f-dk.dts
+++ b/arch/arm/boot/dts/st/stm32mp135f-dk.dts
@@ -628,6 +628,7 @@ hub@1 {
 		compatible = "usb424,2514";
 		reg = <1>;
 		vdd-supply = <&scmi_v3v3_sw>;
+		vdda-supply = <&scmi_v3v3_sw>;
 	};
 };
 
-- 
2.53.0



