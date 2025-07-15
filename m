Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F692E6D39;
	Tue, 15 Jul 2025 13:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586664; cv=none; b=o05DdwMniuIryW0hwz4FTxbDkv7U2jQ6+3DmIs/+B6+P2rotdJUogE4iJOEr9/8JeDGenzhoVPwPNivFDeqRnKglreVJgn6IJSNY/0oVabc9Zpt7QIK5LDZv9eaVHKKD3s7+bO/QCQxcp0QxGZBNna8FVSR0FVhjwtaOMav7IA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586664; c=relaxed/simple;
	bh=6WeCW45QCG5zGoDB1A5A07PoQhnbTBGn/B1IkQLaxGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uywBhEIEPJ1B9xqiFgdBq3fsvPDK7Ipx8J2M5SmXKiNKHZ6gK52GZFBfuQWh8ZsqGWYuat75GWFB6ZGki50Df6vsCCq6hKziscEpvKa3AC0icT5w4qI1rR5vCn+H2dLVhnU5lDIxGWFv2uzDWWr3IBwxakSqUButIEnMKig6aRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8bYJ3dv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8bYJ3dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8A7C4CEF7;
	Tue, 15 Jul 2025 13:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586663;
	bh=6WeCW45QCG5zGoDB1A5A07PoQhnbTBGn/B1IkQLaxGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8bYJ3dvVKQrcDrG6JpYD8txy9pgHHcSJLl9qbKEk0tyYDjCoCD8J2LzhZWLSARX8
	 CXcESHaddyy0XTx+nUli26yOjlpIGFAzOROc65I7JYqv791qIbgpnQW1pITUVailvO
	 J+sCtXhcfh3iAjst0MTZQXK5BjZwzybdxnqVs2c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Sean Nyekjaer <sean@geanix.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/148] can: m_can: m_can_handle_lost_msg(): downgrade msg lost in rx message to debug level
Date: Tue, 15 Jul 2025 15:14:20 +0200
Message-ID: <20250715130805.810780460@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Nyekjaer <sean@geanix.com>

[ Upstream commit 58805e9cbc6f6a28f35d90e740956e983a0e036e ]

Downgrade the "msg lost in rx" message to debug level, to prevent
flooding the kernel log with error messages.

Fixes: e0d1f4816f2a ("can: m_can: add Bosch M_CAN controller support")
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20250711-mcan_ratelimit-v3-1-7413e8e21b84@geanix.com
[mkl: enhance commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 26f721664e761..123c87196a368 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -520,7 +520,7 @@ static int m_can_handle_lost_msg(struct net_device *dev)
 	struct sk_buff *skb;
 	struct can_frame *frame;
 
-	netdev_err(dev, "msg lost in rxf0\n");
+	netdev_dbg(dev, "msg lost in rxf0\n");
 
 	stats->rx_errors++;
 	stats->rx_over_errors++;
-- 
2.39.5



