Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626143;
	b=L+0MkWdQgaau9pHd2DwrzgL8/wDTI/d8/avZwjn9/xOp4T65RdwBQRYBrFbDpb7UWSqm
	 8oIubwQ27HJUekE5o/90qYKjwkF3jqfEXRPStM+E9AzJO/yBkSSP2yh7FAh14rONnMtXF
	 r9OAcpk/iQgFTjuZhKB59arTSaft6TvukpldVTSaozTnr31SH8CUKK8U583vJ9tETqoUV
	 7OyRcmGhRgD8FS2GRBu1ZqnsvjBMyBKONTbUUqj6HAw6Zupoby+5SOtfAAzPS2zM+xWqF
	 yMxFkq4EOax0EuYeFGNKipKnG/UnyUW0surbQN/tCXYpzEE7Gk61lpFPxsETyHLzmsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NjmlFCrJANf/QjInu6+efOH78Bdr4y3qb5b8/0Yb7ks=;
	b=sLWo/8Qd8j4CB+A7L7YBBeKS9gKuw65iVNNd80giDU/S0m4onxEm3gVJJgoVurQV7ptZ
	 oE8wbyrESsWGBtfJrd+RpOfY9BCuMaQwrSyXR7kDqhqfSbUUhPq4DhU58ua4/tjyIXGO6
	 Zl9ph/ckRTNxn79ZOJjEID4TzB0ITFBB0v+qlfkRf1OlKCCF9FaXuTBSYFd56O1MqMbPZ
	 fMfDsqhtivKcdEiGj3EBhga41pm7KORnh+tcgXAryccyGzZo5DrsVfUX2gN+701qZwNNf
	 LoNRxUEOXdXxHh+hgxx1rrSx/xGfV+OhlKfBVTYkBxXvvWF05hyoHHhHzUXnNqRgvQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6raaYtP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6436606A31E;
	Wed, 25 Nov 2026 17:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6raaYtP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A111F000C4;
	Wed, 25 Nov 2026 17:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626143;
	bh=NjmlFCrJANf/QjInu6+efOH78Bdr4y3qb5b8/0Yb7ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6raaYtPy8XDaNwM/kcZNp52OmZpp3xS59Vd0OhkUISxwZ0CeQKcj1VIH1cYBFPCz
	 +xtRVTrkGiAkoHjKIJyznvjw/1AB7NStUYDWCzRn7HUQQtpoL3SvlGl26Tkq5UtQ3O
	 zNNA/l9bSgZql2YL4yy6reaZHI0AKOH+wrHB1mSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.12 744/816] usb: usbtest: prevent divide by zero in simple_io() with zero length
Date: Wed, 25 Nov 2026 15:38:12 +0100
Message-ID: <20261125143906.398305956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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


