Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCF1197544;
	Thu,  6 Jun 2024 14:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683197; cv=none; b=M4M1Ov/PubMds1LLM71AOqyoMVPQaRdbOTRBZHeLn/PKv6/S4SNI2K7WpzVjuouTGAdhq5eR7XiNJLzyloroaOdtt+XK26Tqg0IRw58pzTrmnd/6mWlTeRlgfaKvzE+7xBylALVh9rgjzA2aDHRfXlTGkyDrqZjBXIckF7k8YY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683197; c=relaxed/simple;
	bh=OJV40AF0yb5RKZi1spPTzw89GAWrfJU/Wj703RvLd1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwYieBasybhSJQxmYPciZ4wyn1EBYtAXKs4qTWhl/rzTtffftfeYj6BUSiw64IcHIyofh3QbPugojVzI7UYhIbLYKMk3nVk3pI8X45t6GMF5++Gw8l63H7weSCGD/Li5PvE2cncfNeUZLchMZmckXNf5bNluY9o+1pSQ9+jqGI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8vo/BqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8vo/BqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E19C32781;
	Thu,  6 Jun 2024 14:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683197;
	bh=OJV40AF0yb5RKZi1spPTzw89GAWrfJU/Wj703RvLd1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8vo/BqCb6zSDPokqdK3m1nONic9dprP9AWW2MpqpDKOrxNELtweOchewjA9ftFwA
	 z10EA4QZszD1lf9LhdXhkwaakJFwHatVgjyuvl/l9ipHiUuMAmHjxaP6IGv8U78MYH
	 W0WDWdgI6wb889ah/v/H/ciVqN4tm6hMUK8hbAN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/744] enetc: avoid truncating error message
Date: Thu,  6 Jun 2024 15:56:52 +0200
Message-ID: <20240606131736.903338446@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9046d581ed586f3c715357638ca12c0e84402002 ]

As clang points out, the error message in enetc_setup_xdp_prog()
still does not fit in the buffer and will be truncated:

drivers/net/ethernet/freescale/enetc/enetc.c:2771:3: error: 'snprintf' will always be truncated; specified size is 80, but format string expands to at least 87 [-Werror,-Wformat-truncation]

Replace it with an even shorter message that should fit.

Fixes: f968c56417f0 ("net: enetc: shorten enetc_setup_xdp_prog() error message to fit NETLINK_MAX_FMTMSG_LEN")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240326223825.4084412-3-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index b92e3aa7cd041..0f5a4ec505ddb 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2769,7 +2769,7 @@ static int enetc_setup_xdp_prog(struct net_device *ndev, struct bpf_prog *prog,
 	if (priv->min_num_stack_tx_queues + num_xdp_tx_queues >
 	    priv->num_tx_rings) {
 		NL_SET_ERR_MSG_FMT_MOD(extack,
-				       "Reserving %d XDP TXQs does not leave a minimum of %d for stack (total %d)",
+				       "Reserving %d XDP TXQs leaves under %d for stack (total %d)",
 				       num_xdp_tx_queues,
 				       priv->min_num_stack_tx_queues,
 				       priv->num_tx_rings);
-- 
2.43.0



