Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030662;
	b=1w6d+rvuHEf43hd72jia8pwpurxxAYmPVpVTCc8kzI/7xE4Jd5ARrqciwDm4hg1jIfSY
	 7eXJVGjHAs2GZhiVqXlgPsm1szzNr9Ba+iix0ts856yyOgsquKnG9uK0/m4F7Ll15mqnP
	 CkpXn+FbMBfCvYGcjyEr5xWFVJs+YE56mv1ICqQlXEMBt7l9H2rAglrnRbPplg5loXIL0
	 DtNrg7HIUoZ3iwMxMdMTof0Olx3Qiw+W/n4vKasKMzV0q+xp6aEwHRNyny9L+FMwWXuue
	 1SqsGhgrWM8GKvW4UQ5AGf35A2IHQsiRlcqBf3+llc/cK60J0lqzuPstDh6j3+ejklQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xBpo0kMmACi2LsFL36vyJ6in+lyXCOj7mUirqXDFMWw=;
	b=ZaTudgwI0Jo/DAqhShhhHL/1xwBFQUzdFKFD0V09WQ0Upbmwumts7aq0CZCiCImjzX4h
	 xoAnYpgyDw3SAnword6ms+NLmmYfCk0aT77OvkTa7LfX+/obnwqvrENft1f9NFX5yQJWh
	 RhQ7I5R+ce3QKR2Wnm6CzSabc3s9QFjUepiUP8/G86gkrBvyuRK8CGoDm5KzjvnqmR+8N
	 D5Jiwvg3imDQqpxSLcWLidl5Z5488pj4vKbGjHw7vXnCozqibcKvOh6M2keorPpCus2SK
	 wwTkVHjVmy92opFQWrTIB91a9dX0LN82ZS/VxN1Ft443wyccOtvPWiZ5JMBSmKVk57Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eaSloevF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE005606F518;
	Wed, 18 Nov 2026 19:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eaSloevF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DC41F000C5;
	Wed, 18 Nov 2026 19:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030662;
	bh=xBpo0kMmACi2LsFL36vyJ6in+lyXCOj7mUirqXDFMWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eaSloevF36SmxVfJMITvYhyI8NJt9/Y+z+iPhmIv7/e9HsSIhdv9TuEY27jSor5QE
	 01/5j6sJ0OxHdP2igNN0mnLT1Hk0lqw17KIXej9t32TATtzlsusBFia8J13+Em96R3
	 EJyprRUFvpj5SBbsTHVZ8FF2Uz9dOB0fSXBFZbSo=
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
Subject: [PATCH 6.12 0782/1756] phy: rockchip: usbdp: Limit DP lane count to muxed lanes
Date: Wed, 18 Nov 2026 15:48:29 +0100
Message-ID: <20261118150040.742082631@linuxfoundation.org>
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

[ Upstream commit 443997ca8d797375ff35e8f3ad3828799e88f71b ]

In theory the DP controller could request 4 lanes when the PHY is
restricted to 2 lanes as the other half is used by USB3.

With the current user (DW-DP) this cannot happen, but as the check is
cheap and users might change in the future protect things accordingly.
Not doing so would corrupt USB3 usage by the following code configuring
the voltages.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-phy/20260612165546.98E1F1F000E9@smtp.kernel.org/
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/linux-phy/20260612165546.98E1F1F000E9@smtp.kernel.org/
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-v15-12-80e2c11d1ce8@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index 022218e64f48e..fa6446c1c6c0e 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -1102,6 +1102,9 @@ static int rk_udphy_dp_phy_verify_link_rate(struct rk_udphy *udphy,
 static int rk_udphy_dp_phy_verify_lanes(struct rk_udphy *udphy,
 					struct phy_configure_opts_dp *dp)
 {
+	if (dp->lanes > udphy->dp_lanes)
+		return -EINVAL;
+
 	switch (dp->lanes) {
 	case 1:
 	case 2:
-- 
2.53.0



