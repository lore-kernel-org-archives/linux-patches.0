Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705750;
	b=OMNKF5L5tB7gwzaEBNGlpOM0XkXJwSN6BMb/PhanPTUrg/9FbbBuUrx2lmQeEySnEKaz
	 AidzI6vYqFtaTbeNHk7m+T72BjYFQjcMVrQ17sSAQkP8rG/RiINWe476hnkKUAmYzzKKJ
	 iXwdqpBimJ4YzLF9OBh9klueT8s9WKCV9ckeWKzXYCfb0UeOIYRBnw7hibygYpdCkJWdx
	 8ZClQOedrPJfmmNfRVulKKnqU3ihPsVVfZqdzt3KVygYGDzbSZ8lYH3/0ELbScnC4g9pg
	 sRr3GA/2m4c3abhGeBktp45GkWNyogjw+VdWYOsv7kIUB3QDo6l8eOYezTXS5Vx6yUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9P9RVzMJjhRVR5Wdw+GxHKyOIn0Gy6sh8Op7EjNi56Y=;
	b=RegUuSKlNqNE26SYgv5w6ABn6/RKU/2/z078FeJdqXS9q5WA4T421rUoxQPuVukQeHiq
	 bE6KxNfuFfrUdc+b6l7qGtepiGsOAgwiCKQG0sDuL9Zh7X4vPqmyg7XFHizXnb1fTzVOg
	 jV4yySlQrfiAsymvKLuwv3GBEsa2Pur9JHBPJChVE+LCcTn88+Bi9lZ1YGYauDENO/Wk3
	 FFZ6nTcaftwihJoMczaRLpeR23fzqXR8L0ibzN1QPQGg6wM0lM/oBWTnil+Ip/YwVtM8w
	 wFyF8rtoZzbk0YpSpYmrNDXbebY8rt39tHOivT9KiaQGU8hk62K8Azhg8dW0f2UhSxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kUwRaATh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25991606A69F;
	Thu, 26 Nov 2026 15:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kUwRaATh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0FA1F000E0;
	Thu, 26 Nov 2026 15:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705750;
	bh=9P9RVzMJjhRVR5Wdw+GxHKyOIn0Gy6sh8Op7EjNi56Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kUwRaAThXpdhNY9sYBGymItyS29iq/wvZX+m1DItOJp+6mmHEAR5szcjuAWrNkbGz
	 AU9Gioc2V8LIdG/AtgGWuC3JKAKetqQjRhXDt1kMrubacURH0qA6Wxvn0qG/edhNZR
	 rZik05tfdZ4qH4EKEHaSgCJ6ML+EhXId4WJyo/+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Czirr <maxx-cz@web.de>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 301/319] iio: hid-sensor: Fix scale for magnetic north heading
Date: Thu, 26 Nov 2026 15:41:09 +0100
Message-ID: <20261126144013.551610109@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


