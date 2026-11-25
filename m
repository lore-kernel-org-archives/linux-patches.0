Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626264;
	b=dDEsuMnTlWvGizc7iNYpgyFTEZWWeEMkAR+KQQJJcaLI6lt3GqHpO+YPVsx7OTSLc+W9
	 PcfUeGUmPgUS4mOPcjWgqlUnvcm2KWBSqAxy9km7rCnANRma5wgV0xhLLN3TPTayWYyL+
	 KszmZfKjI+JbSyM8ldOPfe0mZVH+3OWjm+8vYCjIUvfV/XZIJ5b09f+JER9X08aCLZmds
	 WMuK+iZjjRCSjZZW1iYvXbbFU97Xc07kvZAZzuf9fZTepbS6Yh41QjAJH+ZXPzx1YNK9a
	 4fUJRJwGBrcsCn/Iwyhrq2WRAxbB8AdwAQ8BpN81xAupiynQ9Wb8r8pMTpetusE4CGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XiI8BYz5vEVhkC0a+KDW4XXXlc9Ng3EhAWRnWD2IFa0=;
	b=TmcbtK92AEksCoXlSbI2DcjyZAtHV9MazekgkbySlnJkPVM2x48RdGBbyFn179ewWCe7
	 9g6WeIEcP7fygQIYFhu4JDM54RSEWNj24dBBnQg9+caYj9nI1vGacyKgxpERdnY2VcLtX
	 jLup6Ny2rMl2KLtLNF3O2pWi54fGTlmTKFNONHa+8G0z3T5EN9DsRG7wQf0kLlJl346JV
	 UUQH4LdypT63g2HbwLYnGeMhN4f2+78q6KdC4qLBdXDXUQI+CB/1Ixayf+CNRrLnx7r0K
	 uXG5ja1mruXD7+3BQB4MwL2zpPDYbD8sEZrqJX6J7DhNMIE9OYYhUPLvrWgmoF1SzRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g7SnqPu6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE84606A321;
	Wed, 25 Nov 2026 17:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g7SnqPu6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAE71F000D0;
	Wed, 25 Nov 2026 17:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626263;
	bh=XiI8BYz5vEVhkC0a+KDW4XXXlc9Ng3EhAWRnWD2IFa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g7SnqPu6mocgyo6LLWR/m7tehdUF6w0ht492ebMLmwSYouto/JkM4FsIcZUtrVk2i
	 ZOQXU8tK996DLRnrqd8k6b6ziK+z9dUGrdfl0nTKxmdSusYpkkN8wNMAZbMRMiY+bP
	 CMCupRX0fKwmRG9pFlKqLYnYlOawNX787tjjrwbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 785/816] iio: dac: mcp4725: Update the cached DAC value only on success
Date: Wed, 25 Nov 2026 15:38:53 +0100
Message-ID: <20261125143907.344017439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -359,6 +359,8 @@ static int mcp4725_write_raw(struct iio_
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
 		ret = mcp4725_set_value(indio_dev, val);
+		if (ret)
+			return ret;
 		data->dac_value = val;
 		break;
 	default:


