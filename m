Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208985;
	b=UPG8dWf9twCRzQeIhxjXmo7FAdMneGxkpDauKm2kI7XJ5VgO4TcQTKgFt6W6bIwqOcrv
	 FSVW19Ve3ypLctOXKupvGW/bCKRxwQpkDVdLGfHPgv9am5adq5ZbEUlb64TFVVzhTtSqE
	 HpZuKlolefdB7tAeaIWcerOZ7MqADVZlgYEDCqfTByvdSmna31LVscJHBHiHgrqGNlhpg
	 1q7lYKU2rAhl7prm/KYfAg1RZcwIi1xKoUjiX1hCaXkqKdLxDlu63GpRIoJERJ5mxG8ep
	 lP9Xcjrb9Gigs0JahPRUy2EgvaVS0eipsUXumTA9IRYfr/zpHvRJP26RQvurlapYPAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oM8Hc2qNoXE1v27Zi7mZ1/ykBrHpAr6rLgOFeb0A5n8=;
	b=quj6hz0ZOz1UL6TPgLzIjWaTYjXVmNOL7gypkpda69Ljp0SpXsD2g2LhDD+4V9CVXy7K
	 tNE/EpiDjjtJuJHtR//jPYDmmuH2Vn3BCZie7GQ7UjUV4IApK6y/OgJxAFRAeCOyt2FEp
	 Abmaq9MIejH316OUso91M6miCf2wQ6y9mgZogettetnBfwMnU9ilb+DSMNXelKlJoFHRs
	 47prxysIpf3t8t7Iw19TsllESDssZ3IeyaXptD9eSWIpyQE4aPILXZ+PF2ehe/wwcCci1
	 ZuP6JpTL+2szBvZC7M93u3mySwGuKKo5/PyZTd+K68TEV3mgobMchb+Mlq78OsFpjZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fzvQeApo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A64606A31A;
	Wed, 28 Oct 2026 17:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fzvQeApo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39CD1F01828;
	Wed, 28 Oct 2026 17:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208985;
	bh=oM8Hc2qNoXE1v27Zi7mZ1/ykBrHpAr6rLgOFeb0A5n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fzvQeApoyyfqGqfAq0UNopof+c8IorlChU9S7PQNrRHeiDznCTIic+YsHKpZQOkU6
	 ktbOK2ahm0DNktl53p3s6E5c1L5xyGjAOUlkNaLRvtnQK+iRzhQA0lV5tEmivGG1Oy
	 TEr+boFm1MFGakoWoV9d2YiRQDCH3Kv0TDhAouko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 311/516] iio: adc: max1363: sign-extend bipolar differential channel reads
Date: Wed, 28 Oct 2026 17:57:43 +0100
Message-ID: <20261028170010.857229986@linuxfoundation.org>
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



