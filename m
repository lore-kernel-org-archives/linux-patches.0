Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620554;
	b=i04LKd+Bphp7VVg3XTBYsEnlZZ+Q0Zb8Jdcc79vJgXJeS94PuEnTg0r7EqmTrIevs3c1
	 WuBGPcFadyxOIWt2+vX6hDdMk0mDy0dBdGpkJFvpze1bCSBA7sQHO2JsnAmzzQVmJpod5
	 yzz4+GIhnk6JpzSLsJZuxsy/EDGsuvA7c5TdaXRZK191lYFLq/fECukWAlQZ6Tq7SokLq
	 RWVpLNAazsDl+1kdKX+bU0gSwTI9I6t+BEduURX3vIlE0rhf5uR0U309+MiQAAmomIZf/
	 UNwTKARsNuDoWqAsTE5gVnMHddQ/JNmQw78GCxS7upK5pZkU+MXLyLJbxF0RMV7+dUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l+ryeFzlvNamrx65QQMQJ5n1m7iYC1FUGPfqNO+Umhw=;
	b=xyTAz76n3CjwjrMWENw7d7Nb5SbETcc9mnfYSva4jThvDRmNS+hp/NLp+gnv5+4pLhF+
	 dabqWQRJ5xJRB09MJxVlxHabc+qg0EUCmu5NlVasQrSHyDUifpe6JgBIWprC2nrRnoKJn
	 O49GcxaLxj6dODkQGM0/RrpEfj+JSAiozB5zBNwmWKj4HGb0KENUnqhfsHsEsJy5LRs9/
	 IOjcPOLx0VtFi2QRx+r0aitHXbyz2/fxZkNwiPaC7Pyh4zqAaL7/LrlWUBEo45imDhBLl
	 AQfmrCZQIagJwzPFjT/lxgQ9E8e/T+599BUbZeMrgnGXNd3rgrxOj/MvDLDTaRLNJfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lMWH+ck;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E951606A321;
	Wed, 25 Nov 2026 15:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lMWH+ck
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C1A1F000C6;
	Wed, 25 Nov 2026 15:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620553;
	bh=l+ryeFzlvNamrx65QQMQJ5n1m7iYC1FUGPfqNO+Umhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lMWH+ckCDgSGUQZpDTqhMVhGvuTfiD+VV3mYD0BqlsYkCeiBwMSvzdj2ZYpTxB6r
	 EWFIWICSOKFrvK6LCfl1GEhF9JHA0zA3sn9oAV3qD3Dvt++WXm4NGgzE0Lj57QLqDP
	 /fwjUAo3h8R3CJj4HtUoGOU3RJd2xYkAeKzhwNEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+763813d65c7e18c1b6d5@syzkaller.appspotmail.com,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.3 0956/1005] USB: serial: io_edgeport: fix NULL-deref on early status
Date: Wed, 25 Nov 2026 15:38:14 +0100
Message-ID: <20261125143844.066919126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit ae22e9b6412e5dc99e1cf8bd13c6176d44c7d42e upstream.

The driver submits the interrupt-in URB during probe or on first port
open, which on completion may submit the bulk-in URB before all ports
have been opened and their waitqueues have been initialised.

If a (malicious) device sends a status message for a port that has not
yet been opened this may lead to a NULL-pointer dereference in the
bulk-in completion handler when attempting to wakeup blocked tasks.

Move waitqueue initialisation from open() to port_probe() to address
this.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+763813d65c7e18c1b6d5@syzkaller.appspotmail.com
Link: https://lore.kernel.org/6a8818d8.ae6ddae5.3da009.0031.GAE@google.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -877,11 +877,6 @@ static int edge_open(struct tty_struct *
 		}
 	}
 
-	/* initialize our wait queues */
-	init_waitqueue_head(&edge_port->wait_open);
-	init_waitqueue_head(&edge_port->wait_chase);
-	init_waitqueue_head(&edge_port->wait_command);
-
 	/* initialize our port settings */
 	edge_port->txCredits = 0;	/* Can't send any data yet */
 	/* Must always set this bit to enable ints! */
@@ -2965,6 +2960,11 @@ static int edge_port_probe(struct usb_se
 		return -ENOMEM;
 
 	spin_lock_init(&edge_port->ep_lock);
+
+	init_waitqueue_head(&edge_port->wait_open);
+	init_waitqueue_head(&edge_port->wait_chase);
+	init_waitqueue_head(&edge_port->wait_command);
+
 	edge_port->port = port;
 
 	usb_set_serial_port_data(port, edge_port);


