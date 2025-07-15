Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF4F19D8A7;
	Tue, 15 Jul 2025 13:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587358; cv=none; b=MI2b1PTchgWeVEtHdT6+GS4wZkUKNe7WDJNoQ+NbNrWa5Yfl0go0Pez3f+sM2TMj+sOJfJJSU7I8Rt3D0GKKiJe49c/9eUEmBnNTWoGI+CtHHCN+bnqzpGvBi6Pq1dBykboVZYAfJ9L4XzRv+RQRjiFrDmvZb1VLu9n296JTOQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587358; c=relaxed/simple;
	bh=eCttoadScFc/zdqWkrNSnXHNao3P/mxvWNkDUeHpmXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crtqq9Q2h6k1eoKzKR9Qo0NaTx+EL4eGzDhiMO9IOi27ovK6Lcob0oWN85hAWJ2LYRHS403X0zgKB+ZFIdVFYIHcEGMqOCh9+qnmQVoYS93TUHH8JmAWc64USGQ9351KBioL3GPiOTTpLlYsbFuMEskBNLYOVAi00xRlqyCFziE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6u1iznu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6u1iznu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99BCC4CEE3;
	Tue, 15 Jul 2025 13:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587358;
	bh=eCttoadScFc/zdqWkrNSnXHNao3P/mxvWNkDUeHpmXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6u1iznulICAFhN6sKdRH1RwX1d9Zs1gV00exq/ZlkT6dntdM9+QCZmr55teckAH0
	 LwKzu11NhLsdFwdkbBK2GYuDmu7/3Jj2WabKDhgLD3Bnaqb2VdAQrfnYgsNdkZI3ib
	 bEh9WuRchv4oZrXewd3U8Kvr7gG6hoSMVfpxJPCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Sean Nyekjaer <sean@geanix.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 69/88] can: m_can: m_can_handle_lost_msg(): downgrade msg lost in rx message to debug level
Date: Tue, 15 Jul 2025 15:14:45 +0200
Message-ID: <20250715130757.340105934@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 56b0f49c81164..814f947e7f505 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -577,7 +577,7 @@ static int m_can_handle_lost_msg(struct net_device *dev)
 	struct can_frame *frame;
 	u32 timestamp = 0;
 
-	netdev_err(dev, "msg lost in rxf0\n");
+	netdev_dbg(dev, "msg lost in rxf0\n");
 
 	stats->rx_errors++;
 	stats->rx_over_errors++;
-- 
2.39.5



