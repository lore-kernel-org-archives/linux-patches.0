Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028886;
	b=zJHrgvoLZbCm/1WlWvF/J9GrRxAzWCW+68Wk0IUuGODtXd/3ybGTw8BV+qUUK1U3x896
	 ep53jGztmN1LED0g3WgNNyC3NXH02rgvJ996VKBhxRKWXTzn9m4E9N6pXQnCdOy5O10oW
	 4kIb4D63Dms/fTJmqiSKD+GW4D4Tw7cARZG9S8zn9yXRxoN49y2w2EOts5FqG3TuqYJLq
	 I1KdkG/urId+zQSZ/tOhIniQrNSlPqB8iQ1fLNlhTLJ8o4Xud6aNx4jvOLfmF/fXWPInC
	 H2bA9sVtexVvdI2q+RvywIbM1ZOBxBckyrdQMh99hWZEmir3Ol8nZ06S4uDOn6PcFpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ed+1negK4STS8hLLTbFRf4zAsCDL6i1+HDGQ/pPlbS0=;
	b=icw0kjaFEygNqI19aRZ+BjRdyJ87+J0RSYakVmg12RGyaiV8UZC4X5f/8eJzch4b2laV
	 evGnkpXrW9KkMZMmaUnskh6A5hfgEfz/o7vSWNofGT0BqKkGb1c+/axKem+C1JN16NJmV
	 ZlTjOlLuD4xemWPqSB+vgi28Dh7bnWQnObnCuRlyMVTLdUlZls5baWl9qUsviOA1SEzEC
	 KVr+ydIBX3gz5krKyFD5Y86pV5g0zivurrrvAQnylQM7V0iHecMnPd4MUUlxLtBI0bfBd
	 FEY8+rBqqNcftFz6SX/9lvBXaOAlGYfY65nxDF5RA1+YTPSg9j7rOPm1VS6KhwNrOkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="A/uHB3Px";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87578606A325;
	Wed, 18 Nov 2026 19:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A/uHB3Px
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856751F000C4;
	Wed, 18 Nov 2026 19:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028886;
	bh=Ed+1negK4STS8hLLTbFRf4zAsCDL6i1+HDGQ/pPlbS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/uHB3PxGBoJE/Ft3SXsb7XZuT0YP0jXrHne/rvm7Gm+OfK4Br8HEn+ic7i8NGTG6
	 Jcd/lzH/zEmzt+4wNh7bDAVpySnxKOEcI1d3vQQxVM3nPuOEtkKv2ZFhVkx/m5bHO/
	 jKem07JA9T/8tLry1D8aSXwEh0VQIIeQG8Ra5U2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0152/1756] iio: temperature: tmp117: fix calibbias cache update on I2C write failure
Date: Wed, 18 Nov 2026 15:37:59 +0100
Message-ID: <20261118150014.180847749@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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



