Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062828;
	b=sHjHQSWIltnUsbI0IrTe3cJzZ0RIzPjch3d5iEBgpygOCntBMsrL8kBPaa/8PaQQZsFB
	 qXJRNLUJ7qasofD//rQ+3n3fw743jYwyCFFr5gFP6yCl2KDaCu4VEXK9m+YUoUuRl5t47
	 e6Bein6xm4ucXDgLucjdUESOej5PYNProaHZJ6HQ1aUI8eBDKfebzkU5rBCSsf62mGq5E
	 cYrxoZGGTyKJ46fJOd4WhsyJN6SJtboGPP9zyhhjSczO3P3DmQqbEhyts0utKLh4HIWwA
	 p47pMx9UYET4yXAFtsqhtZUWKEnyUIDokVvTdPVLo4FmCqkXftnf3R+uM+/G3QAG60g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A0BJV+h+/g9zptnVmVMhm70uDa782lvg04fsepAcuaU=;
	b=iNEc3QZEfPJrzJ/0kBW547Os2iZzX0dN+TGQGYoJfhOSg5vSE4pwXwz7n6SbgD8LgYHc
	 T7zfnTAtLDRhE1J6mJORZiVTFJue884PfqFm3ampFMSzTzYTd56I/XzwnkiQM1wx3AS8A
	 MW6Pmcgujy0rt2ow5LpYlnX/tT5LUjqD4uFP2ha6mEDRYsXaBfHtjIarfTbpMUqxp5QV9
	 L6TaQC5S8WjIK2K5rbSrTKByhEye/IGTPSUMdnTD+hnjOF7qT0sgcQg4koTXWV7ColeBS
	 M723VqFfwa8LTj09HITjr8v4pMyYcm5FDj2kc3wLVz85NGZvIT5gRKm+MmrgVovu9hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k41kD9VB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797A4606D804;
	Sat,  7 Nov 2026 14:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k41kD9VB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263CE1F0089F;
	Sat,  7 Nov 2026 14:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062828;
	bh=A0BJV+h+/g9zptnVmVMhm70uDa782lvg04fsepAcuaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k41kD9VBS196+qklwWmGCVu2SV1JJpfgPvwbIftwUBgMiztYsj9BCOrLT4o0t1rjp
	 s6Az2zF1mqvFxmZcJDL4ECcCDnigwEozeLbJ0tjg4td9KHm9GmZifhUnfbuZvuKywr
	 C8DicxBGxDeXcs5ag/qohqr/K0KXv2HRZprzZr1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+ddccc0c0dbc0a38ffccb@syzkaller.appspotmail.com,
	Juan Perdomo <jcperdomo100@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 123/869] media: cx231xx: preserve I2C transfer length
Date: Sat,  7 Nov 2026 08:46:45 -0500
Message-ID: <20261107134856.679344868@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



