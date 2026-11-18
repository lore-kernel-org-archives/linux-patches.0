Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044982;
	b=wiqUoZ+HtNGyEfLefBnU5/l0DIAAsvkyfgiRDfnMqLxeCoY9WDeDmE6uOD3V7zSs6x0X
	 1uzWXpFXMvgGb9meFau0DxJ/72gVQq8pTSRnP65/shKxt73AMLKKyTvZLp5+4wztg5GDd
	 iNmUcatGqij/XP4hoLhx8mlCGLsq1ENUKW1wsn++1fglvp4yZuq2BV+rpFBFAPcA9dCVb
	 dmQAQKi+YFbi9inPM3diZqmEr58dYLqvYQlXaPPDkCtqZQD97D4IalpjzFaE4xUmmXnAR
	 CSaUQY7Qu3Nq8dWmqY1mlKBLQ7kVo4IWcmG5y96r4CgqrWSuyUraFMi7iQhDNeP6zGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J7lgoIDBP6EjaNAFNrrtc+rtZfe7xt3B3x/hGZCYdqc=;
	b=JA/beahjggYa+SoAROJYdQrPNqtUUpNFqVZinyX67GXRv/Hw39P9gJHzYvfEXvZNL1Ht
	 yLePdIPJPom+tN6Qvc1Gfm4uX+ufcdYOUu5OpykMWJPTVDTZMRrIyl7jWV0hiGyDrnCq5
	 xq66jWvyvduR+jWSOly3GT5YSF/kZGLo5ROrXzLkrdG7zm+/tgCMupj1m7vAms1HW4suu
	 JDgqTShCoSiZEy89MK8pibRCYWfhhl9hCjGb/sUG6kqZBI3FHu9kE9X+jLpR5XPXq8znV
	 0/FsloyJU3k/+wXO7Cjy0lWIKzuBfuMzfMdqYfhfYW7Z2hgsgxZPtctXgteIVYSUC4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iLuLE1Vd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCE0606A325;
	Wed, 18 Nov 2026 23:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iLuLE1Vd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0191F000C4;
	Wed, 18 Nov 2026 23:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044982;
	bh=J7lgoIDBP6EjaNAFNrrtc+rtZfe7xt3B3x/hGZCYdqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iLuLE1VdlY2KY/ZcRa34VnQHXvI01g0T9+5Gd8V5TLWORbD7JcFJHnHTrNbeXu/Cg
	 q7YRcGbIR1DO4TDhgttIRR77qSPJSb9We4sBgtQm1WZ8Ri80cUwMj9t5vWPYmFKoOM
	 oNcnm71p34MHoVv2PqICTk8rqqHSuxYwq8VmUKUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+ddccc0c0dbc0a38ffccb@syzkaller.appspotmail.com,
	Juan Perdomo <jcperdomo100@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0760/2857] media: cx231xx: preserve I2C transfer length
Date: Wed, 18 Nov 2026 15:29:54 +0100
Message-ID: <20261118150228.914558365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juan Perdomo <jcperdomo100@gmail.com>

[ Upstream commit a19c9502a69bbd42c18816b09cbefdeb4cb68066 ]

The I2C core stores message lengths in u16, but cx231xx truncates them to
u8 when populating cx231xx_i2c_xfer_data. A 0x700-byte read therefore
becomes a zero-length request. USB treats zero-length control transfers as
OUT regardless of bRequestType, so the IN control pipe trips the
usb_submit_urb() direction warning.

Use u16 for buf_size, matching both i2c_msg.len and
VENDOR_REQUEST_IN.wLength. Oversized transfers then reach the existing
URB_MAX_CTRL_SIZE check and return -EINVAL.

Fixes: e0d3bafd0258 ("V4L/DVB (10954): Add cx231xx USB driver")
Cc: stable@kernel.org
Reported-by: syzbot+ddccc0c0dbc0a38ffccb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ddccc0c0dbc0a38ffccb
Tested-by: syzbot+ddccc0c0dbc0a38ffccb@syzkaller.appspotmail.com
Signed-off-by: Juan Perdomo <jcperdomo100@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/cx231xx/cx231xx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 6929e4d97067a..4e00b082e3854 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -460,7 +460,7 @@ struct cx231xx_i2c_xfer_data {
 	u8 direction;		/* 1 - IN, 0 - OUT */
 	u8 saddr_len;		/* sub address len */
 	u16 saddr_dat;		/* sub addr data */
-	u8 buf_size;		/* buffer size */
+	u16 buf_size;		/* buffer size */
 	u8 *p_buffer;		/* pointer to the buffer */
 };
 
-- 
2.53.0



