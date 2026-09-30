Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4E73812F1;
	Wed, 30 Sep 2026 15:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783868; cv=none; b=oF7bT4VRvd0wX/GNRXewXD0JbHacfzv1xeGRuy5JiRUOrsRmRi0Y0+Pfg8+hmfM3GqisX7NWnaU52KCqdTyDo0lUUjhefK3MhhiD/luKNq3yEXV87PFdeTAVv6tQCowZ7RCyo0T3L7jhbYrXKWaDSqHAYRCoiZVZvv7nh7Us164=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783868; c=relaxed/simple;
	bh=bx0p7+/VUc5YWTl4bhNdGZC0hqldXyJyClcfeiyYIy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+aJJ7zeIsmB0QiEGeegvmBTQf94r/p4CpjR7ULI6yYc4nmY9IfqKDP5TG2PiqRcmtnrgR8WLcaYMtT8CbwPhl/BHcyrcvk6D2UqUFaPVZXo7wODmHP6BtKKBKOVZ0lx2oyXzyZ3Nx5iHJVS5cN+Kfob/dk6Gjrw6rSvVbIpiYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dcl5O5h4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dcl5O5h4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655D61F000FF;
	Wed, 30 Sep 2026 15:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783863;
	bh=8fxNjNI9eobUAbfn66jZS/ASS/xjEVFqJJvi6SW7T8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dcl5O5h439D8mW6IkVnzqbuXf2R7Iv7j80ttoE7VoLEn6YtnrOILoQWtwqUwwoHt0
	 W1OfwENkkGSRnRW/fwJ4rYZCdL17s7DXR9EN/SiDEKXCIRjRkAZyo/d3gkXcmNujYF
	 uuxPhvQLSONE7bgpTL51NTrEan7LdU1xw6Ah53oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 504/595] ip6_gre: Call ip6erspan_tunnel_unlink_md() in ip6erspan_changelink().
Date: Wed, 30 Sep 2026 17:26:37 +0200
Message-ID: <20260930152358.537641004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit dd47bcf279f1083f09bf5266890b26263361022b ]

The cited commit accidentally added ip6gre_tunnel_unlink_md()
in ip6erspan_changelink().

Let's correct it to ip6erspan_tunnel_unlink_md().

Fixes: b80d0b93b991 ("net: ip6_gre: fix tunnel metadata device sharing.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260916230927.378957-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_gre.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index ff4a205ae73fe..0c72115404022 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -2294,7 +2294,7 @@ static int ip6erspan_changelink(struct net_device *dev, struct nlattr *tb[],
 		return PTR_ERR(t);
 
 	ip6erspan_set_version(data, &p);
-	ip6gre_tunnel_unlink_md(ign, t);
+	ip6erspan_tunnel_unlink_md(ign, t);
 	ip6gre_tunnel_unlink(ign, t);
 	ip6erspan_tnl_change(t, &p, !tb[IFLA_MTU]);
 	ip6erspan_tunnel_link_md(ign, t);
-- 
2.53.0



