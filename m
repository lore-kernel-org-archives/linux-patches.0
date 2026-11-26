Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705743;
	b=H3w/0JyJtQgkcnbMLEA79Q2/FiZdJAV7aRO+ZiVF7CpHOk8lPN6EJSWc8IALyEuWdFKS
	 F4lQJHD80/ZtoS1o3g/nW8U2Ki4YVR/oRlRHH2PtGZSHMV3WvSZHINKXBUs0yJ9mASL3W
	 G32meEEP4C1/GkZDXYGJqYoB7NJj2WWxuHZzQMZ/qMTd9TOMpaoxm3mtGikdxnQWGZ7vI
	 o+g7K08biFsBw8DAsqBwAT4dufziMS8kipA/OA+y/YM6O3QemIvETds4tEO8cKn9/dikF
	 G8tjGwKm3mNl+yYmziBTqyeDoeiRYdKbTFzA9vO0VGqjibNTGRY0KdXj/hkzMUCFgcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5LpV7Yu9kNpNsjl1ZYnkQU6VlDT4PsEB1N5M6ywBeCI=;
	b=qSgk6/3L2oVhk1Pikr+bY3MYbMNOq5nC9x3KMDFMD/h70+Q+nEVVsuAtOiGQBuWpaiuc
	 IeEOuby463TCiyfu3tijn93qYJDtqKfCfSerhYYo2ilkolnf8ty2B0ciJ5lK7WWprGAUe
	 z9/rcud0fwdjKAtNZyxNMoslHNomxk9YwvdZGdm0kgrDegQDE1N22V5PaERqgLgOcLfGz
	 00PuU1FFli5/UNI27qnF5B/qHCDx70gZhHoC+pftcrgRtedEvy2T2HOqOG6b+1c9As9HH
	 J9It38j0B72NhI4IZ6W8Ld/a2EvAvZnswPAXfF/wPNZYnIEWyG8wKVm3Cbr9uDn4xSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="L5P/VuWR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620B2606A329;
	Thu, 26 Nov 2026 15:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5P/VuWR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B581F000CF;
	Thu, 26 Nov 2026 15:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705743;
	bh=5LpV7Yu9kNpNsjl1ZYnkQU6VlDT4PsEB1N5M6ywBeCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5P/VuWRgh8sUcvwHeSifCdXbg8PNCLJEP52icrT3OjtFOVMtyNVDN5yg0LJKizia
	 4Ll0XAH6VM8RFl5sY+tVTbTvHu4xhMHBMW9z0F6ECBsc4DedXIP51lvIlOR3JbZ2Hw
	 Ef79C8TKPXyNlVXikuoyZtw8Zo6nulf5nPPCPRw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 299/319] iio: dac: mcp4725: Update the cached DAC value only on success
Date: Thu, 26 Nov 2026 15:41:07 +0100
Message-ID: <20261126144013.507103680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -353,6 +353,8 @@ static int mcp4725_write_raw(struct iio_
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
 		ret = mcp4725_set_value(indio_dev, val);
+		if (ret)
+			return ret;
 		data->dac_value = val;
 		break;
 	default:


