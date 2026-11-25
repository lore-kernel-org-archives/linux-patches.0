Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620617;
	b=4jZlzWV/l80GCDJGZxipYgN+MDO1P9e36xDRHWdl1DNdYf6DeG+CIXNwHikXnA1gXlS4
	 vTE1yFo2Dnk1O4C9asGGxzQr/7kuig3Fsb7eXwf56ExPZUWGkGaJG4UaYzOT6Xd1shlsE
	 eWPKudC7l++8pDTCO3IXSp29xtzZ5USVEpV3gAk2MbVtJsYIZKNitwTVd0UdpVQQkNHw1
	 P4eOKS8lqWY9Ewlcxjqx6ssWQOK1qLAOgC6X/SiKYrXMhxUy/Syxg2fV+Dt/AcooqvOQA
	 jyvANJTC8jEyWyokRxsgYU59unAjjotQMLMeqpkX5n5vFH2XcIm5l3HDikCwP0cp7kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o98M6tJWcXcd4jGs9cw70Gftu+QCpqKE7/9ZRiEMDa0=;
	b=EW1XoxlvuzRcr9Osb5/P6t6Dyzb1gxQ1L3qy0ToBL4weHoAsVmSsbPwtq/fgAFB5QtD/
	 KZjivLlWw356ygj1jQ62dTBCQvwDgHfbeFUO4J456A7JylB53btCrJ91Qfotbtp+euij+
	 C51xysF+OxtmWZMtlUcUq2VTeJC/fzaGABPgDOdPKykOjt0fiZETWa2oRx+DS9If6HPD3
	 VNCeIiJrabuR3i4P7agNMwJDc7WeH8JScvRgiFzOZy3gNJmVaBMm0eCG9o1eEBrJRYMyz
	 4e8f5u5+NJaC95tIuR+Uwc1t75xet66GboR0vwoK04cuIewKJTWN8/9uhAU96GIH0ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=urwfxOhj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC894606A33E;
	Wed, 25 Nov 2026 15:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=urwfxOhj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4E31F000C6;
	Wed, 25 Nov 2026 15:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620616;
	bh=o98M6tJWcXcd4jGs9cw70Gftu+QCpqKE7/9ZRiEMDa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=urwfxOhjds8EZGG6aiTX1Mc4YZucps0uSNYr3+QgUu1UDxGDxqMxWMKoub/KEB1tc
	 GkWiWexqfTf9XV7xz4EEBQFHi66OCMjTei+PLGZWovQHXwb5J489pMSef9xr9PVTWn
	 C/s/ExckUdAgWrGSydeKVR4uDqKBTjGXiWTH5iUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0975/1005] iio: humidity: am2315: fix negative temperature decoding
Date: Wed, 25 Nov 2026 15:38:33 +0100
Message-ID: <20261125143844.503875419@linuxfoundation.org>
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

From: Vidhu Sarwal <vidhu.linux@gmail.com>

commit 0a570feeca37d85fbfd6b4f6e3d9f33e1461c634 upstream.

The AM2315/AM2320 report temperature as a sign-magnitude value,
with bit 15 as the sign and bits 14-0 as the magnitude.
am2315_read_data() stores the raw value directly in an s16, causing
negative temperatures to be interpreted as two's complement. Both the
read_raw and the triggered buffer paths are affected.

Decode the sign bit before storing the temperature value. Positive
readings are unaffected.

Fixes: 366a3270c1c5 ("iio: humidity: Add support for AM2315")
Signed-off-by: Vidhu Sarwal <vidhu.linux@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/humidity/am2315.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/iio/humidity/am2315.c
+++ b/drivers/iio/humidity/am2315.c
@@ -113,6 +113,7 @@ static int am2315_read_data(struct am231
 	 */
 	u8 rx_buf[8];
 	u16 crc;
+	u16 temp_raw;
 
 	/* First wake up the device. */
 	am2315_ping(data->client);
@@ -144,8 +145,15 @@ static int am2315_read_data(struct am231
 
 	sensor_data->hum_data = (rx_buf[AM2315_HUM_OFFSET] << 8) |
 				 rx_buf[AM2315_HUM_OFFSET + 1];
-	sensor_data->temp_data = (rx_buf[AM2315_TEMP_OFFSET] << 8) |
-				  rx_buf[AM2315_TEMP_OFFSET + 1];
+
+	/*
+	 * Temperature is sign-magnitude, not two's complement:
+	 * bit 15 is the sign, bits 14-0 are the magnitude (x0.1 degC).
+	 */
+	temp_raw = (rx_buf[AM2315_TEMP_OFFSET] << 8) |
+		   rx_buf[AM2315_TEMP_OFFSET + 1];
+	sensor_data->temp_data = (temp_raw & 0x8000) ?
+				  -(temp_raw & 0x7fff) : temp_raw;
 
 	return ret;
 


