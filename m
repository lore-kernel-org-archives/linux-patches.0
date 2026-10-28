Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213348;
	b=V6g+ADCc4q3Oibviv9NvHfRbormuLeKYUrgYrxVVtXIPxcq1AOhrwQK6GlJJv/uTXQTO
	 lt2xqvIfF+tyAL90Ppa0BvZRzgGShPYiRCLkSFBAYEpEFaOWCX7uUPETYbNiKd2g5zL+Q
	 8sbCLetKhtz6oNHL9JujVZv+5PvwoKAjVBI2LUaPjjn0JqF9jpdLSKlWf+31NUGSsl9wT
	 qs5SS9kpSdjVIn27ClesvQjjgB0FRba3B2Jll5UJPneULiSsAxyrtfyy0KyiTYZNimO0W
	 XgzbfP2Kx8vDmqQYMyl/lYs0a69mT9mdH77Mc/ybNzZmp4x2uCinUjj5weSwRrSO3SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yzErNfkiZ2F0biba26slcQq9urEOyYcKXSQ49Fb9MiE=;
	b=KKe6ufG2sq1iJ381thM2hIzADLSuQ7hY357geiGmC4YFX/C5MClGnHs75JOnOo/c4ar3
	 dVmcq5nPf9A81afSthoQAQ7WGA4Rt6FXD2O82ASmwzNJZZuw0qs6qY0hrC4kKKFdHYaO7
	 oqv9nUkOBYM1o1OWRODIQA9H8C+cqjw27IcR9PF2bUo3na11sC+V72pO2X5hNjIf7wqoJ
	 +ODd61eRgpEN3FtZReSbl+VDjTZJz5gUZuYASX+2Db2eSEpOoihn/rnaDE4JWPgml6ofh
	 N7nmba9PRPwYr8F2af4Pf2cRgaIvCpOqxgEhj7cJQEfYkZ9PBIJ8RKAo+rcJwUYAvZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ey26zXav;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E1C606A31C;
	Wed, 28 Oct 2026 18:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ey26zXav
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0311F01825;
	Wed, 28 Oct 2026 18:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213348;
	bh=yzErNfkiZ2F0biba26slcQq9urEOyYcKXSQ49Fb9MiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ey26zXavrKkS+1fg3avm0DPZWzCdlYxdULLkYvAeF9a0rDBpoypl7TSrIp5rnLNm1
	 Akr+F8YdLEkTpNI6XirSdAcRJVXkq7/4pnD5hXQcB0/I3Fk1goclUK2EHBE0iojrtm
	 poPQsWQLZC5snqCzdTFE5fBk2p1Arq7IosZXjL1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4a807caf7680652d53b6@syzkaller.appspotmail.com,
	Palla Raghunath <raghunathpalla.0209@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0473/1887] Bluetooth: RFCOMM: Fix NULL tty_dev dereference in rfcomm_dev_shutdown
Date: Wed, 28 Oct 2026 17:42:49 +0100
Message-ID: <20261028170510.005682596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
@@ -131,7 +131,7 @@ static void rfcomm_dev_shutdown(struct t
 {
 	struct rfcomm_dev *dev = container_of(port, struct rfcomm_dev, port);
 
-	if (dev->tty_dev->parent)
+	if (dev->tty_dev && dev->tty_dev->parent)
 		device_move(dev->tty_dev, NULL, DPM_ORDER_DEV_LAST);
 
 	/* close the dlc */


