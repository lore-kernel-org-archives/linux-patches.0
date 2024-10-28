Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391D62AF07;
	Mon, 28 Oct 2024 06:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098196; cv=none; b=TYlarwYXIHYsKfnfxJXOfO6VIdvMEeBy6yEbn1Yt867RNzz4qR1piS0j7BVann39J8TUYZLroGdBDDNhNfUCsN3cd/LPYKFD6S5e5kpQ/FxIeQXMYTybNv8d+YdVmCSZ4oEFRANoysghcsA53IlVPQVeeJHYqEYjFa2Q4uDxE4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098196; c=relaxed/simple;
	bh=Ta/+Hu2FWOmQ8ZGM4ZOIE0I7DsixY23DBMfcgvPLEnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnOFKZSHo7NOZtuxrcJ8w9Keq1cFp3cAqZNhbeQGo9f6XwRRewmcQPowJErDDL1+cwJgaNCCkGkXqqsrFDY7cwMIZnlw5/HNDclj2TuPdENbYCOBYpd/tzu7RRx8RXTLguyPg5AI9qUIMg8jaQXX8tH6DBX36XaOB12hGFfEkb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yly2+r5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yly2+r5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF7FC4CEC3;
	Mon, 28 Oct 2024 06:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098195;
	bh=Ta/+Hu2FWOmQ8ZGM4ZOIE0I7DsixY23DBMfcgvPLEnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yly2+r5opLbPIwI+p+MjmDx8wNsm/op9ovify8z5rL0ZrHQhBvux7WyQuHakTaYJg
	 EjtQbN67kH7K+La8cf0IhLq/Fd0wT3joIA4oaCEUpfzCy41HVejBJzWn/6/SF4GL1v
	 ogx1fMnKgBcfS4T9hpyul/ALzD+Dzs+oKIOw6YnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Mathias Nyman <mathias.nyman@intel.com>,
	linux-usb@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 119/261] xhci: dbgtty: use kfifo from tty_port struct
Date: Mon, 28 Oct 2024 07:24:21 +0100
Message-ID: <20241028062315.010907946@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 97c5dc290138b..8ec813b6e9fda 100644
--- a/drivers/usb/host/xhci-dbgcap.h
+++ b/drivers/usb/host/xhci-dbgcap.h
@@ -110,7 +110,6 @@ struct dbc_port {
 	struct tasklet_struct		push;
 
 	struct list_head		write_pool;
-	struct kfifo			write_fifo;
 
 	bool				registered;
 };
diff --git a/drivers/usb/host/xhci-dbgtty.c b/drivers/usb/host/xhci-dbgtty.c
index 64ea964949975..881f5a7e6e0e1 100644
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
@@ -203,7 +203,7 @@ static ssize_t dbc_tty_write(struct tty_struct *tty, const u8 *buf,
 
 	spin_lock_irqsave(&port->port_lock, flags);
 	if (count)
-		count = kfifo_in(&port->write_fifo, buf, count);
+		count = kfifo_in(&port->port.xmit_fifo, buf, count);
 	dbc_start_tx(port);
 	spin_unlock_irqrestore(&port->port_lock, flags);
 
@@ -217,7 +217,7 @@ static int dbc_tty_put_char(struct tty_struct *tty, u8 ch)
 	int			status;
 
 	spin_lock_irqsave(&port->port_lock, flags);
-	status = kfifo_put(&port->write_fifo, ch);
+	status = kfifo_put(&port->port.xmit_fifo, ch);
 	spin_unlock_irqrestore(&port->port_lock, flags);
 
 	return status;
@@ -240,7 +240,7 @@ static unsigned int dbc_tty_write_room(struct tty_struct *tty)
 	unsigned int		room;
 
 	spin_lock_irqsave(&port->port_lock, flags);
-	room = kfifo_avail(&port->write_fifo);
+	room = kfifo_avail(&port->port.xmit_fifo);
 	spin_unlock_irqrestore(&port->port_lock, flags);
 
 	return room;
@@ -253,7 +253,7 @@ static unsigned int dbc_tty_chars_in_buffer(struct tty_struct *tty)
 	unsigned int		chars;
 
 	spin_lock_irqsave(&port->port_lock, flags);
-	chars = kfifo_len(&port->write_fifo);
+	chars = kfifo_len(&port->port.xmit_fifo);
 	spin_unlock_irqrestore(&port->port_lock, flags);
 
 	return chars;
@@ -411,7 +411,8 @@ static int xhci_dbc_tty_register_device(struct xhci_dbc *dbc)
 		goto err_idr;
 	}
 
-	ret = kfifo_alloc(&port->write_fifo, DBC_WRITE_BUF_SIZE, GFP_KERNEL);
+	ret = kfifo_alloc(&port->port.xmit_fifo, DBC_WRITE_BUF_SIZE,
+			  GFP_KERNEL);
 	if (ret)
 		goto err_exit_port;
 
@@ -440,7 +441,7 @@ static int xhci_dbc_tty_register_device(struct xhci_dbc *dbc)
 	xhci_dbc_free_requests(&port->read_pool);
 	xhci_dbc_free_requests(&port->write_pool);
 err_free_fifo:
-	kfifo_free(&port->write_fifo);
+	kfifo_free(&port->port.xmit_fifo);
 err_exit_port:
 	idr_remove(&dbc_tty_minors, port->minor);
 err_idr:
@@ -465,7 +466,7 @@ static void xhci_dbc_tty_unregister_device(struct xhci_dbc *dbc)
 	idr_remove(&dbc_tty_minors, port->minor);
 	mutex_unlock(&dbc_tty_minors_lock);
 
-	kfifo_free(&port->write_fifo);
+	kfifo_free(&port->port.xmit_fifo);
 	xhci_dbc_free_requests(&port->read_pool);
 	xhci_dbc_free_requests(&port->read_queue);
 	xhci_dbc_free_requests(&port->write_pool);
-- 
2.43.0



