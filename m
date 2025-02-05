Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280781DAC81;
	Wed,  5 Feb 2025 15:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768253; cv=none; b=QeTmsI5FTUcg22FQlcAk6Szs9Tq5OYky4cVlDsk6KuUsugcLPd+GODiYZMsdeaeqH5i+nD6wjqI6TkeWBoc24m7nF/rfwZ6nAkwive+WLxUPayr+Mhyp1aDhY8RPO+eqwv5o9Qd3p9AIsQGAso2NaW+CCisFnWg4tIz4WsNGvtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768253; c=relaxed/simple;
	bh=PlwlgF2CusFyonWBsc1YGZxxrAFtu1qR5Ec8dvcirtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSWUM/DAmSFf5fBWuo9ESyynEQPDYSTNwE7QgRMODnSpKg0Z+oWabVbVYS+OE/Rtl956PvIYaw9mMQgfRKFD1ws7xVDqqwhOnNf3eU9SmC4xKRu+bI67eS6Sd8UKSvSN7YvS9r/Qr920r9lX/Z6hu8wQMfkOanvEr/jYBj4gv8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7htMFPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7htMFPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4A0C4CEE4;
	Wed,  5 Feb 2025 15:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768253;
	bh=PlwlgF2CusFyonWBsc1YGZxxrAFtu1qR5Ec8dvcirtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7htMFPKP0aXiQ1Dfi3LJMeFTIy0mh72RP/ucvsQIs7YH0CBXUuKVaz3Pv6TRYvUY
	 3R7Mb9V4EnvxdAS3Ma2mY26Q+By1ZZs0QyHyTOzqOjmMw7RgbXxWgvLvCJTmBfbHqm
	 iaAQsH5rX6IP9qcZrKjY/Soe0Q4/Vl4Mfb1uGdJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.13 518/623] ice: remove invalid parameter of equalizer
Date: Wed,  5 Feb 2025 14:44:20 +0100
Message-ID: <20250205134516.044987044@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Polchlopek <mateusz.polchlopek@intel.com>

[ Upstream commit c5cc2a27e04f2fcd77c74ada9aef76a758a24697 ]

It occurred that in the commit 70838938e89c ("ice: Implement driver
functionality to dump serdes equalizer values") the invalid DRATE parameter
for reading has been added. The output of the command:

  $ ethtool -d <ethX>

returns the garbage value in the place where DRATE value should be
stored.

Remove mentioned parameter to prevent return of corrupted data to
userspace.

Fixes: 70838938e89c ("ice: Implement driver functionality to dump serdes equalizer values")
Signed-off-by: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 1 -
 drivers/net/ethernet/intel/ice/ice_ethtool.c    | 1 -
 drivers/net/ethernet/intel/ice/ice_ethtool.h    | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 46f9726d9a8a8..f5858e89dadd7 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1491,7 +1491,6 @@ struct ice_aqc_dnl_equa_param {
 #define ICE_AQC_RX_EQU_POST1 (0x12 << ICE_AQC_RX_EQU_SHIFT)
 #define ICE_AQC_RX_EQU_BFLF (0x13 << ICE_AQC_RX_EQU_SHIFT)
 #define ICE_AQC_RX_EQU_BFHF (0x14 << ICE_AQC_RX_EQU_SHIFT)
-#define ICE_AQC_RX_EQU_DRATE (0x15 << ICE_AQC_RX_EQU_SHIFT)
 #define ICE_AQC_RX_EQU_CTLE_GAINHF (0x20 << ICE_AQC_RX_EQU_SHIFT)
 #define ICE_AQC_RX_EQU_CTLE_GAINLF (0x21 << ICE_AQC_RX_EQU_SHIFT)
 #define ICE_AQC_RX_EQU_CTLE_GAINDC (0x22 << ICE_AQC_RX_EQU_SHIFT)
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 3072634bf049c..f241493a6ac88 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -710,7 +710,6 @@ static int ice_get_tx_rx_equa(struct ice_hw *hw, u8 serdes_num,
 		{ ICE_AQC_RX_EQU_POST1, rx, &ptr->rx_equ_post1 },
 		{ ICE_AQC_RX_EQU_BFLF, rx, &ptr->rx_equ_bflf },
 		{ ICE_AQC_RX_EQU_BFHF, rx, &ptr->rx_equ_bfhf },
-		{ ICE_AQC_RX_EQU_DRATE, rx, &ptr->rx_equ_drate },
 		{ ICE_AQC_RX_EQU_CTLE_GAINHF, rx, &ptr->rx_equ_ctle_gainhf },
 		{ ICE_AQC_RX_EQU_CTLE_GAINLF, rx, &ptr->rx_equ_ctle_gainlf },
 		{ ICE_AQC_RX_EQU_CTLE_GAINDC, rx, &ptr->rx_equ_ctle_gaindc },
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.h b/drivers/net/ethernet/intel/ice/ice_ethtool.h
index 8f2ad1c172c06..23b2cfbc9684c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.h
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.h
@@ -15,7 +15,6 @@ struct ice_serdes_equalization_to_ethtool {
 	int rx_equ_post1;
 	int rx_equ_bflf;
 	int rx_equ_bfhf;
-	int rx_equ_drate;
 	int rx_equ_ctle_gainhf;
 	int rx_equ_ctle_gainlf;
 	int rx_equ_ctle_gaindc;
-- 
2.39.5



