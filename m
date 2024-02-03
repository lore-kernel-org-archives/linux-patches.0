Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6389916423;
	Sat,  3 Feb 2024 04:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933847; cv=none; b=rPoyUzoFWWacoUAyJJc6iiz0iXw/SZlE1a5tTIg6VbYKP2pgIdPW5pw31BcjBO3/5jbwxI2lcE/663MGCxZFT7iaya/lgTDD6K/0lmIIBg9Z/Sy0L4GM7NlqQe5Lg252Oh/z9jXDExRcvULyL3++O05yJ8/Q1F49eSCuqfrJatE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933847; c=relaxed/simple;
	bh=kQCN8NYZbqlbcRaja53WKD7a+uU3Z9LjtrI3BB+sN/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBuQtzV8lbzqVPB96wUE6qTQqlWU3hdZAMC+kxt3fVEFpnF8Ld1qEdf2JMf8Mfs3NYXRhEjWD8+CA0W84MJvBDSrhhGAXgjb++gYC7S9O+9upOr5msBw8CRmrwAsMt1deJZpfYLXGVvu9W53Ss2Uhg7wOnVoXVz96CITCRkQf4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGIP0VWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGIP0VWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD03C433F1;
	Sat,  3 Feb 2024 04:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933847;
	bh=kQCN8NYZbqlbcRaja53WKD7a+uU3Z9LjtrI3BB+sN/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGIP0VWEl02GGM2fGXdcvdEq3ijdTkVH+8keOif3w/DyDtnixmV+gQSZtrQhmS0+d
	 Mz68xiqPT99xKFOD6w4x60btPmiGsMsPXHq0TsMFlhx+MOvFSoZqvk268HGJIjCgZc
	 YaQRtalfdlNohdQi1WMRPWffdKAv0TDYPvaafC0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 168/353] RDMA/IPoIB: Fix error code return in ipoib_mcast_join
Date: Fri,  2 Feb 2024 20:04:46 -0800
Message-ID: <20240203035408.955966821@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 753fff78f430704548f45eda52d6d55371a52c0f ]

Return the error code in case of ib_sa_join_multicast fail.

Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Link: https://lore.kernel.org/r/20231121130316.126364-2-jinpu.wang@ionos.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 5b3154503bf4..9e6967a40042 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -546,6 +546,7 @@ static int ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
 		spin_unlock_irq(&priv->lock);
 		complete(&mcast->done);
 		spin_lock_irq(&priv->lock);
+		return ret;
 	}
 	return 0;
 }
-- 
2.43.0



