Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024690;
	b=R+5xBq7UdddMyyZ9HuP1mF1AU1FvzoGP8VU0fJ2qNGrIieJBFivvl8GzHmpFaIBPUl5m
	 gff9HosObQX0y1eOvtgNrai8anhr4wAiiml+wokqHnEHk+zwAk2tcA6AYRecXrklno7IY
	 2H7FAd+YjftazVCSDpZFufb/HiGZPOjRL+t8ixRc70w8aQYv4sx204iOr1GBMiMxvFCyf
	 NAUFtJmHzKO0lTC/y1CzZ2w69Jq+EfQ2teCpZDhZGJ0iXNjlOy1LxfrhHN54lJkBoU0qj
	 2E38orsflrfhPTzeSgh76sXh/eKBJNkFDOSmGyDReV+A+wKCMrg531DIIQfVn1hLTng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2VglpOopLGdbf9M/E3qrW5zYocOJJHJp8TLFLMdyn3A=;
	b=k9xdxZEs6d73bPQLCE4QeK1cm+OZ2C6f6c+p4I1SORAJTpHLICtXxs+hINyJozcVdxvs
	 225/7JaQKDLDBg/9UfsW8MEMGd8ONTALM2pmfodiFgroEnhOgu7Yxvladez4lVYOFR8HJ
	 /ePMT7jguEiX6UbjvkwLONsn24Qre0kCfJ/0Lt0I97HUOFTBhBCpPbpHpH0dABJrjlStQ
	 t0e+/2f2kq+WA3vQVKCl15XmQOUhmRe6zsDlM3Ehbwqwk/1IAv8vFryk+YAANlkx5TQ+N
	 2qt94ei78h3xmI2SJDQUen4j2RR0/hBy7vKpVAFhIzwTXn1uHO1DGHO6hVbT2ycWoMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdhHahwu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98429606A32F;
	Wed, 18 Nov 2026 17:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdhHahwu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AB01F000C9;
	Wed, 18 Nov 2026 17:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024690;
	bh=2VglpOopLGdbf9M/E3qrW5zYocOJJHJp8TLFLMdyn3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdhHahwuIRQ3PN8WFx9fZvxgn1vXPMr4yS+nFILQWpZi5AJ/bWd5s5GIJkK3cbLBv
	 pdc3pGLLJoa6dKspGDrOvEz/EMEgaXW4H0XdogX61eFCevwb4sTRkKIV/5f4dfECFw
	 egNVx4QAtBgnxY22PjkUfJc/w2FHF8VT9iXKgi6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0814/2151] iio: dac: ad5758: Reject out-of-range raw values
Date: Wed, 18 Nov 2026 15:42:29 +0100
Message-ID: <20261118150151.781678932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arka Mondal <arka@arkamondal.net>

[ Upstream commit ebc026be1b719e47bd7f2f1e72fabc875b590f87 ]

ad5758_write_raw() passes the value from userspace straight to
ad5758_spi_reg_write(), which keeps only the low 16 bits. Writing -1
to the raw attribute gives full-scale output, and 65536 gives code 0.

Return -EINVAL for values outside 0 to U16_MAX, as ad5755 does.

Fixes: 28d1a7ac2a0d ("iio: dac: Add AD5758 support")
Signed-off-by: Arka Mondal <arka@arkamondal.net>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5758.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/dac/ad5758.c b/drivers/iio/dac/ad5758.c
index 27d5c460254ef..67fdd59bd69c7 100644
--- a/drivers/iio/dac/ad5758.c
+++ b/drivers/iio/dac/ad5758.c
@@ -557,6 +557,9 @@ static int ad5758_write_raw(struct iio_dev *indio_dev,
 
 	switch (info) {
 	case IIO_CHAN_INFO_RAW:
+		if (val < 0 || val > U16_MAX)
+			return -EINVAL;
+
 		mutex_lock(&st->lock);
 		ret = ad5758_spi_reg_write(st, AD5758_DAC_INPUT, val);
 		mutex_unlock(&st->lock);
-- 
2.53.0



