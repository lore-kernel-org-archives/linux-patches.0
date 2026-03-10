Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC66F2D24B7;
	Tue, 10 Mar 2026 11:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141110; cv=none; b=WSsXtH6vtdcC4EW/R8OtYk7jzhGQFilkGXcv6QQRH+2mntPg1VcM5Y8/v9McM8l/o9aXscRnszSaEEIXSZ8sRkKJS7yQyVJ6h0QPuPCpeR1AyDbEuNsXLn2UbBB1n/L35yR47JUr9zc99/T5Ff+1NEncfhYZE4gd3pTOiUeaNJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141110; c=relaxed/simple;
	bh=oGgJWj3yt+9Zj1LUE7RsII8mFcF/OKgVoj2voLY06Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSjJL84yDXkLpv3BPRhOt1o1pHKXga+VTQ2Y9hCwvFdzvkzYNykw7jOvNcbXn/38e5JoReVK4oA0HmaUmIMow+HGQ8KvmS9k/68vSvqMe7KMl5smaRchO/lNaH0Z7F803FPPGpKTvVpRd8ptRRDAyY2m1Jrma/8T2zLnaJGtoW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pwWtZci3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pwWtZci3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4919C2BC9E;
	Tue, 10 Mar 2026 11:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141110;
	bh=oGgJWj3yt+9Zj1LUE7RsII8mFcF/OKgVoj2voLY06Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwWtZci3Y9siAet+w2s5nJFHBya4sTMNdQ05QeJW+wBZgSoLhcYpgIVyPZqGJqn9R
	 DpTp+LqERYGiqXK52SRVkpwe4Y8sx+OWgnKJy0Sihbndpwf06L2ShQFs33ier5icJv
	 l4z0Pyh+uXxZmrJf12qN+fCbWsTT6gGqzka7hZPLOpyT6s9BnGHjJb+JdSzBiPwL3O
	 w67OAfG0cOzq0KoeTXZe1CBiQ0N7OjEGuAzCZvXadmm2e7WTJN6J8l8C+BlSKwqPly
	 QnzTx7xCk76pKZ406fFgrQv+3aDNDStJiJFB4YJcLcrhhhBQaKxsdQIkG1PrkB5s8W
	 GlEPhJ4zuOD3g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.19 112/311] can: usb: f81604: handle bulk write errors properly
Date: Tue, 10 Mar 2026 07:02:39 -0400
Message-ID: <1d0932be9768d8c58af97a51d40381dcc621f6eb.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 51f94780720fa90c424f67e3e9784cb8ef8190e5 upstream.

If a write urb fails then more needs to be done other than just logging
the message, otherwise the transmission could be stalled.  Properly
increment the error counters and wake up the queues so that data will
continue to flow.

Cc: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026022334-slackness-dynamic-9195@gregkh
Fixes: 88da17436973 ("can: usb: f81604: add Fintek F81604 support")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/f81604.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/f81604.c b/drivers/net/can/usb/f81604.c
index afd216949d03f..ea70ddf325d32 100644
--- a/drivers/net/can/usb/f81604.c
+++ b/drivers/net/can/usb/f81604.c
@@ -891,9 +891,27 @@ static void f81604_write_bulk_callback(struct urb *urb)
 	if (!netif_device_present(netdev))
 		return;
 
-	if (urb->status)
-		netdev_info(netdev, "%s: Tx URB error: %pe\n", __func__,
-			    ERR_PTR(urb->status));
+	if (!urb->status)
+		return;
+
+	switch (urb->status) {
+	case -ENOENT:
+	case -ECONNRESET:
+	case -ESHUTDOWN:
+		return;
+	default:
+		break;
+	}
+
+	if (net_ratelimit())
+		netdev_err(netdev, "%s: Tx URB error: %pe\n", __func__,
+			   ERR_PTR(urb->status));
+
+	can_free_echo_skb(netdev, 0, NULL);
+	netdev->stats.tx_dropped++;
+	netdev->stats.tx_errors++;
+
+	netif_wake_queue(netdev);
 }
 
 static void f81604_clear_reg_work(struct work_struct *work)
-- 
2.51.0

