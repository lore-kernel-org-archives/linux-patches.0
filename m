Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623720;
	b=upETJr+v2HVF6sgEJ9uhg+mqIs4lwPCjeFmJVHVS8yRxlVB9Y9p/8sIXQb9HwV3lMrw9
	 XPPIKRc+R/hjZ/eiYBWhSdCVKBql1cYb51Zd5t0af3tbT6TyOt6FvveVMLaNJKbIWtFlW
	 z62kOkKKnxuXfT2NxyPsR3lMH8zXIl1s6nryhqetcNJTGLO0Xvtgl9QYX7y1ZOVLK0dYv
	 nbJ9+04miNsn7s+3YNJP4nsIMFd5poRq227881Gk6IMwgVtKRTQ4A5FQpEOGsICm0X335
	 ABvbwZPGm36VFBwtqMRx/w4hRSaZvEcxPgZp/WkTlzNDG8FydjkWI/43m6Y6NIR24jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4qo3ULEKBq/rHj0vzNcti6x70rjfsmiGkIVSbjbirrI=;
	b=gm7BR1lrTx2zyzw5DDEH7F0sINEiN8Q36jH7cL4j/gxdJXaJmJoigf60LKCc+OqR8MWh
	 OXOpQj2v0+jC9vujoB+IqbYRG4cdXiCpTLu8hgwhdTlDmfFj0O/oWJMlmbx/Gk/XfLmmH
	 HHfHWPQxGl5o46wHPrhoMxdy/FGlgGCJdqxZTOH5DqOjHIQYVd7tK2JcCpjDxOii1br5z
	 9Q8dK+SIfv8GSqNzoGG4IRO9oXKYuWtbrwzf3vzVARe5qvuhR3Ak3xDaxxblX90tU0rfn
	 Awe//9LEVW9vnHXl4hdP6kGeSiiVSeuLyOy4k/bInl44yzLhdrpAc0NOg+d0QzJObYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HFE3LCmi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08597606A31E;
	Wed, 25 Nov 2026 16:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HFE3LCmi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511A81F000C0;
	Wed, 25 Nov 2026 16:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623719;
	bh=4qo3ULEKBq/rHj0vzNcti6x70rjfsmiGkIVSbjbirrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFE3LCmikCJTWbFbc5h/bHhjwrXgBqA94HZE9HTjwFZ4FKJ2r1paxhUIumIG3iv47
	 yYbxeguvldvBjWnM3J+fOWoGclWAi2H01aPg93ldn52oUwI/Qme5vw9SnlSIIu4r3g
	 EpSo8GNj1UvuO5PZ+LdOwVr0txJa5SPGnI9vvDyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Arnav Kapoor <kapoorarnav43@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 949/990] iio: common: scmi_sensors: fix truncating 64-bit divisions
Date: Wed, 25 Nov 2026 15:38:36 +0100
Message-ID: <20261125143844.220761956@linuxfoundation.org>
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

From: Arnav Kapoor <kapoorarnav43@gmail.com>

commit 043ececf147863fbd253687aa0b9edcac358a711 upstream.

do_div() divides a 64-bit dividend by a 32-bit divisor: the divisor is
stored in a uint32_t on all architectures. The driver passes 64-bit
divisors to it in several places, so they are silently truncated:

- scmi_iio_set_odr_val() divides by uHz, which exceeds 32 bits for
  sampling frequencies above ~4294 Hz.
- convert_ns_to_freq() divides by interval_ns, which exceeds 32 bits
  for update intervals of ~4.29 s and above. If its low 32 bits happen
  to be zero, this is a division by zero.
- scmi_iio_get_odr_val(), scmi_iio_convert_interval_to_ns(),
  scmi_iio_sensor_update_cb() and scmi_iio_get_raw_available() divide
  by int_pow(10, n), which returns u64 and exceeds 32 bits for n >= 10.
  The SCMI exponent fields allow values down to -16.

Truncation results in wrong sampling frequency, timestamp and
raw_available values being reported to userspace.

Use div64_u64() and div64_u64_rem(), which take a 64-bit divisor.

Fixes: f774117c96f9 ("iio/scmi: Adding support for IIO SCMI Based Sensors")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606040245.XfmRpBhA-lkp@intel.com/
Signed-off-by: Arnav Kapoor <kapoorarnav43@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/scmi_sensors/scmi_iio.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/drivers/iio/common/scmi_sensors/scmi_iio.c
+++ b/drivers/iio/common/scmi_sensors/scmi_iio.c
@@ -14,6 +14,7 @@
 #include <linux/iio/sysfs.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/scmi_protocol.h>
@@ -71,8 +72,7 @@ static int scmi_iio_sensor_update_cb(str
 		tstamp_scale = sensor->sensor_info->tstamp_scale +
 			       const_ilog2(NSEC_PER_SEC) / const_ilog2(10);
 		if (tstamp_scale < 0) {
-			do_div(time, int_pow(10, abs(tstamp_scale)));
-			time_ns = time;
+			time_ns = div64_u64(time, int_pow(10, abs(tstamp_scale)));
 		} else {
 			time_ns = time * int_pow(10, tstamp_scale);
 		}
@@ -163,7 +163,7 @@ static int scmi_iio_set_odr_val(struct i
 	mult = scnprintf(buf, sizeof(buf), "%llu", sf) - 1;
 
 	sec = int_pow(10, mult) * MICROHZ_PER_HZ;
-	do_div(sec, uHz);
+	sec = div64_u64(sec, uHz);
 	if (sec == 0) {
 		dev_err(&iio_dev->dev,
 			"Trying to set invalid sensor update value for sensor %s",
@@ -238,13 +238,10 @@ static int scmi_iio_read_avail(struct ii
 
 static void convert_ns_to_freq(u64 interval_ns, u64 *hz, u64 *uhz)
 {
-	u64 rem, freq;
+	u64 rem;
 
-	freq = NSEC_PER_SEC;
-	rem = do_div(freq, interval_ns);
-	*hz = freq;
-	*uhz = rem * 1000000UL;
-	do_div(*uhz, interval_ns);
+	*hz = div64_u64_rem(HZ_PER_GHZ, interval_ns, &rem);
+	*uhz = div64_u64(rem * MICROHZ_PER_HZ, interval_ns);
 }
 
 static int scmi_iio_get_odr_val(struct iio_dev *iio_dev, int *val, int *val2)
@@ -270,7 +267,8 @@ static int scmi_iio_get_odr_val(struct i
 	mult = SCMI_SENS_CFG_GET_UPDATE_EXP(sensor_config);
 	if (mult < 0) {
 		sensor_interval_mult = int_pow(10, abs(mult));
-		do_div(sensor_update_interval, sensor_interval_mult);
+		sensor_update_interval = div64_u64(sensor_update_interval,
+						   sensor_interval_mult);
 	} else {
 		sensor_interval_mult = int_pow(10, mult);
 		sensor_update_interval =
@@ -396,9 +394,9 @@ static ssize_t scmi_iio_get_raw_availabl
 		 */
 		exponent = exponent - scale;
 		if (exponent < 0) {
-			rem = do_div(resolution,
-				     int_pow(10, abs(exponent))
-				     );
+			resolution = div64_u64_rem(resolution,
+						   int_pow(10, abs(exponent)),
+						   &rem);
 			len = sysfs_emit(buf,
 					"[%lld %llu.%llu %lld]\n", min_range,
 					resolution, rem, max_range);
@@ -503,7 +501,8 @@ static u64 scmi_iio_convert_interval_to_
 	mult = SCMI_SENS_INTVL_GET_EXP(val);
 	if (mult < 0) {
 		sensor_interval_mult = int_pow(10, abs(mult));
-		do_div(sensor_update_interval, sensor_interval_mult);
+		sensor_update_interval = div64_u64(sensor_update_interval,
+						   sensor_interval_mult);
 	} else {
 		sensor_interval_mult = int_pow(10, mult);
 		sensor_update_interval =


