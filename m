Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8DB224B09;
	Tue, 26 Aug 2025 12:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212785; cv=none; b=Pc7W98y8ZCacFvGSIeyUn+fjfsTQlLj2Vwm4TF4xJ8AsPgltCxO/GZTjitdxg8GNt35n5+/Tuw2LVUw13waBf+2WoydqRLITKqFkq5Q/be8CAEH5KpGEFHek9dkrzWTTSnzgBnbi8R48ubJJgJw3KVQMv/wMzLSzcl+Y/BpePCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212785; c=relaxed/simple;
	bh=ZZ7rH2YS8Q/hcwtA+W7Omd25n/+Oh6K4I0n5b0FgBEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QI/qebCo/+8rTUOWWetSpQxfb3anCSLH+tLGBJM0hZL0OLt0hbft6fBqoyGu4elrHIjb9yLZP+IoZwNhKc/OwgoVM5IYjaaly7S77bfgQp+6Oyafcqbsea185TETaMYbY+nV1BY7Hfq87IutZN9ph+fALdSjvE6HJBZUJb2Js0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KM52WF5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KM52WF5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D536C4CEF1;
	Tue, 26 Aug 2025 12:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212785;
	bh=ZZ7rH2YS8Q/hcwtA+W7Omd25n/+Oh6K4I0n5b0FgBEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KM52WF5GMsDlj0b9FAvLmEGRv5onJ3+k/AtQDCh5VdDjNi7uuyT1Aj5QXmwwB9Ki8
	 ffBlZtVE0ZGc2JhXHYDmU/D0gMvwiNwjypKzhpqvgqdUwr8JQ3XMo6ypqvi6Zytdyx
	 mEWmzW9sHL1hUgCk+OybcQlYfnu01ip0QkNwOHZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/587] iio: adc: ad_sigma_delta: dont overallocate scan buffer
Date: Tue, 26 Aug 2025 13:04:11 +0200
Message-ID: <20250826110955.536119176@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 5a2f15c5a8e017d0951e6dc62aa7b5b634f56881 ]

Fix overallocating the size of the scan buffer by converting bits to
bytes. The size is meant to be in bytes, so scanbits needs to be
divided by 8.

Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250701-iio-adc-ad7173-add-spi-offload-support-v3-1-42abb83e3dac@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad_sigma_delta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad_sigma_delta.c b/drivers/iio/adc/ad_sigma_delta.c
index 533667eefe41..71e775a10a91 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -378,7 +378,7 @@ static int ad_sd_buffer_postenable(struct iio_dev *indio_dev)
 			return ret;
 	}
 
-	samples_buf_size = ALIGN(slot * indio_dev->channels[0].scan_type.storagebits, 8);
+	samples_buf_size = ALIGN(slot * indio_dev->channels[0].scan_type.storagebits / 8, 8);
 	samples_buf_size += sizeof(int64_t);
 	samples_buf = devm_krealloc(&sigma_delta->spi->dev, sigma_delta->samples_buf,
 				    samples_buf_size, GFP_KERNEL);
-- 
2.39.5



