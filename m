Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028908;
	b=o/5dIcF5wQHEuqZI8znLr1N98lHzyHYtnm0hUjyi1X9NjGmqEil9TV/NNMkD0TWoB9WO
	 mNYzsJm6/OBqjFNco58PUJ7iZqtmtfy6MehKxwW2eUlrlcQ1UE2kJ1OSBE8zMfC5VlV8O
	 gHQa70ahTKcfmIl4y9jrEwtcK8jz6AnkK+bTWVyUFMtAyVXW2nzi9eJANORiJKK0d2OSE
	 jLPhZu/Wx7dHF89PvJrz5eITGVYzSpMV16pNM3zhnYKIBKCpViP8/bA4wrMq9wjXnRUsX
	 oZpjZFW3qUc2zHhglrCPKmBjk7ZVwKm1ED9u4O0fe4+MKp4xatfm0TPgql4Z9oGqCqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h7lTfRdXo14X82sjRheQuXNKW+rCajSDYqV82dO9eV4=;
	b=S3yJCyji3iLZlqIHiwoD4rQCNB5SxEolZR+6+R7DbwBr+OWXb2gQGISR5sLvNurLMrD1
	 CmvgQamk931bhxTE1hAI8onpfxJSyRoPDVOijQlRmq0ExvWIDlg/c/ZcroIdg/8uTbUXA
	 N4NJwJ1ErHhqol6XbXx/W1oMcY1QAXNQzY6HRQ0Qt2gHoouNzSFrkPNDw/lwnL5Xr1R+U
	 PTnqM3NcepiIgzkCUUHKQvXjWcTPPScdOz4XBpqCpZKR4lJmBL9xLpuvLw/2bCKUqGtbK
	 jjhZceJ9Wbo/WfUe9e3zvbwhxdD3o16wBNLncd+e7H+46OUyulUxdOcnepg6aCWnESw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XEkdOj6S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D23606A331;
	Wed, 18 Nov 2026 19:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XEkdOj6S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B551F000C4;
	Wed, 18 Nov 2026 19:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028908;
	bh=h7lTfRdXo14X82sjRheQuXNKW+rCajSDYqV82dO9eV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XEkdOj6SlYOT5VSKiwW+q9HpQUrwIpuCzwD2eGZyYMxbejUNkiAU9dNvUUQJ7ubVI
	 r+blDXHqhh52aA+pX60vYaJ/JNjlMEHzoMUrv8XaNa1IPu5TdQh9lsqLBO3UvIN9fz
	 y5hiWqrI8qTFJ1X3lj0a0ofQyJn9dTSFnYh2AKno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0115/1756] hdlcdrv: close the hardware driver once, and only if it was opened
Date: Wed, 18 Nov 2026 15:37:22 +0100
Message-ID: <20261118150012.771489363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

hdlcdrv_unregister() calls the hardware driver's close() when s->opened
is set and then calls unregister_netdev(). Two things go wrong:

 - if the interface is still up, unregister_netdev() closes it through
   ndo_stop, so hdlcdrv_close() calls the hardware driver's close() a
   second time;

 - hdlcdrv_open() sets s->opened before it calls the hardware driver's
   open() and leaves it set when that fails, so close() is also called
   for a port that was never opened.

The close() methods of the baycom drivers are not written for either
case. baycom_ser_fdx and baycom_ser_hdx call free_irq() and
release_region() for resources they do not hold. baycom_par
dereferences bc->pdev, which is NULL if the port was never opened and
points to an unregistered parport device after a first close.

Set s->opened only once the hardware driver's open() has succeeded,
and let unregister_netdev() do the closing.

Tested in a QEMU guest (6.12.94, KASAN and lockdep) with
baycom_ser_fdx and two ports: bcsf0 at an address without a UART, whose
open fails, and bcsf1 on a UART, left up. Unloading baycom_ser_fdx gave
before the change:

  Trying to free already-free IRQ 5
   ser12_close+0xa1/0x190 [baycom_ser_fdx]
   cleanup_baycomserfdx+0x38/0x50 [baycom_ser_fdx]
  resource: Trying to free nonexistent resource <0x300-0x307>
  baycom_ser_fdx: close ser_fdx at iobase 0x250 irq 9
  Trying to free already-free IRQ 9
  resource: Trying to free nonexistent resource <0x250-0x257>

and after the change a single close of bcsf1 and no warning. The
baycom_par case was not reproduced, the test kernel has no parport
support.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 056d9c67e92622d5ec8cc6ce4a49179a16c53ef1)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/hdlcdrv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index 2263029d1a20e..dc4e2c45e2d11 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -441,7 +441,6 @@ static int hdlcdrv_open(struct net_device *dev)
 	/*
 	 * initialise some variables
 	 */
-	s->opened = 1;
 	s->hdlcrx.hbuf.rd = s->hdlcrx.hbuf.wr = 0;
 	s->hdlcrx.in_hdlc_rx = 0;
 	s->hdlcrx.rx_state = 0;
@@ -458,6 +457,7 @@ static int hdlcdrv_open(struct net_device *dev)
 	i = s->ops->open(dev);
 	if (i)
 		return i;
+	s->opened = 1;
 	netif_start_queue(dev);
 	return 0;
 }
@@ -725,8 +725,7 @@ void hdlcdrv_unregister(struct net_device *dev)
 
 	BUG_ON(s->magic != HDLCDRV_MAGIC);
 
-	if (s->opened && s->ops->close)
-		s->ops->close(dev);
+	/* unregister_netdev() closes the device if it is still up */
 	unregister_netdev(dev);
 	
 	free_netdev(dev);
-- 
2.53.0



