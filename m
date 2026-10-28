Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211092;
	b=mpqyLSNRqzSfX78G9l0nX4T6l7Qz/fIoe86UsGIaa6ABLCNFYasNIY+aAkc4Q3Ga2QP6
	 7pPAPs/4ODeiW9DMgMpRYI4Ba65EMN0hN4rpeW2DstgF0DbSrAPsIpJRiTh7UFQ8am5ah
	 spYY3PV43E11UGkakm1mDYXluYCAkqdaIgu7retcGBpnPHK7baMYa+sbItY5Faej5KJgP
	 D+G1BwqVQx1BojxPXn8wQiaWN1Ol5t6dFtQ7AoKERVgwqKBW8Kz3krHzs+m7+giF/a2+M
	 xmO59wk7yg1olXu7tli/a1JlfhP0av0ZD/vrQVYkmZY+PIrA/p1r9f9ToLD/ZuvzrqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HMUazfsrqDdwki1QRi9YIwTnHlb7ohYhQbReYCW76Js=;
	b=l75VjDRn1JQHl/pbxwUPZrOReNNInuLOHUnwvfZX/d+qDREdoEcoDlcq9P8VC8rDILBi
	 UKLJfeH9vBCM8ItBaTevaxCmOoa58dFS1Lsuud2drS0Jy/tk16cEiP5QQjLYH5JXt3eXR
	 iaJaKAt/H3Bi/4iR+0MZtdqK6WQiTx3eJ57RFnaTx9DDtwjrGtlVI1lITByylCrb4zdNx
	 bUQr8WbH71DtQL9aBSweRVDevq+JSj7D5iS4PAMaOMaAQZIAGkYBHe+fsgwc38v4iJ4WB
	 HmlGAHkHQcZL7E2oNv6aihXw9rIa0Oo5bliQlr2ZTqKRqjuR9YfDcF6v53LE58mKGOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qzkT4mpf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4985C60A3831;
	Wed, 28 Oct 2026 18:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qzkT4mpf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DCC1F01829;
	Wed, 28 Oct 2026 18:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211092;
	bh=HMUazfsrqDdwki1QRi9YIwTnHlb7ohYhQbReYCW76Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qzkT4mpfInAHB6295mhKey0wyNgAOTDSK7GZcgOvB3HTGPnHYQaMPEoY9AciGPDdV
	 h9UzaxqwAX9nl96YQ9dtonz3iQUppEfG/tAU0fMU6dDrpqD43SUTD1gisl92ThGWam
	 OF5bwjaT9mGHYDcSCwL2+UhLC59NFvsQqoq00gAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 255/571] iio: gyro: adis16136: fix unprotected debugfs reads
Date: Wed, 28 Oct 2026 17:56:42 +0100
Message-ID: <20261028170014.056296718@linuxfoundation.org>
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

commit 2b498df75d6c29aa3e760127ae0f0003df598b53 upstream.

The serial_number file operations are open coded and never call
debugfs_file_get(), which debugfs_create_file_unsafe() requires.
debugfs_remove_recursive() therefore does not wait for a read in
progress, and unbind frees the iio_dev underneath it.

Use debugfs_create_file() instead.

Fixes: 9aaea09b4cbd ("gyro:adis16136: fix debugfs_simple_attr.cocci warnings")
Signed-off-by: Arka Mondal <arkamondalofficial@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/adis16136.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/gyro/adis16136.c
+++ b/drivers/iio/gyro/adis16136.c
@@ -145,7 +145,7 @@ static int adis16136_debugfs_init(struct
 	struct adis16136 *adis16136 = iio_priv(indio_dev);
 	struct dentry *d = iio_get_debugfs_dentry(indio_dev);
 
-	debugfs_create_file_unsafe("serial_number", 0400,
+	debugfs_create_file("serial_number", 0400,
 		d, adis16136, &adis16136_serial_fops);
 	debugfs_create_file_unsafe("product_id", 0400,
 		d, adis16136, &adis16136_product_id_fops);


