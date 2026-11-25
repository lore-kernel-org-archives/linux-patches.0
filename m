Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619253;
	b=K9L8SJM5bWSNpyjTd6LzjwNajXIUhGpiiRmYBFs7kxVmnRy+14/I6rnX1kA8svrx/X7w
	 ioKDezoWtaLxE9WE1FaV30cnRTQ6YEGU9EdIRc2kbLrFgzphCTjvztW8J5n3A1cwPq4+G
	 SH0/zlbenxSAI+nUPq8zi/H/SBxDdsFpvO1cq+lS6VyALotu2ft8215xBQ6R1rKt3Aqo4
	 VzAvAKRzon6lPPMoLH0y5r4mobAB6bXSF/wb3Hlf9P3azOCgCS94WEukP3/V/JoW1VMMX
	 QNAiPURndtofIva2wUeeNCUBnKyMDzypIarRQ6YhmkpFPLjUI0b7tEuNfFZSwmV0prA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uwI+SLMLX15dmD7UqWuvsHs6wq36McXlcillFQ9O7fo=;
	b=HvTW7ab89S0rV+spgyOGfnCeqp6ySfq1HnLc+CeKbLyGiSxiChMFjAibrq21XjybnHgh
	 y+pKJUFjQ3j+jArfMLmOATM3MQD/YplkIECOsoNlhc7Dygi5IXh5E8kdNisvWaOFj8hxD
	 DW6qkG5VBymSJp6lT3FcLXJTpCcNPw9hSYLZXAI29DKq01RuqWqgw7XKhf6Ufo8XydYYI
	 HlO9xuYCsQdFdfm2SXiLqxe0xe9tQiSSuS8hZT3CPRUQn/Y0GCSc6ncvdGxlPqF5YZoWA
	 4puo3iB/ihQFZUYZZ6w+Z2uuiHt3YlEHOkxfD7gUGtq/9pqmtNoaSKwmCW8O7R78zcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVXHh5Wr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87007606A31E;
	Wed, 25 Nov 2026 15:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVXHh5Wr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831861F000CF;
	Wed, 25 Nov 2026 15:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619253;
	bh=uwI+SLMLX15dmD7UqWuvsHs6wq36McXlcillFQ9O7fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVXHh5WrRb82Hyu7rX4DCx8Dm/gPsMNqr9niMYZD5UIcw+qzEHGISMeO542smlUjg
	 bkuShZiuf7bw2ptT8/LGMwItHqcG+fyCRH2dtCBL9hPmZrsR/WAk/2VD2U+y+0kcqq
	 XEy1kKUGE4bOA+mQEdVWq7NVd1EVfT4nmUUioHaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Petr Oros <poros@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0537/1005] ice: dpll: set the SyncE divider only for the port driving the output
Date: Wed, 25 Nov 2026 15:31:15 +0100
Message-ID: <20261125143834.325398083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 164721e16b822c3b2f19526ff00deaa7b47fbf46 ]

R10 holds one divider for each recovered clock output, shared by all
ports. ice_ptp_link_change() sets it from the link speed of its own port
even when another port drives the output, and checks the mux only to
decide whether an error is worth reporting. With ports running at
different speeds, a link change on one port leaves the output of another
port with a wrong divider.

Skip the outputs that the port does not drive, and check the mux under
cgu_synce_lock, so that another PF cannot select its port in between.

The check computes the mux value as port % ports_per_phy + 3, while
ice_tspll_cfg_bypass_mux_e825c() and ice_dpll_rclk_update_e825c() use
port + 3. With the skip, a port from ports_per_phy up would never update
the divider, so use port + 3 as they do.

Tested on GNR-D with dual complex E825. With the RCLK pin of one port
connected, five down and up cycles of another port of the same complex
called ice_tspll_cfg_synce_ethdiv_e825c() 20 times without this patch
and never with it. Five cycles of the port driving the output still
called it 10 times. Both ports ran at 25 Gb/s, so the divider value did
not change on this setup.

Fixes: ad1df4f2d591 ("ice: dpll: Support E825-C SyncE and dynamic pin discovery")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Petr Oros <poros@redhat.com>
Link: https://patch.msgid.link/20261110094350.184185-3-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c   | 10 +++++++---
 drivers/net/ethernet/intel/ice/ice_tspll.c |  4 ++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index b15b02c03b933..07c315f3f5a1d 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1347,6 +1347,7 @@ void ice_ptp_link_change(struct ice_pf *pf, bool linkup)
 		int pin, err;
 
 		mutex_lock(&pf->dplls.lock);
+		mutex_lock(&pf->adapter->cgu_synce_lock);
 		for (pin = 0; pin < ICE_SYNCE_CLK_NUM; pin++) {
 			enum ice_synce_clk clk_pin;
 			bool active;
@@ -1365,16 +1366,19 @@ void ice_ptp_link_change(struct ice_pf *pf, bool linkup)
 				break;
 			}
 
-			mutex_lock(&pf->adapter->cgu_synce_lock);
+			/* The divider is shared, set it only for our port */
+			if (!active)
+				continue;
+
 			err = ice_tspll_cfg_synce_ethdiv_e825c(hw, clk_pin);
-			mutex_unlock(&pf->adapter->cgu_synce_lock);
-			if (active && err) {
+			if (err) {
 				dev_err_once(ice_pf_to_dev(pf),
 					     "Failed to configure SyncE ETH divider for pin %d, err %d\n",
 					     pin, err);
 				break;
 			}
 		}
+		mutex_unlock(&pf->adapter->cgu_synce_lock);
 		mutex_unlock(&pf->dplls.lock);
 
 		if (linkup)
diff --git a/drivers/net/ethernet/intel/ice/ice_tspll.c b/drivers/net/ethernet/intel/ice/ice_tspll.c
index 25227690418eb..b4773e9b64dd3 100644
--- a/drivers/net/ethernet/intel/ice/ice_tspll.c
+++ b/drivers/net/ethernet/intel/ice/ice_tspll.c
@@ -634,6 +634,7 @@ int ice_tspll_init(struct ice_hw *hw)
  *
  * Check if given port is selected as recovered clock source for given output.
  *
+ * Context: Called under pf->dplls.lock and adapter->cgu_synce_lock
  * Return:
  * * 0 - success
  * * negative - error
@@ -662,8 +663,7 @@ int ice_tspll_bypass_mux_active_e825c(struct ice_hw *hw, u8 port, bool *active,
 		return -EINVAL;
 	}
 
-	if (active_clk == port % hw->ptp.ports_per_phy +
-			  ICE_CGU_BYPASS_MUX_OFFSET_E825C)
+	if (active_clk == port + ICE_CGU_BYPASS_MUX_OFFSET_E825C)
 		*active = true;
 	else
 		*active = false;
-- 
2.53.0



