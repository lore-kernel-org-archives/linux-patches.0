Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704730;
	b=jE5JHUzH2Y/bHRZMmgct9pS0NPUy6dLfdxZmxx3+w4JKJMbjS05ceP4BRg4wU18fx/VW
	 U8fVAtJb8zvGO49lRGXufmCle/fqkJJ0ELe39qyhTagvb0ETpT8X8Prl72PfBd7Lql2yV
	 JiKT3nGUBKBcDhI6Jq5ZyqDyf5oTCATtofzFPozfRqhEgaO8KOEHWeICAfxU7hgkDd1iA
	 A1B8w7dSqoMvef47KiqXab2A7jyeP2njGbI6FzYcxe6jJwOX+gA2j89FwqGlXZj1xtYVX
	 IwZcQmBJi+XtklI5rCRPfSziS2XLXmpryCQARTEyVuEsmEZGAucTB91FjyP9PukcLUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NLFrn8s0OZikaI1lkX5Z+8Wbp5NXpUgtkJXlsLqQbFM=;
	b=0ofS6tvudoZOlQgmO+Luqv0g+h8rATdg8axVySP7Kq3KfNTi7cTcUDQboc3BG5DWVDP5
	 6mlK3vvLybs3aNieujBKPnLZtettXmgURPemCmGmH6KXhjtq2KegZ/O6vjXKCWQuGQRKk
	 Uak0sHKsca69cn8gnefsKTiXHtRGTZOH1g9TNiMR5WF1/Avxah4WS00MJqxDsPDPpiddk
	 +2shVFMlUHTxKHwq+fqKYQLzPicqPLSRhRMcPEOuR72t2Z0tUAsI7ovHxY0LZTyE3vcis
	 UgeQz5KGxBeqHWM041BSlOaPNLEaysgviIOjLAy88du0D0QjMwBTRQIkOGiH5c/IBcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZjk0DEJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CCD606A31C;
	Thu, 26 Nov 2026 14:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZjk0DEJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25FF1F000C6;
	Thu, 26 Nov 2026 14:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704730;
	bh=NLFrn8s0OZikaI1lkX5Z+8Wbp5NXpUgtkJXlsLqQbFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZjk0DEJjIHXdAkWduT6OlBpsR2XjdheaHe9jWWXZCGj+gjvq0TGFEOLYGI6Ib7SL
	 FX0eTdJXJpBKjtWkUEWUtXmMxDMuoSHwH65rDTdgpWL+EFtXO2cUhG+fz9eh88TffL
	 bI4KEN/gqqxYm7G2GIlpz+k+J0DyWmYlW4F9C0NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 223/265] usb: usbtest: prevent divide by zero in simple_io() with zero length
Date: Thu, 26 Nov 2026 15:39:13 +0100
Message-ID: <20261126143620.841731890@linuxfoundation.org>
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

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

commit fdaca138694111153f96c7d76877734b9dbf0e01 upstream.

A divide error oops was observed in simple_io():

	usbtest 1-1:1.0: TEST 3:  write/1 0..0 bytes 16307 times
	Oops: divide error: 0000 [#1] SMP KASAN
	RIP: 0010:simple_io+0x2c4/0x540 drivers/usb/misc/usbtest.c:497

The variable-length tests (test 3 and test 4) compute the next URB
size with "len %= max", where max is the original
urb->transfer_buffer_length. However, when a zero-length transfer is
requested (param->length == 0), simple_alloc_urb() still returns a valid
URB with transfer_buffer_length set to 0. On the first vary update,
"len %= max" divides by zero and the kernel oopses.

Commit 564e69893c63 ("USB: usbtest: prevent a divide by zero bug") added
the equivalent zero check to alloc_sglist(), which covers the
scatterlist tests (test 7/8), but the single-URB variable-length path in
simple_io() was left unprotected.

Fix this by returning -EINVAL early from simple_io() when vary is
requested but max is zero, so the divide by zero never occurs.
Zero-length transfers without vary remain valid for the other callers of
simple_io().

Cc: stable <stable@kernel.org>
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20261016072750.34256-1-25031212351@stu.xidian.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/usbtest.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -466,6 +466,9 @@ static int simple_io(
 	int			retval = 0;
 	unsigned long		expire;
 
+	if (vary && !max)
+		return -EINVAL;
+
 	urb->context = &completion;
 	while (retval == 0 && iterations-- > 0) {
 		init_completion(&completion);


