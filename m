Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209077;
	b=U349Snj8gtlrzNpiIrnBScSS0e5No3YchR1XMq+Wx3KMHJ9B9/mmsQmJhzQ5C7oF+Q7u
	 CGOugODb7wKvbwYhE7dGhGm4fg37KpNmWNigGEuGz4adsYbfWbxpbGb2AInOEBOLiRZCn
	 xedtRKPKFT8AbZwV8ZbcqVmwzil5EzW3y5WgRcaDjp9OpoABcpcK/QrFUt2I/G+D8PMKN
	 V54MVq9mTuKNFsmOMloR49SH6saCe2cVvB5TJoGuHxc5q8BO5oodO/FO3YEOIwGMJrEIK
	 cbOdn5zJAJSilggpGhoPOv+MnUY9TA87XC1ozMp9W5AmIL75jaIAKiBLFmuhljo3lxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uIp++ceshqdUke8FEissGPIGLNKVQe5ViQwURPXo3cg=;
	b=J++gMzyI/6oJ119oxgGHfq4HA4nEqCajXCFNdAguwDmYk34vS3Dv9dasLG9hg/ElbN98
	 1v9LCpgv4o18M1omEAJas/fv7FHbvRtL8eN6D7RwhNXGoDuppKFruyj/Po8rYQrMXnBVy
	 zPzjUPw6hcN1Y8oewSdS5WgjPlk1LJhypOxQLrsTKN/i9b283Pb/segugdObqpacCGAX0
	 txW2ZlKFeL2dv1cRXJJT1h2JRCnqZlJ30Jj5MPPmbQ7zkRv8Ic1RW5B8ZRCSC2IbKnboF
	 jkBI1QaSP0JdzGIL9CGzAY8Q9x15TTDtab+3M8vwGBsRJfxnaGMgqi4Y/2pbTlbg+0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u5kva/OB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99AA606A335;
	Wed, 28 Oct 2026 17:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5kva/OB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155B91F01825;
	Wed, 28 Oct 2026 17:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209076;
	bh=uIp++ceshqdUke8FEissGPIGLNKVQe5ViQwURPXo3cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5kva/OBzLuicuaFsyhqqb55zIeUr/0HBXlHyvcYUoUDZn6Lcy9SL6IxN8SBd3q0V
	 Z9AOQ1MlcsaYJ/k1n4wsc1eY152iEGoltaZIYj7QMbXW0j68WlJ7hSXwJNAXNY81zs
	 Jy2wLXUMBQJ5HXnSHDbJIo2IfQPce9bwkpTvW7K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4a807caf7680652d53b6@syzkaller.appspotmail.com,
	Palla Raghunath <raghunathpalla.0209@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 345/516] Bluetooth: RFCOMM: Fix NULL tty_dev dereference in rfcomm_dev_shutdown
Date: Wed, 28 Oct 2026 17:58:17 +0100
Message-ID: <20261028170011.660295528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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


