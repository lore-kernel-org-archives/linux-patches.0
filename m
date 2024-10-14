Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561C9487A7;
	Mon, 14 Oct 2024 15:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918350; cv=none; b=Tjgurx+QMcAFYf5O4H0yBghJPdg3/6H1/e556BTTNbi8WTN7hs3kVqxhKtBHC+kbp2+eOTO4yYRT+6Ve8amCz/J/msjmKl4nqZaTZVu+Sr8L4q7coYtrvKTDP4dsfRbmt+MjJm2W+VN9t6cD2rul/+B8lq7+cBAt6C3b0uilOGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918350; c=relaxed/simple;
	bh=6e9MCUzm+0tALRTyQO7DcKLnkIEOrH7Ovm3tO9teI6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ScwrV2CzptUqMZjbCAxRu1x73i5ZSybmUpjbYY5PihbeOWNmKDAkBAh+a+HW+Rs4BL4FdkdYh7yNKA2qMF57d7mvZd5XYnv0X52LB1FfpHvTr0s8CpeNCgtIdgCc68ILnX0PGh2teK+rF/m2aIw6WgGH+yNKRH4qmzZuBDm/pzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKpN1kLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKpN1kLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683EBC4CEC3;
	Mon, 14 Oct 2024 15:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918349;
	bh=6e9MCUzm+0tALRTyQO7DcKLnkIEOrH7Ovm3tO9teI6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKpN1kLSVJLQ6VORuf7XMmaAkD4o7erBQ+iLhvHMczUmFmqXfCbmpy4qOZYqii5ce
	 HIbJpVo4pDGe5UdSTmoJgeSTEX5cZ+EnM5m0CgmnvS7y+XVnwBb1bHIBGQMGwXb8rX
	 wu9B0qf9AETyehWapC+cZW9kPP8agUCS6XxafWZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 265/798] net: ipv6: select DST_CACHE from IPV6_RPL_LWTUNNEL
Date: Mon, 14 Oct 2024 16:13:39 +0200
Message-ID: <20241014141228.343863625@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 93c21077bb9ba08807c459982d440dbbee4c7af3 ]

The rpl sr tunnel code contains calls to dst_cache_*() which are
only present when the dst cache is built.
Select DST_CACHE to build the dst cache, similar to other kconfig
options in the same file.
Compiling the rpl sr tunnel without DST_CACHE will lead to linker
errors.

Fixes: a7a29f9c361f ("net: ipv6: add rpl sr tunnel")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Simon Horman <horms@kernel.org> # build-tested
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 658bfed1df8b1..71cefa4b866fe 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -323,6 +323,7 @@ config IPV6_RPL_LWTUNNEL
 	bool "IPv6: RPL Source Routing Header support"
 	depends on IPV6
 	select LWTUNNEL
+	select DST_CACHE
 	help
 	  Support for RFC6554 RPL Source Routing Header using the lightweight
 	  tunnels mechanism.
-- 
2.43.0



