Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E9278B4F;
	Wed, 21 Feb 2024 14:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524216; cv=none; b=RSfj47uKfh6f/XB+OXqDo2gsCgqtkmFlOa+a8P8ZE3k33iK5J/mtsYy1EVmi9bQkfVCpc2adIJJ3XwAwoCy3UMgvRMt/wuSHo+bWXtCkbGGvO+pWCYt3eCIhV6DtD/CR5kYuT5bLGTqoUAroFSFnzSMi4DDOJDNoibQ6HjxOQKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524216; c=relaxed/simple;
	bh=yzff06359oea/V9xluvZiaZacOqYkzSNw2O5/K5gb1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHTmJcwpOjhU0w3VWq2QoTlvS+YeL8FdS2yPlup827JxCnYoOXr7pxFt9zwy+ZJAwmjy5hjELCNF/wwOSj+22nmOmJd91X5o4LGHWRYf4282APWEQfrkldH83mHofIoUcI3Hb4LYLRruX+UiP5up7Cg+Y5+34ejLESAHXZzcg2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guzD8C0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guzD8C0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4B8C433C7;
	Wed, 21 Feb 2024 14:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524215;
	bh=yzff06359oea/V9xluvZiaZacOqYkzSNw2O5/K5gb1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guzD8C0ui2XXziJT9G8pJX6egzLv305v3O7tXvX4/ZfSsIRNa99ym9BggYOZw1tz7
	 A/88ICdJnFV0d6zXgTknkZX0GEiFvaoY8dbHv43fM0Ill3NPiSCpA7AEhbKtzAd8XF
	 LCnp87weulo5mg8glhvUhQUoZzAcvPjcvMtVeMQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/379] RDMA/IPoIB: Fix error code return in ipoib_mcast_join
Date: Wed, 21 Feb 2024 14:05:58 +0100
Message-ID: <20240221130000.205139175@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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
index 86e4ed64e4e2..5633809dc61e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -557,6 +557,7 @@ static int ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
 		spin_unlock_irq(&priv->lock);
 		complete(&mcast->done);
 		spin_lock_irq(&priv->lock);
+		return ret;
 	}
 	return 0;
 }
-- 
2.43.0



