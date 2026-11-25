Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620611;
	b=JF2IAyg92r9pTqbp62Kc//eJPRGYMaz9l8H2mpjsIe+/CKoDkFrjEuRaArtikFpNBdtA
	 Xu9d04wDTToXbeVfvfMiYCmC970sYXoNKpeUICLKnD+YKUAOPdAHzZXg9tIhFXdQxfV1K
	 4cFrRmR6PtbbeyyLunT0BUiUy1OvYVoZNykq9ezXOX6GMhYxIx8OVWup+4tr4SlPrjFBJ
	 +ZBSUBitTgrRuubTuX2y/6VSNpUiteQyIP/3Rf/vK2Bi6qC4eSZpKKKBvwsXePEgeZgQx
	 tPsYWy6AjOeQCD7MP6Kdzz9+nqHO0hsbQmvRvOh2Izj9tag3Sfhqh6muxS0oPzUZqNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5hwcwzYbm/XnD40QRtTWk6NXNYuWtDClxcOnCh5fE0E=;
	b=ug2MyeuNLhXYiArnAFU6tHQ+cJ5ooWpLhE3JyrocGTHHsHpAmIASFaGvwT7KRZ8z9QOZ
	 xA5NmM1Q0TpskpCPDB6S0c6KGsTcyj58wtr4gJN6b1MJi9g6X+AWAbidMwcpfCqGr8VZG
	 9h2LqQ9TgW7/fkDDG6+VR7EmUCQkHvBXtzABiKZP0o0psZv2HLRUYTTwqGTIlM9MG2jfg
	 9qfso8WLAoyIOgkcnYpStmVaLaw1M2yyTQLWfS+THRt07LbXwuLtJjQAEwlaWaxlt4KCD
	 fHXTNyW7hBD66gLsXXs9lsg2n2mCPIbtOwamVfrfAvrm0LEUQw61hXZmzRyQ+Mftzaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XKGGEiLe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38220606A321;
	Wed, 25 Nov 2026 15:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XKGGEiLe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884AE1F000C0;
	Wed, 25 Nov 2026 15:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620611;
	bh=5hwcwzYbm/XnD40QRtTWk6NXNYuWtDClxcOnCh5fE0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XKGGEiLe4IGq2/Tg9aeCvHVHg+hDe+jAsuov2pFoNtx+Yxwg9WJUjOauP5fwZYnMq
	 o9eln0NHGFAiOvL+2F4UL8HTsZ2t2DjOSqyHowXzigezSLDKzHl0BTgD9ygOD8rQRq
	 tBmbs2KzuG7Q81h5m6eLzUVkKF4dmw5j7YGBjapI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Czirr <maxx-cz@web.de>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0973/1005] iio: hid-sensor: Fix scale for magnetic north heading
Date: Wed, 25 Nov 2026 15:38:31 +0100
Message-ID: <20261125143844.457404744@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Maximilian Czirr <maxx-cz@web.de>

commit c72dcaeaabd60e164e7324f80ccb037e879eefdd upstream.

hid_sensor_format_scale() applies the HID unit exponent only when
the usage and unit match an entry in unit_conversion[].

Rotation-from-north support uses
HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH, but that usage has no entry in
the conversion table. As a result, the unit exponent is ignored and the
heading can be exposed with a scale of 1 instead of the scale specified
by the HID descriptor.

Add a unitless conversion entry so the HID unit exponent is applied to
the magnetic north heading. A sensor reporting an exponent of -5 then
correctly exposes a scale of 0.00001 instead of 1.

Fixes: abea9c62c32f ("iio: hid-sensor-magn-3d: Add support for rotation from north")
Cc: stable@vger.kernel.org
Signed-off-by: Maximilian Czirr <maxx-cz@web.de>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/hid-sensors/hid-sensor-attributes.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
+++ b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
@@ -38,6 +38,8 @@ static const struct {
 	{HID_USAGE_SENSOR_COMPASS_3D, 0, 0, 1000000},
 	{HID_USAGE_SENSOR_COMPASS_3D, HID_USAGE_SENSOR_UNITS_GAUSS, 1, 0},
 
+	{HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH, 0, 1, 0},
+
 	{HID_USAGE_SENSOR_INCLINOMETER_3D, 0, 0, 17453293},
 	{HID_USAGE_SENSOR_INCLINOMETER_3D,
 		HID_USAGE_SENSOR_UNITS_DEGREES, 0, 17453293},


