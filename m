Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C845D19B5B1;
	Wed, 20 May 2026 16:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294734; cv=none; b=CaDTENBXsJYhR5lD4mpLageOJy0t9D56K3puI0uX2uv/FwgUOSbJt+iLhnnn4ca/qgnflU25bBmHLo6bL2HKotfK5amdB4ycs8gxYNOYNwjDFUZIUeJZ3BmcMy39cdJ7E94bJlChFb+dbO67Qmq/MTRUtq2qazyAFUUwhtnPWRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294734; c=relaxed/simple;
	bh=wkWHsuBpFnbpOpDo21Mby9f5P2Y23C+VWOwi3ywqB4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTA3KhKaVR4vDm5W8vzomHIPciHWMZVqHOFl5mgWZKvIWrJ/gxBi1K4hrZLXzjSZg+XzaVau7QSypOZHp00681He6mS+uSpfKsPWKbjiyzY3ncHp//0YmoLYmUZBTdAf7czAqU+5mTfuP11qjiq8mSxgpb2n7QOeEVfAqdt1d6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGBmMCl/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGBmMCl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F66E1F000E9;
	Wed, 20 May 2026 16:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294732;
	bh=Itd0kqJqNjak94/XcmjwZvUBXD3j0TFJqjcbI64ORL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGBmMCl/ZRZQwgLqdAcucHS5TSXvtuNO1As5eR6NsjiWx7BRTZeHlLhTmqq1KFOiG
	 W2aJ2jMJ897sO8dgh/KdVCKCp8X0zP9PWjG58pDpXKHooEJLbNSnwg89XJ6Z9bXnn9
	 o0Bxx1O1tMP8f5Z17KVqmZQxxXsQbM31umCaRN+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0151/1146] net: ethernet: ti-cpsw:: rename soft_reset() function
Date: Wed, 20 May 2026 18:06:41 +0200
Message-ID: <20260520162151.721783484@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 7f42f58a4b031..c5be359f3c663 100644
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



