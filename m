Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212758;
	b=4zgrUqAQZ1xv72JFr29OpjDhssfKQm/GAs173cSvbDIkdLUojnJQYtuSV9Gn4LBIxvaU
	 sNHz4ye7gQ9S5XouZIIYRiMquDpg64MwDJRhgoa0Og7QSgVdKHZzYkxS5hTr1xuuSkk+9
	 6R5bkVAphCuvyVomlPJO4i1xIdgPkkRZrDaWoEF+NoB/TKvpS0BLanCd7FPY+m2Timbyy
	 Igefjols8VRNW1DJja/DR8VQxxuP4GvsOgrNmQcDILlVb+R0BiFJAOGdVUe1BrlpcwcaU
	 yTXlA0oA0B/EwniyleYeOD+MbbvKM0WCgrrJgrEuLv5A1AxHHEdU5R4UgMnCTO2apJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3/IDBfzOhFi6Ft7VZX2VNKGQUFmvWTWQHvAeof2CyGg=;
	b=fEC28z8snVHJRjCqAfZiIWkqfRjjNiGR3vo5aLH6A4qpnwfX8qx5sU9/nM2KT1mj+10N
	 nx1Ggx1JoLzXoWXRyivTrmX6STmYfRxAgk2jlGLvPiKyPo/8JhZpiotM327dqLX2zk3dJ
	 OclEij/8m9uyaZYNsFxenbXUSqv1lYRGKfbdQ+SbUOTejeuAO29pRnLeaVrPxwv9eqADR
	 QOkvYZvNBHTO03gSKYfFQc80iI9EvGWwDKs9kp2R+qxAZhJN1dvS5N6aw7sU2+Uy9JgQK
	 SsgO1EK8/J5S2V2CVIcNT/TZvsAc5YqcnEAhOFUAy2fAfrXmlp7MHwgywk6l9sV0khg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TEdNI4SM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA76606A31A;
	Wed, 28 Oct 2026 18:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TEdNI4SM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C981F01828;
	Wed, 28 Oct 2026 18:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212757;
	bh=3/IDBfzOhFi6Ft7VZX2VNKGQUFmvWTWQHvAeof2CyGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TEdNI4SMyz0InZEhLsAOoCFekqUz6pqy4HNGdVpfJcNLfewKvciN02T5lh/nMoCJY
	 1mOwoFrpTLFViya2jyXre31etq2OziGN8d8COnXepP7yLAAM401yOWAd0x1MUH3c1K
	 z7m/ttP1PIvL6h1akOwZd7xcQ0o0qxVDfwWJhm6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: [PATCH 6.1 0267/1887] USB: cdc-acm: skip URB restart in port_shutdown if disconnected
Date: Wed, 28 Oct 2026 17:39:23 +0100
Message-ID: <20261028170505.305656815@linuxfoundation.org>
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

From: Yuchao Zhang <ndaugoing@gmail.com>

commit dc614d6bc991740d41d5a99ac7765c4b675dda88 upstream.

acm_port_shutdown() is called from the tty-port machinery whenever the
last user closes the port.  acm_disconnect() sets acm->disconnected and
calls tty_port_tty_vhangup(), which eventually triggers port_shutdown().
At that point acm_disconnect() has already called acm_poison_urbs() and
is about to free the control and read URBs.

However, acm_port_shutdown() unconditionally calls acm_unpoison_urbs()
and, when the ALWAYS_POLL_CTRL quirk is set, immediately re-submits the
ctrlurb and all read URBs.  If the concurrent acm_disconnect() then
frees those URBs and their DMA buffers while they are in-flight, the
result is a use-after-free in acm_ctrl_irq() or acm_read_bulk_callback()
accessing the freed DMA memory.

Fix by checking acm->disconnected after draining the delayed anchor and
returning early: if we are in a disconnect path the URBs must remain
poisoned and must not be resubmitted.

The early return is placed after the delayed-anchor drain loop because
that loop only cancels write-side accounting (wb->use = false and
autopm counter) and does not touch the hardware path.

Fixes: f58752ebcb35 ("USB: cdc-acm: Add quirks for Yoga Book 9 14IAH10 INGENIC touchscreen")
Cc: stable <stable@kernel.org>
Signed-off-by: Yuchao Zhang <ndaugoing@gmail.com>
Link: https://patch.msgid.link/20260918114309.3659635-2-ndaugoing@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -776,6 +776,9 @@ static void acm_port_shutdown(struct tty
 		usb_autopm_put_interface_async(acm->control);
 	}
 
+	if (acm->disconnected)
+		return;
+
 	acm_unpoison_urbs(acm);
 
 	if (acm->quirks & ALWAYS_POLL_CTRL) {


