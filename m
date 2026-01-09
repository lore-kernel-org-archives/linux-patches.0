Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E705535B137;
	Fri,  9 Jan 2026 12:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962536; cv=none; b=j1q35XNkBm/61baQxT+Fgj8rpXf//2q2DfKsSL/+BgipPrS3us9wKVf2n1lXv49fgQEdPqX66nZHPGe29sa4eahR8AiGZ06EYmxhweFwPRpeE2E/LrgYhMdlXPy6BOcz7+9j1Khpx0cTnnpuEnmVUnemIy6BRg9+/iWAd3MXTrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962536; c=relaxed/simple;
	bh=MZc8gHxe+Uqg27NfyKvODjsXM3DqbgKj/67vVy2OOqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZOoJYQYmSNRcPkeGmOuAm2blfkSvPseJu0SSw5S30kByBZL3QvPwn6jZGrS1nIUJTelyp7RwvCTPlqBdGXXvbmM7/9N8q2tA0u4ujQ3UclLa3j7nHhfmZiPHDH5fmR69Pt5rqwxGBr0Ci9BOE5HQV22oFE7UVymZwSZLMlNUsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEkCQVoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEkCQVoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E63C4CEF1;
	Fri,  9 Jan 2026 12:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962535;
	bh=MZc8gHxe+Uqg27NfyKvODjsXM3DqbgKj/67vVy2OOqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEkCQVoyJRXdVx53n2R2KnbWKZBMHWswaqGIU2KH0r+lRV4UHRwIQmGpOSkUx3RK9
	 6+m3N9MkMmrOERC6nDj9Ps7VB4gXRr5CF61WouEWj++okI1W0POaw8gEdvcsyJEbig
	 lCWq2H3BTKm470BRUikIjxFrRsh4SrRt9/yZMLa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 400/634] i40e: Refactor argument of i40e_detect_recover_hung()
Date: Fri,  9 Jan 2026 12:41:18 +0100
Message-ID: <20260109112132.580810064@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 7033ada04e33048c8b33294fecbb0d73f3cd1088 ]

Commit 07d44190a389 ("i40e/i40evf: Detect and recover hung queue
scenario") changes i40e_detect_recover_hung() argument type from
i40e_pf* to i40e_vsi* to be shareable by both i40e and i40evf.
Because the i40evf does not exist anymore and the function is
exclusively used by i40e we can revert this change.

Reviewed-by: Michal Schmidt <mschmidt@redhat.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 699428342153 ("i40e: validate ring_len parameter against hardware-specific values")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 10 ++++++----
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |  2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index fb0dd6f33090..f64ef96ed4f7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11304,7 +11304,7 @@ static void i40e_service_task(struct work_struct *work)
 		return;
 
 	if (!test_bit(__I40E_RECOVERY_MODE, pf->state)) {
-		i40e_detect_recover_hung(pf->vsi[pf->lan_vsi]);
+		i40e_detect_recover_hung(pf);
 		i40e_sync_filters_subtask(pf);
 		i40e_reset_subtask(pf);
 		i40e_handle_mdd_event(pf);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 2ede35ba3919..d6fe9e3a8482 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -867,13 +867,15 @@ u32 i40e_get_tx_pending(struct i40e_ring *ring, bool in_sw)
 
 /**
  * i40e_detect_recover_hung - Function to detect and recover hung_queues
- * @vsi:  pointer to vsi struct with tx queues
+ * @pf: pointer to PF struct
  *
- * VSI has netdev and netdev has TX queues. This function is to check each of
- * those TX queues if they are hung, trigger recovery by issuing SW interrupt.
+ * LAN VSI has netdev and netdev has TX queues. This function is to check
+ * each of those TX queues if they are hung, trigger recovery by issuing
+ * SW interrupt.
  **/
-void i40e_detect_recover_hung(struct i40e_vsi *vsi)
+void i40e_detect_recover_hung(struct i40e_pf *pf)
 {
+	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
 	struct i40e_ring *tx_ring = NULL;
 	struct net_device *netdev;
 	unsigned int i;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 6e567d343e03..8188ec7e3ef2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -465,7 +465,7 @@ void i40e_free_rx_resources(struct i40e_ring *rx_ring);
 int i40e_napi_poll(struct napi_struct *napi, int budget);
 void i40e_force_wb(struct i40e_vsi *vsi, struct i40e_q_vector *q_vector);
 u32 i40e_get_tx_pending(struct i40e_ring *ring, bool in_sw);
-void i40e_detect_recover_hung(struct i40e_vsi *vsi);
+void i40e_detect_recover_hung(struct i40e_pf *pf);
 int __i40e_maybe_stop_tx(struct i40e_ring *tx_ring, int size);
 bool __i40e_chk_linearize(struct sk_buff *skb);
 int i40e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
-- 
2.51.0



