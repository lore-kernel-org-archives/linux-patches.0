Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030259;
	b=W/FdAMP+YT7Y9AY0PijolW07Hz/CUkrruFYgy05Aw70YFx/oJ558wZhu+ZXX8ed9FInf
	 ZtnzrmS7++etzcQsZNPYJZOECAZ9B1xzDYOdGlnBMk2GNlCyVwyzHz7ECBZ3Fy4bUFcR7
	 KG7pLAlB5jG13+h+NG0poVIfij7b3fGcHk28R1GbHGnn9ocqsY/cp2aVexIC2L/TUMe0e
	 sbAnv2zR4pdicLmiVkIVPa5DQCGYcZRA5oJWMiiQfsm71zfm06LTze8sONhjFzmBUubCi
	 jQM7c6S/t1tDFLNTkX4yoMseMJ9kpNj6mOSdXiQAGhjie8xUN/TiD6lHgw2DvKlkc3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=RtsD4DuJgIn91zvzy2YpbEbpPhEb27n+4w79ZV2tiM0=;
	b=qpy+1ox3KQBFD7UQDWxaxdjq15Av1Rkc3dUd+TjwCIl4QksIIWJwirPSBJxgU4t+0H94
	 L8I/FMDxtq3CvxsmQtzQx32fxpBTsjGwFb5tYSuU3hrQ00JJNX7ocUlEOVNyE3IByMxcS
	 KKZf+q9WKxeIPnUuK0KfmhjxNZQXmCRswB+N7zsXMFIhIHNGne7a4aYPEtzqSNWJfU74Q
	 l5XeTPfIH0SW60z4kVcsEtxq35ZJFP0yMDE9QPRf8zdxQ/GcdBU8k4BB+9YNAPTms3Erm
	 886d/g6Rs0Lt9agy+tlcSCTiQrac2ctmlLGj4Zfh800oJ7EleV7AqbI1vTk6sSCI3UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HCY71bAg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA21606E7C8;
	Wed, 18 Nov 2026 19:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HCY71bAg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634A11F000C4;
	Wed, 18 Nov 2026 19:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030258;
	bh=RtsD4DuJgIn91zvzy2YpbEbpPhEb27n+4w79ZV2tiM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HCY71bAgvL814o1pAPw/81df47wDhJIF7hiyiCtBuUHdvF8q98GmT8yp9rQyHVkCg
	 GbQS0f/787BuHkls+JUB7y1Wf/TTDegfRje9aacbew5MStdihaTfNP5Qac9D2QOOtz
	 ZNn3pr8Ng8pyUX0cd5lcsTbR+bokz5DoOOjA2xuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0640/1756] iio: dac: ad5758: Reject out-of-range raw values
Date: Wed, 18 Nov 2026 15:46:07 +0100
Message-ID: <20261118150034.328937495@linuxfoundation.org>
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

[ Upstream commit ebc026be1b719e47bd7f2f1e72fabc875b590f87 ]

ad5758_write_raw() passes the value from userspace straight to
ad5758_spi_reg_write(), which keeps only the low 16 bits. Writing -1
to the raw attribute gives full-scale output, and 65536 gives code 0.

Return -EINVAL for values outside 0 to U16_MAX, as ad5755 does.

Fixes: 28d1a7ac2a0d ("iio: dac: Add AD5758 support")
Signed-off-by: Arka Mondal <arka@arkamondal.net>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5758.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/dac/ad5758.c b/drivers/iio/dac/ad5758.c
index d7fd2acd7dfee..19e8397b6ca05 100644
--- a/drivers/iio/dac/ad5758.c
+++ b/drivers/iio/dac/ad5758.c
@@ -557,6 +557,9 @@ static int ad5758_write_raw(struct iio_dev *indio_dev,
 
 	switch (info) {
 	case IIO_CHAN_INFO_RAW:
+		if (val < 0 || val > U16_MAX)
+			return -EINVAL;
+
 		mutex_lock(&st->lock);
 		ret = ad5758_spi_reg_write(st, AD5758_DAC_INPUT, val);
 		mutex_unlock(&st->lock);
-- 
2.53.0



