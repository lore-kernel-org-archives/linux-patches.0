Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C63A3B47FD;
	Mon, 23 Mar 2026 15:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279241; cv=none; b=jXBXZ0f6JHHW29A1gnwmi+jWT8bPfvpQbMy9SVwKp+HfFpYxnPoEBEwIFxR/liEwR1agI3QYAPvELd0tlCTuIwP8lk9Px04k4H1hIjb7GOQtNFdTf9+DM5LZffSTWWaOFTIUFJUrDQJgKM46vIQAuas8NcAES3h8FhH5wGlOM7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279241; c=relaxed/simple;
	bh=5TnAkXn9pudv1YV9+jpudIr1C0QN4A0XnxWvhFhRR2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=limHFcUCSM0edvatXpGGpGQzjPvLTwt9UqKzM7Ugfn19QN8zvwdS2ikqBFK8APdF9zb0jHh9R5C+5vRY3h6Zi/+siHW7s/K2vVuh2pMMpdTXXnmZxoxNSxCcThiEKtrxNVDDOM0imkXwaGT2iAPkzJRUs+VEWRn7PojkgKU4Jt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltVpQtnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltVpQtnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590E2C4CEF7;
	Mon, 23 Mar 2026 15:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279240;
	bh=5TnAkXn9pudv1YV9+jpudIr1C0QN4A0XnxWvhFhRR2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltVpQtnjxbKhY9tw5HX92r+r+dup5KdyUxOegqM9zHcsYYWdPDPDNzLbB+15LujGa
	 yTQ3hTdikVVfDi+JrONiIlXZN12I8wqA9pYwjiz596u6kuHcJ2GcMiTiZriD6t4/4Z
	 Jsliqt9ku5Iv/e5+aZHKQJV4Wl0QiKvBEQCgykAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 522/567] net: bcmgenet: increase WoL poll timeout
Date: Mon, 23 Mar 2026 14:47:22 +0100
Message-ID: <20260323134546.920846536@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 6cfc3bc02b977f2fba5f7268e6504d1931a774f7 ]

Some systems require more than 5ms to get into WoL mode. Increase the
timeout value to 50ms.

Fixes: c51de7f3976b ("net: bcmgenet: add Wake-on-LAN support code")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260312191852.3904571-1-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index 3b082114f2e53..2033fb9d893e0 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -123,7 +123,7 @@ static int bcmgenet_poll_wol_status(struct bcmgenet_priv *priv)
 	while (!(bcmgenet_rbuf_readl(priv, RBUF_STATUS)
 		& RBUF_STATUS_WOL)) {
 		retries++;
-		if (retries > 5) {
+		if (retries > 50) {
 			netdev_crit(dev, "polling wol mode timeout\n");
 			return -ETIMEDOUT;
 		}
-- 
2.51.0



