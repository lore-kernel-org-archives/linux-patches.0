Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94109403E9B;
	Tue, 21 Jul 2026 18:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658493; cv=none; b=fxEwmGnTcwe2v/4OkBO8wKw8R1jsAiq3B6WU67ct5DTlKytikHq/oa6kqRkqbxkSQ/7jaSnLnprFJ6F8XaWRGhuVQzgw5Ra9rJIhKX5pp6eDDCf9tkubunoVZ4scjQShAO/I3Bx17OMZ/cUKkUPRKJiWU6qFNtMWmmC/Z1YB34o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658493; c=relaxed/simple;
	bh=HYWK0BnTwt3x7/SYa95prVKkzdaoiGx3dqCwB9gJ8E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8itujzxZd+Jm8Lzd0lDuRHmYJf9kmuDtVZixC6EtCcuox/yhafZENHqs/SPCrHjDwwjOBXtW/lr/4KUQdphqoyZgLUW4ze6H7syw9f8JQZycat1ekNyJj2BdO+pRv0em/2ls/wbJWIoKFwqtK/fHSeLixK0y7LL5X9PcXo1Py4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ye1ja+Sh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ye1ja+Sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9B61F00A3A;
	Tue, 21 Jul 2026 18:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658492;
	bh=3noeoGsv9awOANifog6X+abwhuJNXp66SDfksPDNtFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ye1ja+ShjJjy9c1RN6uEYUA8Ob4WNSKx9g0nui4ijynvIpAvLwy+C5Chn9No1fHmP
	 Ns6npvNAAFTXuAMGBmfV388H04Qqj/T7mAQE1c5Jh3sxr08EYuNac1oT02rIFcsOkU
	 17wlBcNYeEbQkGe8M60DYEtrbJNvBe4eilaVxSwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 6.18 1121/1611] ARM: dts: stm32: stm32mp15x-mecio1-io: Fix expander gpio line typo
Date: Tue, 21 Jul 2026 17:20:37 +0200
Message-ID: <20260721152540.635339301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


