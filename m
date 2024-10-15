Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA2F1C07DB;
	Tue, 15 Oct 2024 13:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997612; cv=none; b=FEX1eL79+tUFvwXS42ko4c4WEubmBO11X+0pzPcIAnQgxtIUXpR1Qr8pdhPQbGwHuUyDfnbO5Oi6AzAqeDo31LiNzMbQm2CO/jyggBi5EBR9x5KR1ffZXvidTkXq+8lYrSYFcfjCT9pPTqcty4br3tVk19MqK3IbmAKvLm4TLDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997612; c=relaxed/simple;
	bh=dV3tSXSGNAPSqboE7Ssxt/0+hHzLZuUhJkzPlTwNB5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qB4N96/Q3BZrDewQbgsRquoXaKt5avJ2gZ1vYZIUbyui+keFrgBChLiwLd9bA5/ju7zjkJax67EyTDte2/QUQdhOLVOA5N9K4x2P0dMBjBv69eW1Jxy4sVY8OFWplLpExSAmrYKxygwG7NCqlqhvQ2+Ro44u5wpSzZUb2/e/jKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlihQL9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlihQL9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA30FC4CEC6;
	Tue, 15 Oct 2024 13:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997612;
	bh=dV3tSXSGNAPSqboE7Ssxt/0+hHzLZuUhJkzPlTwNB5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlihQL9c9vc7jUuriUkd/SgAJNgtxKw1+yFWQmir+mj8ccoqTZXaAlHMt2GgI6jR6
	 SBdUb3z4d0Rao+N9D85b8tDHiUs29MmnKlVwMT04A/4q36NF44QaNaHN49E7SxqMBU
	 153D6NJKzePg3gG1NL8J2TLy5CsrQ8GCJRk7qr/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 203/518] net: ipv6: select DST_CACHE from IPV6_RPL_LWTUNNEL
Date: Tue, 15 Oct 2024 14:41:47 +0200
Message-ID: <20241015123924.819612627@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 747f56e0c6368..db430f7c45a25 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -322,6 +322,7 @@ config IPV6_RPL_LWTUNNEL
 	bool "IPv6: RPL Source Routing Header support"
 	depends on IPV6
 	select LWTUNNEL
+	select DST_CACHE
 	help
 	  Support for RFC6554 RPL Source Routing Header using the lightweight
 	  tunnels mechanism.
-- 
2.43.0



