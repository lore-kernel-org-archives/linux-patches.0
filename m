Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017656;
	b=35GDMisUid7/unJTm1mIfRHHggUAj0QcbWsc8V62RAtN9mm3xCE4hkL5WQRARO7wcpf+
	 fgKsgJfWfYkQ0BOqce4VnNnVQ86owQ24EdHoVIACDKiQmhReTlQU2O73X+9+8IoHxJlNh
	 C1BFLlgWZBSkMnzUfhLBCggw7HCM4mV8oBZqAityJI2rQLNCqc2QaSZpi9OfaYMyqOpFK
	 IPldHvvqhv+WzAsRY9CTj3ZrWdfXrPmLU0Z85H/imACkHlHVSHCW0yiA0meD6Mf7WOkg+
	 9kheI5E88Sb7DosBuZQ9wreGle2NEkhP1qv9iZxSVWCNv0I3u1xpwApeft78wbRxVng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Tn3Axpjf+f1NfoJNLVd/K4FpksOeqDko3sD8vb+6rwQ=;
	b=ZP3LGNUffK+gH5VthSA4gW818I2XX/UGSMe5TeSiZVTl+V3h/w3lxntAUV6rmCJmlPyr
	 cS8G0kx0XxwlUiZGAKaE8ByprOyzPHGeMuoonCVdNyu+S6qt84qS1V0KSnfd+/B0gwafT
	 jdhJCt6rULW0Re1lXzmX5Zlc0JhCRxhpJe6lw1upNyIIuwrl+NpFvPswPPAWPe7lJu0OL
	 hYWI3kdzopDGvgk/otTFQ6SMSYQK9Ad7X3r380GMI9572O0lPNBThjhwdZyTb6m68Rb7+
	 oa6ndRCDM4++kG3TZLhdOhB9xE8QDStpy9MYQk2om/aTkfYVRKbT5MlK1BV7Xyayxww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4N2JRA0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0199B606A333;
	Wed, 18 Nov 2026 16:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4N2JRA0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2210F1F000C4;
	Wed, 18 Nov 2026 16:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017655;
	bh=Tn3Axpjf+f1NfoJNLVd/K4FpksOeqDko3sD8vb+6rwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4N2JRA0MiKy64QJVU31lmHK00SNrpgY9YEs9YyJtS6f4KMu/aP/T/nwkFGQknNBC
	 ae/TfXpBT19xZZD5Ah3QDaWgqfbJieDCWLEqIOn2aCQx+RLkFe53lPSrODOq6yG7s8
	 97r7387+LEZAw9+TLhsrl1T0rVCHuMRD4QGxW6as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0955/2651] iio: dac: ad5758: Fix alignment for DMA safety
Date: Wed, 18 Nov 2026 15:36:35 +0100
Message-ID: <20261118150322.282450092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 44efa373cd80a..ba381bd252d11 100644
--- a/drivers/iio/dac/ad5758.c
+++ b/drivers/iio/dac/ad5758.c
@@ -117,7 +117,7 @@ struct ad5758_state {
 	unsigned int dc_dc_ilim;
 	unsigned int slew_time;
 	bool pwr_down;
-	__be32 d32[3];
+	__be32 d32[3] __aligned(IIO_DMA_MINALIGN);
 };
 
 /*
-- 
2.53.0



