Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623729;
	b=PnxlopjRNVOUXW9XGpY51bPZoCAU3i1+dAkIR9kAoZfYqgALkWIQXQ7QQFzAEvHtD+hI
	 XaOsloA8zgWUnAtslciiSxSV+lqB75Q8x4d9ZmtRLfGvuhDqQRMvHUVfQyMCTXlcQ5XU7
	 d+o8cw0ivTINJPO+vtY7JKArdkYcpZTMlHFpNoso6zJyiRyV6K9ifTTnWcogifE1eqPQb
	 e5dtnWEE40axT1QAE2+oGsXH59s1VMgSMVoa/DXzHjSkEH1Luyi46fls1zS9HaMHirLVg
	 /h5KMhmJPay/htfW60MJOBwlOcXb16HRT3+MiV+jps+fA9nx6OvXNDhOMcx3fHlhTdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UX32MCmlTBZampYLALzTaCFTfTUbycLK738QdxOtoYU=;
	b=Uw2YC6/fmxjAfm35NQEFJaUXECmMoG9G0j/cJifzYbN2RqmpPVSEKPPOldlb93fSFRwh
	 Bvib3UxEa7t0Zjr8mPKsebXod7/v3DIk1EBTMuJOSPPoLnQze+JX6qJ9PU+7vnbOHRAAl
	 FDfS+ZWJrJaIAKYZqe4yF8H4fxwptLjbZK350tmWuo6XO74okV7BiXQI6eYgShey0TOmm
	 MOEJLq1axF1ufN4DShHJLjrWf5xzFRfodPO8+i3SDPb2PAD0lEKFADpHPSDnUt1VVFui0
	 jvxix8G5CHhnGPeARnQgfeNjT5CzfkLOwC7ZBKReQWazKC3vh6rFgh/kJTCm5wBIu4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t38lVjKI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300A9606A321;
	Wed, 25 Nov 2026 16:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t38lVjKI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F051F000C4;
	Wed, 25 Nov 2026 16:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623728;
	bh=UX32MCmlTBZampYLALzTaCFTfTUbycLK738QdxOtoYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t38lVjKING5S0HNWbmKSm3tN/Keg76XNoH3L+V3Lk44Rl+Vwrq6gcxWMZCybMVyK6
	 Y27LrKxhHljXC1iSC2/OQzYKVRpFnTj1gpnwXl+o5uztQobgWYvCm0cR6WLpCiYZMm
	 VpvejyeeKTi2G0lQhO0Y/88Zq70HybvXTV63kRD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Czirr <maxx-cz@web.de>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 952/990] iio: hid-sensor: Fix scale for magnetic north heading
Date: Wed, 25 Nov 2026 15:38:39 +0100
Message-ID: <20261125143844.288482796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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


