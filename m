Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A5769DF6;
	Wed, 21 Feb 2024 13:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521507; cv=none; b=iZpkiKhhDRyWpaQLLFzf7YJCJwUvhCrmdGNsHItiV2SP82P4pbhrPDzaW7X0a17Ho2+lCquon187q1VzrMCh0xshgIMtwbNFlj3oa2wbOwZT838VOAR88f1vxvOn50CuxVvojEozWi+7s8SwKOIVC0IqA45axMAy0za9jrOgQwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521507; c=relaxed/simple;
	bh=CzdeiPSY6v1zraU4EQmGK9GV1lKe7odT0FVMezVMPdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAKeko/FvOONzR0fNAFTkY8LfZ4ngqK86QAYUt1sxQpD9+LAIMCzMB0YSYDf1n+ofqbGXN7tEcg/PKeLaBQe7W00psDI2RnYQqglAwR+FZqdwpaNHrWDhWRGAqBBJTc3sjwotTL1mWNQdyi8xjvynAtnrtgtuhrR7W2d2xqId/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dq3Nz5Hz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dq3Nz5Hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8E3C433C7;
	Wed, 21 Feb 2024 13:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521507;
	bh=CzdeiPSY6v1zraU4EQmGK9GV1lKe7odT0FVMezVMPdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dq3Nz5HzdibBaKwBx1JMh2EShGnhX3xZnM3YsYBhD87X2kzocUNwdBEt73oVlFj/n
	 cGxHcT2lkDzSmFA7udigVER3orf4qDs8dkOOV21TJvJJuZ1u0nUqQxlQBYOkHdxPMT
	 gH5+LexKdtn/caud9Bo4JBur36+BRG7AWqnBbU7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 131/202] net: remove unneeded break
Date: Wed, 21 Feb 2024 14:07:12 +0100
Message-ID: <20240221125935.940497818@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Rix <trix@redhat.com>

[ Upstream commit 7ebb9db011088f9bd357791f49cb7012e66f29e2 ]

A break is not needed if it is preceded by a return or goto

Signed-off-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/r/20201019172607.31622-1-trix@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: bbc404d20d1b ("ixgbe: Fix an error handling path in ixgbe_read_iosf_sb_reg_x550()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 1 -
 drivers/net/ethernet/cisco/enic/enic_ethtool.c  | 1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c   | 1 -
 drivers/net/wan/lmc/lmc_proto.c                 | 4 ----
 4 files changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index adac5df0d6b4..26ccaf173ba7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -823,7 +823,6 @@ int aq_nic_set_link_ksettings(struct aq_nic_s *self,
 		default:
 			err = -1;
 			goto err_exit;
-		break;
 		}
 		if (!(self->aq_nic_cfg.aq_hw_caps->link_speed_msk & rate)) {
 			err = -1;
diff --git a/drivers/net/ethernet/cisco/enic/enic_ethtool.c b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
index f42f7a6e1559..abe01562729f 100644
--- a/drivers/net/ethernet/cisco/enic/enic_ethtool.c
+++ b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
@@ -454,7 +454,6 @@ static int enic_grxclsrule(struct enic *enic, struct ethtool_rxnfc *cmd)
 		break;
 	default:
 		return -EINVAL;
-		break;
 	}
 
 	fsp->h_u.tcp_ip4_spec.ip4src = flow_get_u32_src(&n->keys);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c
index de563cfd294d..4b93ba149ec5 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c
@@ -350,7 +350,6 @@ static s32 ixgbe_calc_eeprom_checksum_X540(struct ixgbe_hw *hw)
 		if (ixgbe_read_eerd_generic(hw, pointer, &length)) {
 			hw_dbg(hw, "EEPROM read failed\n");
 			return IXGBE_ERR_EEPROM;
-			break;
 		}
 
 		/* Skip pointer section if length is invalid. */
diff --git a/drivers/net/wan/lmc/lmc_proto.c b/drivers/net/wan/lmc/lmc_proto.c
index f600075e84a2..7ae39a2b6340 100644
--- a/drivers/net/wan/lmc/lmc_proto.c
+++ b/drivers/net/wan/lmc/lmc_proto.c
@@ -103,17 +103,13 @@ __be16 lmc_proto_type(lmc_softc_t *sc, struct sk_buff *skb) /*FOLD00*/
     switch(sc->if_type){
     case LMC_PPP:
 	    return hdlc_type_trans(skb, sc->lmc_device);
-	    break;
     case LMC_NET:
         return htons(ETH_P_802_2);
-        break;
     case LMC_RAW: /* Packet type for skbuff kind of useless */
         return htons(ETH_P_802_2);
-        break;
     default:
         printk(KERN_WARNING "%s: No protocol set for this interface, assuming 802.2 (which is wrong!!)\n", sc->name);
         return htons(ETH_P_802_2);
-        break;
     }
     lmc_trace(sc->lmc_device, "lmc_proto_tye out");
 
-- 
2.43.0



