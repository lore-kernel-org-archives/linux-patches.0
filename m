Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061976;
	b=iYal3POf2U1sUrr48yjd8y4adTeb+5iPOYr9a1JnpfT7AvOSUbVRimF9Pnlqid20cMFm
	 nZbyZivt0mP6Z2hvKIWCA2R6uTAxrHg7B00Ic/l7R438ormtXES91yn2YYA6WUjXaeS0R
	 6oSUrc0Qlwr5ywB7yv7Ef17ilhuKha51+YJKpkwRrUbK+jAc9qVrQAOzBuFEO21gaF5lT
	 /Kt22e2EZH4GwOj2uDmstmpT4sIL6Qwq4t9Ful1+3KvXOU688GnwKJ4yMsSmuR6XfZjKv
	 13j/f8VlkXQ10Bm3yb0Wxn5wEAcqYR2YyRjvEFc/eMc3oinVUVVsP7kWmmyKzQP7Xnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ZoSh3E8FQTFv1yO6DNgqZuaZ4SoHxxXlWZv7BY2Mz0=;
	b=U9XQ9xNQtvRW8E7+plmoAgwFwsH8ju4OQeh+xcWwPn5kPttF/CAYHoMKmTtTgsKW8kXU
	 tFdwQIZc/4fMUMP5hraXSWO1KyKR8YlOef4BuRPOXSO21mbluj2pM7t0AMLYiIRrWpOYP
	 snaZFxRqFjWEVTnIKcjHYpjExVsiND+rmg1M7W8jjM6qI4KsYqC99Tx4rjq1YcFzENz+0
	 BLdLQpBQEuxSMYdUFZ+Q9jyGz7je4k7Qr8JiEE2IdSnbMelDe6EAP/CtEjyZeQDc0tgMs
	 2LyQ7JDIn8SaG2MyeGyRkP0z1UkUWcqhfxo0wr8LaLlIzhcBdOhEUGujqvE9QHgogdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K91n+eeV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EA0606A32E;
	Sat,  7 Nov 2026 14:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K91n+eeV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761941F008A2;
	Sat,  7 Nov 2026 14:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061975;
	bh=2ZoSh3E8FQTFv1yO6DNgqZuaZ4SoHxxXlWZv7BY2Mz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K91n+eeVnnyj4D/l6KCdIDIOYI6e/OXXVxq8vjtOJ1z/updtYJbbyWCQqcWJXr4Vd
	 4Bdc3qw3SFwSlMiwMNncPC7Ay86KpKUMBGcP9Zfvk1R7860vcwOZ9IrvhAcy/s4QKg
	 qT2erWt1RItktvTs2g8KPo4piFdxWkt7pivCL6ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+ddccc0c0dbc0a38ffccb@syzkaller.appspotmail.com,
	Juan Perdomo <jcperdomo100@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0970/1536] media: cx231xx: preserve I2C transfer length
Date: Sat,  7 Nov 2026 08:49:46 -0500
Message-ID: <20261107135024.891920473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 74339a6a2f718..3c419bb45fbdd 100644
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



