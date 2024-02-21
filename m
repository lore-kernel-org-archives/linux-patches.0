Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7521973161;
	Wed, 21 Feb 2024 13:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522727; cv=none; b=YqAr0QegYhIY7OO0/W3EWBK7JDZa0ImpC6QLEGTSl2tqpPQWqrXB2QqkUYkLrYXRIVo1GGTCzxAOLaqCJF7dI7t+UJMTnbPyYJvtxexIKxYjWYJcWPHeBoOm9GaKuf6pfZ44jtCgMllIvz6YvbN6PPEVVSHdEd/LkMVu0qzAXSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522727; c=relaxed/simple;
	bh=c4MvLX9DdRywYq7B3K+lZL1CywstmINL8hOj8iKBV5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPe72eXa1F739tPsF05mN/YjSD2j2oTtrmmqPF4uq8bPqYRBiORz98HaZoFoNQwDytjhxWJttm6ac0g5iCnvKKCzLEFN/uBueiLUjT7IMunyqY07CodTwTyFfjAiH2FDddldH6DosSanxTRabETFzbRYB5p4bya+fHxiNGkT5Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fxyiq0fN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fxyiq0fN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823F2C433C7;
	Wed, 21 Feb 2024 13:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522727;
	bh=c4MvLX9DdRywYq7B3K+lZL1CywstmINL8hOj8iKBV5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fxyiq0fNacxQ//garFmHZkVDuFyIbMlyPCgT97wRpZZuiU/Rlql8zVaTIy2Tuom+Z
	 Wtjzm3wUX3lCRfHq8gthzQBHoEJhOGGUF9WnLuROcEvRUzO0ZllH/cintsEAzsLfgx
	 AHe0IjUaJVB31gRxctc9fcpt1rWX2XN0R7kgrWCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 212/476] RDMA/IPoIB: Fix error code return in ipoib_mcast_join
Date: Wed, 21 Feb 2024 14:04:23 +0100
Message-ID: <20240221130015.737418681@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



