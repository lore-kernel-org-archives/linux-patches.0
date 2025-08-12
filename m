Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5322626FA77;
	Tue, 12 Aug 2025 19:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025980; cv=none; b=ICjm1U5nkFBvVqxcjzxz4rfmN3SwgMgauAjn+2maI1am1JYeOFC+fj/+d03Gb1ebZp5KywJKzZw05B4tzgfkoHTykpeUe9PQ62MGXlfmNWkfk0Hb+53BXGo4VnzaWQVElgEkZ0hZq36DqxybGtt2xq6BloDKJFgZkrza3J6MLsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025980; c=relaxed/simple;
	bh=Pq+idyaO4u7Nwl5ngUMg9aY/UEjGYvBkSM48288UalM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4/ku55b8BN7dDtDruLk3NURaassmCAFEFuD1ut0NhY1EmRf4+RkHhwyoFUjadaxii+LgCEYo8U9fJcfGC0JKxkRzEoTyQB3N4sJY5ag6MAl7GF6PEz1HiGGI8WCAhmH+u57uhSM0hjuP+lA/meL3WuQyoy9JHYTcN6cKqvQUho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dW1rHaxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dW1rHaxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE513C4CEF6;
	Tue, 12 Aug 2025 19:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025980;
	bh=Pq+idyaO4u7Nwl5ngUMg9aY/UEjGYvBkSM48288UalM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dW1rHaxUTFJfUVfUBqxne4i8aGh7YlTLvOyE5Zz5V4a0vrRE45h/1TLhG5OGwsP5z
	 0uotvYZ+l90Z1S9NAnVfVBXDzXw20lCSRdUKeOwv8JXDMtxAY1/b6UUYuVBQwyaTUG
	 upePePsRgU4Kf2lPSl+bFStg0PZYFJinLPy40gpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 202/480] can: kvaser_pciefd: Store device channel index
Date: Tue, 12 Aug 2025 19:46:50 +0200
Message-ID: <20250812174405.810279965@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit d54b16b40ddadb7d0a77fff48af7b319a0cd6aae ]

Store device channel index in netdev.dev_port.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://patch.msgid.link/20250725123230.8-6-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/kvaser_pciefd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 0071a51ce2c1..879b3ea6e9b0 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -981,6 +981,7 @@ static int kvaser_pciefd_setup_can_ctrls(struct kvaser_pciefd *pcie)
 		can->completed_tx_bytes = 0;
 		can->bec.txerr = 0;
 		can->bec.rxerr = 0;
+		can->can.dev->dev_port = i;
 
 		init_completion(&can->start_comp);
 		init_completion(&can->flush_comp);
-- 
2.39.5



