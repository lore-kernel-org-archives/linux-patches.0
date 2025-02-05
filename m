Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8354618BC26;
	Wed,  5 Feb 2025 15:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767663; cv=none; b=S6Ivk4JOffzqezoPIwqpGHqWzDaSaXwyPh7tW+mb5zm7Lmma/8bgi9jk8DhgT1UVD8vwWxy0v5TsYsy0/0F6RVqnRgnjz23VR3AL8ttLyZZc4wGwS/UmnyOeAd5uVxsjE4WReHEt0HhHy84qvlSJ7P35udRauYlQSIRd/4d0Soc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767663; c=relaxed/simple;
	bh=Dy+AS9BigNrPik5PkrP3SKkZxAv0f5b7yls7owpTlBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdiupGlldoinLDO66BgbB6IymUrk5SSxYkbuQ6DlY0fBb+M9YHw0p+PCSdq5cDAEooHvCTfzb3VGSGVmpxfRjop+HShppbPNNBc4GuH2ZVRt6pOMQycWWwVO1jfjVFmMClUe+oeZuU47WAXcgJ8PZkzpon0wWtmG3kocjiYVgbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlliiEXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlliiEXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3ED1C4CED1;
	Wed,  5 Feb 2025 15:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767663;
	bh=Dy+AS9BigNrPik5PkrP3SKkZxAv0f5b7yls7owpTlBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlliiEXYq9VPZ9fx0V+Ga+MkVR5HEhyU7np+ozz0nFvsJNtFNgJwefgiku0f39e47
	 LAjdsCJKkpKXUauuXaACDOCnFzJkTzgyWyOLvUEKY9NuO/99fPlw+Qq6k1PD37oqW0
	 7+7W6bsvJYCgXoOKzrVTCdkU+zOzJoMfVsAY+dok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 489/590] ice: remove invalid parameter of equalizer
Date: Wed,  5 Feb 2025 14:44:04 +0100
Message-ID: <20250205134513.977179438@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2a61e1da993ed..66ae0352c6bca 100644
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
index f94b6bddbeaa1..7d1feeb317be3 100644
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



