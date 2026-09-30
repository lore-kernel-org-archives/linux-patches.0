Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C934FDA47;
	Wed, 30 Sep 2026 17:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789106; cv=none; b=jBz9RTxiQjXp6WjV0BL8L/1yQoIcVPmduP2Rw3Eo5sVQN9/gSVAJodQnWHpfmPWoHKKuLEft1UmQvmQ9rwhkjg4UHojLYw55yR8US3kIMkfZTpoXurKDiuXIyvwgmv7drm19FSkCeKoVgrCG8hCnnTvz7f9LRc4cuSTVCVnB/rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789106; c=relaxed/simple;
	bh=KLRbjItU/DzpeWVHj3LkpovJqd9y3X4d4I3fvpxaVpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lf2v0ix4QUJ1Gv/HhFp7rhpEAYrhW7lE0eyuTO+1jrx5fD6qUIW+1HATQBQ7hD4qp9SrkMclaKAXlByePKhQLdY495L+RdtX4bhm74U6rHmRcoY9F96XBKkrQLyZ0xHyq755bXo2cdzEvOHaw179kSvo+7LKsaoFt/JIXZat30w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxGS0ylr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxGS0ylr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D1B1F000FF;
	Wed, 30 Sep 2026 17:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789104;
	bh=/9xnQvAPvEAdYMhQcbWonBlX2F5dFJpgrLuiG6+ZUpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxGS0ylrRDDN/2GB7CkwDIF6m0MDuL8Oqr/8CDf0tg2deySPQYfm2UvGTCttUFIu+
	 g5xO6F53uSc57evEvwwGCaydwaI1luGLYJyXRMYwgru4X5BzZqUpLG8T82rEEMeEx9
	 CYIM1h3G4JwDR3QXGLVHAz70uUAnaX96GfjMkGqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 361/877] ip6_gre: Call ip6erspan_tunnel_unlink_md() in ip6erspan_changelink().
Date: Wed, 30 Sep 2026 17:21:12 +0200
Message-ID: <20260930152422.467440815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4b0c166fe7e24..ce1ba9d2af405 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -2314,7 +2314,7 @@ static int ip6erspan_changelink(struct net_device *dev, struct nlattr *tb[],
 		return PTR_ERR(t);
 
 	ip6erspan_set_version(data, &p);
-	ip6gre_tunnel_unlink_md(ign, t);
+	ip6erspan_tunnel_unlink_md(ign, t);
 	ip6gre_tunnel_unlink(ign, t);
 	ip6erspan_tnl_change(t, &p, !tb[IFLA_MTU]);
 	ip6erspan_tunnel_link_md(ign, t);
-- 
2.53.0



