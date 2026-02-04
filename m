Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846A129993F;
	Wed,  4 Feb 2026 15:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218496; cv=none; b=lwdSRjSssUfQ+9rTo39yU1kJL9mDNYtaKajVbMQ3vki1YoNCFeM/w9eoYlJEfvQ9+tsk+YbD+7nZ5HvNYPBZFlRhPBQ1c1AxrUFQeFfbyt3PvZa1ZTrh/fRH8+xqoFYHeGFNqxNOiYoQaPVyYBMnSfdh57PB5JC9ExFpgZ5MKQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218496; c=relaxed/simple;
	bh=SQ0MgUZ7qpIw+9jqWoZL3iTMiqSatIBDAq4T/OZHuhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8D851jHn9S48S4eS10F2E1i1OYzssVSm/dFqc7haow9JBX5SxLPFwTSN4q6BJcKG0VCLmHTArO0f5Jsp7Z10Idauhqty+0qQ9BMAvERlcc0n9V2BjnDq0YtWTffY+JzERZR72/edKx/p7CeckQ69jWA4qfzl4iUKSLVjvAS+ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVp7+Z6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVp7+Z6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82BEC4CEF7;
	Wed,  4 Feb 2026 15:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218496;
	bh=SQ0MgUZ7qpIw+9jqWoZL3iTMiqSatIBDAq4T/OZHuhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVp7+Z6sceoDDMQTCXSGJDVa7uAf0bPyjWk//GViUVyJvYxbU7PiuRKcQ4nDUHoYp
	 3Qel7uhuy2YmrPpEnCeZZE0zd/MQOXc5B7LjpaJ0gO9AG/ZfrNtWXKXrYvKmC/1hws
	 M81OUILuYRAhvX05b7UIuMPzDPNVGuyHDHXsddHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 03/72] can: gs_usb: gs_usb_receive_bulk_callback(): fix error message
Date: Wed,  4 Feb 2026 15:40:06 +0100
Message-ID: <20260204143845.733529164@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 494fc029f662c331e06b7c2031deff3c64200eed ]

Sinc commit 79a6d1bfe114 ("can: gs_usb: gs_usb_receive_bulk_callback():
unanchor URL on usb_submit_urb() error") a failing resubmit URB will print
an info message.

In the case of a short read where netdev has not yet been assigned,
initialize as NULL to avoid dereferencing an undefined value. Also report
the error value of the failed resubmit.

Fixes: 79a6d1bfe114 ("can: gs_usb: gs_usb_receive_bulk_callback(): unanchor URL on usb_submit_urb() error")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/all/20260119181904.1209979-1-kuba@kernel.org/
Link: https://patch.msgid.link/20260120-gs_usb-fix-error-message-v1-1-6be04de572bc@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/gs_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 63439affd59d5..7a3c6493a3536 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -607,7 +607,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 {
 	struct gs_usb *parent = urb->context;
 	struct gs_can *dev;
-	struct net_device *netdev;
+	struct net_device *netdev = NULL;
 	int rc;
 	struct net_device_stats *stats;
 	struct gs_host_frame *hf = urb->transfer_buffer;
@@ -765,7 +765,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 		}
 	} else if (rc != -ESHUTDOWN && net_ratelimit()) {
 		netdev_info(netdev, "failed to re-submit IN URB: %pe\n",
-			    ERR_PTR(urb->status));
+			    ERR_PTR(rc));
 	}
 }
 
-- 
2.51.0



