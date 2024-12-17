Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0817D1F4735;
	Tue, 17 Dec 2024 17:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455471; cv=none; b=jqBzxN+B37eYIOqoh0aHylX5JMG8EaMuwiAcmgX3NkXWjGGi1ME/NNLRr03nMt0ktZpLrf0EUaxaZ3UBuiv8L9bHKcUhQW+L/rFLUyI/4iddCXLay2ZgDDwi0sbZnpd2z9Od2i8TLbDlH5Zjfas6WNq5aDhE+LmMnl5tsRj9Ie8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455471; c=relaxed/simple;
	bh=Q0L8wEnjz4387efLvtWp/s9uVoYiE4gsUJO5hqTky+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQfGmeYv1yWIqN5rqk/P54IuREY4cfJ0yvFuwgqcebXhu6VeKdHQEVF3Sy0m4vJuhEfxdZmomaT08VTiyASp8N+M8IvxAP43e642/eE4ZqwMDKw5Qita+uQXqHkk1txGKVP7G4qMOO0RXLbLKXHLeZKSxXlIflGnCuy3N1PoZMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrPLLOZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrPLLOZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80567C4CED3;
	Tue, 17 Dec 2024 17:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455470;
	bh=Q0L8wEnjz4387efLvtWp/s9uVoYiE4gsUJO5hqTky+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrPLLOZkHkFJUde91FB52gSZr9JN/NP09z4gHL3Y2k+OJ66rZ6eK4WUgNlJUEGG2Y
	 8WucgGupqXsq8/iWrw915mxup1OXV+GKQkUhMIHWPATTdNNINsmb6HEAfX7bPRg+eu
	 rlqDA9YPKyVaQWcE8RbD6jzHQLUfIES8ia0pTcJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anumula Murali Mohan Reddy <anumula@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/43] cxgb4: use port number to set mac addr
Date: Tue, 17 Dec 2024 18:07:12 +0100
Message-ID: <20241217170521.310938672@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
References: <20241217170520.459491270@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anumula Murali Mohan Reddy <anumula@chelsio.com>

[ Upstream commit 356983f569c1f5991661fc0050aa263792f50616 ]

t4_set_vf_mac_acl() uses pf to set mac addr, but t4vf_get_vf_mac_acl()
uses port number to get mac addr, this leads to error when an attempt
to set MAC address on VF's of PF2 and PF3.
This patch fixes the issue by using port number to set mac address.

Fixes: e0cdac65ba26 ("cxgb4vf: configure ports accessible by the VF")
Signed-off-by: Anumula Murali Mohan Reddy <anumula@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241206062014.49414-1-anumula@chelsio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c      | 5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 2dd486915629..81cf29c80717 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -2086,7 +2086,7 @@ void t4_idma_monitor(struct adapter *adapter,
 		     struct sge_idma_monitor_state *idma,
 		     int hz, int ticks);
 int t4_set_vf_mac_acl(struct adapter *adapter, unsigned int vf,
-		      unsigned int naddr, u8 *addr);
+		      u8 start, unsigned int naddr, u8 *addr);
 void t4_tp_pio_read(struct adapter *adap, u32 *buff, u32 nregs,
 		    u32 start_index, bool sleep_ok);
 void t4_tp_tm_pio_read(struct adapter *adap, u32 *buff, u32 nregs,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 3c28a1c3c1ed..720f2ca7f856 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3249,7 +3249,7 @@ static int cxgb4_mgmt_set_vf_mac(struct net_device *dev, int vf, u8 *mac)
 
 	dev_info(pi->adapter->pdev_dev,
 		 "Setting MAC %pM on VF %d\n", mac, vf);
-	ret = t4_set_vf_mac_acl(adap, vf + 1, 1, mac);
+	ret = t4_set_vf_mac_acl(adap, vf + 1, pi->lport, 1, mac);
 	if (!ret)
 		ether_addr_copy(adap->vfinfo[vf].vf_mac_addr, mac);
 	return ret;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 7e8a8ea6d8f7..51ea81638b31 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -10246,11 +10246,12 @@ int t4_load_cfg(struct adapter *adap, const u8 *cfg_data, unsigned int size)
  *	t4_set_vf_mac - Set MAC address for the specified VF
  *	@adapter: The adapter
  *	@vf: one of the VFs instantiated by the specified PF
+ *	@start: The start port id associated with specified VF
  *	@naddr: the number of MAC addresses
  *	@addr: the MAC address(es) to be set to the specified VF
  */
 int t4_set_vf_mac_acl(struct adapter *adapter, unsigned int vf,
-		      unsigned int naddr, u8 *addr)
+		      u8 start, unsigned int naddr, u8 *addr)
 {
 	struct fw_acl_mac_cmd cmd;
 
@@ -10265,7 +10266,7 @@ int t4_set_vf_mac_acl(struct adapter *adapter, unsigned int vf,
 	cmd.en_to_len16 = cpu_to_be32((unsigned int)FW_LEN16(cmd));
 	cmd.nmac = naddr;
 
-	switch (adapter->pf) {
+	switch (start) {
 	case 3:
 		memcpy(cmd.macaddr3, addr, sizeof(cmd.macaddr3));
 		break;
-- 
2.39.5



