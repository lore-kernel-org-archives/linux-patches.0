Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015216;
	b=A5wiQG8+zffl3rS435wVfItLVSK7NJK4gYNG74h/NX49SlQwZY8u1VvRohOEi0hl1WD3
	 5fKtaX4Hhy8rFMUK24599YQseAoPjfb/9fBhhbGkrD434wSk4VblORxFecIzJhZADxNkc
	 tbF8pROIqtLZN5dRCCn5TBeiCHEH3OBo4lqa7T56MXfqd+ksFeU3zNi/HSuOUwGAiUfHo
	 IPzrJWQccNnC8JeQI42Wc3un21peqGQZi1C0QJbT5oLrVVajPjQ2sedVY14uOkWeL1miV
	 9aXBpOixmoOvwrmvQ4ldfqfnC2xojYEmz2dWRX/8BgR55PD/rUnl1M7qaqvP6DAfA/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xRnGzTGWQ0KmP+CD6mR1XAXHlCHvwPC5l4MhqMzlR88=;
	b=tIXqB7J1d9CtPeagisFw4nm+vmA9BJ+RytarffaPWaNP8vYs2WG0Te9Z/kUgY6apL+XU
	 GF+0thXRect8qYrbUfynkgitrL0a75YnOLkRA98P/KHLpqKaEi0rR9Lr/XmZSRCk7d9se
	 lVDKJr+D1Nh2dymbrPA6p0CZY2RICHvyDoO4SdaoTQ6Y0hA05Z+ZaC/Q0GYSPvjqvFBFf
	 7vyjVOC/BQm0LqrdjCE2yBK1ektc7Fvi2Xq46vx1k+p7Gr+fl/yWCVRFz4pWkCFUDohBk
	 CsegEidclqhuuRSDitO+6Pqyk3BJEAj6b6QZlQpIt0f3IU3maaccvEl5TtnQUCpH/mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cNYBY2sV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19FE606A31C;
	Wed, 18 Nov 2026 15:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cNYBY2sV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1108D1F000C4;
	Wed, 18 Nov 2026 15:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015215;
	bh=xRnGzTGWQ0KmP+CD6mR1XAXHlCHvwPC5l4MhqMzlR88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cNYBY2sVPZouZY+DqO9axf9ZpP2CaIRhDtRtfWudzTqt/9XK/UGRKfobJlHeJZerT
	 oHURA7u6wEQ2oXw4Mm9rrBHNmxOOAojOT43+VmurhlBi2zj6JYXIN8ipyKPnuZCcHT
	 8E1MzMbpMNUy03MiDlJnY2V9o8pInjB/gbVem7/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0094/2651] iio: temperature: tmp117: fix calibbias cache update on I2C write failure
Date: Wed, 18 Nov 2026 15:22:14 +0100
Message-ID: <20261118150251.287929208@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 74cb8d62bef3c..3d8c97aa0d998 100644
--- a/drivers/iio/temperature/tmp117.c
+++ b/drivers/iio/temperature/tmp117.c
@@ -97,15 +97,20 @@ static int tmp117_write_raw(struct iio_dev *indio_dev, struct iio_chan_spec
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



