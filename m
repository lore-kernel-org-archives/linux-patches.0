Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058161;
	b=W+qIEFQ+f6BWjfre+LpbxdDFwhsWlja7XEugfEVku05NjQDIPyeUUdJmC2YS6gABfOPB
	 9Qh1yzN5RHTkf0RlJ8Vc/+WHMXtx2xHQMVsojaPZcWwICcFkmGxkWy2/ee1R6STaUD2Tt
	 le6vPjSUhCIVHh0HLZDruPeenb2w4Hucpxfak1C0TjAsg3U8lYiAR8pzvq1M227nRv2Rw
	 e8jRju80b5QY5z7K6p6vT0oc08VOMuhazv6DWKI02Pii13qFV/Im1wPbbUK3LP/g+cFs3
	 STBcbiNwEzGYLsbc4+yFxFjOPnBb6QMpSfKqIu8wi4UWaA5YdfL1eNLcQdR9zeqEs/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NBEchV2VTfj9NSY4lCqJPspERDEiz0SrZmv4ZD0foRc=;
	b=fcfTY/EvAozlkz3Sx9V0LeRkoAJ5ap+bl+flpT1DecgwVC8KTESVS4c8X3q8TnXbDNqo
	 4Nv03A+9vUJpXAxLnaAi+A9fMAWUey4wAb3ZHHLirP3yKuswjikXjOpA+BHfpYxu0LkQu
	 hEOTo1wxMkLAXCdRA9h/D8uy92/0pl7WyTS9cMc07+M7RozMF+DRq58LD977As2j7DiOl
	 zuiFRZ64ot0X1EFeJxuzzyJR6ZlyHET3UsbOGI+/cN/kJ0zu8SnNzjczuf7zncjmt8TuO
	 q+tHsvBF9rNO5mHrLAKPCx8b5ehOjRTE2d9Oy/HdQXQj+mwPXMHA1fuR6u9eAqfsL1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yX/+/Z89";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148D2606A325;
	Thu, 19 Nov 2026 03:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yX/+/Z89
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940511F000C4;
	Thu, 19 Nov 2026 03:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058160;
	bh=NBEchV2VTfj9NSY4lCqJPspERDEiz0SrZmv4ZD0foRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yX/+/Z89rzTxvjWUQSb20GNnYLyk6gTteHDJftVSM1igQD1PvG9/Cww7KOCh/HnTk
	 7Jj3OZY0IXznQbxvWOz9swH83YRmNDaIyK8DkxMgYHvCdTEQiYR3wsVnHlg7uD4+Qh
	 jvl7mqx7VoTXKrqVXsoTeQ9dgbJlsSWdkLBXE/Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+ddccc0c0dbc0a38ffccb@syzkaller.appspotmail.com,
	Juan Perdomo <jcperdomo100@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0386/1848] media: cx231xx: preserve I2C transfer length
Date: Wed, 18 Nov 2026 15:40:24 +0100
Message-ID: <20261118145929.801955268@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index b32eab6417933..fca21b9b5c283 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -462,7 +462,7 @@ struct cx231xx_i2c_xfer_data {
 	u8 direction;		/* 1 - IN, 0 - OUT */
 	u8 saddr_len;		/* sub address len */
 	u16 saddr_dat;		/* sub addr data */
-	u8 buf_size;		/* buffer size */
+	u16 buf_size;		/* buffer size */
 	u8 *p_buffer;		/* pointer to the buffer */
 };
 
-- 
2.53.0



