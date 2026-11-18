Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043100;
	b=QzTDVx5Gp+AMXU+Myf9w0SZLLHSliuERr6L4fa3UKZ00hoHaXh0tuQkwECoTPWEVkG4V
	 kQ4zaq57P/toOdXkfdbu6eFSXo4FFkw4JXD3FXLyHLVDwsaPun2xV9hI8J+REdB7AkjHp
	 Mr2ZKnZK4bqu76y9dld3k8iRct/xUQUgT9YKI2cmxSpJyu7hVCKXitEc3CTt15qASRpn3
	 JJZWFcsGtwW5Ghzr+4ZEfD6Jr2Q3757Qn/Uoj/39AlN1+I/SwmsdwHPFPQcNIO8ayG3C0
	 wtCQm+UjqjcgvetfCYnEYYZrIEwK8FgNL6ZEb6sIsltDSRChnDK8UQOIZ8uuijizraQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YTseUtYKfzgA4+oE7D4wnkAkq3ccinJOCHCH5KwPwno=;
	b=BwwZpD2FJowc3/gNTKDoRj+Y5AUBLxeYhZHAZ25b5iz/8RLQtNOEv+SXlkpAk3jVntDS
	 37/lKnT3v1A9zE+ttDjNeIkLzEL39vJrMWcaCIKtzM1oKaSfDNvKWefc4x6SzqDTNsfKu
	 5oI5tZkyOjecQBL1XIugnMYINrL6deOKiLGdjGDGXunMms/Ixsjln8bL3rimx3Ku/7Vz2
	 Xhx4NWseZ+Qfmtv4BnOfTtkeS6T/XG5ctvU/lZ5lMLPlrydvHkU1PVJByAyzYoQjSkazC
	 5XLmXXzPK+azTB+NdXQ38EY9+gVu4Z5xN5mXg/sfl0VTgG72fAj/zgWiB5i73mOJZ2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WNrRPPcM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49421606A325;
	Wed, 18 Nov 2026 23:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WNrRPPcM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E301F000C4;
	Wed, 18 Nov 2026 23:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043100;
	bh=YTseUtYKfzgA4+oE7D4wnkAkq3ccinJOCHCH5KwPwno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNrRPPcMiZmkM3MDf8FMiQoqhxWODEYfVPyWa2HlUpD78gW+wzNZZfT6TWJV1XCLw
	 pIxmYtFDdTLuVUV5cvo1W3wf3hVGPZlPirVdUf9RsirvNAUmpob+khu7JSEjTXZ4Ec
	 4nnKHoQftNbQ0qFrh01Gp/RoGXwyogT/9c9+jr/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0089/2857] media: ivtv: stop VBI start-code scan before short tail
Date: Wed, 18 Nov 2026 15:18:43 +0100
Message-ID: <20261118150204.487755182@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit f373cf17fb8e7a530bc6e1e36fc41cb5dab2cdaa ]

compress_sliced_buf() scans one byte at a time while testing a four-byte
VBI start code.  The final iterations can read beyond the remaining
buffer tail.

Stop the scan once fewer than four bytes remain.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ivtv/ivtv-vbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-vbi.c b/drivers/media/pci/ivtv/ivtv-vbi.c
index 80478b026d752..279a4d6bece19 100644
--- a/drivers/media/pci/ivtv/ivtv-vbi.c
+++ b/drivers/media/pci/ivtv/ivtv-vbi.c
@@ -330,7 +330,7 @@ static u32 compress_sliced_buf(struct ivtv *itv, u32 line, u8 *buf, u32 size, u8
 	unsigned lines = 0;
 
 	/* find the first valid line */
-	for (i = 0; i < size; i++, buf++) {
+	for (i = 0; i + 3 < size; i++, buf++) {
 		if (buf[0] == 0xff && !buf[1] && !buf[2] && buf[3] == sav)
 			break;
 	}
-- 
2.53.0



