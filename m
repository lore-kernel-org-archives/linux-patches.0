Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D1F1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A489C433C8;
	Mon, 21 Aug 2023 20:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648340;
	bh=2rnd9LZVN/utajeYp6BjMU60ll1wyBl8NIF2ApHuu80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0wpiYhx5L7m8ioBRQWcpXmI1e9VLD37wVsgv82TyoWfl5Me/f4gQM+pqbTxZEPJG
	 Utkh22v5TUTpFJ9I0vd5mCWOwFGr/vbwc/5zZM7pONJJYlQ8g2aRKcp9P8Dyuwi/Do
	 RZWlPDm78I+0/mYLkvbHv6M/PaxWU3tqrizZAd9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 141/234] xfrm: delete offloaded policy
Date: Mon, 21 Aug 2023 21:41:44 +0200
Message-ID: <20230821194135.062308096@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 982c3aca8bac8ae38acdc940e4f1ecec3bffc623 ]

The policy memory was released but not HW driver data. Add
call to xfrm_dev_policy_delete(), so drivers will have a chance
to release their resources.

Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index f06d6deb58dd4..ad01997c3aa9d 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2345,6 +2345,7 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 					    NETLINK_CB(skb).portid);
 		}
 	} else {
+		xfrm_dev_policy_delete(xp);
 		xfrm_audit_policy_delete(xp, err ? 0 : 1, true);
 
 		if (err != 0)
-- 
2.40.1



