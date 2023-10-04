Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7C31D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linuxfoundation.org
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B92C433C8;
	Wed,  4 Oct 2023 18:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442772;
	bh=iIHfL1GXp4SKT6H7ZQhsqkODmn+g/fcKdHo5xUXryLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6+MaL5ynk1JSy8RVGRbwAxjeRbBrZdpTApewYdMsxIbLXPxB/4a0uqLTS+KLhoCL
	 udhKQy5Il+2WsCQrHqAFuXfVY/xY6CpI5Hn9Ybcv73rykwrTPAXy0T1E9dn7rLi8D6
	 g8pgj7XgoA/hqYtorJZyTiIFsffYC4+RgVAbS6Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/183] xtensa: iss/network: make functions static
Date: Wed,  4 Oct 2023 19:55:35 +0200
Message-ID: <20231004175208.235261747@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 1b59efeb59851277266318f4e0132aa61ce3455e ]

Make 2 functions static to prevent build warnings:

arch/xtensa/platforms/iss/network.c:204:16: warning: no previous prototype for 'tuntap_protocol' [-Wmissing-prototypes]
  204 | unsigned short tuntap_protocol(struct sk_buff *skb)
arch/xtensa/platforms/iss/network.c:444:6: warning: no previous prototype for 'iss_net_user_timer_expire' [-Wmissing-prototypes]
  444 | void iss_net_user_timer_expire(struct timer_list *unused)

Fixes: 7282bee78798 ("xtensa: Architecture support for Tensilica Xtensa Part 8")
Fixes: d8479a21a98b ("xtensa: Convert timers to use timer_setup()")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Message-Id: <20230920052139.10570-14-rdunlap@infradead.org>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/platforms/iss/network.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/iss/network.c
index 1270de83435eb..e8491ac0d5b93 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -204,7 +204,7 @@ static int tuntap_write(struct iss_net_private *lp, struct sk_buff **skb)
 	return simc_write(lp->tp.info.tuntap.fd, (*skb)->data, (*skb)->len);
 }
 
-unsigned short tuntap_protocol(struct sk_buff *skb)
+static unsigned short tuntap_protocol(struct sk_buff *skb)
 {
 	return eth_type_trans(skb, skb->dev);
 }
@@ -477,7 +477,7 @@ static int iss_net_change_mtu(struct net_device *dev, int new_mtu)
 	return -EINVAL;
 }
 
-void iss_net_user_timer_expire(struct timer_list *unused)
+static void iss_net_user_timer_expire(struct timer_list *unused)
 {
 }
 
-- 
2.40.1



