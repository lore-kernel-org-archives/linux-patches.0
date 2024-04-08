Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC2D69E1C;
	Mon,  8 Apr 2024 14:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585092; cv=none; b=BlaQr9oawnPX3MxPAXyMbu21BsBpA6qaQxD05FmwGbvHCq8UPXrbAY5UUxOMpb8cWodoDvRPmWy9sej8McX9jQmug3/cO8F7aqRz+tdHQSqk3OXpHnreiBE1yZyPFLef2jyCv4Asx4L3piA7RJaL4VHUxhYKXjINzTUJwCef/Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585092; c=relaxed/simple;
	bh=4mi3pb6UfB/wgLOMcZD6eUFfTzJa53RiSiULUHtTvDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwwtfp9RsycMGWyQ7C+N0KGim/TAF5W/lzSxAdjLdLwcpjDB+oBxkEvFftrkFIll9al5k/1mqUG0jm5zSD1yXlPoj9m0VKjVwTJQ1S4MdJdiV2vjdK0NgRNi0HcKnTwAtZZ6cO1vWNPWIzlkIxXohrHAcBAUu0ZKNUGgaR/U/H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKZtfFKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKZtfFKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5C2C433C7;
	Mon,  8 Apr 2024 14:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585092;
	bh=4mi3pb6UfB/wgLOMcZD6eUFfTzJa53RiSiULUHtTvDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKZtfFKR6aT2EK6GOaFAK5hg/J7npJRNUs6vA4nO5geJC1EbuNrDQzwbMx6FKt+Uf
	 vLy86T5Lv34aXUHVP/DKcFpZdXFXNO3xYcKP2/BxijLrH3gERknf0yA0yn8XzIMJ7Z
	 PcECm7xgVTINSWkCeO+6BN9UIBHBXGMUn3LNIQzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 5.15 661/690] i40e: Remove _t suffix from enum type names
Date: Mon,  8 Apr 2024 14:58:47 +0200
Message-ID: <20240408125423.632167100@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit addca9175e5f74cf29e8ad918c38c09b8663b5b8 ]

Enum type names should not be suffixed by '_t'. Either to use
'typedef enum name name_t' to so plain 'name_t var' instead of
'enum name_t var'.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20231113231047.548659-6-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ea558de7238b ("i40e: Enforce software interrupt during busy-poll exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h      | 4 ++--
 drivers/net/ethernet/intel/i40e/i40e_ptp.c  | 6 +++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.h | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 7282dfba4122e..1580f9c2a3209 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -108,7 +108,7 @@
 #define I40E_MAX_BW_INACTIVE_ACCUM	4 /* accumulate 4 credits max */
 
 /* driver state flags */
-enum i40e_state_t {
+enum i40e_state {
 	__I40E_TESTING,
 	__I40E_CONFIG_BUSY,
 	__I40E_CONFIG_DONE,
@@ -156,7 +156,7 @@ enum i40e_state_t {
 	BIT_ULL(__I40E_PF_RESET_AND_REBUILD_REQUESTED)
 
 /* VSI state flags */
-enum i40e_vsi_state_t {
+enum i40e_vsi_state {
 	__I40E_VSI_DOWN,
 	__I40E_VSI_NEEDS_RESTART,
 	__I40E_VSI_SYNCING_FILTERS,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index 09b1d5aed1c9f..38942d3f7819b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -35,7 +35,7 @@ enum i40e_ptp_pin {
 	GPIO_4
 };
 
-enum i40e_can_set_pins_t {
+enum i40e_can_set_pins {
 	CANT_DO_PINS = -1,
 	CAN_SET_PINS,
 	CAN_DO_PINS
@@ -193,7 +193,7 @@ static bool i40e_is_ptp_pin_dev(struct i40e_hw *hw)
  * return CAN_DO_PINS if pins can be manipulated within a NIC or
  * return CANT_DO_PINS otherwise.
  **/
-static enum i40e_can_set_pins_t i40e_can_set_pins(struct i40e_pf *pf)
+static enum i40e_can_set_pins i40e_can_set_pins(struct i40e_pf *pf)
 {
 	if (!i40e_is_ptp_pin_dev(&pf->hw)) {
 		dev_warn(&pf->pdev->dev,
@@ -1089,7 +1089,7 @@ static void i40e_ptp_set_pins_hw(struct i40e_pf *pf)
 static int i40e_ptp_set_pins(struct i40e_pf *pf,
 			     struct i40e_ptp_pins_settings *pins)
 {
-	enum i40e_can_set_pins_t pin_caps = i40e_can_set_pins(pf);
+	enum i40e_can_set_pins pin_caps = i40e_can_set_pins(pf);
 	int i = 0;
 
 	if (pin_caps == CANT_DO_PINS)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index f3b0b81517096..a4f38ab0ecca9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -57,7 +57,7 @@ static inline u16 i40e_intrl_usec_to_reg(int intrl)
  * mentioning ITR_INDX, ITR_NONE cannot be used as an index 'n' into any
  * register but instead is a special value meaning "don't update" ITR0/1/2.
  */
-enum i40e_dyn_idx_t {
+enum i40e_dyn_idx {
 	I40E_IDX_ITR0 = 0,
 	I40E_IDX_ITR1 = 1,
 	I40E_IDX_ITR2 = 2,
@@ -301,7 +301,7 @@ struct i40e_rx_queue_stats {
 	u64 realloc_count;
 };
 
-enum i40e_ring_state_t {
+enum i40e_ring_state {
 	__I40E_TX_FDIR_INIT_DONE,
 	__I40E_TX_XPS_INIT_DONE,
 	__I40E_RING_STATE_NBITS /* must be last */
-- 
2.43.0



