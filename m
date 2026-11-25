Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626270;
	b=cIKyYnYFZdIEW/8gSwLAbfIBeeL14i5sz0LkhiEGpwHZwPnCjg2MgmGXav4LhtXOfjnA
	 AYZTuIl0gGcURip8AoBoCgwseWGxs7rGopRI1pb7dfBzZdNdizHlOemAchP1kFC1YBggY
	 K/mGiVAuN6vfrygfBEQbgCh6qeDhVGN3tlOw5eKGnmBrekbaeE8MarOJ5Kz3YaJZvY9/J
	 JYACBYavkZv+Xvx3+qPG0VroQcIDuUhYYMO6Ap9Vqn2YhYbknL5ZxXi2PgqmSJTRpzAW2
	 GzXpxwIZysLSgfUI1JTm7J5RBwj2phya/9g+niTyBr1CePUajXU3lDbPpLx+J9RgBTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ipRXskCxlplLjXDYW4oEHDchteAeQJ+GJ5YF+D6on8Q=;
	b=Y8faUacT+mPi3hT9G3pT2X5y82JfxKXtx1Kz3WIz/DoTnrVOt2n1O2OQ2b3GrCaa1pHd
	 FZnbh3TY+ToIM6UflkDP9qb4kDUZAHHTGifhh3T3wp+K12lV+0lnScejaoTTfaQ1twRiG
	 dkiZop4j3gbV6dPRv3NVwiQ9d3HUkLRxpmkkvsXqS2F7OedNF1mnahdWIdRSokHn3tgec
	 qDYrkKnSSXpEkFgkOlra20JYogWqkdbB2D21mqh2Q+N+gHQ7x0gwl1Zsmpyn1e/jAV89x
	 kaFOod2h+B4E6WnSu5cHJq2QeeIca6DrqWabXEbF9Gdai4hlyXs9+05joLTN1o3IJcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dULSb8hG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B166606A31E;
	Wed, 25 Nov 2026 17:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dULSb8hG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321A21F000C0;
	Wed, 25 Nov 2026 17:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626269;
	bh=ipRXskCxlplLjXDYW4oEHDchteAeQJ+GJ5YF+D6on8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dULSb8hGXar7Wjt636+sU+bRldb0kacl6Y0CEJWfY2x0xUmJ3mkUuj0V0kzRbh3jF
	 Ijgv/YFwHbyStmmkGqwC2NUmQr8MMXGbCuvohAFVwvlE6eYBLU8ORnSxTFNWCUDzvP
	 pPVs7cbSEk0sxGfvpQaj+3sBuao+SpG9RrMJ0jsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Czirr <maxx-cz@web.de>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 787/816] iio: hid-sensor: Fix scale for magnetic north heading
Date: Wed, 25 Nov 2026 15:38:55 +0100
Message-ID: <20261125143907.389200022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -38,6 +38,8 @@ static struct {
 	{HID_USAGE_SENSOR_COMPASS_3D, 0, 0, 1000000},
 	{HID_USAGE_SENSOR_COMPASS_3D, HID_USAGE_SENSOR_UNITS_GAUSS, 1, 0},
 
+	{HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH, 0, 1, 0},
+
 	{HID_USAGE_SENSOR_INCLINOMETER_3D, 0, 0, 17453293},
 	{HID_USAGE_SENSOR_INCLINOMETER_3D,
 		HID_USAGE_SENSOR_UNITS_DEGREES, 0, 17453293},


