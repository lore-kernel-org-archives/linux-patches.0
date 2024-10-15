Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46081CFEA9;
	Tue, 15 Oct 2024 11:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993038; cv=none; b=H7nfclgUuh4CgDhQl4Mn689MA0jDDZHhENbyWnLcoIYuKzdbUrfVVG2OrDCILu+xuFiKfxgU9qRIMQZ2dly58OvcML+sN+tYfWaRp4ZDQZy84piBxdlQZmkRjylI7vezQim6MmfDVXcYGj0f9XXqc3oyUN8mvI0ZuLesaQGArmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993038; c=relaxed/simple;
	bh=N1iIBSdZJjGE6ZbIq0UyJ7p66yGoCn0LC4i6zJGZknc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k2ZhMLvXrCrTnM/rN7kLMieAPSeBx/f6OAqT3b3j9fhh/PSVB/OIAbKjY8NtCG3DJ3GcfKtHk00XcC83wKJngduP44OgZY/53EeVncw5lE4EzmN1jdCsZvsmIMh369Vep56Gyt6p91++EhDZK+v0GdH582WNfNvkOxd0VQXWUbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hx62D3CQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hx62D3CQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C34C4CEC6;
	Tue, 15 Oct 2024 11:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993038;
	bh=N1iIBSdZJjGE6ZbIq0UyJ7p66yGoCn0LC4i6zJGZknc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hx62D3CQDUqdAmsZ7kNkvQKTfxiqhHEahIHoklJjIs/E2qaF/kt92RtlwKEiEUvKS
	 kpBTHPM209E232J6ri/C7A7fhxW5Gtqr+LUIWA8IM3ALapACajB1pioAcZ23WVqfV8
	 q0jyoKLHswGpwCI61DbSZWr8/96aIM6Ius98ymlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 293/691] net: ipv6: select DST_CACHE from IPV6_RPL_LWTUNNEL
Date: Tue, 15 Oct 2024 13:24:01 +0200
Message-ID: <20241015112451.974715068@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e504204bca924..a7e79851256b7 100644
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



