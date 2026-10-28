Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211445;
	b=pkkxrd8ztsevpG0HWHcVTorcu77riafVhobMV8gDSjFzu3xLfTRO1eZENuZ5WIyGdJav
	 XVLbzbVhiShHABoVH98jgBpaTMNtl5qnEYiimJ76FUFhSmwNa9Asri3R4HMwwBVfD9gWJ
	 oDqt04vk9ozuFJEpmpdoiVlZaSQ62qnKT0ERjqkikF6Pr4aAqOo1/tPsHtJpilANjRcM+
	 xQ7Fyz+7vfdo8jiE6ZJ6MC0g2LWWL4fk9yWbhfBxkkKUzMmqaUK5hcQpicqdL80dn5POG
	 gKD6rosastQ0wJkblu1RRJolvuYJ105rzTt9DJTan0aQh3gdQ/9zkW69juuOeuhmCCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1ASYBGKvX6e8DisISmN3YIxMJlkYRT51hgWb2jtZw2k=;
	b=IsD39nzPr+Bt5JVVa50yPXzsAgjAq0b7RR+NsUtt4qbfgbmkPDPX8AaqxqN6qVDdH10Y
	 t012LB3Eu9Gslqan/sQTn1S44qSGcaLLGSqgp7U4FPXiUbt23mcKLe+8UZFm6oGROQZds
	 Z66tarm9i6O1otCCnx3+XBOIUMO1XtF+htmeABN9G/ILMnUYUNZASOu5GESYC1A/xWbNK
	 nBwe6bSgx7jNZYfsNyCYk7+gKCa70HsA6oh87koWX+btu9TswM21O6xuvOLEvg/8R9o1b
	 tBr8F8YqZs5cXsnnXhL44f7RXa5zHFnGvY8LRNvl+hu5IJ2XeNy6B0Laz6CkRZjWPOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IypabGpT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4C7606A31E;
	Wed, 28 Oct 2026 18:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IypabGpT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A7D1F01825;
	Wed, 28 Oct 2026 18:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211444;
	bh=1ASYBGKvX6e8DisISmN3YIxMJlkYRT51hgWb2jtZw2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IypabGpTB7A4GWLnO1/XVFWWCF3H97n8E2BdNLyrQIV5aWRn1orAFEFM6MyoJR8Ur
	 HvTQOJaBZJj00nNL/3P5bl0ApgKk/haqGdOvCMIZPILXJSYmABdPwNz7Kqjm3/8z89
	 RsVUGKP8CDWPeXlwQbaEIJ3U4LlT1QkdQy0S15/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4a807caf7680652d53b6@syzkaller.appspotmail.com,
	Palla Raghunath <raghunathpalla.0209@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 381/571] Bluetooth: RFCOMM: Fix NULL tty_dev dereference in rfcomm_dev_shutdown
Date: Wed, 28 Oct 2026 17:58:48 +0100
Message-ID: <20261028170017.052889190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Palla Raghunath <raghunathpalla.0209@gmail.com>

commit 08e90633377f1b2567ab5ad6810b74c552246a07 upstream.

syzbot hit a NULL pointer dereference in rfcomm_dev_shutdown() when an
RFCOMM tty is closed.

rfcomm_dev_add() puts the new device on rfcomm_dev_list first and only
then registers the tty device and saves it in dev->tty_dev. If that
registration fails, dev->tty_dev is never set at all. The device can be
looked up in the meantime, so an open() of /dev/rfcommN gets through
rfcomm_tty_install() and attaches to it. When that tty is closed again,
rfcomm_dev_shutdown() uses dev->tty_dev without checking it:

  Oops: general protection fault, probably for non-canonical address
  KASAN: null-ptr-deref in range [0x0000000000000040-0x0000000000000047]
  RIP: 0010:rfcomm_dev_shutdown+0x48/0xb0 net/bluetooth/rfcomm/tty.c:131
  Call Trace:
   tty_port_shutdown+0x1bf/0x220 drivers/tty/tty_port.c:372
   tty_port_close+0x4e/0x150 drivers/tty/tty_port.c:705
   tty_release+0x359/0x1670 drivers/tty/tty_io.c:1718
   __fput+0x418/0xa50 fs/file_table.c:512

rfcomm_dev_destruct() already copes with a NULL dev->tty_dev. Add the
same check to rfcomm_dev_shutdown(), so the tty device is only moved
when it was actually registered.

Fixes: cad348a17e17 ("Bluetooth: Implement .activate, .shutdown and .carrier_raised methods")
Reported-by: syzbot+4a807caf7680652d53b6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4a807caf7680652d53b6
Cc: stable@vger.kernel.org
Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/tty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -132,7 +132,7 @@ static void rfcomm_dev_shutdown(struct t
 {
 	struct rfcomm_dev *dev = container_of(port, struct rfcomm_dev, port);
 
-	if (dev->tty_dev->parent)
+	if (dev->tty_dev && dev->tty_dev->parent)
 		device_move(dev->tty_dev, NULL, DPM_ORDER_DEV_LAST);
 
 	/* close the dlc */


