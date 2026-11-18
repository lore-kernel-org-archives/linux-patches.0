Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056649;
	b=MZiPfa6m/VUGKH+yyLN8WVyZbySKTiG8YNe6erHE0gep6dZHPpeFnjwrgHNNMV/OoG02
	 ezL/HrW9Zvk8+OijXH1jQ2MMGSGUq/rXvEzUgUKZK4LkBKP5GyGPC/qyi+vbyRO/C2TjX
	 dnFGscxnc0LXdNAR8gD4T1MoXJTEAsh1PMfC52s4urLJ6PovjASXZ/H/1O0C2z61sPToO
	 f0hTESGc81V8WoEsd8/gxACDVG07wPbIhVAzT4w5IgsGUPMOKb8+QQRehS1YIGNb7S29P
	 kOVJplZuCge5RsXyw4AuGBZX+5huyJssEi/4WIbo+FvhxQNweNatc8xMmQ+sgtN6tmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=19dmL2ozWNZzbZXe8v26RgavFEhFRWzh5rq4B/6MEcI=;
	b=aaf4+aWSXlPy2ZBUlcCgGzMjZDLHKAtdwAhbCRLoLo3OUwIsn7PwJcc/iEat39lQQ5X2
	 OQa1h3jHH5QC1fLOWI3+3tyrS58ZC3TZRG4B3O2RXyH/FutvM2O2Nyf9mDgInLZGhIKL6
	 i92v45iMpXMofsDa1zFJsHb+10ndCDpclh0o7aMRn3Kc6FWRA8wi3x+12Wc5rMvLeP3up
	 5vQFTBvW7N50DqsBSxFEmTM8iS02RDklU33mWDGqUCQxHNEosUUadGrBbYSOK3hq54tOY
	 w6bQnmT+CzEgvmpZa3Ce9CV3uGDIB5SM4vUjMfMdrg/9b7CtabsjogBO/SEmzZp9TwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PGepKc87;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9659606A31C;
	Thu, 19 Nov 2026 02:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PGepKc87
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5A91F000C4;
	Thu, 19 Nov 2026 02:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056649;
	bh=19dmL2ozWNZzbZXe8v26RgavFEhFRWzh5rq4B/6MEcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGepKc87I9eFQX4uPEKtT+ITpy2rCor0XFt3dsVaztFIWgbsIutud/h0I7ZWUI/1e
	 F3CQXZlKnHt+Qh7IhQ4lIG8O8WCDmfa/Mjz9gUC3YPKWjO34wiS/chwRWuz+oCQ7/G
	 xN75LVQ1b6uPc1yq6syRs5eY+RSHMk5bHDjNebAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2036/2214] RDMA/core: Remove device argument from rdma_build_skb()
Date: Wed, 18 Nov 2026 16:01:52 +0100
Message-ID: <20261118150132.191437181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 05195dcb43504e381bf383e837fc935aac4258cc ]

'device' argument is never used since rdma_build_skb()
is introduced, so remove it.

Link: https://lore.kernel.org/r/20220826143215.18111-1-linyunsheng@huawei.com
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: fdfd099222d9 ("RDMA/core: Reject LAG selection when source MAC lookup fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/lag.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
index fc1dd6b5bf5ef..c18642accfce5 100644
--- a/drivers/infiniband/core/lag.c
+++ b/drivers/infiniband/core/lag.c
@@ -7,8 +7,7 @@
 #include <rdma/ib_cache.h>
 #include <rdma/lag.h>
 
-static struct sk_buff *rdma_build_skb(struct ib_device *device,
-				      struct net_device *netdev,
+static struct sk_buff *rdma_build_skb(struct net_device *netdev,
 				      struct rdma_ah_attr *ah_attr,
 				      gfp_t flags)
 {
@@ -86,7 +85,7 @@ static struct net_device *rdma_get_xmit_slave_udp(struct ib_device *device,
 	struct net_device *slave;
 	struct sk_buff *skb;
 
-	skb = rdma_build_skb(device, master, ah_attr, flags);
+	skb = rdma_build_skb(master, ah_attr, flags);
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.53.0



