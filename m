Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B681E503D;
	Mon, 21 Oct 2024 10:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506695; cv=none; b=mh12hGRGtve1q3thLMzBM550g2IbMrudziCAUZhC8DyRe7dHeqTmycYCl0LUw7ibSVWo75CaX7SY8IwqARmbPcOH1BV4YTokAbET6XmFLR7ObNEFuSVoTzIHNip5cPKV6aCylcyU5YJvkZlXQM0qf5ffWHPudI18VuaxMx50kSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506695; c=relaxed/simple;
	bh=JDTEkhbQDj7edjxdYPAmiWdOhQ9jvdbaG9KtRzilGGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TK16nAILL31+NEmYvbkrgDsZZhXlwvLueZUrabYxemedm2Y2oI6EjukApVeXLWHmWXFRgURmMNPlogZWue5G7FMrwoQ4fluS43zFQiKh2WsWq3+nmIHd/jvGDQ+BTz1d9UPwSWHu0X5M/eRxQs7yY53JV7vHjwaREN7JvZXmXlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mhN3gzc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mhN3gzc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483BCC4CEC3;
	Mon, 21 Oct 2024 10:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506695;
	bh=JDTEkhbQDj7edjxdYPAmiWdOhQ9jvdbaG9KtRzilGGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mhN3gzc0EDv+QiuCKbr1SQ9BERGbjI2UKSc/FnitGAnYiNYupjmCfRZ1Jd1RhWwRO
	 2fBdrkWl5KdgX/ZocWehw6W0wsAXVOv4Ipsj+Ynf8qZD6G5bBMVAs9oMvQOAYlv37i
	 g+MLMIl2GL+rJus/dDXdYiDp/GNVHk7+yRvFTfbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 090/135] iio: adc: ti-ads124s08: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:24:06 +0200
Message-ID: <20241021102302.847164730@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1447,6 +1447,8 @@ config TI_ADS8688
 config TI_ADS124S08
 	tristate "Texas Instruments ADS124S08"
 	depends on SPI
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  If you say yes here you get support for Texas Instruments ADS124S08
 	  and ADS124S06 ADC chips


