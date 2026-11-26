Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704878;
	b=KAtA4lUAysCZY0+NYcc7smFQjJw3jffCFabuwxJGbjaYddRxNFx6+sDoK525UUs4SSqj
	 NDh2ZumpBS5IpXuau2WDQBrWOfBWfCTPxYoVhjgzJd0AGwcyX4LfuvNY8mIAJEXOT0B/D
	 eV3yGBaKPL1+WwYQWLx3G5u1XK7ja6zVjSZHyFtjWzmBxUxO8D8BKSsHOus7cRxw8F0T/
	 p5DKS4GFQz8Tk1UVD60zrchYj04I0QCvOr5jFuKdf85ytau2OmW9z4VHDL4VJlauF2juv
	 C8HOp49k3YhmuFfzl+XYXGPCMqDiHBQA1AZ8CeNrVpWC2wVPgfrUbSed8KBSTTBUZIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c1tqO3chXQN9+w/JOSK6nGnpHIPJpIjv4DAta0YWR0g=;
	b=LFnyfwvMoBtyr1FaYOxJ629pwUp1aKF8Kbpt47Mx8S9t/iIav6XBjJz5VqjOzS0p4Zxc
	 z0Dntvs1zmKG0qAo6SDC+Hhxjp/a5iKRX0bdwyZAs4YfJ903oaK5/9eIcAXjaLT5SDBgy
	 Y5Nt+HnIUblCPxeFFLdsz59y9aGRYMNMJJF116VbY7O02IkJrgAQeIGE553ETlpnnfb1D
	 EYxQRRerLd+JROufb7keyr1WPt5I6qfdbAMHFxO0In0vgbFjV/bdLDgQHWjm718j0pb4Y
	 sXuNpkIbkDOFOOnzhga2Nv83QPQ5z8dvmM8CDIV237qsuld5kmX0VYivra4FjgbmymA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qoC9fQGm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EED606A31C;
	Thu, 26 Nov 2026 14:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qoC9fQGm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF0E1F000C4;
	Thu, 26 Nov 2026 14:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704877;
	bh=c1tqO3chXQN9+w/JOSK6nGnpHIPJpIjv4DAta0YWR0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qoC9fQGm4t6IAO4Sx2VEV3LL8pPES1B9lBYdaAmbHlXZYVR7X9gk1xRPIG9QIJ3Z0
	 LWUy/lnYbwvIIYJcH8tFvNkvBR45VF2Efz6+HDRrqHnG1Ws5lwhMKteymoX7UqPsj6
	 Nn4ujE92paHnEsHLAuhyfSnKSu0cb4f4rWflEnmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 245/265] iio: dac: mcp4725: Update the cached DAC value only on success
Date: Thu, 26 Nov 2026 15:39:35 +0100
Message-ID: <20261126143622.377429618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


