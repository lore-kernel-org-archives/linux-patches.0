Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620602;
	b=5NalS/3fMtXKv9w112vMy4AOt0yGAGFT7+kw7OQrxX++0lB7Ep5JY9pmm1/KQO2OP3ZD
	 QK+LpVtGbDMrTNIiD9VkgTMZCccItZLUHABhIj143i+Fl1Gil9HbcAGtepKudwrTQJQry
	 9euCJxu2U1losC4p28eSQwVKjEzAUXjKIlx3+YMPsKRguDf/08J8zr2FmsWV5beB/RUGF
	 v3m03yT0EUcmT6SHZNWPJcqKxDxsOcvQ5jwLAIqTjeq3WdGSiUv08p9ljbpmhsxV1xsNx
	 v0fwoX6FLoxgo05if85ctMoBgihPSzY94lVWCVVwTzmn2DIpDX5xaN81B5mcokWSexw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t76FggURDf424tdEcN8/3StuIzWXmUUWXPwMH5qDON4=;
	b=IR1VnDajPQMVSEvrPmLN3ODPGCnTO2LkMcY4QeVoNJvqKjrIgxOjrVipSqDVHPmBPIlP
	 1HYVXClHd6vn9Cs/o1nG5OLRSdCvp07PAAEfmMnz/HhYDMtZqQUdymE5gd9JNFeOwVtG+
	 SnAulOQfTHtsIEn2jk4FF65CJHlua4v/jiDkQkDIlrFP6VDAhDndUI1CeEDXg17qfC56q
	 9eywWaicfMGZ70WIgWLc7q63j2zNzOv75GgyScYjiNCnrESFafHCbUU1qd+eF6TBI0dYy
	 7MwcWL6CUwaL+zYo7zoS+CSKZOlMDCkifyozMmDoy13geL+dhhEOXYfV2muHls0W6wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HbmCcgV4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC760606A31E;
	Wed, 25 Nov 2026 15:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HbmCcgV4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97421F000C0;
	Wed, 25 Nov 2026 15:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620602;
	bh=t76FggURDf424tdEcN8/3StuIzWXmUUWXPwMH5qDON4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HbmCcgV4Uo/LtXE8zqQdfIq1TcvOiudspHHmCtywiPYJD2MQ7T4ApiBak4EDx+75+
	 oavbA94Bc7WS63UwDeRYFEHWeLaqqxOiG8oZrbb0eHt/nAYk59ZT91v6O6F3+RwTxv
	 0oE+diTNtj3HornS51uk/z+rmPlq7kA1GlseJqiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0971/1005] iio: dac: mcp4725: Update the cached DAC value only on success
Date: Wed, 25 Nov 2026 15:38:29 +0100
Message-ID: <20261125143844.411948491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -356,6 +356,8 @@ static int mcp4725_write_raw(struct iio_
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
 		ret = mcp4725_set_value(indio_dev, val);
+		if (ret)
+			return ret;
 		data->dac_value = val;
 		break;
 	default:


