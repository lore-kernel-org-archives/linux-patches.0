Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FB63F20FA;
	Wed, 20 May 2026 17:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296426; cv=none; b=T2OftR3/qfTRRxP3NMG+IRaCwAIpXYZXoj4a////ff5iQoJaHnOJbWZrvbaYceVkW4Ek4BkwhVUm37Iet2U90ue1vCXNux51DxxRoQgGuQeWXjwApaZgVvviB1s6iU38A0yV33oV2PgWijHgyz7xYfeP6o8NC2SHntR/nVR4WOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296426; c=relaxed/simple;
	bh=Ygj3DyHFJ1ERohfdExxFpyR0dxWaCFYoHIfnU2xwCKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4fDKZdsQxnbd//vLf/+aEny23eDxy7XV6NnVIpktdhr5tpMxQQRQZMy47VN2IQ15ZrILCmd6Hq7yZ0nszCUDz3it2tXQBiWOAAoofVVoLM8HtDgapIuKOWAW3dmA8LbIdj5KTUJfIQmrm6670MYeEW4/GlydfsXmze8D5yylyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0MWLnNi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0MWLnNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E15C1F000E9;
	Wed, 20 May 2026 17:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296424;
	bh=W12rUfy9ZHXrOXAZnLp7/S9E4CO0gOKmmj+Uy8InAys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p0MWLnNiRhxTIjTA2KEjZJU4RWTQkpflczfvK20N6k/UxMzSi/KLJr5Pu8Pp2DJxh
	 SlMVP2SMU9pZiPAuo6e9fx6NFTncFIUa4jytkMBN3x+keMPmlNZPQLtMPr9z1vEDDW
	 pliINo0p0HvCQ8APPgg9y9tqD9a1L6nRK+ChJbzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zoltan Fodor <zoltan.fodor@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Sunitha Mekala <sunithax.d.mekala@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0795/1146] ice: update PCS latency settings for E825 10G/25Gb modes
Date: Wed, 20 May 2026 18:17:25 +0200
Message-ID: <20260520162206.217763077@linuxfoundation.org>
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

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

[ Upstream commit 05567e4052732d70c7ff9655217b3d14d25f639a ]

Update MAC Rx/Tx offset registers settings (PHY_MAC_[RX|TX]_OFFSET
registers) with the data obtained with the latest research. It applies
to PCS latency settings for the following speeds/modes:
* 10Gb NO-FEC
        - TX latency changed from 71.25 ns to 73 ns
        - RX latency changed from -25.6 ns to -28 ns
* 25Gb NO-FEC
	- TX latency changed from 28.17 ns to 33 ns
        - RX latency changed from -12.45 ns to -12 ns
* 25Gb RS-FEC
        - TX latency changed from 64.5 ns to 69 ns
        - RX latency changed from -3.6 ns to -3 ns

The original data came from simulation and pre-production hardware.
The new data measures the actual delays and as such is more accurate.

Fixes: 7cab44f1c35f ("ice: Introduce ETH56G PHY model for E825C products")
Co-developed-by: Zoltan Fodor <zoltan.fodor@intel.com>
Signed-off-by: Zoltan Fodor <zoltan.fodor@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260416-iwl-net-submission-2026-04-14-v2-2-686c33c9828d@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp_consts.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_consts.h b/drivers/net/ethernet/intel/ice/ice_ptp_consts.h
index 19dddd9b53ddd..4d298c27bfb27 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_consts.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_consts.h
@@ -78,14 +78,14 @@ struct ice_eth56g_mac_reg_cfg eth56g_mac_cfg[NUM_ICE_ETH56G_LNK_SPD] = {
 		.blktime = 0x666, /* 3.2 */
 		.tx_offset = {
 			.serdes = 0x234c, /* 17.6484848 */
-			.no_fec = 0x8e80, /* 71.25 */
+			.no_fec = 0x93d9, /* 73 */
 			.fc = 0xb4a4, /* 90.32 */
 			.sfd = 0x4a4, /* 2.32 */
 			.onestep = 0x4ccd /* 38.4 */
 		},
 		.rx_offset = {
 			.serdes = 0xffffeb27, /* -10.42424 */
-			.no_fec = 0xffffcccd, /* -25.6 */
+			.no_fec = 0xffffc7b6, /* -28 */
 			.fc = 0xfffc557b, /* -469.26 */
 			.sfd = 0x4a4, /* 2.32 */
 			.bs_ds = 0x32 /* 0.0969697 */
@@ -118,17 +118,17 @@ struct ice_eth56g_mac_reg_cfg eth56g_mac_cfg[NUM_ICE_ETH56G_LNK_SPD] = {
 		.mktime = 0x147b, /* 10.24, only if RS-FEC enabled */
 		.tx_offset = {
 			.serdes = 0xe1e, /* 7.0593939 */
-			.no_fec = 0x3857, /* 28.17 */
+			.no_fec = 0x4266, /* 33 */
 			.fc = 0x48c3, /* 36.38 */
-			.rs = 0x8100, /* 64.5 */
+			.rs = 0x8a00, /* 69 */
 			.sfd = 0x1dc, /* 0.93 */
 			.onestep = 0x1eb8 /* 15.36 */
 		},
 		.rx_offset = {
 			.serdes = 0xfffff7a9, /* -4.1697 */
-			.no_fec = 0xffffe71a, /* -12.45 */
+			.no_fec = 0xffffe700, /* -12 */
 			.fc = 0xfffe894d, /* -187.35 */
-			.rs = 0xfffff8cd, /* -3.6 */
+			.rs = 0xfffff8cc, /* -3 */
 			.sfd = 0x1dc, /* 0.93 */
 			.bs_ds = 0x14 /* 0.0387879, RS-FEC 0 */
 		}
-- 
2.53.0



