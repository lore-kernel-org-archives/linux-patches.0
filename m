Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030694;
	b=1QA+65Jb/DL8yOReZIAqCzcq7trazD/9UcXl3Lw6wFsE2Wlmy4WWU6L06p8Na4HyQS91
	 ovQy3rbdJNJmlwo7G336WcHrePfsYXUiMcCKQAVDnu0qeORibbYoMh7FisKGA8VbQ6tIL
	 ef4tlH0XxZY1jH/zUpH+7b0z5MmAnF2tK2aDEujVftGSZYOtYJdp442QUfbfZPWY2Q2/a
	 LGuliDiwsJjV9V6rbFEIDloKXNvWdKiGVsTKevpm24wNbUx012PFNgAp4SD/H45g7qaoe
	 vzMQZijBjRWIf5RS+0f/F4XGPRokDveDCAWxIo/SnxLADOfC9joBUTo6Q4oOFpWAKwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KssMpm5y1fK+EkbKXnB62pIhQs/Mg4saI1Dxb+kdVug=;
	b=LZWpezd0DkCvDR/abU6NTnCjZmsP7DNbpMCNq+pHCX4LURwva5qc8aZ6qQsupTvl1LvB
	 8mHjFAjoaS/neao7gLClQ+NhbNj/zvovo8DdRyK0b5k97U9wbYSPotrfl+VSMPZ6SHCI2
	 i0sTFvuv4elEISoTVh5xpZBuko089BHsJeCyHgbNWeuVh0YJiCWsBgRtzApnniA21p37A
	 B89xbOmr7v0Si9CS0b6p3MjqEICTnCwkNWBAJ+mMV7nvKbceX2fwryB4NDeNyx6/q8F5o
	 FP/jpepnyvJnvRknbo7kwd02HbDdKuWb8mDA5HTuSCHVzaq8q17cQTzESLLxxpVYE2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lVGyVOPx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2B8606A33B;
	Wed, 18 Nov 2026 19:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lVGyVOPx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035E01F000C4;
	Wed, 18 Nov 2026 19:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030694;
	bh=KssMpm5y1fK+EkbKXnB62pIhQs/Mg4saI1Dxb+kdVug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVGyVOPxxD2EkRC9uS+9OLiQ8dMu0wJD7YSdyY3ktvgR+wzNeG5P3QIbIVCeI9Pci
	 iTeJ6/XnRTDrPvgqDGEePkKKilqCVEM8rAVeMzjmXiZoOM0AP/OzDwdrWBeY1H18Hc
	 xpb1hLW46DsH3y6sTDEUUMDz5O3Hspg0XrExbjYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 6.12 0788/1756] phy: rockchip: usbdp: Hold mutex in DP PHY configure
Date: Wed, 18 Nov 2026 15:48:35 +0100
Message-ID: <20261118150041.083459806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 619233ce6b2329529c9f0ff9682d6e22d160ebd6 ]

rk_udphy_dp_phy_configure() accesses some variables from the struct
rk_udphy, which are updated independently from the USB-C framework.

The USB-C mux/orientation switch functions already hold a mutex to
ensure mutual exclusive access to the struct rk_udphy states, so
simply hold the same one in the DP PHY configuration function.

Reproducing problems due to this on real hardware would be really hard,
but could be possible when quickly re-connecting the USB-C connector.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-phy/20260612164627.23D391F000E9@smtp.kernel.org/
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-part2-v15-7-8d507cb1174f@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index 05edd03761c37..f611018171e34 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -1136,6 +1136,8 @@ static int rk_udphy_dp_phy_configure(struct phy *phy,
 	u32 i, val, lane;
 	int ret;
 
+	guard(mutex)(&udphy->mutex);
+
 	if (dp->set_rate) {
 		ret = rk_udphy_dp_phy_verify_link_rate(udphy, dp);
 		if (ret)
-- 
2.53.0



