Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623525;
	b=YjhA1ZgVBWTS2IO9IhT3HEaqS+D2KS5n34Y9+FvJ6VnP13RPel7dQrh2YkliSU55yvlS
	 zY1xdxlMeDaOJo5i405fN7PXE9RTUfwHr2LRol20Of9XIwuqKdJ1JimA5L2Y+q7Yum4zY
	 Dbb8Z2sde6RupxzPRgrxM9/imXjmECSZ0Az62Yy9GgO0xAcE48330SC39E3iMK7MNrWtY
	 hd70H91WtIvgSSxjelbSM9Qb7wnFm8ftlVZkXI9BEDsxG1yTkTMUr64FQKOBTUnrEyGA4
	 MPV9KqLSxRB6P+Um30NJPk7IRQzFw+QIpG5xIxMXtxXT/nuqzK1YJ0oittq2sf2nYJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g4uuFCunH2pZR5+jRMRMlzTZ/p30DfI7MioTVzS/K8I=;
	b=zWsj8eP82B6K8jqleuo6CDtACb8ISjausSG2mmaNvqxhndLleY8gT4GyKyoT7l85UBEc
	 unlbeIQ919KDu/mzt4S3Br/OkOj8jXyO1HEeLw5eLTqj4wW72TM7K9IaPDjdmTnW/1sUz
	 /8uhqxtnogIAYn35pfkQX0O5vajKPA/fp0zbj6QxtcC3cNMllhvOol45y3r2Jd5azIav8
	 a45pu8JkFtIj5oBZqrzP1vXffpKFDDKfyKmpTCe9HsMj3jxYtSHU2Vs0ItCpm+1v1vQwt
	 dVduMh/da5d6+fh8EsWP6dPmaZpPu5vY9k+SuBUqMQqZYHF7/3q96pXcs+U7OIKQ4ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7IcRJNf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD14606A321;
	Wed, 25 Nov 2026 16:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7IcRJNf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF711F000CA;
	Wed, 25 Nov 2026 16:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623525;
	bh=g4uuFCunH2pZR5+jRMRMlzTZ/p30DfI7MioTVzS/K8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7IcRJNfEBu194aY+SvqC37/Iujpw/PnvqQ3/JqBGBbWcNZZ1ol04aSobFdO44/YW
	 AFv0oKRoeGUMqdf7RfAIwfhXzVS9l8n5gSXWibtsKoNSaWbGRPOjyXFeTKxt6OfAl4
	 jxIoWkeNkD8prx1WnreBXBFN8IulHAReTrMmtGK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 889/990] iio: hid-sensors: fix a division by zero
Date: Wed, 25 Nov 2026 15:37:36 +0100
Message-ID: <20261125143842.836030644@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit fd4c92bbd3a64556e81042ff8d30545b15a3b93a upstream.

convert_to_vtf_format() divides the micro part of a value by
10^(6 + exp).  The unit exponent of a HID field is a nibble and goes
down to -8.  For -7 and -8 the argument of int_pow() is negative, which
the unsigned parameter turns into a huge power of ten: 0 modulo 2^64.
The division by it is a divide error.  The exponent comes from the report
descriptor of the sensor hub, the value from a write to the hysteresis
attribute of the IIO device.

Multiply by 10^(-exp - 6) in these two cases.

Fixes: 73c6768b710a ("iio: hid-sensors: Common attribute and trigger")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/hid-sensors/hid-sensor-attributes.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
+++ b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
@@ -141,7 +141,10 @@ static u32 convert_to_vtf_format(int siz
 	if (val1 < 0 || val2 < 0)
 		sign = -1;
 	exp = hid_sensor_convert_exponent(exp);
-	if (exp < 0) {
+	if (exp < -6) {
+		value = abs(val1) * int_pow(10, -exp);
+		value += abs(val2) * int_pow(10, -exp - 6);
+	} else if (exp < 0) {
 		divisor = int_pow(10, 6 + exp);
 		value = abs(val1) * int_pow(10, -exp);
 		value += abs(val2) / divisor;


