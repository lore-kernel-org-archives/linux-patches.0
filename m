Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043910;
	b=L/+EZ2xXuPFFVnmq3TroNANlO7kvnbK64RNu2TAwO1L7xMiSZoQe0cneV9pkVtTswPy/
	 8sRdgdm3Ls2psnGGw05s81tkj6S5iSAwMNX1qlzkJjMgL2DVsdlQDsLawWSXMfedc+tOU
	 no3Vz1aSu+fgCid8Cw36mgb6BJvVxNK+WBGmXxtjhoLVAA+txeuCIVVSInXCbHJ+DNX0o
	 42CVTgn686qZOgZ0g3GPDxRB6nBVaQbYOZvPC/dXIUVHNS8iIVr5xKB3SblFEeK1Yeb67
	 f+DdahIACMl+/2gaw9C5DE9vyD1/OVxdPiIhZpztyjmBHPK8r6X4tEtW2Oe51jymbTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FKzy/rikDFcN33XSWpGFf3Ty6vd/BP9LBVSPz3tZv5c=;
	b=OFPsulawAANFy5vmv0JRnA4xmA5CzCiSH+Wjff25IJLSsOEnQlB8BVMgu8DRLb3q+1gH
	 LBHKnMMoJo4QdmcTYhmRLJe4y7IcacIqD7ErGMgjOBDKG3AD8VRDW4+D1WUFrail0Ah3O
	 izgwHqKALwJ0/3wV4pYnPuI32ciOQ1VrCXg6Q/OV8+dlhA4PoonHlchCNvFzmG64hVbAQ
	 qxiBZRym95rqTVaySL5kBcSn8z8vRwMep+5TKPYmBg/cpGH6ZqjbP78ikYMynbWCjOqSo
	 hqhRwb6mf28TbzOg7KNH/XA39fUHYbES1Jiv066k85Lfe+ZYYohkvznQ6kTj9K0bHkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gZdU9CX3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BF7606A31C;
	Wed, 18 Nov 2026 23:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gZdU9CX3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A991F000C4;
	Wed, 18 Nov 2026 23:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043909;
	bh=FKzy/rikDFcN33XSWpGFf3Ty6vd/BP9LBVSPz3tZv5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZdU9CX3A1KNduqPKht2bw5NRR2SxPaJB81sBFEhT6Auy+LzX7nF7IuNrnKHxnyCh
	 VrYIH+rBevZ6iGcjq+jCscxKnUsnlbwEKQmsErKWGEfxHv6BkSH3QTZCmEOJbpuAEt
	 DNrYQ5Z33Shf0bRk06eajW5n/5bI63F2TJ77Ydps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Alexandru Ardelean <aardelean@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0380/2857] iio: core: add accessors masklength
Date: Wed, 18 Nov 2026 15:23:34 +0100
Message-ID: <20261118150215.088573214@linuxfoundation.org>
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

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit de79583ffe794663c53b77f97be814522d4edc4f ]

'masklength' is supposed to be an IIO private member. However, drivers
(often in trigger handlers) need to access it to iterate over the
enabled channels for example (there are other reasons). Hence, a couple
of new accessors are being added:

 * iio_for_each_active_channel() - Iterates over the active channels;
 * iio_get_masklength() - Get length of the channels mask.

The goal of these new accessors is to annotate 'masklength' as private
as soon as all drivers accessing it are converted to use the new
helpers.

Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Reviewed-by: Alexandru Ardelean <aardelean@baylibre.com>
Link: https://patch.msgid.link/20240702-dev-iio-masklength-private-v1-1-98193bf536a6@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: f0ea4824deeb ("iio: health: max30102: fix NULL dereference in interrupt handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/health/max30102.c |  2 +-
 include/linux/iio/iio.h       | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/health/max30102.c b/drivers/iio/health/max30102.c
index 437298a29f2d3..9a076973acd19 100644
--- a/drivers/iio/health/max30102.c
+++ b/drivers/iio/health/max30102.c
@@ -293,7 +293,7 @@ static irqreturn_t max30102_interrupt_handler(int irq, void *private)
 	struct iio_dev *indio_dev = private;
 	struct max30102_data *data = iio_priv(indio_dev);
 	unsigned int measurements = bitmap_weight(indio_dev->active_scan_mask,
-						  indio_dev->masklength);
+						  iio_get_masklength(indio_dev));
 	int ret, cnt = 0;
 
 	mutex_lock(&data->lock);
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index e18b3b2fd4260..5752a76c6c48c 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -767,6 +767,24 @@ static inline bool iio_read_acpi_mount_matrix(struct device *dev,
 }
 #endif
 
+/**
+ * iio_get_masklength - Get length of the channels mask
+ * @indio_dev: the IIO device to get the masklength for
+ */
+static inline unsigned int iio_get_masklength(const struct iio_dev *indio_dev)
+{
+	return indio_dev->masklength;
+}
+
+/**
+ * iio_for_each_active_channel - Iterated over active channels
+ * @indio_dev: the IIO device
+ * @chan: Holds the index of the enabled channel
+ */
+#define iio_for_each_active_channel(indio_dev, chan) \
+	for_each_set_bit((chan), (indio_dev)->active_scan_mask, \
+			 iio_get_masklength(indio_dev))
+
 ssize_t iio_format_value(char *buf, unsigned int type, int size, int *vals);
 
 int iio_str_to_fixpoint(const char *str, int fract_mult, int *integer,
-- 
2.53.0



