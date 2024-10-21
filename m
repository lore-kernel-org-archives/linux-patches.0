Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F1316F27E;
	Mon, 21 Oct 2024 10:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507660; cv=none; b=nKLpBPIcr0EGOFHmH3zJqCftrJjTc8523CFS1ZxcpIs74mTSH3ieVw1BguGsCBw3IfXPTmtxxtPpAlXGPXujvZey/AlKi0bd47BUhzfSpQXlWPmGJcH13VzXm/J2MyKHtovAdIqfj56i39MfczOC1DIEtg4vqdm6vo9WAioJFkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507660; c=relaxed/simple;
	bh=BFfHeZh9nx0m/PXdmgXw6USjvZLTRg6mcd+XYi43lB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPlsvQwA1jW0K0Wx51YBxXRepHOv7QJ41QcyRv7+7/Psvtha1WRvJ2zWOFu1hKcT9IDbhKmodJ4PqacI4+EbdFAidVli9OQ1DxJD3IPgPsNN4LYcXnMUWbbyXqffrW7R0Cmzp03AQ0MzZh0AbY5rz5+Kg4jpGzLiQ/PTB1eIUU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCoUtwoY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCoUtwoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E635C4CEC7;
	Mon, 21 Oct 2024 10:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507660;
	bh=BFfHeZh9nx0m/PXdmgXw6USjvZLTRg6mcd+XYi43lB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCoUtwoY0V31dCgEl70GDv9J/mpzGgksGhmpxs4WkM4tD79q0aotoh9uEJr0IxKzY
	 HKi6Gie9JZgDtF+u0AJNwgubwgg2qJLGG3c/cFw5mvotEJ8DtMoXNdTQCkctgAogEC
	 gNt0pnK4IPnITIhxBz8bAQxxT68yQOSXwdZ4/TqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 60/82] iio: adc: ti-ads124s08: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:25:41 +0200
Message-ID: <20241021102249.602056552@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit eb143d05def52bc6d193e813018e5fa1a0e47c77 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: e717f8c6dfec ("iio: adc: Add the TI ads124s08 ADC code")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-3-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -1143,6 +1143,8 @@ config TI_ADS8688
 config TI_ADS124S08
 	tristate "Texas Instruments ADS124S08"
 	depends on SPI && OF
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  If you say yes here you get support for Texas Instruments ADS124S08
 	  and ADS124S06 ADC chips


