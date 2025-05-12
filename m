Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A435623C510;
	Mon, 12 May 2025 17:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071957; cv=none; b=k6hPbrBTdFHDGzH0fDAcwE90XOv3RFcMM0Q9DH9MMPfkez4PT8gAGEyr7WrM/q9dgBHKCtOW/5zYAJanTiu0L7ZAIpG3NNQs8CKv59HnrWYX+LKcvCQN8GP48ObsBB1aa+oxWTosJnVfACJTZteNZ3+UOAIkBtv7aBzJjgud5Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071957; c=relaxed/simple;
	bh=VokVJiJtU7EMwUgiX6cMHEPeQjUzVAi1w9ZsxDyfxCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXhD09msBRGzx3IAJi3i7DMUOmRc1dPYnJL6rJ6Xy6J5fVVtPJn7hOwXbFIRdylAbbo7rvaF4au0pNzQYPZ5nPbU+QGhPkge9rn3aWaOPQytOIgJTamLgGuFI+yl28qfotazthEu4yvGX1Gcf6g0nqxdP4RXneAW4H6Mh1Xj3cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+/VEZxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+/VEZxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0DCC4CEE7;
	Mon, 12 May 2025 17:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071957;
	bh=VokVJiJtU7EMwUgiX6cMHEPeQjUzVAi1w9ZsxDyfxCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+/VEZxth68yWRGH4Y/0omU7JJFgbzA9zVanrlgHqyCr8/lzbUsBYZtaL9SMxE6xc
	 w91J3smotbe5bpa2vtnfLLYrjhD6oUJqFUG7HstZD+WmMiIvMnTfB7lERLv2FxvF5e
	 CgyhJS/7nrNuJoasDJkwis3qL9nx4IOZwkTq/r+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.14 090/197] iio: adis16201: Correct inclinometer channel resolution
Date: Mon, 12 May 2025 19:39:00 +0200
Message-ID: <20250512172048.048928771@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Shahrouzi <gshahrouzi@gmail.com>

commit 609bc31eca06c7408e6860d8b46311ebe45c1fef upstream.

The inclinometer channels were previously defined with 14 realbits.
However, the ADIS16201 datasheet states the resolution for these output
channels is 12 bits (Page 14, text description; Page 15, table 7).

Correct the realbits value to 12 to accurately reflect the hardware.

Fixes: f7fe1d1dd5a5 ("staging: iio: new adis16201 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Reviewed-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>
Link: https://patch.msgid.link/20250421131539.912966-1-gshahrouzi@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/adis16201.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/accel/adis16201.c
+++ b/drivers/iio/accel/adis16201.c
@@ -211,9 +211,9 @@ static const struct iio_chan_spec adis16
 			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
 	ADIS_AUX_ADC_CHAN(ADIS16201_AUX_ADC_REG, ADIS16201_SCAN_AUX_ADC, 0, 12),
 	ADIS_INCLI_CHAN(X, ADIS16201_XINCL_OUT_REG, ADIS16201_SCAN_INCLI_X,
-			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
+			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 12),
 	ADIS_INCLI_CHAN(Y, ADIS16201_YINCL_OUT_REG, ADIS16201_SCAN_INCLI_Y,
-			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
+			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 12),
 	IIO_CHAN_SOFT_TIMESTAMP(7)
 };
 


