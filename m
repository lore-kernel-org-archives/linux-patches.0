Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE1C1D0491;
	Wed,  2 Oct 2024 13:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876545; cv=none; b=ewk0Ynd0Ar6tItwRPTz4v3hMROGiDYRwtk6rtT/sNXlGuTLD/Xg0fz2pqoY7/0COUQXFZFsvJVX4fsEwmxbIQZ2oaW8JWSy30nPyMDlQfm+Pb6FYgXSbJWUBc4VuYDHJ4H55tlUkW6W1FTicED0/7NNihj4InO54T5WAoU+Oy50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876545; c=relaxed/simple;
	bh=ZLsc2fc5Mhlnob2eblS28xpfDM7tpl7rSuYAz522I98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h+URY/QO793NBoSt+UHSIy/2cW0BSWl6JdNM2gAg84zccqB8ONenmOd14aNTx/PI+PGos8eEi9bYCK6mhu1dOFSaU8uynM9KQgsHaKZZbrmD1umraI+44VPTR7v1uO2adBm7b6fGzY82WBZmotOmMVagYdG6aMWHr1GSFeTNo+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRSSAFVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRSSAFVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62972C4CEC5;
	Wed,  2 Oct 2024 13:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876544;
	bh=ZLsc2fc5Mhlnob2eblS28xpfDM7tpl7rSuYAz522I98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRSSAFVKSBf7kqS3249mDpB/2L7ZijfeL+YMKj7p8VkZAq2NosNPP6iPQOpnV8fGQ
	 Zfb9/QmLbsk4iNWZoS2EKmQF1ZCJrxEMG06sUQ5t/1swbJDtiMpWZspj68L1RLTWEq
	 1WikkED/ZX3rwUACPL0RHI742WsS4D90WCBTAfK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 480/695] net: ipv6: select DST_CACHE from IPV6_RPL_LWTUNNEL
Date: Wed,  2 Oct 2024 14:57:58 +0200
Message-ID: <20241002125841.629761768@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 08d4b7132d4c4..1c9c686d9522f 100644
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



