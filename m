Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052202;
	b=BUjMjMoDu8m4IvaPU1ea/JZqnNc3E9agH/iluvVtt4+AFyqn/CPL73xCuC0ELlhTpBDI
	 uM09MI1GzV8ij0IzKTnFCPdg5hQ5/y3raeCCZC8+19AV823AC990Y6/vte2YIsiWpw5D3
	 O8nSIn0EnpfMhOcYbsdKwmUW7gp07oIGZQ8058D2rxz3N+3D8Fo94QOOt5re37ifMH/nk
	 vBRwz4qF8Nigv9y1Qx8sbYHsMUMdQXyCKzPhDfyN3VtA207awf0ox8Uw1HpV1tvuQEFMg
	 JFy8BtuMme67dari30CwSOE/m+VCvqSsHwLko3r+YUqCCQHJZfdlpslUR61lKgCx+5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ACGsIZG85hWELkZsyNRIpcDUV8g8IfCyRv+le9497GE=;
	b=cEF/x8CQ6GoY47Wwo4fXGOWwJZ3vgv1LaXzmjENYg4fui0S5bReqIV18MXk4Y8yOD3rT
	 qQ8ExDHFwSw5Gs02cVqmjerk1Y7aRJzyIkFXobPTvteVZlTSY2It14Yf6mmiMx+PL/YwJ
	 RRpgcTy8sXgS7VUySQqk+zKR7NTg4rRgsIvvwMI0T7J5M//c2b5dvOvC+Vz3yl5jepIyk
	 LZxTxxyO0aX2POD4qY5Iok8F3dLoaDUGOp56Ff9ofCO+cVKxnyCXB8hzGTld0/3QmG+e0
	 RFW43UWOMAhM4FuIyWZEs3Y5lEsEjSmx0wvnRBfzl6ykLOigVv1qm5Pq8XUXOL8O2/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gz1eqrSm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B54606A320;
	Thu, 19 Nov 2026 01:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gz1eqrSm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E29E1F000C4;
	Thu, 19 Nov 2026 01:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052202;
	bh=ACGsIZG85hWELkZsyNRIpcDUV8g8IfCyRv+le9497GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gz1eqrSmF65dtyEPWzPkly0sZsINnpm5ZUls6bmwEZldFC1Ov2etMFXf3DN4UOKCD
	 Tp0/4haiPNDTnagt+Vo5FQ5Dg8GZBUjkKxbQhF4nfoK6zqSoZe/Pk9KasXWkjwH3xT
	 rK5zxeSzC72yvXm/h5wI/kSCtio8417SDBaGUR3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+ddccc0c0dbc0a38ffccb@syzkaller.appspotmail.com,
	Juan Perdomo <jcperdomo100@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0481/2214] media: cx231xx: preserve I2C transfer length
Date: Wed, 18 Nov 2026 15:35:57 +0100
Message-ID: <20261118150030.443777101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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



