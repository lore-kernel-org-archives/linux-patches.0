Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030253;
	b=KDQamt0FAAB/q0iHaTWayIhht/ZxHGGqpaBlyWay/QAGw9vd38NPWMPf6XmSSI27/tkb
	 pe+VVECX2CminiwjppPoA+RbAQCjvXDNzWCaR2v8SOPBjNY6cjgr+APDVRcZ8OPjTdAZm
	 tzpNFaraXehoMp0FMBsys6bu4unPc4iQDvbB3Fr3qIfyJ2b9z4xc1NZ9wNxUy0CeMufY5
	 TQb/E/xuN0F72QMyv1LgsysC9vXQRLo9x/GmC8yk69d2pGz1bQwMpzheGHiN3rqi16KBv
	 bkHR/nt95+FiyYfn3ubQ+3kgQxn552ykX4hDQG+yJXWj1wwZesNP5FMS+zn1cvoeztQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VI9fHvN+prz4gclt7kZzgy1Gb5mlWWrlnKQo62hm5mo=;
	b=xrl0Gcm+b0G1ZUmk87X0SZ9tPnrc62huMfJapes+sCEexs78SpRjkQ/X8/se/venA3z2
	 +++4dZJ4P4+2Ob0wRquzB6kbEwEosZ0yfH6cQkmlLA0bE8wutMfpeCoTN+9nN34sdA1cJ
	 HHXOYLn5j5OrFUpkWX5jr7ErIGWYbVu0jbGWooDH66SSbF0vKNPDOFPB9letMBo6gQa4w
	 GViAFswY6uISW49gMXaOKDbGs9jhGIy88I7yWxUh8LoK8daYg3y6DGDcUUc7xGTIiC7Xe
	 WJiHuRMrDfhxbgaLN5QEf9UsqsNxQZ76qTh786znyN1PjOl7PqNS9hjwNbFxxmbKBWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Crrh/xHO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A82606A331;
	Wed, 18 Nov 2026 19:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Crrh/xHO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F641F000C4;
	Wed, 18 Nov 2026 19:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030253;
	bh=VI9fHvN+prz4gclt7kZzgy1Gb5mlWWrlnKQo62hm5mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Crrh/xHOd4Q7txGW6E7gN3RMz0wpl5EoPuIZa60k8N3E/EihRnk9WO2o6YyEG01Zq
	 GxhyQKt34L9OwzRURvRtUhnkGgvPnzYwogS/8WYR4Mt23eDNh4pSGNCpWhZwrewNnn
	 LK+hSvqU2fSpNqfG3ZYLjGfEGIPb/7382d2XDGrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0638/1756] staging: iio: adc: ad7816: Protect sysfs attributes with mutex
Date: Wed, 18 Nov 2026 15:46:05 +0100
Message-ID: <20261118150034.249186150@linuxfoundation.org>
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

From: Abdelnasser Hussein <abdelnasserhussein11@gmail.com>

[ Upstream commit b96187644664d10b641dddeb7ca2eeef97a77c41 ]

The sysfs store functions modify driver state that is critical during
SPI transactions. ad7816_store_mode toggles hardware GPIO pins, while
ad7816_store_channel updates the internal software state
(chip->channel_id).

If these are modified concurrently by userspace while an SPI transfer
is in progress, it could corrupt the hardware transaction or cause the
driver to communicate with the wrong channel.

Add the existing chip->lock guard to these functions to serialize
access and prevent these race conditions.

Fixes: 7924425db04a ("staging: iio: adc: new driver for AD7816 devices")
Suggested-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/adc/ad7816.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/iio/adc/ad7816.c b/drivers/staging/iio/adc/ad7816.c
index ade1b8db197d4..aac3de84e0a87 100644
--- a/drivers/staging/iio/adc/ad7816.c
+++ b/drivers/staging/iio/adc/ad7816.c
@@ -143,6 +143,8 @@ static ssize_t ad7816_store_mode(struct device *dev,
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ad7816_chip_info *chip = iio_priv(indio_dev);
 
+	guard(mutex)(&chip->lock);
+
 	if (strcmp(buf, "full") == 0) {
 		gpiod_set_value(chip->rdwr_pin, 1);
 		chip->mode = AD7816_FULL;
@@ -207,6 +209,8 @@ static ssize_t ad7816_store_channel(struct device *dev,
 		return -EINVAL;
 	}
 
+	guard(mutex)(&chip->lock);
+
 	chip->channel_id = data;
 
 	return len;
-- 
2.53.0



