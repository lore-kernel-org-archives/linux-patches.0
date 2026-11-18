Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033491;
	b=WVd4ZphQb2tC9Y6oiW/vC6GkqiY5UVm9yzZlf2Q1LxuJCzjE5ayFmM5wESlildJj2tE8
	 058bmj05te1bEMlcc3OOaAPMRgCBAgoxXo8ei/NbO7je6w0cDlsvE1reaiXtNoT6fUjWI
	 snde/Z4NWikiergaqP3MqGeAMTEx5A0g3UUm4oR2HhSuRjgOuVP7KLHDIthRzT6l5aMVu
	 KDaK76P6Cp/SZVkyjy1yp+tlgmldHTwslLfIFZ3myzzQRVJjVu6O5vIblxCBqUz685pcI
	 HC4i2FgIIAhHH+takcWg9WOqjXNohg9gxcMVtF+N/AXZUccGDuFusvR5HCOWToST9YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pxCEaiXP/o+RHXOIHnlmhn7QYQtJs/BMVUSp/p5+Akg=;
	b=mAQrqgB7+xHwLp0cviI5IMLRZRhHc/2Q4MDZ14EdxVtj9O0sgqMkcgKPMTMzC98xEX3N
	 NDI9c2OkwggaghIbWE2YOx01VFoetPdLrhsHiRkOHDXOFceQuvj7jAyB/vGnNYdStOfOO
	 fAx7YrI6u0u4cT+1rELfpbLgFtHqPkyrV9Ma8zdoh8x6IheOMOwWuAjBv6xfEbqOuX+RJ
	 cSwLXpB65wfn6XHxIcRyob60b5GP3mLC3SIqqZMYi/MGyoYMf2VDVpkW5zjqGhVAEyBnu
	 eWd3u1gMzK90OwgNGOXut2X/18NDRFdgr1TEFr2/hFtEY4i8PJqpHKa/kalpJoWsuTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tg2uUAXs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C311606A325;
	Wed, 18 Nov 2026 20:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tg2uUAXs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DA91F000C4;
	Wed, 18 Nov 2026 20:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033490;
	bh=pxCEaiXP/o+RHXOIHnlmhn7QYQtJs/BMVUSp/p5+Akg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tg2uUAXstHo2xjFOyoPpqsry+QOc2671D1Qd37Hh7WPY/PkXCp+fbTZMbDU2eFQO3
	 p3giU6/onJtqI9Ulhk7k294+lfwwvWy7mPVglRTxYP0I/uJzlwuTfbVCGu4Ha9T0sk
	 C3uuadOeG6ZbtN/bRD29zXlkuBEe3SPsXuSfRAi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0034/3318] iio: accel: fxls8962af: clamp the device-reported FIFO sample count
Date: Wed, 18 Nov 2026 15:10:56 +0100
Message-ID: <20261118150314.842201012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 2f8225b91eb478ca2e9aec8aaef4d229765bcebe ]

fxls8962af_fifo_flush() transfers the sample count the device reports in
BUF_STATUS into an on-stack buffer sized for FXLS8962AF_FIFO_LENGTH (32)
samples, but the count is a 6-bit field (0..63) that is only checked for
zero. A device, or an attacker on the I2C/SPI bus, reporting 33..63
overflows the buffer by up to 186 bytes: a stack out-of-bounds write.

Clamp the count to FXLS8962AF_FIFO_LENGTH before the transfer, mirroring
the clamp already applied in fxls8962af_set_watermark(). Conforming
hardware reports at most that many samples and is unaffected.

Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/fxls8962af-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/fxls8962af-core.c b/drivers/iio/accel/fxls8962af-core.c
index f4e253c6c7d70..87585370defc9 100644
--- a/drivers/iio/accel/fxls8962af-core.c
+++ b/drivers/iio/accel/fxls8962af-core.c
@@ -959,6 +959,8 @@ static int fxls8962af_fifo_flush(struct iio_dev *indio_dev)
 	if (!count)
 		return 0;
 
+	count = min(count, FXLS8962AF_FIFO_LENGTH);
+
 	data->old_timestamp = data->timestamp;
 	data->timestamp = iio_get_time_ns(indio_dev);
 
-- 
2.53.0



