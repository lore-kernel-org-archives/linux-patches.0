Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623754;
	b=fJ92iWnTFIE9PoW1O7/Ouw94qHWZ+e7flfg2vFOnWf76GLAWICOWjm0EjcrVx6pXJZwn
	 8OfO4AqwBmi6ey6tLtx/2jVfUicd3MOXNsmZ4ws62rBu0acMCFrMOlSdasaHoXBNzYC78
	 lNz6/aSbqCpXaiYs/t1QJgCEjIDfHe3b5v5WP6nxTVQCh6MzxkOh67X0nWqZeMiunJAl5
	 pE0njodnUhjXEroY8kpJc1IW0y7fPWxVvYrju+gREMJvKonX4+SEJBNVa/CaU8TPeo3sL
	 lPA7eMxk17jvtmxDiJQVYwTNEeOo2X2NvH5kCV/HRui/lhJDOhYo+MXVHM3t1oPiECg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OlPUHLRdFMjpSwNUnclrrqbRC29Cp43/JzC1RC7TJr8=;
	b=kZMokV5FiAXiYF2E5VDfUChYtJePYcm4axYuUXcpLKcquFTXU7pKdmX63rMluEKMDzpL
	 YGMekCanCWi1m0bhvTfV37tSxW2W1elta52W7EzGvMHyhoVGYeX2HBTHXRrvR6VC0lIpJ
	 MaOC2g8SzGHdEpfn4P7yn9pTyee4WSmc3I3Qa9t4xXAKBtV/lCdOrPmJGGnQb43tksQI7
	 GtG/jeqtZpZ2N71hElwEh/XGstBwM7arDSSzkPq6r5K/sl982pQJA8taWSAqtVq1MPQkD
	 vLVCai7CjX9hLu4oFlUt2nqwHPSqBn+PACLpYD/oS7S6vliZpYX5h6osHFEP2Ww3zng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Xhd/wn+d";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79743606A330;
	Wed, 25 Nov 2026 16:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xhd/wn+d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCF81F000D2;
	Wed, 25 Nov 2026 16:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623754;
	bh=OlPUHLRdFMjpSwNUnclrrqbRC29Cp43/JzC1RC7TJr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xhd/wn+dYVHDwpk70BkOHb2UCmg3EGGAY6S6I0I+hcI05upzcYD/PC97n6wEmTzYO
	 adWhgACa4wD7Cf5ClOz5sc2u2NTBIAlE0SWPbt59AK68sjpGPc2R0/cR9zuu2zx7HP
	 Jds+D0I0H2GUa0Fv4WKSc4ksjpCKq6apSO0BVIaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Triska <martin.triska@mycroftmind.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jan Remes <jan.remes@mycroftmind.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 959/990] iio: light: tsl2591: dont divide by zero
Date: Wed, 25 Nov 2026 15:38:46 +0100
Message-ID: <20261125143844.451758475@linuxfoundation.org>
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

From: Jan Remes <jan.remes@mycroftmind.com>

commit bd63c89aac5672f40cdc123a856493b628fc1abb upstream.

The TSL2591 has two raw light channels - CH0 and CH1. The algorithm for
calculating illumination from the raw channels requires division by CH0
(which can be zero) and by "counts per lux" (CPL) value which is also zero
for (gain = LOW, integration time <= 400 ms).

Furthermore, the algorithm assumes CH0 > CH1, which can be violated in
almost complete darkness.

As a result, reading from 'in_illuminance_input' results in
division-by-zero whenever CH0 is 0 (complete darkness) or whenever the
parameters result in CPL being zero. This results in kernel oops on
x86_64 and in reading the value as 0 on arm64.

Fix that by:
- reporting CH0 <= CH1 as zero (catches also CH0 = 0)
- updating the lux algorithm to only do the division at the end

Fixes: 2335f0d7c790 ("iio: light: Added AMS tsl2591 driver implementation")
Cc: stable@vger.kernel.org
Reported-by: Martin Triska <martin.triska@mycroftmind.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jan Remes <jan.remes@mycroftmind.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/tsl2591.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/drivers/iio/light/tsl2591.c
+++ b/drivers/iio/light/tsl2591.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/pm_runtime.h>
@@ -425,6 +426,10 @@ static int tsl2591_wait_adc_complete(str
  * Scale values to get more representative value of lux i.e.
  * lux = ((C0DATA - C1DATA) * (1000 - ((C1DATA * 1000) / C0DATA))) / CPL
  *
+ * CPL is not computed on its own: at 1x gain it is below 1 for integration
+ * times under 500 ms, so the division by LUX DF is folded into the final
+ * division instead.
+ *
  * Channel 0 = IR + Visible
  * Channel 1 = IR only
  */
@@ -436,8 +441,10 @@ static int tsl2591_read_channel_data(str
 	struct tsl2591_als_settings *settings = &chip->als_settings;
 	struct i2c_client *client = chip->client;
 	u8 als_data[TSL2591_NUM_DATA_REGISTERS];
-	int counts_per_lux, int_time_fval, gain_multi, lux;
+	int int_time_fval, gain_multi;
 	u16 als_ch0, als_ch1;
+	u64 lux;
+	u32 rem;
 	int ret;
 
 	ret = tsl2591_wait_adc_complete(chip);
@@ -473,23 +480,28 @@ static int tsl2591_read_channel_data(str
 			return gain_multi;
 		}
 
-		int_time_fval = TSL2591_FVAL_TO_MSEC(settings->als_int_time);
-		/* Calculate counts per lux value */
-		counts_per_lux = (int_time_fval * gain_multi) / TSL2591_LUX_COEFFICIENT;
+		/* No visible light, this also catches C0DATA == 0 */
+		if (als_ch0 <= als_ch1) {
+			*val = 0;
+			*val2 = 0;
+			break;
+		}
 
-		dev_dbg(&client->dev, "Counts Per Lux: %d\n", counts_per_lux);
+		int_time_fval = TSL2591_FVAL_TO_MSEC(settings->als_int_time);
 
 		/* Calculate lux value */
-		lux = ((als_ch0 - als_ch1) *
-		       (1000 - ((als_ch1 * 1000) / als_ch0))) / counts_per_lux;
+		lux = (u64)(als_ch0 - als_ch1) *
+		      (1000 - ((als_ch1 * 1000) / als_ch0)) *
+		      TSL2591_LUX_COEFFICIENT;
+		lux = div_u64(lux, int_time_fval * gain_multi);
 
-		dev_dbg(&client->dev, "Raw lux calculation: %d\n", lux);
+		dev_dbg(&client->dev, "Raw lux calculation: %llu\n", lux);
 
 		/* Divide by 1000 to get real lux value before scaling */
-		*val = lux / 1000;
+		*val = div_u64_rem(lux, 1000, &rem);
 
 		/* Get the decimal part of lux reading */
-		*val2 = (lux - (*val * 1000)) * 1000;
+		*val2 = rem * 1000;
 
 		break;
 	default:


