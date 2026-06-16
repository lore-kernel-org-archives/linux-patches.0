Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C2326B0A9;
	Tue, 16 Jun 2026 15:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623455; cv=none; b=ppt2cBw6KqqsPYgRfzDxJ6Mrs2O/KpMhJYGT074rUL3z8Wf4bAAeLbdOo8Vh4zXvqQxX25j4OskoiKjv286kA50s2pb7AelqgWuF/Z3scsreWoVePXj1SxqoyS2YLE+8CFSZ+Sfu18vQpZJGT6IPwn8NRFJoG6NhA0NntdtpdFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623455; c=relaxed/simple;
	bh=q+kVimrAmrrwoJcs25KgMmgSaJGUFc3lBc33eDLm6Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgJ1GOSA2Un9TKOQMJoaB1fFUH3yEh1ZOVDxUk1tjDxbdRQ6tIVYKIoErHBSUehWMh/7XIH3KcRbZqZumAFzioZNY5odMvHRkmgpIkHOcTjC6XMf+5OiCi2AWHrhFqHqbjiOI35AaQVYjIVvunnPi+xEAnB159VXwMJaZnZfI3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7xq3mTz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7xq3mTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A491F00A3A;
	Tue, 16 Jun 2026 15:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623454;
	bh=1XfJxFAGsj5StyTqXXpThjCQQmsMP4p9P+Q6rLPoJEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7xq3mTzGCk4Q5HMFchwZxDuIh4wD/pY7/grvGZ6Lq53ioGruBlHyC8AhTnJoZnEu
	 d28nafNJ43RtsvDr3fzxpJdlIAvL+GL3Y+SM1HCOZnYp81ZBTiReqF2CgoaJoQlbWT
	 YKzloWngIM5yUglCXUbfpgGHUPokyX2zvihSCSxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 152/378] net: txgbe: initialize PHY interface to 0
Date: Tue, 16 Jun 2026 20:26:23 +0530
Message-ID: <20260616145118.245115286@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 47f848aac4e79bdb197f849fa86e71fff1ad36ef ]

DECLARE_PHY_INTERFACE_MASK() does not guarantee zeroed contents. Add a
new macro DECLARE_PHY_INTERFACE_MASK_ZERO(), make the stack variable to
be zeroed before setting supported interfaces.

Fixes: 57d39faed4c9 ("net: txgbe: improve functions of AML 40G devices")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20260608070842.36504-4-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c  | 4 ++--
 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
index bdac654a236465..8fc32df8e49a44 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
@@ -204,7 +204,7 @@ int txgbe_set_phy_link(struct wx *wx)
 static int txgbe_sfp_to_linkmodes(struct wx *wx, struct txgbe_sff_id *id)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(modes) = { 0, };
-	DECLARE_PHY_INTERFACE_MASK(interfaces);
+	DECLARE_PHY_INTERFACE_MASK_ZERO(interfaces);
 	struct txgbe *txgbe = wx->priv;
 
 	if (id->cable_tech & TXGBE_SFF_DA_PASSIVE_CABLE) {
@@ -271,7 +271,7 @@ static int txgbe_sfp_to_linkmodes(struct wx *wx, struct txgbe_sff_id *id)
 static int txgbe_qsfp_to_linkmodes(struct wx *wx, struct txgbe_sff_id *id)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(modes) = { 0, };
-	DECLARE_PHY_INTERFACE_MASK(interfaces);
+	DECLARE_PHY_INTERFACE_MASK_ZERO(interfaces);
 	struct txgbe *txgbe = wx->priv;
 
 	if (id->transceiver_type & TXGBE_SFF_ETHERNET_40G_CR4) {
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 6b05f32b4a0109..877234e3fdc2b6 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -315,6 +315,9 @@ void txgbe_up(struct wx *wx);
 int txgbe_setup_tc(struct net_device *dev, u8 tc);
 void txgbe_do_reset(struct net_device *netdev);
 
+#define DECLARE_PHY_INTERFACE_MASK_ZERO(name) \
+	unsigned long name[PHY_INTERFACE_MODE_MAX] = { 0, }
+
 #define TXGBE_LINK_SPEED_UNKNOWN        0
 #define TXGBE_LINK_SPEED_10GB_FULL      4
 #define TXGBE_LINK_SPEED_25GB_FULL      0x10
-- 
2.53.0



