Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017686;
	b=KkFp4KA+Q4W2T1PsSI7tfw++X5CwFtk6G237KKFNZH79IMGHaONyDgEe5ylHC5aBXIgU
	 UggWmBKWOxgtEC54z1aHrotexOWeEODSiWwQKWrqTykYp1tmY3DTxncBYKWFTnmQN6E0N
	 CmFdQj4OFBOPjVG6uWFWIz5oY/AkkLrTwWuFud6R/saAIAZVqaIVD7z9/jogyRk1VMv0o
	 TRnYSpfLYy5WdN8yWEzN41om4/FEEeHo2dyvgaOTJV2432fGTRniTKs1sre08RQm63JKQ
	 EiJroCIrdL+TRoTznDIqfWgFDbHXVAnS3Ruo3dN6ujzBYUeyqX0cXZzwXIOheUEmfWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZiqINcL4f5M1kZL5ESJ8G1pym2+SdDEj8FgInx1Xyno=;
	b=H4xdegNO0g2dtgwkUu0vcUWDXh2L36D1qVhf86GYodzLTcLRGPpT8jmup1yuSJG2uKmN
	 Yyvxe3NSprH4eUM8Ej55W2VedPDL/bKL3PRks9UYl3V3c5AdjjT5hy6CiAoEG07IyDLaG
	 vXMpgCUwOrJ5gziMtcHW29DLwdrxkv1HQGgVoPvN901a28ilkqdkoTUpaEPMVTu+Hq4vF
	 3SofU88rDQsrrjxD5IEqPK23KIGvYcoAREZeGJ/+ND+e3AS6tj8sGv6R1H1L2kizpm4bU
	 0/1dGl9fN2I4/suVqGKjPGD49VnbWzqJ0p3LV2MSfGfRjLad6QbhIJ/cEMW+kYJgd8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Nuo1i0G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3A9606A31C;
	Wed, 18 Nov 2026 16:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Nuo1i0G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97711F000C6;
	Wed, 18 Nov 2026 16:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017686;
	bh=ZiqINcL4f5M1kZL5ESJ8G1pym2+SdDEj8FgInx1Xyno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Nuo1i0Gnfu0Z/TNZTXASm+SsrEr2JMlRE5aqtjnZ3QEG4WYDuKOQakTr4h2jwoMB
	 JTBTkQ2Wj2JaELScnG4OxyRXrJPovrf8FENX0OathVQ1lGhWmkNSrjtwtPR4DwV2t8
	 Pnfz0WcHByoURoklW4BJz34XMn6TUy7oaUqM0NhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0956/2651] iio: dac: ad5758: Reject out-of-range raw values
Date: Wed, 18 Nov 2026 15:36:36 +0100
Message-ID: <20261118150322.318603142@linuxfoundation.org>
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
index ba381bd252d11..2a9e907b5eb8c 100644
--- a/drivers/iio/dac/ad5758.c
+++ b/drivers/iio/dac/ad5758.c
@@ -556,6 +556,9 @@ static int ad5758_write_raw(struct iio_dev *indio_dev,
 
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



