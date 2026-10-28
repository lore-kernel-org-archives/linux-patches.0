Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212763;
	b=W4ndnQWyZNBT/86RAv5m5Z8XRcRF5BU4Pn6l+Sh/LC/UAs28D3qi6ojutUI7kKneJQ3u
	 GohtOJcfsvKCRo+VxIq/lTYLE/a+qZTTCBIuIn2a8ZFcSg3z2NKoU5pF4a/Ml6eddRKCq
	 Q63aV+up73ntpAMgIBUPbtP+Jj1e8M/odT/P3ffsbZxj+bYO5aE3spNfSpRXNCp/OEQgF
	 yEk50CsGCVOObF+uS5gUnmNRt2Bdmj5528iaTR3t/KMa59hkBCVfPwZ/D7oAOPghgxktI
	 Epx052RDrsdsV5I9NJ5aDrsR+KS8uQCwEBt7JijdIQ4VQ5nCoQpAU7AqLSZKJo/YRgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dNENxy8kF/LFCUDyHFGygK6zahjVAGy9e8d2xczEH0E=;
	b=v/HLGQZ/RhZoqyGhqKK0gxjHjE1WQicDwwcCOiS7qr+spn7iNoiPcXA1W81KJfZ9zXWG
	 2zd1BBmGmdXlyPv5rcrCCe18Jn5PsQ58JPl3/m04VJnjKQ44LQUOLrUvTWoGJGbdpClb1
	 6mT4sphpzA7pmheTmOMYudaCNiygVHGBcaIkHEl04Rm1S52S6zr2PFWj83zqCYXjVeod+
	 +tp9I8cppL0qZRNuJn49Usr4BoP+5nuNm9fzp6JG8P0sR0O/7pH1Bf4rqOa5quTiPX62U
	 X9rxcS+N7OiosL6ms0FE5MpxxZlk0nGzug3CfUPeCSZQvm0sU5T+ZzaDCBJSQYf53sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ppvxurHp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9507E606A31C;
	Wed, 28 Oct 2026 18:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ppvxurHp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E421B1F01825;
	Wed, 28 Oct 2026 18:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212763;
	bh=dNENxy8kF/LFCUDyHFGygK6zahjVAGy9e8d2xczEH0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppvxurHp/Zb7WfFeyspyHsUCVMTX7kOg4Ops3yxcL8AwhF3iLfFbBt5oftmKpq6w5
	 kGO5Bkz1E+0fvv9GG8vJ4iULzbK9RJEAszFZe8pR7fMwU51flnhqj63hXkg4Tx+By2
	 L0x5W6hAQUMuqTgGNqXjnbSAN4ZNOuf9yJ5bWzhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e5e28c3e953b2eebb16e@syzkaller.appspotmail.com,
	Alan Stern <stern@rowland.harvard.edu>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0268/1887] USB: serial: fix port tear down use-after-free
Date: Wed, 28 Oct 2026 17:39:24 +0100
Message-ID: <20261028170505.328561443@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 33c920f7c5952dfc42d1b8ea6efe16b1f0bb0c5b upstream.

Some drivers for multiport devices access port driver data from
completion handlers of shared URBs submitted at attach() or first open()
and stopped at disconnect() or last close(), respectively.

A simple NULL check before accessing the driver data makes sure that a
port state container has at least been allocated, but a completion
handler can still race with port tear down.

Reorder the disconnect handling so that ports are not deregistered (and
their driver data freed) until after all ports have been hung up and the
driver disconnect() callback has run so that all I/O has been stopped.

Fixes: 2d93148ab698 ("USB: serial: fix lifetime and locking problems")
Reported-by: syzbot+e5e28c3e953b2eebb16e@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/6a7e6fb9.ec5dc6cc.21cb3f.00c0.GAE@google.com/
Cc: stable@vger.kernel.org	# 2.6.30
Cc: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/usb-serial.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1194,12 +1194,17 @@ static void usb_serial_disconnect(struct
 		usb_serial_port_poison_urbs(port);
 		wake_up_interruptible(&port->port.delta_msr_wait);
 		cancel_work_sync(&port->work);
-		if (device_is_registered(&port->dev))
-			device_del(&port->dev);
 	}
+
 	if (serial->type->disconnect)
 		serial->type->disconnect(serial);
 
+	for (i = 0; i < serial->num_ports; ++i) {
+		port = serial->port[i];
+		if (device_is_registered(&port->dev))
+			device_del(&port->dev);
+	}
+
 	release_sibling(serial, interface);
 
 	/* let the last holder of this object cause it to be cleaned up */


