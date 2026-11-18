Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040315;
	b=rlFK01bOVCQNYV8aUFQsdhPz5FIw8GKwzvBtJMjP8BWV31QkkJmKQ91FKkngDBhYzAti
	 751fQguHsOfp296BCtARkAwMwHUTnNq0QBplU2DdSocsj+uuHYu2FQvc7HCbJcOpZl2zG
	 ukSZfc1eWc0YNszonmmvJZ98/M+98uv2rXXGRI4JekaMwiUbVghdaxrVPNECC+4W/RDy/
	 Iw+i7JqQsG0qw3rOcLJLsdnnphWYYTqnLLgtzUuUasGI2CL2h4WdQt0JbxRLqf/6+794G
	 9Nel9w0py7ckIMzB+Rol7TsIp5LXDrXM0aHKI+ucdfC9aPVBaCJ9J4U8EKyvgHhXSTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1VI35J3wwsHvMzRkVqmOXrxt7RM6zoJtyLFE256mHs0=;
	b=idB5/Beo3NvOVDTqDogLsPfSHquruQja7npKZo66A+HGNj8EsnwXkDySW2bokyYHlAy0
	 L7g1tCSCafy80NFZ+wWPZwwfM5HT6D0Gm3F+PP6j8l3OohYgCS8+BVTpbwRGEW+aqtgfQ
	 +YHO18Glm+1upRD1N+xDrKQmnUdk4wyP6cLFeJdcPjgo18RfJpEgmTrKzw8w1PlcwkOKU
	 LT/FzB3mLB/bgGeDYMkH2qlQL1SV/poepO6gjl4mMaB0ppKot7cIdtMx69Gct1izLYyzn
	 3KzZXZ1l7S+vztwJ4cP6hyu7GFgYxuoYC7MH3YRKKe+EPa7tT8Civp9bhvtDfXQlc6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pt/MQU8Q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8341F606A31C;
	Wed, 18 Nov 2026 22:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pt/MQU8Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA30C1F000C4;
	Wed, 18 Nov 2026 22:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040315;
	bh=1VI35J3wwsHvMzRkVqmOXrxt7RM6zoJtyLFE256mHs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pt/MQU8QBOMTRd/dqAYzr7UCVoYQ3NZJiYKF6lCLjjDmjaRSNXKtlbhznKKtOqxu5
	 BHEgZSboXo3EhlkUAOodiTh3Jcx1VTJerLQawGWdNsEvHKYhhQDX9RKjpZlUJGbw4d
	 8cpznAUv/7kaNh+mY6yLskE54Z/MtnaEfAWnEobE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2414/3318] iio: dac: ad5758: Reject out-of-range raw values
Date: Wed, 18 Nov 2026 15:50:36 +0100
Message-ID: <20261118150433.910430619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d7fd2acd7dfee..19e8397b6ca05 100644
--- a/drivers/iio/dac/ad5758.c
+++ b/drivers/iio/dac/ad5758.c
@@ -557,6 +557,9 @@ static int ad5758_write_raw(struct iio_dev *indio_dev,
 
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



