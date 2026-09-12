Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E015332610;
	Sat, 12 Sep 2026 11:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212754; cv=none; b=SIjBung1NVGQHkFFmm4uCqwPnb9gj1qvWrJ8UioNOBU0AjMVH6dK7odRWP7u4+sJ9FqivY/PzcCmMeYVFx13Xtr5pm7uO/E/RMfuh1wmfnWlyE9S6rvZIIeyyMkjvuntbhr97TP0Wd1zVeGFoaG0rsJ0vo9nLcFYCQz7m70nPj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212754; c=relaxed/simple;
	bh=Mjudn40rZxN/RJU/vuDCqUNpDA5z8h4r3go/Q+8H0qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzKhQTIjo10h/THHA9flymi+sBxxL75S0n+8iyYb3mLv19803eT4dYOo1a27QoCjqMJMUtavJU62ApvBpssqrddD3PQVpDByCSeWy0JnfNu5OnbF2LxTnv3cPZwEZblZwNQV95BFKQKViYYaZO1B34nkZKbTuRhNK6Cj930spUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmSq2WGJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmSq2WGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9979B1F000FF;
	Sat, 12 Sep 2026 11:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212753;
	bh=AsaesWsCfuuhDhjMLFJokw5pX8e+F5mhRnqPssHMtuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmSq2WGJUc5v2Ko4A0bYEwoMx2DM4xzOo+4ImZAVXgNjR5kt5+Y0b1FXQuNJwExH2
	 akQ9DWlfGSGeiU6ZWI0WYvuDl7zrd5pLqhFArDrkvTZfHLYr+/OlLwBO8pHlgj1msV
	 U6OoXpQfXk7ZoBmfyyY//sWkHyHRILWkxW0HLGv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1500/1518] ipmr: Add __rcu to netns_ipv4.mrt.
Date: Sat, 12 Sep 2026 09:01:09 +0200
Message-ID: <20260912065657.494771628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit a6039776c7994dd0b9a4acce23a3f897d1688cbf ]

kernel test robot reported this Sparse warning:

  $ make C=1 net/ipv4/ipmr.o
  net/ipv4/ipmr.c:312:24: error: incompatible types in comparison expression (different address spaces):
  net/ipv4/ipmr.c:312:24:    struct mr_table [noderef] __rcu *
  net/ipv4/ipmr.c:312:24:    struct mr_table *

Let's add __rcu annotation to netns_ipv4.mrt.

Fixes: b3b6babf4751 ("ipmr: Free mr_table after RCU grace period.")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605030032.glNApko7-lkp@intel.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260502180755.359554-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/ipv4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 62166da045548..fa49a9598bbb0 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -271,7 +271,7 @@ struct netns_ipv4 {
 
 #ifdef CONFIG_IP_MROUTE
 #ifndef CONFIG_IP_MROUTE_MULTIPLE_TABLES
-	struct mr_table		*mrt;
+	struct mr_table __rcu	*mrt;
 #else
 	struct list_head	mr_tables;
 	struct fib_rules_ops	*mr_rules_ops;
-- 
2.53.0



