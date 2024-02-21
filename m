Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694133CF42;
	Wed, 21 Feb 2024 14:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525458; cv=none; b=XMXNtv0X+/E5nr1VJuJMm6A16l+zKgYlNY/jaYNCeMbdzeEFbJziuGU3o6bJOUOcDQVI1yis26ujPVJ9Mh7TeZvEsKWqrzopXKZFudXmSRaoD/IkZHn5r9YVNTxcoiYLaznl+9UuJNWGFswbqkyi3BAxufA6mvzuJ9WD7gpM4Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525458; c=relaxed/simple;
	bh=TmLktg+QEfNXn5S5Igs9Fv5AvkQx8+MVlAKv5ncka2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsRyU0YyOxZyQibEaDz1PQyCZqPFKSFbmQTSb+jYA5yJJBn62eXSNluzvu2biaD7FDqVrikJtgDsjUyMX0gCNqx8tsVQFG3g4mnRbf3+ZzmuAyfwwQyJ1jeJ+LXGpv9zIzd5BK0RwsHjc/hjOwtsBvwCnJj1B3bYCUqr3TmOcbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjazY5em; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjazY5em"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E595C433F1;
	Wed, 21 Feb 2024 14:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525457;
	bh=TmLktg+QEfNXn5S5Igs9Fv5AvkQx8+MVlAKv5ncka2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YjazY5emj6dmv7V4SI1wMNA5TRk3jYEdU3wu7JHtQ06us8eZsIXsgqwrpTCiOcSz1
	 6+F1WdomRz5u0H0WRrrHivV2QU/4My2oVf3gWZ7JIPoIgnKB8koRXqKj82y6Zc4u7D
	 GEWU8wAgKz9FOExyrL4B92dQFdesqzJ61IdxlKF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 160/267] net: remove unneeded break
Date: Wed, 21 Feb 2024 14:08:21 +0100
Message-ID: <20240221125945.102296968@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 145334fb18f4..4eeafd529385 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -903,7 +903,6 @@ int aq_nic_set_link_ksettings(struct aq_nic_s *self,
 		default:
 			err = -1;
 			goto err_exit;
-		break;
 		}
 		if (!(self->aq_nic_cfg.aq_hw_caps->link_speed_msk & rate)) {
 			err = -1;
diff --git a/drivers/net/ethernet/cisco/enic/enic_ethtool.c b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
index ebd5c2cf1efe..e799c686594e 100644
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
index a58301dd0c1f..1c63ae9a3ba8 100644
--- a/drivers/net/wan/lmc/lmc_proto.c
+++ b/drivers/net/wan/lmc/lmc_proto.c
@@ -101,17 +101,13 @@ __be16 lmc_proto_type(lmc_softc_t *sc, struct sk_buff *skb) /*FOLD00*/
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



