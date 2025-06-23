Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8397253B60;
	Mon, 23 Jun 2025 13:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685022; cv=none; b=tncEIVYWIoxMdVohCgn2AeIekPH0caySMxtrXHB1BtGSxxhLdRxhTO3gqaxrx3qAiP5mHlvHrfycx6v+yu9RxDSMYvl4b1h2grz1fsla5OCdWT2z81DCG64OCq0DX5k3906nKoDD6MIvpePzxMW5T0MwaFagzlrPMXATbaGJHLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685022; c=relaxed/simple;
	bh=wZMgIkYyvJwtOTzPxDl01RNBzHz/Alf2Ng0n2t9tXjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XztbAO51bc9Rpbm9yPYJnOJY8fcraNe8g+sFg7CtmCS1aGo0BDz2MVhmTfd6songzeE6KxQ+kettlrsBIofn57pnFcwBg1ciWDBRyTYk42eGa6h0baFVdbjFRVXCWqRx79Hy5yvE6DV0BvLe1goZHJW+nEQ3lU6VVYZGMu6l1Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+5cDTTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+5cDTTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0188AC4CEEA;
	Mon, 23 Jun 2025 13:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685021;
	bh=wZMgIkYyvJwtOTzPxDl01RNBzHz/Alf2Ng0n2t9tXjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+5cDTTGFym9tiJpV0stJvmiXi1bDpgsWLNqlbW/Ljg64YSWaHhljcjPVEXZS7hRB
	 iuGF00Cuy87Ebuh6Pv8+Joc86H5xf3i0s2f0UbsgFf/ykr2DG5KZmwBe6Mr8RyhjYr
	 ruUCfQlv0KxRk3CtX5sHvLlME3yeXCtxvsjxxVvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur-Prince <r2.arthur.prince@gmail.com>,
	=?UTF-8?q?Mariana=20Val=C3=A9rio?= <mariana.valerio2@hotmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.15 202/592] iio: adc: ti-ads1298: Kconfig: add kfifo dependency to fix module build
Date: Mon, 23 Jun 2025 15:02:40 +0200
Message-ID: <20250623130705.094001630@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arthur-Prince <r2.arthur.prince@gmail.com>

commit 3c5dfea39a245b2dad869db24e2830aa299b1cf2 upstream.

Add dependency to Kconfig’s ti-ads1298 because compiling it as a module
failed with an undefined kfifo symbol.

Fixes: 00ef7708fa60 ("iio: adc: ti-ads1298: Add driver")
Signed-off-by: Arthur-Prince <r2.arthur.prince@gmail.com>
Co-developed-by: Mariana Valério <mariana.valerio2@hotmail.com>
Signed-off-by: Mariana Valério <mariana.valerio2@hotmail.com>
Link: https://patch.msgid.link/20250430191131.120831-1-r2.arthur.prince@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -1546,6 +1546,7 @@ config TI_ADS1298
 	tristate "Texas Instruments ADS1298"
 	depends on SPI
 	select IIO_BUFFER
+	select IIO_KFIFO_BUF
 	help
 	  If you say yes here you get support for Texas Instruments ADS1298
 	  medical ADC chips


