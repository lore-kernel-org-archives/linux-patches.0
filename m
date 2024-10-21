Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9267C1953B9;
	Mon, 21 Oct 2024 10:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507406; cv=none; b=Nf+ynmndquDmcp9ogYfxK/1nsGoSaI/xxBtpyC2pUBf3DqYTr8h+7o4tB21nx10UmedFduDukiFbCjWCsznXJwwvpiSGDCN549rHHSNLQ/ejQFkRHSvfTqyRyozZxOzFAZwN0GlxZlVnFDvAImSaNTnuDSGmVR+sFR8QvudrZYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507406; c=relaxed/simple;
	bh=O1PrQc2B31OvCyystX9+8MxkUGd8HlmIt9KXNeK4KIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPFWdugx9AeV3knTox+LDC8H8+IDwnibGyTNpgza6Bmz9GHoYNeIGCmH7iEuJ73aKoV7I7WwUE3F1/qpgMz2sKSaHQ6gsO9TkAAmHDRQAjXyMbzxc9JoCKqA5LGTS7Ok+PTMnOP3uJKj001eQ9UtTu2RezgCd0wZpva/jr1OT7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPv+GuXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPv+GuXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F8CC4CEC3;
	Mon, 21 Oct 2024 10:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507406;
	bh=O1PrQc2B31OvCyystX9+8MxkUGd8HlmIt9KXNeK4KIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPv+GuXm0cL3p2TsWqKRv/cat44s55/a1ji/RUsW6VV25sETk6lDV23XFKLg4AKJM
	 uK50SSHTpoF8p3HlAOy/Cw3t4R1bQmKgnBZ0PcWnGbFGxzCH4kgSkmUxtV4NMuA2SZ
	 DHEX+zwCGkFm7qA2kwe0G/jJHQsAf7IZOarpW++Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 67/91] iio: adc: ti-ads124s08: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:25:21 +0200
Message-ID: <20241021102252.429384300@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1205,6 +1205,8 @@ config TI_ADS8688
 config TI_ADS124S08
 	tristate "Texas Instruments ADS124S08"
 	depends on SPI
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  If you say yes here you get support for Texas Instruments ADS124S08
 	  and ADS124S06 ADC chips


