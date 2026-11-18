Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022816;
	b=COXizg7qGnB4nBLX0ApDvzoEhHEC42SqaoywHtwwuDa6xGdmAGdc2IttREto2WQhlkNm
	 wloSU5SOGeRj0lzdWOd90Rs30HN0aJyngxp6aK3FZFQE6/21FhKo6xrj6UoX69yc9gJJm
	 tgxJaCDMR00Jb9VYoVXC5nlY9E3TGINtRN7Siw1lZ15voC0w3weq56M3XQmiTZsMDZ09c
	 SgS+cZDtJ/NniofWMJK4zZX00zpcgzva1fue9rHnngRLIdSjhWu72OGcjRSEZwAuxsAJ1
	 VMJvVs6MKcc5CDZSiMvCLHKtlwgtCg0qbpReJcd87jiC9cgYoBh7z0gDWEeYOUaQNFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FyCdANDxBLQkA/16YnM/5OV+ARAuuuDARBV5+jw4Lg4=;
	b=OF+VwIUKsc8fRfiWXXI08zZmWNbyAMQK5vMHBzlPO+2A1hZ0Gd2pHgMErsgLLva956d5
	 JGTLhsAPFigFgfBPf3DByfamJ2m2WO/Yqs/CEWrG3nNaCu3xd14QOVqHXdDnw5UQhr6k0
	 p56UjdlTIsafEJkR5S3axe6L0/+Bn5Z7ijkWVTFI3kJSn6C77ojLvWKVL+Ab/8mqfqN4L
	 iJPybSli5e0I0t/ttreUmGkYvoxK5UZkeBLiieLnynCMnEFZLVcnQbk20p+QOR4674Tzy
	 QqZM4y7heTNhu10OuontgDqmG2PGSurbIuj87nfehtUN9qc/CDayhFTuozrYogMHNmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GAR8FGSW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70960606A74B;
	Wed, 18 Nov 2026 17:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GAR8FGSW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D5A1F000C6;
	Wed, 18 Nov 2026 17:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022816;
	bh=FyCdANDxBLQkA/16YnM/5OV+ARAuuuDARBV5+jw4Lg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GAR8FGSWgichwjPzSE6v5LI0oLfmXuK0jtjMkvMobI9HPb373e9UEyjlDl8pByJji
	 BFnoOyCot6DC501XjGV4koNM6nlu3OZRY8dCf765+miQzCgSRoSnfk1o03zQWOe9Iv
	 2TwLymRWrKH1pJUy3HkHoBUrOoum8Tl2VhH0giiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0149/2151] iio: temperature: tmp117: fix calibbias cache update on I2C write failure
Date: Wed, 18 Nov 2026 15:31:24 +0100
Message-ID: <20261118150127.200074410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit 61fff9cebbfdf39bbd04d366882476d1def14047 ]

The calibbias cache (data->calibbias) was updated before the I2C
write to TMP117_REG_TEMP_OFFSET was known to succeed. If the write
failed, the function correctly returned an error, but the driver's
internal cache had already been updated to the new value.

This causes the cache and the actual hardware register to go out of
sync: a subsequent write of the same value would be silently
skipped by the early "if (off == data->calibbias) return 0;" check,
since the cache matches even though the register was never
successfully updated.

Update data->calibbias only after confirming the I2C write
succeeded, so the cache always reflects the actual state of the
device.

Found by code inspection.

Fixes: df041e737a38 ("iio: temperature: add driver support for ti tmp117")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/temperature/tmp117.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/temperature/tmp117.c b/drivers/iio/temperature/tmp117.c
index 8972083d903a2..ea2d4e0bae871 100644
--- a/drivers/iio/temperature/tmp117.c
+++ b/drivers/iio/temperature/tmp117.c
@@ -95,15 +95,20 @@ static int tmp117_write_raw(struct iio_dev *indio_dev, struct iio_chan_spec
 {
 	struct tmp117_data *data = iio_priv(indio_dev);
 	s16 off;
+	int ret;
 
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBBIAS:
 		off = clamp_t(int, val, S16_MIN, S16_MAX);
 		if (off == data->calibbias)
 			return 0;
+
+		ret = i2c_smbus_write_word_swapped(data->client, TMP117_REG_TEMP_OFFSET, off);
+		if (ret)
+			return ret;
+
 		data->calibbias = off;
-		return i2c_smbus_write_word_swapped(data->client,
-						TMP117_REG_TEMP_OFFSET, off);
+		return 0;
 
 	default:
 		return -EINVAL;
-- 
2.53.0



