Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213183;
	b=IpYB1r/0dOToWLrHdJhCGN5cJ3oKN+X8/Z+xyXjVDgPgtfrmsFfAVGezMONIhmDgP27W
	 ILb1bG2beZgshlObaOZjJp+7ZOm6tz0HlbyybiiZ4iHgaO+Fl0nDtu07ze7/kU1a5UxrK
	 AX4hbkeVas58TTVLv+t27Qqpx2yoE7nG6YaaSP8dNsCyAprOjyU3T9OigJP5bvo5SXY7A
	 +R4a9twlg3thB5MZwxc73Z4QFqsi9U7Ehp2SKt3+VWeGKUr1YU6m2iJEa4yppD4+eZlQc
	 OibEqg4NLJDfyhPLg6d7K1XrUgcc2IS8gO9LJ26MIAzm8GbRQMRqQNEdYkEvOMmEDxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XGcdnbOrU+cn4MsqHUGGNDWp77AMLEGCnGjClzNZwDM=;
	b=xiHQyppFkjATKGwtx5cmAo/ODv3CG9i/NxROZXBThQj5Qte/W1vUMpmUzsQpiT/NjjWH
	 jOqsTyQB3MSCtqSHGMc75L4iyQ3rzSqTBjQqu44DUyC5lpwLG4rNZhT0AVLG6+9HEFQn8
	 6UKDtdGjz/pPgv1ukHyXtnQbSKl/H7NAdrYX6arB+enGLcuQ7S/4h1bYwUEsKNKHC9WjC
	 Nf0qbVwp6AIFBR/N/4TmcI3Y63tzsFy46WWShmDWAoOCBAF5q3INmOQZXrw2OLSwnZLLP
	 9pAVpYUXUC1pYukmH7rJuEEFIFJou5+JgPl5A5rpof8lPNid5boSG3IIl6wv7wOlD/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jSksbDtb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898FB606A31A;
	Wed, 28 Oct 2026 18:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jSksbDtb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A331F01825;
	Wed, 28 Oct 2026 18:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213183;
	bh=XGcdnbOrU+cn4MsqHUGGNDWp77AMLEGCnGjClzNZwDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jSksbDtbbUabtkm+/bgL/O7GsdY+NNdpSxiAS1oRso05gKZnzLHtlvS4ai3xdDe+3
	 Z93+sUFyiTMm7YrPS8c4Iysj8G2GbH3BcNGMBzsmsYKvGjJXefQ318g8A7snu6c4mq
	 gPz21Ej68AjRxflLfue2iSqLI8HvvuhOCFkFXy/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0416/1887] iio: adc: stm32-adc: fix possible division by zero in processed channel
Date: Wed, 28 Oct 2026 17:41:52 +0100
Message-ID: <20261028170508.702337338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

[ Upstream commit c5de6a6f855fdcf1e0ea549fb227a316db51c405 ]

In case the conversion has failed or returned zero, processing *val
can lead to a division by zero. Need to check for errors, or converted
value is zero, before processing the data. In case the converted value
is zero, e.g. the Vrefint channel, this should be considered as invalid
in all cases.

Fixes: 0e346b2cfa85 ("iio: adc: stm32-adc: add vrefint calibration support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260911161555.244F31F000FF@smtp.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: Changed iio_device_release_direct() to iio_device_release_direct_mode(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-adc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index 6fede34091cc2..6a666d14a609d 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -1372,11 +1372,16 @@ static int stm32_adc_read_raw(struct iio_dev *indio_dev,
 			ret = stm32_adc_single_conv(indio_dev, chan, val);
 		else
 			ret = -EINVAL;
+		iio_device_release_direct_mode(indio_dev);
+		if (ret < 0)
+			return ret;
 
-		if (mask == IIO_CHAN_INFO_PROCESSED)
+		if (mask == IIO_CHAN_INFO_PROCESSED) {
+			if (*val == 0)
+				return -EINVAL;
 			*val = STM32_ADC_VREFINT_VOLTAGE * adc->vrefint.vrefint_cal / *val;
+		}
 
-		iio_device_release_direct_mode(indio_dev);
 		return ret;
 
 	case IIO_CHAN_INFO_SCALE:
-- 
2.53.0



