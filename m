Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211328;
	b=Jd6wdsttF5d5f05LxHNGcarnzP43bNhcXs/4DHCpq2t9icXYhNkSnBKeo9A7FF7jNPzM
	 Dm4EYIhhGag7TngshfyQEdaN4GmrTnQkQRewLyc8mniJjTmLKzfVUIYZOyi6zO9ZRKss6
	 tD+LwGMqv1SXeGjsCC/p/j547pBsSQz2KQ8C9t0Yw2MJstlLo84Dnzehz71xNWmtkoc8D
	 gMQK/KfvHABfo8SUBxMS9oAb8+Sp4OrIuI33uP97Eu1bSiRtZfUFln64WT27wdUpo98uW
	 IOr1UgoXEkll/+QCuZjeoyIszIsSQm+2Xg2EgVtm9Tlx8LnqYrL/diRdqEQkB6hFn6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NtxeSSorMI60adeiQvhGWxl7hKf9Y20TJ9wrvDBqHuk=;
	b=wjyhOqRI4X67XK4XLI4to3qElENYtvm8NeOw9GACMcGf/7cJy2JzkIlL1ytp6eumTnko
	 qpI0dEghQP0Q7Fxl5WGvvf02NokJCUZ/etjQuIZBVLESJpdv2LwGMeYUz3zzv2gmMhPrm
	 pUHTHfLsOtlA4BaymjsNjV7y9BHHlnWf4J8IHcYWM8vDodlpKqX3R/AQ0gzhobhaeNnZL
	 IJPEksBdbBoL93WcYtLOOH/POFjYJBQlakIX7N9fhQHZWbM2fqUDn7oS3Cyz8fe5/VUHJ
	 /u9EMEkGvzSC1qwuJkVW77++I3ZEjEvZ2EEZ8DNvW/9yvnU7J2YGHnkDVuxIZ8H3zGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UdsAiOXB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25972606A32F;
	Wed, 28 Oct 2026 18:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UdsAiOXB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676DE1F01825;
	Wed, 28 Oct 2026 18:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211327;
	bh=NtxeSSorMI60adeiQvhGWxl7hKf9Y20TJ9wrvDBqHuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdsAiOXB9sTfEvWNeMfKhdDjlJt2SqBf7MmxdRiQUhnodvhqEtBlCqEiP3DTxS7xP
	 nR9joxNvzF4V7kaPzbKtj4dHdTvgbhfhCU4+1VPWgLnDeMODCGGVmriap+AmTQ3w88
	 sDVOYmEo4V0IRArTavAqzLAK9z3A/32q7XX1zXvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 339/571] iio: adc: max1363: sign-extend bipolar differential channel reads
Date: Wed, 28 Oct 2026 17:58:06 +0100
Message-ID: <20261028170016.061097255@linuxfoundation.org>
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

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit 91908c0a78baddc8572aa3ab69e62ee2eb496ba4 ]

MAX1363 differential channels are bipolar, but max1363_read_single_chan()
masks the raw value to the ADC resolution without sign-extending it.
Negative differential readings are therefore reported to userspace as
large positive values (e.g. -1 as 4095 on a 12-bit part).

Sign-extend the masked value from the resolution bit for differential
channels. Single-ended channels are unipolar and are left unchanged.

Fixes: d1325cf45077 ("Staging: IIO: max1363 ADC driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max1363.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/adc/max1363.c b/drivers/iio/adc/max1363.c
index 29c1824162cd0..c427fdf93dcbd 100644
--- a/drivers/iio/adc/max1363.c
+++ b/drivers/iio/adc/max1363.c
@@ -409,6 +409,14 @@ static int max1363_read_single_chan(struct iio_dev *indio_dev,
 		}
 		data = rxbuf[0];
 	}
+
+	/*
+	 * Differential channels are bipolar and the device returns the sample
+	 * in two's complement, so sign-extend it from the resolution bit.
+	 */
+	if (chan->differential)
+		data = sign_extend32(data, st->chip_info->bits - 1);
+
 	*val = data;
 
 error_ret:
-- 
2.53.0



