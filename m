Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DA61953B9;
	Mon, 21 Oct 2024 10:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507403; cv=none; b=M4XvD8eTgHEaxFgePZFNoRRPLpgTzCaLBGjQuwkYfx1qVyRmkJ6qKQr21ZZvAL/J1rFcuBeeaycXZeChyWdV5WmF4IDv82hROmgo55KsC7yd+Hodsd1GWi/qHPF9tItAJh9y57J2juUVFEWVfE2OWQdvwj9nN8m3FXc4GSHK0ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507403; c=relaxed/simple;
	bh=ID2o3hR4iTdYQfx9AidhZ5OkaUBE6NfKO4DdnP1f6/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBs2lY4+X1x1X+QEyBhHKX3F/bOwbrwCWMYkaxoBsT9gEuYMfwjy5HyrCNA1l4Uqa5MU2N+V/M6kjubHfX+GOXEW2zFwEHEBHkEr3NFj+QQnQ/ADPUnZE6Ad2PoS7eVlW24ss9Dm5YqiwcKUfBfWyzfm3m9+iuUS2rAKb814iTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVlkk/JG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVlkk/JG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6829C4CEC3;
	Mon, 21 Oct 2024 10:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507403;
	bh=ID2o3hR4iTdYQfx9AidhZ5OkaUBE6NfKO4DdnP1f6/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVlkk/JGqInoCnRFs8mPXE6NtLAxN/lyRpynAp4ABLD3S5ng6I84sMDADlHn4qLik
	 b+r7HJ3zH8RlW38jWGd1iWTEfQaxnLD0+DtwOP+K/nRTBmI027WTa0eTPke/8h8KLD
	 iUq/T83uZIEKVawsSr4EYxG5uMxQvigwmt0efF6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 66/91] iio: dac: ad3552r: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:25:20 +0200
Message-ID: <20241021102252.391293424@linuxfoundation.org>
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
 drivers/iio/dac/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/dac/Kconfig b/drivers/iio/dac/Kconfig
index 1cfd7e2a622f..9d4600ce0427 100644
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
-- 
2.47.0



