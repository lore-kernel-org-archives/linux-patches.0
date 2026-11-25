Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623528;
	b=EwZATs+iuR57tNWB2tOJdqJI5zXO1dPp3M4gT1E8AsRlZNlwo671QrWQ8+8VOWOQFl67
	 VcmQhVbA+vd4Xt8PxYxgAVn/+J2UaTh2r6RqpWEtB3Q5DcWlXoNolbaF8j0MMG74FeJ1L
	 IZ+hauKtckmPMgB81A0FbldZAiEkRKhJ/1roF6YgPGzbEPVgSWQakx5Er9ZflucapKkGx
	 EgJOyc8SiZsQangtHywW6gZeWWz2Dqpl1foOFtUMVDR3S3CVxJonq9pAkq+93NWYNRspW
	 qFFfXulGLPcp2D3LuykuYPNtXVz3IY3TrDjG9MU+1wn9fo2m+PnVsdKc+A80FzJgcDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sLdSl5r+MV27WLeZyH+qr2yxyEPKRJ5Vs2j0+VW8cCk=;
	b=4aG1RNJHoXq5K3fgLlDFCdHCQv9IUrT5jWnq7bJ9bpDk+jveLHfB16T/RWwJ32QFtg31
	 qjL8nrT3kDpcbJlvz0IZ/KfwK9CffIaBojkwwcRiojgR3auhQmOZSbuGD++dp8VMoPpoM
	 8r/bA31G89FygVtx25iHnpWrct0QtwA7H5p7tpNVHO2S82eHxQTvyniOf6AkQl6yOq29q
	 Jf1j5q5MZeTpWxxM6qqTVR2G9J7fu3uMP6B1zNrSQflwYfleU0kLbrJdIH5HwgXzIfTIr
	 YULObwDqVEx5qquwd1NLf56P6zT/OoCh/u5TeqWQqEewCoYFu50BDALFqujBP3WjNNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I7bCqc3y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758C1606A323;
	Wed, 25 Nov 2026 16:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I7bCqc3y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6731E1F000CA;
	Wed, 25 Nov 2026 16:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623527;
	bh=sLdSl5r+MV27WLeZyH+qr2yxyEPKRJ5Vs2j0+VW8cCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7bCqc3ySe/KXBhvmooya8rYV+olnmqFgvcPwEEUjw/PRA9ZlriCBA29FWOzQppFU
	 4NZ2EJil9r1Z9MOt/MGXRDlu0YAQ3ttyhI6QzMZ24XGWF4pFhk9mFBAJL0ZV+POtAg
	 9qCsK6oXtmkkLkJ4dbZMA8Yw2LiCOf+KxbU60M3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 890/990] iio: sx9310: use the data of the I2C table
Date: Wed, 25 Nov 2026 15:37:37 +0100
Message-ID: <20261125143842.859726978@linuxfoundation.org>
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

commit f3fc8718af9189aad13a2ad7f5b256475bb14b21 upstream.

sx9310_check_whoami() takes the chip information from
device_get_match_data(), which only looks at the OF and ACPI tables, and
dereferences it. For a client which was bound through the i2c_device_id
table, for instance one created with

  echo sx9310 0x28 > /sys/bus/i2c/devices/i2c-1/new_device

it returns NULL, and the kernel oopses as soon as something at that address
answers the read of the WHOAMI register.

The I2C table has the same pointers. Use i2c_get_match_data(), which falls
back to it.

Fixes: 21fd3b1373f6 ("iio: proximity: sx9310: Convert enum->pointer for match data table")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/sx9310.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/proximity/sx9310.c
+++ b/drivers/iio/proximity/sx9310.c
@@ -892,7 +892,7 @@ static int sx9310_check_whoami(struct de
 	if (ret)
 		return ret;
 
-	ddata = device_get_match_data(dev);
+	ddata = i2c_get_match_data(data->client);
 	if (ddata->whoami != whoami)
 		return -ENODEV;
 


