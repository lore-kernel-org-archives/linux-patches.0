Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211095;
	b=FK0Y8SDUiuN4AQrJXGFh5X35zu5PIo+M9aPXLn8ZoIehKMmzsxUGTpFKdTSqb4OudsQk
	 onxk1ufMQRfpyIkkIFsCTw3UXsCInXphI3w/z4xUp36V2cVZE4OJkGlM1T6iVXzIoiTP/
	 8eO1nCamXyPObxmvqBRsE9rOz0IwixkQ9iTj6mWchDWxyM02HVQEoNM/AtGx/ljTDOn0X
	 Ac8ZlIx4Czt3MhIQgud5B0dXACAZVg+Q3DUINne/aKA8v4zLOtPTBnKl5DanbEDvorHBK
	 ZC0vkyZaKhfUmJR1PCaHa1c9xiCub9Q9a/7ULQzBGEJSL2NpF9/GwgR57LsnG9TLnXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/O3CpbuDSBWIR1gqNsBwx9p47NqfV5YNxulHnybAiCw=;
	b=XUeXhfXeBUe8+Urz4uggC1FGm98We/y0UVmXzgCPW8hM0MpM+G4QvGvvBEj9gcVA9l7x
	 jmgdAW0ABReUmPlHGXBmKKfbHqDJW0uT+1gyEmg8AQVkZ3ZTqP5xSb6gn8r/Wra7PntOA
	 RkzlRgCg8NzPSYkg9K+nbyr7EGM8zK30cEMK0URvJv3PrIl7GJ/lnPelkn428en3gjbRc
	 Ftajqj9/vYPx6DQ6vnwNVfBOPVbCdXJHnFabHfEJNjiyiLRBm8fujpb6n2TqufwEzO76k
	 Z7VSbZaEP5WE6RFOTf/xjLXARoloMnT0Qz6fRAB5BModge+RDIW4BwB4zLO7q7u6qTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FFqNvm9e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB3F60A3831;
	Wed, 28 Oct 2026 18:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FFqNvm9e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2681F01828;
	Wed, 28 Oct 2026 18:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211094;
	bh=/O3CpbuDSBWIR1gqNsBwx9p47NqfV5YNxulHnybAiCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FFqNvm9eCM98cmsLzDg5kpDWqGBJfjqMMThMMXMJK9jtVnwGy3bNDKLO87QdS1OyU
	 ndSLvWEggIcbhV6vqrZslEyBWgF9F14DmTW25K47SL3OsNjZw/i7P+Po/oGButl0V/
	 aVWoBteiAJEuovSPwoPj4H7y7K8rhMRzmDuwqdxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 256/571] iio: imu: adis16400: fix unprotected debugfs reads
Date: Wed, 28 Oct 2026 17:56:43 +0100
Message-ID: <20261028170014.080709617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Arka Mondal <arkamondalofficial@gmail.com>

commit d94787287a113a1326211647d5e0deed1e9de105 upstream.

adis16400_serial_number_fops is open coded and never calls
debugfs_file_get(), so debugfs_remove_recursive() does not wait for a
read in progress and unbind frees the iio_dev underneath it.

Commit ae1d37a9bb4b ("iio: imu: adis16400: use DEFINE_DEBUGFS_ATTRIBUTE
instead of DEFINE_SIMPLE_ATTRIBUTE") converted product_id and
flash_count to DEFINE_DEBUGFS_ATTRIBUTE, which protects itself, but
moved all three files to debugfs_create_file_unsafe().

serial_number prints three registers as "%.4x-%.4x-%.4x" and
DEFINE_DEBUGFS_ATTRIBUTE() formats a single u64, so it cannot be
converted without changing what the file returns. adis16475 and
adis16550 already use debugfs_create_file() for their open coded
files. Use it here too.

Fixes: ae1d37a9bb4b ("iio: imu: adis16400: use DEFINE_DEBUGFS_ATTRIBUTE instead of DEFINE_SIMPLE_ATTRIBUTE")
Signed-off-by: Arka Mondal <arkamondalofficial@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis16400.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/adis16400.c
+++ b/drivers/iio/imu/adis16400.c
@@ -279,7 +279,7 @@ static int adis16400_debugfs_init(struct
 	struct dentry *d = iio_get_debugfs_dentry(indio_dev);
 
 	if (st->variant->flags & ADIS16400_HAS_SERIAL_NUMBER)
-		debugfs_create_file_unsafe("serial_number", 0400,
+		debugfs_create_file("serial_number", 0400,
 				d, st, &adis16400_serial_number_fops);
 	if (st->variant->flags & ADIS16400_HAS_PROD_ID)
 		debugfs_create_file_unsafe("product_id", 0400,


