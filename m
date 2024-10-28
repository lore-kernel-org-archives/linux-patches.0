Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FC12AF07;
	Mon, 28 Oct 2024 06:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098194; cv=none; b=VeR2N/lkvQeAjXOezSZpPecE2zsUSdbJyipfDdGL/ONDyUuMEBWGVrtvVr+iXjIwneLhjhoLnU/ikzAa355CSqXYlAyq0/ny8dfd2RyR7qMNyo+RwH6DVbtnHtKH6kI2KiJt/zN08UW0+OIERGV1BP2lp2pdLbGU6u/OnCOq+1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098194; c=relaxed/simple;
	bh=Y7ZjMiapGG1bHLQr8lLVDs0fMGvnyOJfaTOenx17yYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgWa9PfK+9cMq6XP/WNw905QoTnKHPSElObm4xUbjY8UhuZ90WFkHWX2rUlBnxuUGiLGbnhIiJDW9BtgNj+Wf8IA759nR42u7U0CtxpHSGN6+hDigP4d9lswcxQBfRu19+drIiDhHgtqn9dfWP8tVUNCJsLrZsOxEOngCT5UD7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCr6zb//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCr6zb//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439C3C4CEC3;
	Mon, 28 Oct 2024 06:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098193;
	bh=Y7ZjMiapGG1bHLQr8lLVDs0fMGvnyOJfaTOenx17yYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCr6zb//PKexMjVLblWdxr0PbE/Ksseau4MtCb4Vp6QDWoFuMdB1t340Hqznig49b
	 Jx5bh2A2ZhUhLDXYeaJpbhUBtS+mBWYUa+5hIsqlWlUdJgz0jqCVbrquo7os2zBOfq
	 d+VlCDb6ICY8UKufiME/sveq6X5S15nbi2DHQfzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Mathias Nyman <mathias.nyman@intel.com>,
	linux-usb@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 118/261] xhci: dbgtty: remove kfifo_out() wrapper
Date: Mon, 28 Oct 2024 07:24:20 +0100
Message-ID: <20241028062314.987043179@linuxfoundation.org>
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

[ Upstream commit 2b217514436744dd98c4d9fa48d60610f9f67d61 ]

There is no need to check against kfifo_len() before kfifo_out(). Just
ask the latter for data and it tells how much it retrieved. Or returns 0
in case there are no more.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: Mathias Nyman <mathias.nyman@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Link: https://lore.kernel.org/r/20240808103549.429349-5-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 30c9ae5ece8e ("xhci: dbc: honor usb transfer size boundaries.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-dbgtty.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/usb/host/xhci-dbgtty.c b/drivers/usb/host/xhci-dbgtty.c
index b74e98e943932..64ea964949975 100644
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -24,19 +24,6 @@ static inline struct dbc_port *dbc_to_port(struct xhci_dbc *dbc)
 	return dbc->priv;
 }
 
-static unsigned int
-dbc_send_packet(struct dbc_port *port, char *packet, unsigned int size)
-{
-	unsigned int		len;
-
-	len = kfifo_len(&port->write_fifo);
-	if (len < size)
-		size = len;
-	if (size != 0)
-		size = kfifo_out(&port->write_fifo, packet, size);
-	return size;
-}
-
 static int dbc_start_tx(struct dbc_port *port)
 	__releases(&port->port_lock)
 	__acquires(&port->port_lock)
@@ -49,7 +36,7 @@ static int dbc_start_tx(struct dbc_port *port)
 
 	while (!list_empty(pool)) {
 		req = list_entry(pool->next, struct dbc_request, list_pool);
-		len = dbc_send_packet(port, req->buf, DBC_MAX_PACKET);
+		len = kfifo_out(&port->write_fifo, req->buf, DBC_MAX_PACKET);
 		if (len == 0)
 			break;
 		do_tty_wake = true;
-- 
2.43.0



