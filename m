Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98FE241F4
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a166Q6Qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1264BC433C7;
	Mon,  6 Nov 2023 13:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277615;
	bh=YhvHFXyFvcB2X835AZ99RIf0NPjJYtOCTgnF4Me6ByI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a166Q6Qf5+fZLo+WJg0+ZpXFl0Zp/hmnzFLZZXA8BBHAJgfiYpDyJkZrvsRvHQYP9
	 hIoWnKqvbk+gb8TK5TmF0nBuU71PJuFvbbOAyODiRA5jk+7Tqoo6zlBurMz7O1RD54
	 NKM9uvGCpXnDfG3VdlKLZPPnsOPY2cOPiFMZeUVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Menschel <menschel.p@posteo.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH 5.10 78/95] can: isotp: change error format from decimal to symbolic error names
Date: Mon,  6 Nov 2023 14:04:46 +0100
Message-ID: <20231106130307.563786272@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Menschel <menschel.p@posteo.de>

commit 46d8657a6b284e32b6b3bf1a6c93ee507fdd3cdb upstream

This patch changes the format string for errors from decimal %d to
symbolic error names %pe to achieve more comprehensive log messages.

Link: https://lore.kernel.org/r/20210427052150.2308-2-menschel.p@posteo.de
Signed-off-by: Patrick Menschel <menschel.p@posteo.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -228,8 +228,8 @@ static int isotp_send_fc(struct sock *sk
 
 	can_send_ret = can_send(nskb, 1);
 	if (can_send_ret)
-		pr_notice_once("can-isotp: %s: can_send_ret %d\n",
-			       __func__, can_send_ret);
+		pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
+			       __func__, ERR_PTR(can_send_ret));
 
 	dev_put(dev);
 
@@ -814,8 +814,8 @@ isotp_tx_burst:
 
 		can_send_ret = can_send(skb, 1);
 		if (can_send_ret)
-			pr_notice_once("can-isotp: %s: can_send_ret %d\n",
-				       __func__, can_send_ret);
+			pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
+				       __func__, ERR_PTR(can_send_ret));
 
 		if (so->tx.idx >= so->tx.len) {
 			/* we are done */
@@ -976,8 +976,8 @@ static int isotp_sendmsg(struct socket *
 	err = can_send(skb, 1);
 	dev_put(dev);
 	if (err) {
-		pr_notice_once("can-isotp: %s: can_send_ret %d\n",
-			       __func__, err);
+		pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
+			       __func__, ERR_PTR(err));
 
 		/* no transmission -> no timeout monitoring */
 		if (hrtimer_sec)


