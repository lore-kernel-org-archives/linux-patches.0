Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB251DE8AD;
	Mon,  9 Feb 2026 14:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647570; cv=none; b=T63GKN3SrGbGFX6QE7q2P5IjNSw/LWnM3PAYkelh6GhfJAkOMsfzQ7qL0haniBQyV7r13PwUf8euuT55nat2FP2BnmPPcjsJlYS0SGb5T4SSMQsLBA81u5C/q+KTzMnllGxatdiCWsxGOjlBcZPNwbz92ahqrbGb9HxCF6P7Ejc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647570; c=relaxed/simple;
	bh=E2nyBlmC7OEGrjEasl/LjYN06nIsDom17Kg4MxWiXjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGt7n3UDETqi8CiC8/JcJRbBNQgHzO9XxFUfYOGyyEqzExGMoaDuOYjKdF4vypodndfKfmYXJdC0hdvt3mIzpgKRHmD50O/zgzO8b5Eg4twdHaIoR8L42owk2D3F6hEjW4BQoxrnG4Td8+72XSiXTuPC7C6mgYowwKH7ZpwG9cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZYZvU6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZYZvU6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FB2C116C6;
	Mon,  9 Feb 2026 14:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647570;
	bh=E2nyBlmC7OEGrjEasl/LjYN06nIsDom17Kg4MxWiXjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZYZvU6z3N/D+o+/GMvMH/LyvhuWmETvJYYii0aiJVV3gA5wgUcCwvIUnY62GbuVg
	 ZQ+u1kPjxW4+bqqBgmOjwqdVUHd8WTrviaOoh9zIX6rFHiKG8Me31boWCmFuA7RcQY
	 encAzpBKpNIfq8Ledc+/8nKsIKpt3e5uSJN6D8Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 140/175] net: enetc: Remove SI/BDR cacheability AXI settings for ENETC v4
Date: Mon,  9 Feb 2026 15:23:33 +0100
Message-ID: <20260209142325.543073904@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit a69c17230cab07bd156f894fdc82bd78b43ea72f ]

For ENETC v4 these settings are controlled by the global ENETC
message and buffer cache attribute registers (EnBCAR and EnMCAR),
from the IERB register block.

The hardcoded cacheability settings were inherited from LS1028A,
and should be removed from the ENETC v4 driver as they conflict
with the global IERB settings.

Fixes: 99100d0d9922 ("net: enetc: add preliminary support for i.MX95 ENETC PF")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20260130141035.272471-2-claudiu.manoil@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index f410c245ea918..b6e3fb0401619 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2503,10 +2503,13 @@ int enetc_configure_si(struct enetc_ndev_priv *priv)
 	struct enetc_hw *hw = &si->hw;
 	int err;
 
-	/* set SI cache attributes */
-	enetc_wr(hw, ENETC_SICAR0,
-		 ENETC_SICAR_RD_COHERENT | ENETC_SICAR_WR_COHERENT);
-	enetc_wr(hw, ENETC_SICAR1, ENETC_SICAR_MSI);
+	if (is_enetc_rev1(si)) {
+		/* set SI cache attributes */
+		enetc_wr(hw, ENETC_SICAR0,
+			 ENETC_SICAR_RD_COHERENT | ENETC_SICAR_WR_COHERENT);
+		enetc_wr(hw, ENETC_SICAR1, ENETC_SICAR_MSI);
+	}
+
 	/* enable SI */
 	enetc_wr(hw, ENETC_SIMR, ENETC_SIMR_EN);
 
-- 
2.51.0



