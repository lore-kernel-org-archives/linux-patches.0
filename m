Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9873720B806
	for <patches@lists.linux.dev>; Wed, 28 May 2025 10:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748429026; cv=none; b=J4XLYUSn9bjYjMAXSb7IBQWCrrJ9vDjcIEiChgE+HlA7vmPnHOevsW8ky8HD3vJwrYYgyfLp8zvIqwneQmD0D2TybUfcWKse8HpLLxaTntYhsxpMqMuVDJr92NaFIe7kP+pf3jKCaGFAdGappv5MZ+cGs9XSNzVC8MZ8I0WlmLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748429026; c=relaxed/simple;
	bh=WcB9OLk3IbK3PrU7BwDLL38nq2o0Yny7n7fjpv0Em78=;
	h=From:To:Cc:Date:Message-ID:MIME-Version:Content-Type:Subject; b=WAWpWm1OnzL/1r3xGQD7S0EYI3wF+qkoG/CVx9c+yxtnIT+Rnn9XUJJHlaFfbl1XEV/lxESqGhQ/AU7JznCmJLn+K9jN6WS7sx709gtKFYBeeTl6/YK2+qDvdU2dqT+9IfqIXyJtcr/8ngMxv//vRg1kV2Z477VzrJnwcgAzq/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmx.com header.i=meowmeowbeanz@gmx.com header.b=cjqsOMv7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=meowmeowbeanz@gmx.com header.b="cjqsOMv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1B2C4CEE7
	for <patches@lists.linux.dev>; Wed, 28 May 2025 10:43:44 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=meowmeowbeanz@gmx.com header.b="cjqsOMv7"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 28 May 2025 11:43:41 +0100
Resent-Message-ID: <aDbo3WYBR0c-TNjo@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 28 May 2025 04:24:51 +0100
Received: from tor.source.kernel.org ([2600:3c04:e001:324:0:1991:8:25])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=ElbO=YM=gmx.com=meowmeowbeanz@kernel.org>)
	id 1uK7PN-007LOS-AC
	for broonie@sirena.co.uk; Wed, 28 May 2025 04:24:51 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 16D0C61137
	for <broonie@sirena.co.uk>; Wed, 28 May 2025 03:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id D3D69C4CEEE; Wed, 28 May 2025 03:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE19BC4CEE7
	for <broonie@kernel.org>; Wed, 28 May 2025 03:24:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org BE19BC4CEE7
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmx.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1748402683; x=1749007483; i=meowmeowbeanz@gmx.com;
	bh=ir3St0EToVdOtFoQuHxG0DRTDoertb0nXRrbxaaO0rE=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=cjqsOMv7+hCPXjOIFFdv+QhByVhXTx7waAcSZ4Aq40yTB1gR1g2kPIggK0MaGfOh
	 5KFGI5wufh6vYPrxSi7sgUtwcITq5t0lwJyRCKDhVIb+8u0HachgDNecbJwtrDdk4
	 tQ+a4SOc7SKbrYh0/uCryeIJb5YrN9LERRxCG6fyFBbtC2uX82pEWKScljtWu1+Pj
	 jkW3j3jXmHGJ2czpniuNh9weK9d7qtpacQ+IvwWGh8mOPX9vt6hvKuXmnMiXW3Hr/
	 OOiIiscyoudco9094XOWKYiu4X/uICR+ERYz/eKNAzNTTzpHWyOwkDc8TM7DsqrZV
	 27+MclmWIwqSZrGwmQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from gemini.localnet ([24.205.220.130]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MPXhK-1uWr603bik-00Xkck; Wed, 28
 May 2025 05:24:43 +0200
From: meowmeowbeanz <meowmeowbeanz@gmx.com>
To: alsa-devel@alsa-project.org
Cc: broonie@kernel.org, mario.limonciello@amd.com
Date: Tue, 27 May 2025 20:24:39 -0700
Message-ID: <5015425.31r3eYUQgx@gemini>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K1:kjHiMNVefzq9VCPSasS2uJVff12Ov6aQShn39kCOKtBIb5iPwJ0
 ahSKZRq1oTTNjwnxMQenBeOTludkiSi9szoYZLCItzmMx2fYLjj5IzQ0sKedEMlvWQl+IX2
 hJ5Gu0nnX9o+ZrZ+mH9y7iIN3rJDIR0Jg34bIXQj0H5+78DR+j8oZBj+J7koydPrbNltnQc
 uAhHD0TO2dxj0gAr2Z+Dg==
UI-OutboundReport: notjunk:1;M01:P0:c4g6nNytRdk=;6BikSzjNd++dEdpsoAHgfZQWYwB
 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
X-SA-Exim-Connect-IP: 2600:3c04:e001:324:0:1991:8:25
X-SA-Exim-Mail-From: SRS0=ElbO=YM=gmx.com=meowmeowbeanz@kernel.org
Subject: [PATCH] ASoC: amd: yc: Add support for Lenovo Yoga 7 16ARP8
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: /FcO6XYcJDhf

=46rom e1bc7cbafcdefad60ac6a34fd834a734c64f3fd5 Mon Sep 17 00:00:00 2001
From: meowmeowbeanz <meowmeowbeanz@gmx.com>
Date: Tue, 27 May 2025 19:57:07 -0700
Subject: [PATCH] ASoC: amd: yc: Add support for Lenovo Yoga 7 16ARP8

Add DMI quirk entry for Lenovo Yoga 7 16ARP8 (83BS) to enable
digital microphone support via ACP driver.

Fixes microphone detection on this specific model which was
previously falling back to non-functional generic audio paths.

Tested-by: meowmeowbeanz <meowmeowbeanz@gmx.com>
Signed-off-by: meowmeowbeanz <meowmeowbeanz@gmx.com>
=2D--
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 3d9da93d22ee..7e62445e02c1 100644
=2D-- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -311,6 +311,13 @@ static const struct dmi_system_id yc_acp_quirk_table[=
] =3D=20
{
                        DMI_MATCH(DMI_PRODUCT_NAME, "83AS"),
                }
        },
+       {
+               .driver_data =3D &acp6x_card,
+               .matches =3D {
+                       DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "83BS"),
+               }
+       },
        {
                .driver_data =3D &acp6x_card,
                .matches =3D {
=2D-=20
2.49.0





