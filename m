Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208849;
	b=I7HC8rOBReCfTlgg3lkMvadWg+WrpKgaCKQ0rXrfmJtzcyQNQoifYrftJBR/Fk/pdmhK
	 Bx93UOQphbSxCZnmJwASD43+SSEp/kUdKCQwFFMkGMJB0+F1hayS18HbbYNQ6vRduA/Y/
	 iz8hnw0q18lvdGrIkb92sdweS2eyhUPLx7cQv0EOGucvwst3VPZ9AYdWz/HYWSBzbi3Q4
	 EWPrOakQvPdWWMO3IOdzimzskfTTM0dA+AePMxdyb2DJcXtxm8qaAsAw/VCYCdu27JQ7N
	 12Sbb2+oBtxzMGaPCWaYMifSriX10Rd546zfutZ6eAX4Dxy4hm62WRLQwZlu45+rqWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LHvsdkxWGMoiXyRVyu1kFxC7sQNb3hn1yG22zfmZsGY=;
	b=HIgBC5eW/hD3HWIrgsmmip0zpEuMuxuTz0YN7cK/xebYmJ07/VMgtEiwqA5jgqR9Fn+A
	 mhtWHty9CaPHSDQFSgMP6blNvCNhKQJa7BhstNiW7uY23UwWVWVYRhUcROCYDy1ElocZ5
	 6i+FJAc2Q62XsZdraGzMvKZPFD15SnjfniistBYcKCwgLayo/BIvLbRFNtufaJIRvsb08
	 nSHnb/Vj1+pgv4joZrOTIU8tMv6n8mB/fCB4gX7C1teX4z2qGoqfkSGmcJt1AeorYcMuu
	 rtHH9AgMVZcJuj0cn3c/c+D9YMtKoTXjHyOyr0Hbo+neHRSqtFL4VSCMI2fATNy01+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dg2LwVau;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE4F606A31C;
	Wed, 28 Oct 2026 17:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dg2LwVau
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5911F01825;
	Wed, 28 Oct 2026 17:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208849;
	bh=LHvsdkxWGMoiXyRVyu1kFxC7sQNb3hn1yG22zfmZsGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dg2LwVauDs0/xnIlSNl9J8pra7vFbr1Bgam+lOmLECJj80IZc7mf/lcytKaO4rNBq
	 rRSwYbfs8FaM25B8L/soqfdZ3pMoj7pt3OB5cV5rCA2YwIpcswaJtxspaTfpRxFrew
	 gYqFaQu1vjuJEWah3+sibwFQUHX/Y2zGTdK7IXzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 237/516] iio: gyro: adis16136: fix unprotected debugfs reads
Date: Wed, 28 Oct 2026 17:56:29 +0100
Message-ID: <20261028170009.117010543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -150,7 +150,7 @@ static int adis16136_debugfs_init(struct
 	struct adis16136 *adis16136 = iio_priv(indio_dev);
 	struct dentry *d = iio_get_debugfs_dentry(indio_dev);
 
-	debugfs_create_file_unsafe("serial_number", 0400,
+	debugfs_create_file("serial_number", 0400,
 		d, adis16136, &adis16136_serial_fops);
 	debugfs_create_file_unsafe("product_id", 0400,
 		d, adis16136, &adis16136_product_id_fops);


