Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046752;
	b=e478jsw7wsUprJVKWfK5oMfI5UvXX7tU2f3vc0kEUt1d5Iu6a8fQNWO+ffQFRt2ogazi
	 nDELWECPlmDuferViYNHGcjkAoOZjAjIWtZhzG/ULgM0eVPOmeo7Y51lTaZalFTM7cwik
	 F6u4dNvguUtK7Q6nTQUSwoxQE+XZs9bkpfn6k5yYvmP4VK82NnkDfndWhGs9Pyin5ux2q
	 FLcrjkRRoR0u8VjE5SKOXGRAYFGA5Wjts+XONxPWvvxqhqQsLbnCDOM9d7f2X4jExIea/
	 lIkIXlz7NTHXvIYZvx3+9D56PlXUtoDcwnc7fddkUenhUqL8ykyvmOwnCx+76ZayFzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b0vojsCoyXSK5ZJQFtKzW5U4/s41USbamxXBx4KN2pY=;
	b=uHWHqB8nvBBny2iO14Re9pRrP2dPzAVp8mC0gsH+QV87HxExwW+7X4IFhDtxdnYPMNPp
	 Mtd479fPvu75wqR1ZJOE2vKNvU8ShS2rQ/ksuXTSv72Ox+1bm+htaRJmPuasb1SSh0Sa4
	 Mso6Jb/jrMcRw7Htf0tYrK/RYcxSsJcUEnTUjaCA5x28HQwUE8M2B5fKV4apSRkwzL1K/
	 z6WaxGhFaTxBlJiLrm8fYy3yofGrCBnJw0BV2PX6I0dguWIfdWcwrxdpizh6WsQfCdFR2
	 IH5RFszLoUQjUfEd/WruYFVFsqdsAesCSmBka+TE8Wgpnuq/ISZXI6wxdgkCCd1u4xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w1xy4zA0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D36606A32C;
	Thu, 19 Nov 2026 00:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w1xy4zA0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD821F000C4;
	Thu, 19 Nov 2026 00:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046752;
	bh=b0vojsCoyXSK5ZJQFtKzW5U4/s41USbamxXBx4KN2pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w1xy4zA0UlLSw078sQHfx2mhEAKspQ5jjFnYplAsTw1N6tOHisoSt5PevEk07y8/Q
	 45TcpMdV9AKiL2RDGdSopy3nkVboZdwCfT+8OrCGoANKGPkqplQa7GlxVgHWokcKIA
	 T8O8ig+oJgJ8bnOYeozBIHkxIDhi10dQxte02Jp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaibhav Nagare <vnagare@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1394/2857] bnxt_en: dont leave an XDP program installed when the open fails
Date: Wed, 18 Nov 2026 15:40:28 +0100
Message-ID: <20261118150251.550019269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaibhav Nagare <vnagare@redhat.com>

[ Upstream commit 78731b46967e3e7102b5cd5062bef185f3404b5c ]

bnxt_xdp_set() stores the new program and drops the reference on the old
one before reopening the NIC.  If bnxt_open_nic() then fails, ndo_bpf()
returns an error with the new program still in bp->xdp_prog.  The caller
treats the error as "nothing was installed" and drops its own reference,
so bp->xdp_prog is left pointing at a freed program and the next XDP
update dereferences it:

  BUG: unable to handle page fault for address: ff78ecc80ddd1038
  RIP: 0010:__bpf_prog_put+0x5/0x80
  Call Trace:
   bnxt_xdp_set+0xad/0x1b0 [bnxt_en]
   dev_xdp_propagate+0x36/0xa0
   bond_xdp_set+0xeb/0x2d0 [bonding]
   dev_xdp_install+0x1b1/0x350
   bpf_xdp_link_update+0xc5/0x1b0
   link_update+0x104/0x1e0
   __sys_bpf+0x662/0xcf0

Seen on a 6.12 based kernel after bnxt_alloc_mem() failed an order-4
allocation on a fragmented host:

  bnxt_en 0000:a0:00.1 ens4f1np1: nic open fail (rc: fffffff4)
  bond1: (slave ens4f1np1): Error -12 calling ndo_bpf

Bonding is not required to hit this; a plain XDP attach on a bnxt
interface takes the same path.

Restore the previous program when an attach or a replace fails, and
recompute the page-mode and XDP TX ring configuration from it.  The
configuration matters because bnxt_init_one_rx_ring() only assigns
rxr->xdp_prog in page mode, and __bnxt_set_rx_skb_mode() derives
dev->max_mtu from the installed program.  Release the old program only
once the change has been committed.

A detach is not undone.  dev_xdp_detach_link() clears the core's record
of the program even when the driver returns an error, so putting the
program back would leave the driver running a program the core has
already dropped.  If the reopen fails during a detach, bnxt_xdp_set()
therefore returns 0 with the device closed; bnxt_open_nic() has already
logged the failure.

Found in a crash dump; the change was not tested on hardware.

Fixes: c6d30e8391b8 ("bnxt_en: Add basic XDP support.")
Cc: stable@vger.kernel.org
Signed-off-by: Vaibhav Nagare <vnagare@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261012072802.2153706-1-vnagare@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ sashal: replaced the bnxt_xdp_apply_cfg() helper with an apply_cfg label to reuse the existing inline configuration ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 25 +++++++++++++++----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 0d787e105b6ae..635f3e46305f6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -390,6 +390,7 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 	struct net_device *dev = bp->dev;
 	int tx_xdp = 0, rc, tc;
 	struct bpf_prog *old;
+	int old_tx_xdp;
 
 	if (prog && !prog->aux->xdp_has_frags &&
 	    bp->dev->mtu > BNXT_MAX_PAGE_MODE_MTU) {
@@ -416,11 +417,12 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 	if (netif_running(dev))
 		bnxt_close_nic(bp, true, false);
 
+	old_tx_xdp = bp->tx_nr_rings_xdp;
 	old = xchg(&bp->xdp_prog, prog);
-	if (old)
-		bpf_prog_put(old);
 
-	if (prog) {
+apply_cfg:
+	tc = netdev_get_num_tc(dev) ? : 1;
+	if (bp->xdp_prog) {
 		bnxt_set_rx_skb_mode(bp, true);
 	} else {
 		bnxt_set_rx_skb_mode(bp, false);
@@ -431,8 +433,21 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 	bnxt_set_tpa_flags(bp);
 	bnxt_set_ring_params(bp);
 
-	if (netif_running(dev))
-		return bnxt_open_nic(bp, true, false);
+	if (rc)
+		return rc;
+
+	if (netif_running(dev)) {
+		rc = bnxt_open_nic(bp, true, false);
+		/* a detach cannot be undone, only an attach */
+		if (rc && prog) {
+			WRITE_ONCE(bp->xdp_prog, old);
+			tx_xdp = old_tx_xdp;
+			goto apply_cfg;
+		}
+	}
+
+	if (old)
+		bpf_prog_put(old);
 
 	return 0;
 }
-- 
2.53.0



