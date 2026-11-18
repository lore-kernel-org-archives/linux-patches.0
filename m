Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039141;
	b=LSZaFK8UJfPaLX2upIoXidTn035GJj7kAYIIAfJMsscyn5O2aUm3uyntMmA5JPz8iJxG
	 mUgG0nnI7BZxuKZBNAayrG9yeylbEFyRZf6eugmLJVLuMoWUaIbuUzGq6uD8U2qzkuZ+U
	 0URBtrdO07guEziy8l+B8iFxFttPIb4gG3AZoAzPgEnuHRBp6Z3Qt8j5j1CXKoAu3awMP
	 ROdmElHy7yL+W25eHZCFVYZ8oLLVIqUymBLRgZJDrSvHQyuFRMAc5Pb1yUQpE+JKL87qc
	 h79SQBy2k3wM2PsuV5/dCyvB3AL+SHt4Om3tibE1VamYX3jZSz3PjsgHDwiaYmDrKCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ceMpoFf0VZBgro5JEjg6KYMpc13ehiPLHvq1o97ZB8=;
	b=D2+khEafTg4Rm54RLT7Hgg2QF/Fo+9HJo511uNWJOelWDGlJs0tWRYBn/lriQIzsvXx5
	 ax1LO7ta9R5yWA5CcbU741MQ7nkxT0JAWGqM6fD8paZ2/YlCPopZn+2i2kc3jbaP2LCoM
	 S3++lWW81vLKwFR1ezPiFSIuUyGrNdOH8iGyUN0XfHQ3uvEuK5H1VALlSSEyR0D05neB4
	 ZpBPyndHPzuXB0cT37Ic70eM/SUke8T8c3MHWa95oSg28XuPXy8nKGy2qE9sBJgTxkXyE
	 V2VC1pne/Rnyu0O2c3FBIW1F04BNXYo+zMkn+ANCdIw7KJPVRqJbF+9THV9Ouuc8Mxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjtv3q5W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D7A606A31C;
	Wed, 18 Nov 2026 21:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjtv3q5W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A7E1F000C4;
	Wed, 18 Nov 2026 21:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039141;
	bh=2ceMpoFf0VZBgro5JEjg6KYMpc13ehiPLHvq1o97ZB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjtv3q5WJUgBISTGRH41LIrwBAxU7OKVuZlPWMe8WNseZ+jgvzL0oUQwaiA+JZvQM
	 EnJPqoUYgJd4rlxUqaZSG0cSFc5SVYyhDKeEK1DGFdv1L+gDZELx5egHXEkZWaaG32
	 Oi5rI4Dtro5mgbys8PQAy6ChGqo1QN7WraJNyWqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1993/3318] iio: temperature: tmp117: fix calibbias cache update on I2C write failure
Date: Wed, 18 Nov 2026 15:43:35 +0100
Message-ID: <20261118150421.845771189@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fc02f491688b5..5f0bd735a5733 100644
--- a/drivers/iio/temperature/tmp117.c
+++ b/drivers/iio/temperature/tmp117.c
@@ -87,15 +87,20 @@ static int tmp117_write_raw(struct iio_dev *indio_dev, struct iio_chan_spec
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



