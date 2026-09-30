Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930A74DDB23;
	Wed, 30 Sep 2026 16:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787056; cv=none; b=ZPqVeRVAmvbklpma3nq8vpw1CmjOO4AjO3pbShIgqX1sc6ZBGeGVME8LxRmPIOyRPCEDNDD+nQptk3Wi3ZYF/MJ3hcigY8HKJguv8aTtXrh9qaMrbU1LQhzzx+Q/SGKINrZl/4vZmTHKhL6gfuF2zsvnc7pK28IxX73hEtaq+hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787056; c=relaxed/simple;
	bh=vs9vuTmB9NrRxpkVTlXfF7wfHMapUW9vVtft6irJBRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKZaqZGxIEwzB9lUNZdGA0IVIn2qP8dFw/4LiFJVXKeK6Ewm3UY6LItAnuuV8ZvH4c82zDwaYts/OobGAww4m5usWuAjIouJ+R6LbQ/RJuM848RaB1ue4czshfhBGrmLttOExT0d6E/9r2ObTJLQ7zeU5Bf8jPilB6xLvrBkpuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zayQOeEC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zayQOeEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5941F00893;
	Wed, 30 Sep 2026 16:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787055;
	bh=Ro23wCpmSbs4B2Sj9mKxrFGRCpFDsbAexc75suXeVvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zayQOeECWadhdimr2UZGI8ePYsqqmvZtw77BPqAllWey0F9FSRVh19w6zgcFy4AgR
	 1M+ahxBGV8gFIt/5lJHFFBPFRQbg2AQmykBxovDB70nMIfOsjI4PtEUJgD2oa65P4u
	 nnoreWR5bdzAPtdxu5AOARQTzA8PnehFq3T9AlSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 095/457] ip6_gre: Call ip6erspan_tunnel_unlink_md() in ip6erspan_changelink().
Date: Wed, 30 Sep 2026 17:23:20 +0200
Message-ID: <20260930152348.098799874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 678678fcb5da3..e6913a7f68811 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -2280,7 +2280,7 @@ static int ip6erspan_changelink(struct net_device *dev, struct nlattr *tb[],
 		return PTR_ERR(t);
 
 	ip6erspan_set_version(data, &p);
-	ip6gre_tunnel_unlink_md(ign, t);
+	ip6erspan_tunnel_unlink_md(ign, t);
 	ip6gre_tunnel_unlink(ign, t);
 	ip6erspan_tnl_change(t, &p, !tb[IFLA_MTU]);
 	ip6erspan_tunnel_link_md(ign, t);
-- 
2.53.0



