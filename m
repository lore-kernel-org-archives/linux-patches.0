Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044937;
	b=Ku5W59/fSEM+Cip556YMo+MzMh0JAattfDbY6xn2nu9vEFdZOQDAdJoAorFSl00wl3Dv
	 eBlk23btIRbd/m1H/n+A7kvwrHIpi3sCgw4X06acDrjWDazx95upCAFdoLtphz4Rr/9JU
	 3Od5enw5BLbtCfmMTx1vYsN0zhqaXQHtfGiPga+FwZPcv2larTXRAAMPdpQM0DAj03zCY
	 JcPC2VY7J9mUJB+Q6kNqX19K34iLZO69olODHgcDKi1AEpcrdPPDP7dMDxJo3O5g97Lri
	 gbKiGCox5I84tfPxzn6h8a59EkrQu8WNuC0hu+fEqpG9npQDs9TfC7zewfp4uTIDiIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4AMAzwS4oiNixFuU473BBjGdCBBL2F2JaOn9ToQ0hn8=;
	b=Nm51LkeQo7m+QwaiVWNVqzMMqfyFRX1Bq+WnYXDvsdXgaklvK+OgLApgbSiAR8nYNlTl
	 vLEl7oFXpPgqEalen9de2PGLMIQigpGEOhddTV7qB0u08A4EiQFsv0BduMOtzH2+O6oQc
	 ACuflncDBaTT2r9aq66quh6hG8B+/nbfvEoMiCwrzfB6J4l0fq8aUU55VQBxK8YxN7mWF
	 vAtkg3xilCRmqRTTM0eK0tynAWWkBTPkqHkrV5cmPRvYlAkaNYNjFgUd//Xvc+8dNPM4F
	 e4Q2qNPo5YlWfeZdz6v9mO+oHmA6n8AvCQYKH+YeJ3S7J6WND6kXLu6fwVKZPiOJ0Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J01GosWr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF53606A331;
	Wed, 18 Nov 2026 23:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J01GosWr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C824A1F000C4;
	Wed, 18 Nov 2026 23:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044937;
	bh=4AMAzwS4oiNixFuU473BBjGdCBBL2F2JaOn9ToQ0hn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J01GosWr9sEVwqa7aznPVrhpwbI46euRN2wLOJ9bOp4Lmbt5pzIKvrGdmiThPA4ac
	 6YFASQsiQkzaFJuWbPBs2I5yInPHupAdM9Qu/T3SmIrB5Zv96PJO3xfJmBgddutsHc
	 y6GxS94/u976dAwPX8qwlUL5Fr5bo/HN6lJAQV8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punnay Sharma <punnaysharma805@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0746/2857] staging: media: av7110: fix corrupted BER reporting in sp8870
Date: Wed, 18 Nov 2026 15:29:40 +0100
Message-ID: <20261118150228.412423178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Punnay Sharma <punnaysharma805@gmail.com>

[ Upstream commit 5764f9bd7b7a72c6df49db6c8c00d4f9994a55ba ]

In sp8870_read_ber(), the 14-bit Bit Error Rate (BER) is assembled by
reading two I2C registers: 0xC08 (lower 6 bits) and 0xC07 (upper 8 bits).

The current implementation masks the lower bits via `tmp = ret & 0x3F;`
but subsequently overwrites `tmp` entirely when processing the upper
bits using a direct assignment (`tmp = ret << 6;`). This logical error
causes the lower 6 bits of the BER hardware metric to be silently
discarded.

Fix this by using a bitwise OR (`tmp |= ret << 6;`) to correctly merge
the MSB and LSB payloads before returning the metric to the DVB core.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Punnay Sharma <punnaysharma805@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/deprecated/saa7146/av7110/sp8870.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/deprecated/saa7146/av7110/sp8870.c b/drivers/staging/media/deprecated/saa7146/av7110/sp8870.c
index 9767159aeb9b2..f68479e75e462 100644
--- a/drivers/staging/media/deprecated/saa7146/av7110/sp8870.c
+++ b/drivers/staging/media/deprecated/saa7146/av7110/sp8870.c
@@ -384,7 +384,7 @@ static int sp8870_read_ber (struct dvb_frontend* fe, u32 * ber)
 	if (ret < 0)
 		return -EIO;
 
-	tmp = ret << 6;
+	tmp |= ret << 6;
 	if (tmp >= 0x3FFF0)
 		tmp = ~0;
 
-- 
2.53.0



