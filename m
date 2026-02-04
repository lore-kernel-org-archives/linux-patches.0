Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2942D6E73;
	Wed,  4 Feb 2026 15:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217299; cv=none; b=TROdd0Bfb7padh0iFUUZYpQ5K+QG5SAUnwiSs+btjA/G2k6uMbAC77HyX7zex9LgrysK6xr3+N935Cn1LO5zg2qavxbTUfCYbTkV00J5KR8TXxBOR62EIm3nq7wg1dBHLp9Ets6Eysrieg3wCdMrMZw3QmszOU/ShEJwoFJIAtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217299; c=relaxed/simple;
	bh=4v+AAwHMF04KZOQ8HjtmZ/tilu/qPVWfYyt0aa29BVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LiKnobPygtdJGtc2tkNtxcnHo0xUx6M7J6/q+dtbB/Iw+6XT8Ea8tau0g7q532OzQykkbR+xCShBCaA8+HrcTLcttDD8gsT+eE9fmM9aaU7iVxvBIQO5S4PzieuZp330iwn+3OaL50KfKi9/86TC+myhmZqpXXaPO5iH9aV5E98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1Ghey6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1Ghey6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56C7C116C6;
	Wed,  4 Feb 2026 15:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217299;
	bh=4v+AAwHMF04KZOQ8HjtmZ/tilu/qPVWfYyt0aa29BVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1Ghey6z24E5B0nrJoapDKytQpwMpNA9rqd9fSC6u+GKROhAluxme/lcNdPUR/iAa
	 D6b2LBjoDmbliiSOjpEWlAE0fTrW7OT37srjUzuKqGsd3rPTo7PMldjFS2nDQ/SWUd
	 TrgWXyIfxGG6HTXedd4jTsPeDKiWrRLlYNfap2ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 5.15 183/206] net: stmmac: make sure that ptp_rate is not 0 before configuring EST
Date: Wed,  4 Feb 2026 15:40:14 +0100
Message-ID: <20260204143904.810936064@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothoré <alexis.lothore@bootlin.com>

[ Upstream commit cbefe2ffa7784525ec5d008ba87c7add19ec631a ]

If the ptp_rate recorded earlier in the driver happens to be 0, this
bogus value will propagate up to EST configuration, where it will
trigger a division by 0.

Prevent this division by 0 by adding the corresponding check and error
code.

Suggested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Fixes: 8572aec3d0dc ("net: stmmac: Add basic EST support for XGMAC")
Link: https://patch.msgid.link/20250529-stmmac_tstamp_div-v4-2-d73340a794d5@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ The context change is due to the commit c3f3b97238f6
("net: stmmac: Refactor EST implementation")
and the proper adoption is done. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c        |    5 +++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c |    5 +++++
 2 files changed, 10 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -597,6 +597,11 @@ int dwmac5_est_configure(void __iomem *i
 	int i, ret = 0x0;
 	u32 ctrl;
 
+	if (!ptp_rate) {
+		pr_warn("Dwmac5: Invalid PTP rate");
+		return -EINVAL;
+	}
+
 	ret |= dwmac5_est_write(ioaddr, BTR_LOW, cfg->btr[0], false);
 	ret |= dwmac5_est_write(ioaddr, BTR_HIGH, cfg->btr[1], false);
 	ret |= dwmac5_est_write(ioaddr, TER, cfg->ter, false);
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -1494,6 +1494,11 @@ static int dwxgmac3_est_configure(void _
 	int i, ret = 0x0;
 	u32 ctrl;
 
+	if (!ptp_rate) {
+		pr_warn("Dwxgmac2: Invalid PTP rate");
+		return -EINVAL;
+	}
+
 	ret |= dwxgmac3_est_write(ioaddr, XGMAC_BTR_LOW, cfg->btr[0], false);
 	ret |= dwxgmac3_est_write(ioaddr, XGMAC_BTR_HIGH, cfg->btr[1], false);
 	ret |= dwxgmac3_est_write(ioaddr, XGMAC_TER, cfg->ter, false);


