Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A973A2E92AB;
	Tue, 15 Jul 2025 13:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586229; cv=none; b=Mnj7nAhmH4H7PGR89ON/FhPuzLVwUmghpO2ZAwzH0wwmkKU7KtYVXFCpKU1L/uhIlDZUtJAfVRCvsaxWz4Y5Jo7pjxH4TWS2KKIk0qtMhWPohJw9AVugn5h9501IzeRoVDLRZ3B6ZU+GaHg/fAD3obqKm17lA9hVjLbsQjK96eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586229; c=relaxed/simple;
	bh=RNUdTxJ/214lW0lRkX5TsOTmXNwmWvKMXYoUezXPPT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYb95J+NzaHGShuRvo8dhMqgJDvM2SZ8NBSBGwF6u85GJyRqkZtI7dEUo6Ub+5ISXW4RkJzLMz6ia/o7CjSuJOUP8ShKUfZz9d7j44wSygxmGSN4YnpW6+RCovJKqWmFop7fqe1j+X618OL7O4TlZDi8mcGVf42BoI8CrxhP/RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pS3AB3Xh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pS3AB3Xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC02FC4CEE3;
	Tue, 15 Jul 2025 13:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586229;
	bh=RNUdTxJ/214lW0lRkX5TsOTmXNwmWvKMXYoUezXPPT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pS3AB3XhiAW2ZDUVNgTXBUcMLQ8nfFut/M0fmSSlTqimkQy8KpBX7q2i7c9ryoOms
	 4J4auEVOJ6crioY+5gjjVn0Z6O6j6IjtY/L5SifeZQI+jMmnI1WbBfJ5vInII/6yld
	 ts4cOgXbyrL0wvbcqUVZ2aSRjNYEYg50ow8w6Eec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Sean Nyekjaer <sean@geanix.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 63/77] can: m_can: m_can_handle_lost_msg(): downgrade msg lost in rx message to debug level
Date: Tue, 15 Jul 2025 15:14:02 +0200
Message-ID: <20250715130754.257416137@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e8b35661c5389..17b893eb286e7 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -582,7 +582,7 @@ static int m_can_handle_lost_msg(struct net_device *dev)
 	struct can_frame *frame;
 	u32 timestamp = 0;
 
-	netdev_err(dev, "msg lost in rxf0\n");
+	netdev_dbg(dev, "msg lost in rxf0\n");
 
 	stats->rx_errors++;
 	stats->rx_over_errors++;
-- 
2.39.5



