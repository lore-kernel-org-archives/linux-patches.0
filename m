Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0D54E4306;
	Wed, 30 Sep 2026 16:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786385; cv=none; b=f5USJMJmZAxwTKjKrp3NNaVOTD1JwMMQ1uRTa1AKlsLTizx6pX4ZPRZTeNCu3tR/Pm0VkvHjSYjPYBmUxylcqKKJrImUj9ly0QIEWUWEy1S8Tncx/q18PfD3Ojuq5DXV0Z98D/VAxznZYKEa7Q6zawRl0WmgYLUU6XCJr9ijVEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786385; c=relaxed/simple;
	bh=XGGOD5Li7Wx7g16N0ghvM+pDT4c8rtxkqfjQkjT/imo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scfNIPgSckY2FBxDi8H0MdbMaYDlz4nEAZfpshNZmFuRfrdKgG1g9nmNU9NcMfn6R6sqBOi8e9W2ez2WjgSKOpgXTSFA6LJbcIJuESoHJJJfCEJ5dPXTNxeD6mF9df24NGUIVDltOBpdzbwv3l82/+J8ZdE+WcTOv2KnWZbiNO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+OPoHAr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+OPoHAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C602B1F000FF;
	Wed, 30 Sep 2026 16:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786384;
	bh=AwkrvAoYC9VlvXX2cv91npifkzBU2KVxEeyVcrFZ2aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+OPoHArO2Yw7pdXmmSnog2w4P2ixiQ/GdLsS8SZQvR1NSBNMViVapV0EP9P4c6wz
	 +51VjyVLlGq7EAbInetmh+tl/Jek5WSoGO6usbr82nlylmqjywAXC9BYueM1STU4sq
	 9dIPWTDBTGHGZksxaYgAs7+Y8tn2XQtsTWKJatro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 844/982] ip6_gre: Call ip6erspan_tunnel_unlink_md() in ip6erspan_changelink().
Date: Wed, 30 Sep 2026 17:26:20 +0200
Message-ID: <20260930152434.878519867@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 86d2fbed0a363..950d5e74b094e 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -2337,7 +2337,7 @@ static int ip6erspan_changelink(struct net_device *dev, struct nlattr *tb[],
 		return PTR_ERR(t);
 
 	ip6erspan_set_version(data, &p);
-	ip6gre_tunnel_unlink_md(ign, t);
+	ip6erspan_tunnel_unlink_md(ign, t);
 	ip6gre_tunnel_unlink(ign, t);
 	ip6erspan_tnl_change(t, &p, !tb[IFLA_MTU]);
 	ip6erspan_tunnel_link_md(ign, t);
-- 
2.53.0



