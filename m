Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055505;
	b=jqCJ2fMM7MvH6FJyeMEEJNLqZKmv/j4dqU4h6EuUw9S3O3xlH3+jUlQKkkLzmMHhHEZS
	 9AgJz+zW8lYZpv1ApTluCf7omHvOfOOvdfEIKYWpGZR3uAcpqB46/2g06Ljt/TUnK81P+
	 xYrx/v0u2FQ29H3cAYjVgpc6abAUa0ZfyQ+UVXe7NcHEVF4C9nWf6wZ14jBPx0JSKg7de
	 ryZB8YXSbc53JC5eqtbmHDYZgM9Q24wBcB82mYzWLm+b+kxZ0zdKlfWcX8p/bgMVOfA9y
	 haRtOYPYYfMQuyNBZo5jXo0sYYnK7zOe3BaySRAlU16lgKf8nzgGiUz1FloJezlOq+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=iTP2N8ZC5WvCvIs/gQSnJxd4FB/geA4KwLLIennh57o=;
	b=ARG6byKHKI6vt97BWyUq8NT0Q2/InRVsp++bceg8CD2VpwobH/pr0rAKiZFofEklI04/
	 k5/OWCvUHpRrr1HmTaNrBhypYiCaa7Tg8psvibrxA8DrMRHKSsYZ5sIeuxbYk6D0a425h
	 uRX/kcPXa5cuHG/QPmLfKmfwsipqJsis/bw9F1BHV5GMaGLYGZpz42TlC6SM8bS9wahlN
	 AeNWxpstk3DefCrx7rup0tiSVau/BvYibKkJCfPM6fKCzhFOdtv5aGJ0zOEh7lRLA7wYz
	 WUdDiizxW28Xuzva2FXkmlDo9iBnvRJS6dSZo07DOR7JdsSCKKJEKvW7hGrVfuhi91g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MAkVhrRx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94B7606A330;
	Thu, 19 Nov 2026 02:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MAkVhrRx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F04F1F000C4;
	Thu, 19 Nov 2026 02:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055504;
	bh=iTP2N8ZC5WvCvIs/gQSnJxd4FB/geA4KwLLIennh57o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MAkVhrRx3XbJEOFlYSIDwfOeCLroor7Bja3cG4uDTjHIu3aKlnT5D/TDQp1t2W0bF
	 tisNw9T4gcGetuyak+vfAMtPepifJY/P+UYSEDXvyk5qyeVeYx84VWBx5VXBtsYn/E
	 4m1ybWAHvfPhPxMB+fvfUzAAahWWu9Vh1P42I9UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1638/2214] iio: dac: ad5758: Reject out-of-range raw values
Date: Wed, 18 Nov 2026 15:55:14 +0100
Message-ID: <20261118150117.459757370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arka Mondal <arka@arkamondal.net>

[ Upstream commit ebc026be1b719e47bd7f2f1e72fabc875b590f87 ]

ad5758_write_raw() passes the value from userspace straight to
ad5758_spi_reg_write(), which keeps only the low 16 bits. Writing -1
to the raw attribute gives full-scale output, and 65536 gives code 0.

Return -EINVAL for values outside 0 to U16_MAX, as ad5755 does.

Fixes: 28d1a7ac2a0d ("iio: dac: Add AD5758 support")
Signed-off-by: Arka Mondal <arka@arkamondal.net>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5758.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/dac/ad5758.c b/drivers/iio/dac/ad5758.c
index 0572ef5181012..5a8ede7d6e640 100644
--- a/drivers/iio/dac/ad5758.c
+++ b/drivers/iio/dac/ad5758.c
@@ -558,6 +558,9 @@ static int ad5758_write_raw(struct iio_dev *indio_dev,
 
 	switch (info) {
 	case IIO_CHAN_INFO_RAW:
+		if (val < 0 || val > U16_MAX)
+			return -EINVAL;
+
 		mutex_lock(&st->lock);
 		ret = ad5758_spi_reg_write(st, AD5758_DAC_INPUT, val);
 		mutex_unlock(&st->lock);
-- 
2.53.0



