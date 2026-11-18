Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030256;
	b=FByJku0DIFJ0dMGZlVJtT0WloNJPUPK1bc2bd0kr9jX+gbICkSJtma+u7LlUeVHpBoYd
	 iT8pHZHnyxDs4hRA0Xa/OYoXijh9/CGPvmZQ2oNsuZI9P9xq5QhObzI4IdzuOq77Cc6Ns
	 m0z67AdBD1AACHyjqMMVbyyiQgijX2ySNNm2mPalkZ6DviQXxKsFPm1nLYEnuAbFKtxIN
	 KQKQ0asWX4aObeV02yMWzlds55aX4/QnJD6hl77ia98UZw8d4K3TnkUUOTJj97gEyWMn0
	 Nt2SaaNmYcsarYvtQV8F4tTuhW1Q74why9n+Yqt88TtjUfLyIwAgunz4c50huJbyRrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3/uz4jAfZf3fx/am2rp4yWlUXNZ+woBQm0ml5HKyJ/A=;
	b=KAiEL1KbM2qVq55lRnIRM5jQ7GYXN875Mp9FFuTBF3/kIchAD+GJ05c4+L5SDCHjUcGU
	 BZWo+alI+mh2VrsLQKZaOnvYFdpGG1KwimzGZsu7g9JYVmP1y0m+0wfVWNnGhGcP0qlZx
	 nUSvXWzidcpacbQ1xuUCgv/gaJxgjE/1hnyjSipvS4p2FRFZ0S2WW36nm1WepqQuf78/q
	 SCGeYO6q0bVyK2EuDWJi64In0vSVXeA2pTsB6+IZ2NXdweT7PB9KFzGvN0Q8h5sHBh7p9
	 BxopaPNQEcOWt6nXUn2pFO3AecuNg2e9PU2zQsh/zwNzoWhCwK9DkG8QVdCKSNa4Kvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=taqdbung;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896BC606A331;
	Wed, 18 Nov 2026 19:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=taqdbung
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B5A1F000C4;
	Wed, 18 Nov 2026 19:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030256;
	bh=3/uz4jAfZf3fx/am2rp4yWlUXNZ+woBQm0ml5HKyJ/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=taqdbungjAarwDVHLsaNaDh9SglFoADYTC22TAzU0dpnam/IwHCTa3Xiqw/PWNPh9
	 46g6+VcaQqim4blloB5VKB8ROSM9AQgJtsfOgQWfx+GyneZSaq8LlURbolyyP31y+I
	 hCq91JDfB+PNDhJVUrZxTpM7sjIbtKQ3QTSdcp4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0639/1756] iio: dac: ad5758: Fix alignment for DMA safety
Date: Wed, 18 Nov 2026 15:46:06 +0100
Message-ID: <20261118150034.293379893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arka Mondal <arka@arkamondal.net>

[ Upstream commit 465bdce79a9fe140a4b46b95f6bdfd880d197148 ]

ad5758_spi_reg_read() reads into st->d32[2] with spi_sync_transfer(),
but d32 is not marked __aligned(IIO_DMA_MINALIGN), so it can share a
cacheline with the fields before it. When DMA is not cache coherent,
the cache invalidation after the read can discard CPU writes to those
fields.

Mark d32 __aligned(IIO_DMA_MINALIGN). It is the last member of the
struct, so nothing comes after it.

Fixes: 28d1a7ac2a0d ("iio: dac: Add AD5758 support")
Signed-off-by: Arka Mondal <arka@arkamondal.net>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5758.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad5758.c b/drivers/iio/dac/ad5758.c
index 98771e37a7b52..d7fd2acd7dfee 100644
--- a/drivers/iio/dac/ad5758.c
+++ b/drivers/iio/dac/ad5758.c
@@ -118,7 +118,7 @@ struct ad5758_state {
 	unsigned int dc_dc_ilim;
 	unsigned int slew_time;
 	bool pwr_down;
-	__be32 d32[3];
+	__be32 d32[3] __aligned(IIO_DMA_MINALIGN);
 };
 
 /*
-- 
2.53.0



