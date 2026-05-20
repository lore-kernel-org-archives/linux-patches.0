Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906FA36A376;
	Wed, 20 May 2026 17:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297686; cv=none; b=mIbrbCKjt1qwgPiWcoX632hvbSzju9WZpoB1t90yb/s3XLPNXjb01P6/H1Ng8fgYg17h/srmbHP5acqeEFQJGLlN6uE2yRTDLIqnQ5tPPN/z8LgabDOx458ocdDMSyIGBFRexhlR8KTUya+PTHJB2317PImL1lUbLmZUvPvYdXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297686; c=relaxed/simple;
	bh=/zRLFd9oYaPH/C5HqvIkLurqLQiqFTIJtdyKIlHfYRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmdmVXT9LaveGa1yKemw0rZyTT18GZcHSZPsauaMByVAaAs+4rrZNWa1IAwtUDJaDihqYKwVS8mnFYwfLd/E7nJdb9/bVnsooP3dQcKjVgGOnXQBOjsOinae0Hb9wyiXM+EcgUwX7ZUs0wshumKLhPXICwi6ki9/kCzdYOtQjxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCsr9TS7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCsr9TS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B307A1F000E9;
	Wed, 20 May 2026 17:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297685;
	bh=Y/WV111Tj5es1hjRinFn/HWzu4esc3F5T5FsSJEb3T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RCsr9TS7/nbAIYE4LdsnJj4qHn7udO55lCFUZCFLh6fXNLweDXLBNLK8JMANZ4Vf8
	 rhyscSRHjPC9dLVtLsrHXUSu8Hggel/NS83e+4e3Jj5JqDAyDA+PF4E3/f/13Lk/OP
	 yMLGEAMqmGPIOwhdmfouey2N5YMHxSWZWZPvcMnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 123/957] net: ethernet: ti-cpsw:: rename soft_reset() function
Date: Wed, 20 May 2026 18:10:06 +0200
Message-ID: <20260520162137.225711662@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 961f3c535608df64553f61d64ca086aa9f371bdd ]

While looking at the glob symbols shared between the cpsw drivers,
I noticed that soft_reset() is the only one that is missing a proper
namespace prefix, and will pollute the kernel namespace, so rename
it to be consistent with the other symbols.

Reviewed-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260402184726.3746487-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: df75bd552a87 ("net: ethernet: ti-cpsw: fix linking built-in code to modules")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw.c      | 2 +-
 drivers/net/ethernet/ti/cpsw_new.c  | 2 +-
 drivers/net/ethernet/ti/cpsw_priv.c | 2 +-
 drivers/net/ethernet/ti/cpsw_priv.h | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index b0e18bdc2c851..aa3531e844e87 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -706,7 +706,7 @@ static void cpsw_init_host_port(struct cpsw_priv *priv)
 	struct cpsw_common *cpsw = priv->cpsw;
 
 	/* soft reset the controller and initialize ale */
-	soft_reset("cpsw", &cpsw->regs->soft_reset);
+	cpsw_soft_reset("cpsw", &cpsw->regs->soft_reset);
 	cpsw_ale_start(cpsw->ale);
 
 	/* switch to vlan aware mode */
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index fd3931d667021..c6cf7a0375e08 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -573,7 +573,7 @@ static void cpsw_init_host_port(struct cpsw_priv *priv)
 	u32 control_reg;
 
 	/* soft reset the controller and initialize ale */
-	soft_reset("cpsw", &cpsw->regs->soft_reset);
+	cpsw_soft_reset("cpsw", &cpsw->regs->soft_reset);
 	cpsw_ale_start(cpsw->ale);
 
 	/* switch to vlan aware mode */
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index bc4fdf17a99ec..c6eb6b785b0b5 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -275,7 +275,7 @@ void cpsw_set_slave_mac(struct cpsw_slave *slave, struct cpsw_priv *priv)
 	slave_write(slave, mac_lo(priv->mac_addr), SA_LO);
 }
 
-void soft_reset(const char *module, void __iomem *reg)
+void cpsw_soft_reset(const char *module, void __iomem *reg)
 {
 	unsigned long timeout = jiffies + HZ;
 
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index acb6181c5c9e1..fddd7a79f4b0f 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -458,7 +458,7 @@ int cpsw_tx_poll(struct napi_struct *napi_tx, int budget);
 int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget);
 int cpsw_rx_poll(struct napi_struct *napi_rx, int budget);
 void cpsw_rx_vlan_encap(struct sk_buff *skb);
-void soft_reset(const char *module, void __iomem *reg);
+void cpsw_soft_reset(const char *module, void __iomem *reg);
 void cpsw_set_slave_mac(struct cpsw_slave *slave, struct cpsw_priv *priv);
 void cpsw_ndo_tx_timeout(struct net_device *ndev, unsigned int txqueue);
 int cpsw_need_resplit(struct cpsw_common *cpsw);
-- 
2.53.0



