Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620622;
	b=haRsb9zEElu9RJsCLvCxzC2zN04hG1HV/jxVCgx60KzxP/aif1/yNIQyFoRdSt+F9+aP
	 abNfsOCmQcwxrGJ9ctOEqYbqxn4TToniubgJOQv3Nk3mBtyFtj0k2VaoZWs+bgzdVs1ri
	 XuHOhxdi7H+QgiDjx5kgnNwBTsWFXjRA5U4J44K4iiqmtzjIGy5h2WSU/5ll2z12Xx8+D
	 UFhL1WGvGI8HiwUCTEcubhCHPYubbdk3WCxdKySYC5VhtAyEA3TO/nUh17zm96CafWTKZ
	 QrNpRCmJ3epS9jwiRlpSqwTNvXcLLJnI22/9wRajHrYMu+ElcJNtdXQfER2kQi8UMwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HUQeYexbVN2O70BiiU3Ei3/SHIeIZgYf99FWRK3QNYw=;
	b=LpS98fzy3yT31NMROhuzWfiDnQAf5dNc3XOhg9wfyzGez5AT3E/7N021yXZ02JffCH7n
	 UCu3aNzCduyQEc8GPzw1F/Dawvp7BzC9wnQ4SaWooPjCAPYZJC4LgNYd/JGrXxSzYF8ed
	 aoLcmqDfYQlgKuSxveT67RjbCh3WNufRiSQ4n9KMDNChTn2JZIog2NkwIlWth5VXgD1Hi
	 mG1tXBPijxBTltP4WLF+nIG5YXC1vidaJiR6q1XzUqQqGycVg+makln8jHkuKhzpdggTN
	 2+f9nNCMBzgnG/4gwyCXcbFGJPTQ5PAVioLOzrYzsqSF7BR4Gq2PMBCaBhX0XaOkfHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLRHc0V9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3900606A330;
	Wed, 25 Nov 2026 15:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLRHc0V9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313AD1F000C4;
	Wed, 25 Nov 2026 15:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620622;
	bh=HUQeYexbVN2O70BiiU3Ei3/SHIeIZgYf99FWRK3QNYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLRHc0V9DpbCuxBrcqPtMnOjxC7hDyvqcSjBcx1Zgh+W/1i+iov4BrysxslVan9nR
	 0NyG6BKCoXkGXwn2zbs3/4rw/jzQkF7tzAXz5xirVEu8tdwJIAWgLiuPP+HiSNDldi
	 S8OvUMlIzou+pi1P4rp7kmnthouS0Hr5pVhaGm4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0977/1005] iio: imu: inv_icm42600: fix parsing of all FIFO frames for odr change
Date: Wed, 25 Nov 2026 15:38:35 +0100
Message-ID: <20261125143844.549900285@linuxfoundation.org>
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

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 4a141623442888458d147f4e61fe47411c0e4e17 upstream.

For getting all odr change events, we need to parse all FIFO frames
in each iio device. Fix this correctly by sending effectively all
frames to all iio devices.

Previously only batches of frames containing a matching sensor event
were sent to the corresponding iio device.

Fixes: f670d4d34773 ("iio: imu: inv_icm42600: fix odr change not caught in certain cases")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |   24 ++++++++-------------
 1 file changed, 10 insertions(+), 14 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
@@ -550,22 +550,20 @@ int inv_icm42600_buffer_fifo_parse(struc
 		ts = &gyro_st->ts;
 		inv_sensors_timestamp_interrupt(ts, st->fifo.watermark.eff_gyro,
 						st->timestamp.gyro);
-		ret = inv_icm42600_gyro_parse_fifo(st->indio_gyro);
-		if (ret)
-			return ret;
 	}
 
+	ret = inv_icm42600_gyro_parse_fifo(st->indio_gyro);
+	if (ret)
+		return ret;
+
 	/* handle accelerometer timestamp and FIFO data parsing */
 	if (st->fifo.nb.accel > 0) {
 		ts = &accel_st->ts;
 		inv_sensors_timestamp_interrupt(ts, st->fifo.watermark.eff_accel,
 						st->timestamp.accel);
-		ret = inv_icm42600_accel_parse_fifo(st->indio_accel);
-		if (ret)
-			return ret;
 	}
 
-	return 0;
+	return inv_icm42600_accel_parse_fifo(st->indio_accel);
 }
 
 int inv_icm42600_buffer_hwfifo_flush(struct inv_icm42600_state *st,
@@ -590,20 +588,18 @@ int inv_icm42600_buffer_hwfifo_flush(str
 	if (st->fifo.nb.gyro > 0) {
 		ts = &gyro_st->ts;
 		inv_sensors_timestamp_interrupt(ts, st->fifo.nb.gyro, gyro_ts);
-		ret = inv_icm42600_gyro_parse_fifo(st->indio_gyro);
-		if (ret)
-			return ret;
 	}
 
+	ret = inv_icm42600_gyro_parse_fifo(st->indio_gyro);
+	if (ret)
+		return ret;
+
 	if (st->fifo.nb.accel > 0) {
 		ts = &accel_st->ts;
 		inv_sensors_timestamp_interrupt(ts, st->fifo.nb.accel, accel_ts);
-		ret = inv_icm42600_accel_parse_fifo(st->indio_accel);
-		if (ret)
-			return ret;
 	}
 
-	return 0;
+	return inv_icm42600_accel_parse_fifo(st->indio_accel);
 }
 
 int inv_icm42600_buffer_init(struct inv_icm42600_state *st)


