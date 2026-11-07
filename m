Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063027;
	b=f8nuYnzHaQ5GwTUzq2QZqb1O9Li/nZLPxkziji4sSRZtB7aRcjf6M7sLW0zKZdNKohnP
	 ntcAY2E1/KpTjPK9zMNWAFqh6kHXMEHtaTe8J7GaQUsmSyzQTvfjS0yaN4AyuDMATt6XR
	 xcPURURWQeimgXwp36ef5RXkBQh+oE3YgwafxBp2fc8T85t5tDQxBac6ic0erEV8Mcw3Q
	 Pmlc5lYG5+Ilu2iGz1uMjqwFNqEOfJFGaOX6Dpukann1asm4fNgSVKV7uMx4aOLsYFKAo
	 EnEOYEFk+h3jkBk7JA1pC+QasAqdGYVTI3eyVHAn+SeBXt4IGTUb2JlL3C2QI8ftx0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iUMy67ig1Ws++7GHkGMNrrY99wjTCNPdFw5bRd67fSA=;
	b=Ya+GZovaVYzumzcweAxUdAHZDU/+/TsDtr2OT0k5+RTHlwbYa8VyPPWihRWg+gkH7422
	 0RBX9v6yBYAiFvIWzKCgp2o7f6akphZhH6I+AACr3emrJvqenLaMAKf6qMHIDyVxBz1wh
	 StEOByg+fCfhq9yOXADDfDhWi26phgzGkQyYEip3M2xQbXHHMmS57EVfgrDEg+ShWaK+W
	 a3Ub2ousX5Cj+/mxOXnK0uV7MEtAKIH6JyD8mOWmsXEQ8tL8B0W8oMrALGkMulAytm5tn
	 BfItk5jle5ySh6HJdEENpSqLVhrScYPQi0TNHdaauQuN2w4YiPT/RoJ8xUuO0Hsj33w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L14+rWaA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53EB606D80E;
	Sat,  7 Nov 2026 14:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L14+rWaA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA641F0089F;
	Sat,  7 Nov 2026 14:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063026;
	bh=iUMy67ig1Ws++7GHkGMNrrY99wjTCNPdFw5bRd67fSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L14+rWaACcDDroNldgmBcnzXf/E+uukWks3QN4P2c7Vcazr+HVKMlvG/7WnuZDByR
	 Ouksb7gxPqeU8V0tUX79gTQHrGkJ1sCEYK/HX8cASaspHCbWVHzb6EkO7k8rEwqQjJ
	 9gsEiXVpX79WXzzolhtc3yZ+vrrPbR+jR1th6owI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 269/869] iio: imu: adis16400: validate SPI match data
Date: Sat,  7 Nov 2026 08:49:11 -0500
Message-ID: <20261107134900.817354620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 2c01a0a1c5550b4f502c7747c06d2e57a240cd87 ]

A device bound through driver_override need not match an entry in the
driver tables. In that case spi_get_device_match_data() returns NULL,
but adis16400_probe() immediately dereferences the result.

Validate the match data before it is used.

Fixes: 2ef920e0e5c0 ("iio: imu: adis16400: Use separate structures rather than an array for chip info")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis16400.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/imu/adis16400.c b/drivers/iio/imu/adis16400.c
index 7e85c1b8dc160..9f8721c196a95 100644
--- a/drivers/iio/imu/adis16400.c
+++ b/drivers/iio/imu/adis16400.c
@@ -1150,6 +1150,9 @@ static int adis16400_probe(struct spi_device *spi)
 
 	/* setup the industrialio driver allocated elements */
 	st->variant = spi_get_device_match_data(spi);
+	if (!st->variant)
+		return -ENODATA;
+
 	indio_dev->name = spi_get_device_id(spi)->name;
 	indio_dev->channels = st->variant->channels;
 	indio_dev->num_channels = st->variant->num_channels;
-- 
2.53.0



