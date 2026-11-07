Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063952;
	b=Hzn6linDNYlYD6yjKPzuFBen4xAsQ2THzl/LzneEM2hrCfVXRb59IGQ58J109EcfUt/3
	 hOWBvIcAYi/YACTMn5NiIEhRjuVNHcjffClLLuWIiNk7HM9kE6nwSggRQLDWfAd2FUgfo
	 X1mlRDJq1wCwMM84X4nBIYA2ufdP15RWbKqpgtODK+N9PEejOFi7i6Pd749IWE4R9khK6
	 zU7CxzFHrRxoY+brz70PiZTNSSVWE6crKvYXNVEVKQhvc4IEcPfGBT3XhA3zOrACEVsIC
	 ECq38+gfpf/ukN99armppSRgpI5VvPfxBmefYhXEOzdF/QQrndz4Pcss/uMdwPI2mUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b603yQxCQ/f30WiA8NPNuK3A9I8SaU6pwMNV+YCIUa8=;
	b=jO1uMsr4t1NE/vGmm2f+oadYj3hI93YivEb2Pvir3zpIPkI6YSBijgIt7yi5ZbYuB/0y
	 QGHn1aM7LOMALiKaBHzydIidxXg0UUSKDc6sDVozkR0kIa8DZ6qFNY7IP0AFkVrkjBBlT
	 eSgsWH68eqws8tn+w0yU9CBKRs3rKqXgpnWUvPUw6eJ6sBh5lYS0lLMbOSlcxtzRK5TLE
	 6GTXXLD1jpFfz8Bm2t8QJwERllVpht0Tq3tEO5rYKjo6RlnNxR0KsYwAZA9DkagqFhXdp
	 RdCDQGwOx20658KR+JUF4GkKLpLijAF/OO5nuWVoLGUzL6kpldSqYchxeTw1Pa7BJpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p5VkEyWc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833C1606D829;
	Sat,  7 Nov 2026 15:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p5VkEyWc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171311F008A1;
	Sat,  7 Nov 2026 15:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063952;
	bh=b603yQxCQ/f30WiA8NPNuK3A9I8SaU6pwMNV+YCIUa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p5VkEyWcKazgCQzdUL1RlOvG4bVAAui73qQrldspG+ptHbwfrQXkUt4BsC1sgmh2K
	 Z9bK4x8FnG02qrUJF1PyNlNvsLWRL5i+iG6hwVrz3J8LK6tuHfLHRBV3at3zaETAJv
	 CDg2QFoQCyoMZqEl6Q2ANv8aa4VFw1zEeljr12oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+ddccc0c0dbc0a38ffccb@syzkaller.appspotmail.com,
	Juan Perdomo <jcperdomo100@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0143/1257] media: cx231xx: preserve I2C transfer length
Date: Sat,  7 Nov 2026 08:40:39 -0500
Message-ID: <20261107134943.260086116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 19f5036a78d7f..f85d054fbb5cf 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -463,7 +463,7 @@ struct cx231xx_i2c_xfer_data {
 	u8 direction;		/* 1 - IN, 0 - OUT */
 	u8 saddr_len;		/* sub address len */
 	u16 saddr_dat;		/* sub addr data */
-	u8 buf_size;		/* buffer size */
+	u16 buf_size;		/* buffer size */
 	u8 *p_buffer;		/* pointer to the buffer */
 };
 
-- 
2.53.0



