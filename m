Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADAD4052B3;
	Wed, 30 Sep 2026 19:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796708; cv=none; b=T5qccRaItqNRL5fkHl/1tgeCFqBZwi2AYPrbh3Xh4UymcEEEwE5dkqT0yzsCPxhPvEKfL4SSA4rXIpBe7It5tRD+fbZpj3LN6QmNirHt//Hz5PgyjApzZGbQ1pqcXMDOvx2hm8TNRM8Z0EdFdDnrzkaynXL3qeLI2PEEhAJwo6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796708; c=relaxed/simple;
	bh=lgu41Qr7/hkY+bnqRlmHqw8GiZQP4IT+ogOAAzIP/VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxKSvO0ihRlcyBo0dUo1fsjhcdYBBSf0Zt+iVE9FgR6nxWsGbZXjpm41jDwByMBg6f5Wr2AI0WAdtA7f3UTAzEGdWggQcFG9Xv7nNXDv7nxlTBx/FWmsM952emQog3ZDr6PKtuPhMyYOrR55EFyXKX8YVHDH1TFGVKMpImjdP1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNq5FnWE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNq5FnWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEB81F00898;
	Wed, 30 Sep 2026 19:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796706;
	bh=Sd2h2nONWFq7CkZSOcLjW25+PvOKtmKBC4nTqKrRK4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SNq5FnWEhfA2OyS0xygHsQ7A8xUkfKHrhoBan1pbYJUYw5hgoGslHv5wKktLbswXB
	 ARGzhjoHpWYyFRfFeG+4O++pG76jytAcxoIDL/391P2Uja+4AFVrXqOnQzyAu6I8U7
	 hqO/4ZyqtLpx+awwxZwN2m3UDhLvlXH2k3u/CSwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1009/1193] ip6_gre: Call ip6erspan_tunnel_unlink_md() in ip6erspan_changelink().
Date: Wed, 30 Sep 2026 17:28:13 +0200
Message-ID: <20260930152456.661257645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 54fd270edc810..06a1657755382 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -2317,7 +2317,7 @@ static int ip6erspan_changelink(struct net_device *dev, struct nlattr *tb[],
 		return PTR_ERR(t);
 
 	ip6erspan_set_version(data, &p);
-	ip6gre_tunnel_unlink_md(ign, t);
+	ip6erspan_tunnel_unlink_md(ign, t);
 	ip6gre_tunnel_unlink(ign, t);
 	ip6erspan_tnl_change(t, &p, !tb[IFLA_MTU]);
 	ip6erspan_tunnel_link_md(ign, t);
-- 
2.53.0



