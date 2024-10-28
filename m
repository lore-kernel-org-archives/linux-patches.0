Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D2B18DF68;
	Mon, 28 Oct 2024 06:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097280; cv=none; b=EI+VIb6pwTSV9IM33TWBnoFf2fEXOaXM1fZ68taEQ+3+i1ltdfcGpxkJaG0iM6z2w6yTO14FtCtjfbEuXmhIpP9XSQ4avyI3PWjcDJSbJavAsZQvRbtD2SVILc3+CvmsmqQYzgXdn7o+smXny4b7mjEt6XgfaT0gAjpbGAmlC+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097280; c=relaxed/simple;
	bh=Rrymf5zQOUBFty0BEm2djDn3PdL6HOy7GHz+12bCLHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxgRMOSnQkP9LermHfeX3NLwqaX+GegDbPFB91J0Rrsq8nlrAmeCY1SeZFLxg/+L4G38B+zf2Qxxu3DftWWBVUys+Eg4n99x3+AH7OWSFYxV9cCQuUxAY+cWKaZB3WM2/HUL9bnR7nm4YyJ6tFmo7imNdxJ8/aoI0rCj61ur6oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3hDl35f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3hDl35f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C403C4CEC3;
	Mon, 28 Oct 2024 06:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097279;
	bh=Rrymf5zQOUBFty0BEm2djDn3PdL6HOy7GHz+12bCLHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3hDl35fzWZVLzxxfkoMc71WiaRFWb+zMMnch6Eh7GFpQTBY24LlP5p6yJTs8lN5w
	 yYRLxS+ru4Lv4tU46eCa2V0w3dC7rU9m8FF1LXjEoWrVUbJERsxuO2gjwdMvC7AkwH
	 LcWRUHeiEWLgFxD2gsaURQBotE6Ekivdw+498xKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Mathias Nyman <mathias.nyman@intel.com>,
	linux-usb@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/137] xhci: dbgtty: use kfifo from tty_port struct
Date: Mon, 28 Oct 2024 07:24:57 +0100
Message-ID: <20241028062300.412532952@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 866025f0237609532bc8e4af5ef4d7252d3b55b6 ]

There is no need to define one in a custom structure. The tty_port one
is free to use.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: Mathias Nyman <mathias.nyman@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Link: https://lore.kernel.org/r/20240808103549.429349-6-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 30c9ae5ece8e ("xhci: dbc: honor usb transfer size boundaries.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-dbgcap.h |  1 -
 drivers/usb/host/xhci-dbgtty.c | 17 +++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/xhci-dbgcap.h b/drivers/usb/host/xhci-dbgcap.h
index ca04192fdab1d..0d4d60758af97 100644
--- a/drivers/usb/host/xhci-dbgcap.h
+++ b/drivers/usb/host/xhci-dbgcap.h
@@ -108,7 +108,6 @@ struct dbc_port {
 	struct tasklet_struct		push;
 
 	struct list_head		write_pool;
-	struct kfifo			write_fifo;
 
 	bool				registered;
 };
diff --git a/drivers/usb/host/xhci-dbgtty.c b/drivers/usb/host/xhci-dbgtty.c
index 43d3c95eb8ddb..f6e25a1cec115 100644
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -36,7 +36,7 @@ static int dbc_start_tx(struct dbc_port *port)
 
 	while (!list_empty(pool)) {
 		req = list_entry(pool->next, struct dbc_request, list_pool);
-		len = kfifo_out(&port->write_fifo, req->buf, DBC_MAX_PACKET);
+		len = kfifo_out(&port->port.xmit_fifo, req->buf, DBC_MAX_PACKET);
 		if (len == 0)
 			break;
 		do_tty_wake = true;
@@ -204,7 +204,7 @@ static int dbc_tty_write(struct tty_struct *tty,
 
 	spin_lock_irqsave(&port->port_lock, flags);
 	if (count)
-		count = kfifo_in(&port->write_fifo, buf, count);
+		count = kfifo_in(&port->port.xmit_fifo, buf, count);
 	dbc_start_tx(port);
 	spin_unlock_irqrestore(&port->port_lock, flags);
 
@@ -218,7 +218,7 @@ static int dbc_tty_put_char(struct tty_struct *tty, unsigned char ch)
 	int			status;
 
 	spin_lock_irqsave(&port->port_lock, flags);
-	status = kfifo_put(&port->write_fifo, ch);
+	status = kfifo_put(&port->port.xmit_fifo, ch);
 	spin_unlock_irqrestore(&port->port_lock, flags);
 
 	return status;
@@ -241,7 +241,7 @@ static unsigned int dbc_tty_write_room(struct tty_struct *tty)
 	unsigned int		room;
 
 	spin_lock_irqsave(&port->port_lock, flags);
-	room = kfifo_avail(&port->write_fifo);
+	room = kfifo_avail(&port->port.xmit_fifo);
 	spin_unlock_irqrestore(&port->port_lock, flags);
 
 	return room;
@@ -254,7 +254,7 @@ static unsigned int dbc_tty_chars_in_buffer(struct tty_struct *tty)
 	unsigned int		chars;
 
 	spin_lock_irqsave(&port->port_lock, flags);
-	chars = kfifo_len(&port->write_fifo);
+	chars = kfifo_len(&port->port.xmit_fifo);
 	spin_unlock_irqrestore(&port->port_lock, flags);
 
 	return chars;
@@ -412,7 +412,8 @@ static int xhci_dbc_tty_register_device(struct xhci_dbc *dbc)
 		goto err_idr;
 	}
 
-	ret = kfifo_alloc(&port->write_fifo, DBC_WRITE_BUF_SIZE, GFP_KERNEL);
+	ret = kfifo_alloc(&port->port.xmit_fifo, DBC_WRITE_BUF_SIZE,
+			  GFP_KERNEL);
 	if (ret)
 		goto err_exit_port;
 
@@ -441,7 +442,7 @@ static int xhci_dbc_tty_register_device(struct xhci_dbc *dbc)
 	xhci_dbc_free_requests(&port->read_pool);
 	xhci_dbc_free_requests(&port->write_pool);
 err_free_fifo:
-	kfifo_free(&port->write_fifo);
+	kfifo_free(&port->port.xmit_fifo);
 err_exit_port:
 	idr_remove(&dbc_tty_minors, port->minor);
 err_idr:
@@ -466,7 +467,7 @@ static void xhci_dbc_tty_unregister_device(struct xhci_dbc *dbc)
 	idr_remove(&dbc_tty_minors, port->minor);
 	mutex_unlock(&dbc_tty_minors_lock);
 
-	kfifo_free(&port->write_fifo);
+	kfifo_free(&port->port.xmit_fifo);
 	xhci_dbc_free_requests(&port->read_pool);
 	xhci_dbc_free_requests(&port->read_queue);
 	xhci_dbc_free_requests(&port->write_pool);
-- 
2.43.0



