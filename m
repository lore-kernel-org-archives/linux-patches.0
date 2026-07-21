Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753AB33689F;
	Tue, 21 Jul 2026 17:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654016; cv=none; b=rBljWk4bkZJvfY5A6AeLAG6lWnXnHAGI/4K49i2yYj7r4m+9H1YCN16B2D4Fq4GDGAoI9+vmYh9Rb3G5TUC6IB7X+qUKfYdJF6sYYi8TjyZQq76BqOpYq98R+Ax0lJIG1i5P3sOewDQiboiBtF/lkyqhOGXcRp/H2t1OQKtMHyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654016; c=relaxed/simple;
	bh=h/np7ejQj6farzSZp3NfYitykarpkLaAoRwGSi2MflI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jw+yoYZDRwGB4N9yQJp4bdoCdGJ02/AO5xwwviMfEagoAZVCgt/yU9mZRnudouOUHYOWnBJqU29m5KMRUNWuXTq10Uyi2yLws0jM82kBuBCfzAmt+scLeDF8KrCCrzQ37Fz3tu2LQbMDymfx6d6haqmUxp8AXE+DZS7uuJSyJGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjgskDJC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjgskDJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4E31F000E9;
	Tue, 21 Jul 2026 17:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654015;
	bh=Dk1+19zc+IcHl8ZpZgtJ6IqKOX/Ocx2B5xSFAW9eR9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rjgskDJCthQnp8lVXMx7z3G510uAcSRJKlPUE6xfdhXNIiJPSVFP+f6WYGGfgeZVU
	 +2NLqKWIvuZAiaefPPNTTnryD4KafMYSQX3Uyoa8PLz5ODNqSLc6BQMe4tRvPEUHri
	 pj73LbNcy6N83x5YPfYzJoWzfPvXO6eHiD/65WXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 7.1 1545/2077] ARM: dts: stm32: stm32mp15x-mecio1-io: Fix expander gpio line typo
Date: Tue, 21 Jul 2026 17:20:18 +0200
Message-ID: <20260721152629.215873062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jander <david@protonic.nl>

commit dfb93c4acce8ad9c4f573128b2cf7ddb936e0de7 upstream.

Fix a copy-paste error in the GPIO line names for the TCA6416 expander
(gpio@20).

The common mecio1-io include file was originally defined using the
mecio1r1 (Revision 1) hardware layout, but incorrectly labeled pin 13
as "HSIN9_BIAS" instead of the actual "HSIN7_BIAS" present in the
schematics.

Fixes: 8267753c891c ("ARM: dts: stm32: Add MECIO1 and MECT1S board variants")
Co-developed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20260318105123.819807-7-o.rempel@pengutronix.de
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
@@ -186,7 +186,7 @@
 		#gpio-cells = <2>;
 		gpio-line-names = "HSIN0_BIAS", "HSIN1_BIAS", "HSIN2_BIAS", "HSIN3_BIAS",
 				  "", "", "HSIN_VREF0_LVL", "HSIN_VREF1_LVL",
-				  "HSIN4_BIAS", "HSIN5_BIAS", "HSIN6_BIAS", "HSIN9_BIAS",
+				  "HSIN4_BIAS", "HSIN5_BIAS", "HSIN6_BIAS", "HSIN7_BIAS",
 				  "", "", "", "";
 	};
 


