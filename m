Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064195;
	b=qgR+M+YojxuqjmIsYrHQV7cCR94MriEsNV4orVpo8bZw0eb6y2ixHTRK7dcuBRfBTH8k
	 aZkZyIZjFNl65xhLiBxD1YiH/AI/vaRaiwbSmP+aR9R8FRWfVW93VgvluzgQwUS0bV2zU
	 WVvQe4EWgP1VBtdmqArHW0h7yMUKrNd9BXO7TJybS+ee5mQ1nMhwh3ezc96fNn4YoStVw
	 f8S5ncOKQjDalXA2l+EJIPBVBElxVOpvtglfF6pI/+2m9ogJnSihA4eJn2zWa0ETxfMN9
	 pE/3uJG3m+2JEsYehDq0UFMXZtmIyvEfs9wfUXFfeaXXp+65YdYHvoQYkmUTdWo0UBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GK/5jUZuuBpL9uXNkcjQSCS9In+UzQ2lkPWeex4Dm84=;
	b=KIa8QKwmuLJmL/Y10RCF09WeTLzjIw1OX2Z9Q8CPT2lFKdcWHNT0oApt3E42cwPusAfs
	 no8Pk2k2JC9rMQKsAHX4kVKXFreuMPVVTc91AE3p+ILeD0/sDCW4F2Tifc77mhtTX4CCJ
	 zkFuBl1T8/QbOTDTJmzBWIWsElUvQJ0Z74KkiWfge2LbouOOlHSrLu0T1gEdmDOdSik4k
	 FDDckkd5K2kcw45aSZX9bP32Yr1yFDWNFYPl5kSehqKdrcj6l0EJXnv8phdzQezTJ37A1
	 YLiTVCPviOawnOWQuwf4LPlhgFcLf7AYYhHn16SRuzUda0Ac6rAaiEdfCPs6w1jNANw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YvtwoDtS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E235D606EE8A;
	Sat,  7 Nov 2026 15:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YvtwoDtS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912491F0089F;
	Sat,  7 Nov 2026 15:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064194;
	bh=GK/5jUZuuBpL9uXNkcjQSCS9In+UzQ2lkPWeex4Dm84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YvtwoDtSUTnj/8bRrV6yTDW9R+Xr8SBtmI5XLXzbf4vW5M9WQP4yEyAZLNkiFHVMp
	 fm83dHynNFXWMv5i0DxTrLLq6dXjG5w2K1OS9gFsIUjBDXAFR26f91Fjni3nxSpNbV
	 l+41izVVYEssElnz4w5/qMrWlcaVqYaD7/vuu6JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0334/1257] iio: imu: adis16400: validate SPI match data
Date: Sat,  7 Nov 2026 08:43:50 -0500
Message-ID: <20261107134948.635510892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 2c01a0a1c5550b4f502c7747c06d2e57a240cd87 ]

A device bound through driver_override need not match an entry in the
driver tables. In that case spi_get_device_match_data() returns NULL,
but adis16400_probe() immediately dereferences the result.

Validate the match data before it is used.

Fixes: 2ef920e0e5c0 ("iio: imu: adis16400: Use separate structures rather than an array for chip info")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis16400.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/imu/adis16400.c b/drivers/iio/imu/adis16400.c
index 8f664d055e9d5..512a8da63cdcb 100644
--- a/drivers/iio/imu/adis16400.c
+++ b/drivers/iio/imu/adis16400.c
@@ -1150,6 +1150,9 @@ static int adis16400_probe(struct spi_device *spi)
 
 	/* setup the industrialio driver allocated elements */
 	st->variant = spi_get_device_match_data(spi);
+	if (!st->variant)
+		return -ENODATA;
+
 	indio_dev->name = spi_get_device_id(spi)->name;
 	indio_dev->channels = st->variant->channels;
 	indio_dev->num_channels = st->variant->num_channels;
-- 
2.53.0



