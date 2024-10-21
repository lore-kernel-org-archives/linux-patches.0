Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493021E5707;
	Mon, 21 Oct 2024 10:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506684; cv=none; b=AbSJSL/z9lb6voKXSB2yCCer2q4PQaFF+Sz+BzmwvfQVShGXP19wEgVWDr2ubCZvIpObbkCZfF9h5kLHAP+G3l/1656EyEzzhj8m5AdTg4EujDkErjg2Kw73M+ip7P4mg4/UsOjgjKBKwuhe+vdAGa8AsYKkZL/iGynNBXJdy0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506684; c=relaxed/simple;
	bh=CxLcJyR7+/ZeNb0B+u24P3QC3P/3PuFHYuq+30q2f+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzfKHtHNNVCevOICxjkI8A1eFm0bsPOhgsrbLT7o/+gPom+Ba71uWn4UkXbFAk0bdJqgMo/Gd00RrK+208aSS4LeuKT0EZj+bOKIWwG2GIHr62fgVwvtM6Pq1U39SQtODfLxff69mrVvFFX8WY8wkJLRpwmsgjzo+vA+mVB9ZvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWW0H+8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWW0H+8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806D1C4CEC3;
	Mon, 21 Oct 2024 10:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506683;
	bh=CxLcJyR7+/ZeNb0B+u24P3QC3P/3PuFHYuq+30q2f+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWW0H+8HCQM+EXT9TWoZ59JnNd7nm5ujh2hVAsTPRkhA7OXeknQg1HJsnyCg0aHPB
	 PXnVIMDFbDy+ZvzOdoqugJusdnDfpnDnwaLYDcooG4+jj8Tnol7X3gRm30PsV8LjzS
	 R0IeYhr8sNtURFaVCk+BKTz25xpT8i3GyWTE0fcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 087/135] iio: dac: ad3552r: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:24:03 +0200
Message-ID: <20241021102302.729650871@linuxfoundation.org>
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

commit 5bede948670f447154df401458aef4e2fd446ba8 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: 8f2b54824b28 ("drivers:iio:dac: Add AD3552R driver support")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-7-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -9,6 +9,8 @@ menu "Digital to analog converters"
 config AD3552R
 	tristate "Analog Devices AD3552R DAC driver"
 	depends on SPI_MASTER
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say yes here to build support for Analog Devices AD3552R
 	  Digital to Analog Converter.


