Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016145;
	b=Eg1KI9rXQf9vi85HReCm3D3fPrgxWLyyAGNfgSTeGg3e/UcZaIGlsYy7/lwM63RNPKti
	 +EnkEMzTrGNfcZIwtg2FeMjgRPfQ2x0r4Lz4tci/d34xsKcYPciEVSMW8mTSp0c6WSuyT
	 XfInfvIgtQlfyJRXYIjWoldckIDkVlzovfVDDBFnlCEbAb1PJgftIMU4PCYYlMgPTP3Hm
	 pxr3zv73uKp26cup5ogpHTeXhb7s9EjbmOZnsH8DjuDQXfELJHopwQPH5U1TyA3rICkw+
	 jBiVpIiKbf6ZXb3L0IDv640D5Mb6+OSXHoStlu+z5sIuGog3MHixnjo/58nUCLuVHXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZxGDmFJcxqHy5GMIbp+ICRaiaqXGMX+RtCzJKhKiaFA=;
	b=mcC3evKEhlZe0xTviVRAZBwpuULbwFgq0usw0VYzcwxVz1w9tXL8tLnPq/8x0uJrRQ5H
	 YIhTkQO/cgyPG1qyZ3EQkU0EpuBeiQTBkf3F25MkchDO7tPn8MgbYBP8KT87ItyjzCDl0
	 62ZwU5fnDzwQiUNqyXx4p+biSBx/bkHasf45m4p08BwwklAgjxa6JZ5buQsUYG7q7wwp7
	 l/dsqBG+5qBlWP7yrDNJT8/xFdLw9cGobsHxUnC92TYyLiTNkRc+J3sHgWtS1Azr2ZAnx
	 7nOGjf2hC+RTsnHCQLdHEgYZn67tcfXVsCBcbjcuVaxnw77ZBwttv2oVvkIIDNQbgZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YpZGK+b1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D384D606A332;
	Wed, 18 Nov 2026 15:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YpZGK+b1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3617D1F000C8;
	Wed, 18 Nov 2026 15:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016145;
	bh=ZxGDmFJcxqHy5GMIbp+ICRaiaqXGMX+RtCzJKhKiaFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YpZGK+b1mkB9/TT94O8OTNLLLFwpgRKma6tnsxK+MdjN4KA1BnhWPRrVJbBnJMxrP
	 +kfVNMrxRl3NObDUCTKDLTwaZHih49PYlhsGHJtiKw5cb9AFg0bgPDRcXcLCOO5hLg
	 wwlufRBTDC+6Mp2lNpFQDrhuzTNMLL64ZWzfwlf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0423/2651] ARM: dts: stm32: fix vdda supply for onboard hub on stm32mp157c-ev1
Date: Wed, 18 Nov 2026 15:27:43 +0100
Message-ID: <20261118150303.058116095@linuxfoundation.org>
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
index 0e65a1862eb53..ce014561a8aca 100644
--- a/arch/arm/boot/dts/st/stm32mp157c-ev1.dts
+++ b/arch/arm/boot/dts/st/stm32mp157c-ev1.dts
@@ -439,6 +439,7 @@ hub@1 {
 		compatible = "usb424,2514";
 		reg = <1>;
 		vdd-supply = <&v3v3>;
+		vdda-supply = <&v3v3>;
 	};
 };
 
-- 
2.53.0



