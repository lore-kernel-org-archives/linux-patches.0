Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623723;
	b=lpfQbxQ86kRltHlOrznQ9FrxbBJ6z3O716+jLhLUchH3P39zmV9vIP9Qq14vgH0wrEy2
	 1s+hFiAFTfV9e8JgQsnm9Zoeo8mzzY1D37Y1kR9on3OB5n0okk5hagnjnBKWhgtBLj9Wt
	 4ZKAmgL8E3VHP1txY3XhnEUuj3jCkJL1ytQlVyHs9LoqDOimJyOg9VpuMV92smUMnLtBd
	 C+WbWntXKv7oT4ifE9l+1XRtMOVFnvsSeUKkMvusBYjYhjRNhSzKhzwi+SNFsIxDsI0PW
	 EXnApBKYTApHKHlrskNiB3K6QLlMhcA/XXWutqIN8eccvtNsYATyWcOWdQhpyYhpcwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623723;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IoHOx2MgBreyF4qEmCG0FiHjfPuF31SBZuo0ueWPZII=;
	b=kKskikG5zhdpMkEDgTv5IgAeCGzS+YtNiOtbea0RZrpFD9Dn0BtJMekuRyS2C+ziCMH/
	 Ola6CSgDVuNK5iyE3tzT3/XgjnpNmBlJ4CGzKPEEgXe3uF4NaIVUZpAAGkkYNlvX4ecLr
	 beuPEHmUzlv74ply6r8C1Fp1CqgRUJI0b58y4EMM2Ev1QqGKobQSR6bxxmdd3W6WPJK2z
	 Wg+ybje3Zw64nhutvH+ORCDIK/Zrzi0JEFJQxqujA6pxsbsz6UWQVWTLDWusEwDj2/a0Y
	 61WmaLVMbBzwXi0assRPBsMrRm2C5azvLcn9xaQbFTDsHoYUGDIIuaopq8cPtmnOElw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gpZHeVbp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2131E606A31E;
	Wed, 25 Nov 2026 16:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gpZHeVbp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332901F000CA;
	Wed, 25 Nov 2026 16:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623722;
	bh=IoHOx2MgBreyF4qEmCG0FiHjfPuF31SBZuo0ueWPZII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gpZHeVbpQF4hIJRtOIX0Gt9hxc2dY/1+Ipeg7uVCTQtXPHdmZq99sSH+RL8WVNG4m
	 Ox7XPggGqzCEDUU01chvtl493mhQ+s2Z8nQ+T+YXkmTKHYcfRGxeqJbs9QIpasJUUF
	 QvmkZkcwumwxeGw6SrEc+uN5YpFxOSJmJ/SUMFas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 950/990] iio: dac: mcp4725: Update the cached DAC value only on success
Date: Wed, 25 Nov 2026 15:38:37 +0100
Message-ID: <20261125143844.242750629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baek Kyu, Kim <pocj8ur4in@gmail.com>

commit 098a4c37dc8815ea941866179220394e4d182c67 upstream.

mcp4725_write_raw() updates dac_value even if mcp4725_set_value() rejects
the requested value or reports an I2C transfer error. After writing 1000,
a rejected write of 4096 returns -EINVAL without an I2C transfer, but
out_voltage0_raw reports 4096. A later powerdown exit sends 00 00 instead
of the 03 e8 frame for the last successful value. The EEPROM store path
uses the same cache.

Return the setter error before updating dac_value. This keeps the last
successful software value for readback, powerdown exit and EEPROM writes.

Fixes: cf35ad61aca2 ("iio: add mcp4725 I2C DAC driver")
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/mcp4725.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/dac/mcp4725.c
+++ b/drivers/iio/dac/mcp4725.c
@@ -357,6 +357,8 @@ static int mcp4725_write_raw(struct iio_
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
 		ret = mcp4725_set_value(indio_dev, val);
+		if (ret)
+			return ret;
 		data->dac_value = val;
 		break;
 	default:


