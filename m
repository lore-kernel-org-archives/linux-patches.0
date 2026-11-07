Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062385;
	b=eB5tW1TieckVoz2Edu5ggBXwqU2MzY6TDA+IcmzoWVF8HZY7QhI9iO+EXUyXVvI0mAKa
	 wOt02/OvKjqs0AYw3ebjweF+JafSyWQE6OTbLbv3KMYK9LITkrAdoFs4woCdf3xOHSl7Q
	 5lHP23xPf7+FQ/a6pA+f7UGivxlNFvgX6W5xEkysYjdjT7amwqlthyMJZdyGIwlqvvEEf
	 4jdGW72W0x57+6wUfBPSxavNy2b4vGbZIdfgD/ZL2Yc+7/lo9RrZpSGfzPOs08xehjFs/
	 9oqR0OY1Gg/bIeC3ezCKRRfV6y1plP9b4k+DbBovYy8Mza4KCy4xSzQQuyDbFaroTGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U27IMWcbNZg4K6ToVqCxJaUKZS8X+XarVXS0wlO3j5E=;
	b=P0Top5DxwH8LILo5AGgqtU4TFPnHIv0goU8LC1IoysGjJxXVaxH9oCVgFXxEpcyQMRzy
	 XVjtmI4SWRx1Mz598fInvlRHAcBWTQn3hukouRnRCKMqOj47MytnWOPyRCF/CccYSKuZY
	 e6qM9fQ81Q1Lsn+YxMFB+Q9WsohB8tMjK/+g95xGCO3LJHu5g6KTrmRgaoKeO2Rdiuqw5
	 LEC5YhZx55w0hi2b9gdQp3TpZTzVjURrBDur7qhDFTwymdslLb7MgBQU/K1B5MMQ9BGmM
	 bcDJl+rUzkj+t28i9YOnb/gD9Uyo43ZdAVSkBQEvPM08u/c6KWlURCSTT+vI0+L8YZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vu2XxQdx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7200E6083603;
	Sat,  7 Nov 2026 14:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vu2XxQdx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFBE1F0089F;
	Sat,  7 Nov 2026 14:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062385;
	bh=U27IMWcbNZg4K6ToVqCxJaUKZS8X+XarVXS0wlO3j5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vu2XxQdxsc/MZ0tY3IWXFsH2hsOv86fsx23X/sHM7HZhYPmMwuPb9jEWvn9U+9Jio
	 0QgV4h/dN6L0alxIPk58P1zRDb63n123Lo+Es1uX+eYeXzn71Ge3ODrdT4YMq/ym4B
	 l5hN4fLnAkPkkylhXXahhZ1YtLwL8Pu9oF52NaU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1279/1536] spi: ljca: validate the response length before copying the data
Date: Sat,  7 Nov 2026 08:54:55 -0500
Message-ID: <20261107135033.702690368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Weibin Liu <liuwb@xiaopeng.com>

[ Upstream commit 0fe4573c822c4c9152e2fd5269ab85410c9e458f ]

ljca_spi_read_write() only checks that the response from the adapter
carries the packet header and a non-zero payload length before copying
r_packet->len bytes from the response into the transfer buffer.

The payload length is taken from the packet the device sent back and is
neither bounded by the number of bytes actually received nor by the
size of the requested transfer: a misbehaving adapter can announce a
payload larger than what it actually sent, and the memcpy then reads
past the end of the 60-byte input buffer and writes past the end of the
caller's transfer buffer.

Check that the response carries the full header before reading
r_packet->len, then reject responses whose payload is not contained in
the data received or is longer than the requested transfer.

Fixes: caee8e38da67 ("spi: Add support for Intel LJCA USB SPI driver")
Cc: stable@vger.kernel.org # 6.8+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261013031717.3933277-1-liuwb@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ljca.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-ljca.c b/drivers/spi/spi-ljca.c
index 1cc1422ddba0b..83a47629f0ae3 100644
--- a/drivers/spi/spi-ljca.c
+++ b/drivers/spi/spi-ljca.c
@@ -105,7 +105,12 @@ static int ljca_spi_read_write(struct ljca_spi_dev *ljca_spi, const u8 *w_data,
 			    (u8 *)r_packet, LJCA_SPI_BUF_SIZE);
 	if (ret < 0)
 		return ret;
-	else if (ret < sizeof(*r_packet) || r_packet->len <= 0)
+
+	if (ret < sizeof(*r_packet))
+		return -EIO;
+
+	if (!r_packet->len || ret < sizeof(*r_packet) + r_packet->len ||
+	    r_packet->len > len)
 		return -EIO;
 
 	if (r_data)
-- 
2.53.0



