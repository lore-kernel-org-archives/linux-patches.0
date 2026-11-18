Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030654;
	b=3GDhRWlCVmGg9oZEpxb3N+Xau1snpJfsgGa1g0xsNQKJBcqzgq4EsixGHAWlQyHw028H
	 KiC9h637uwXTD7oaedSKA8UdU9KNH6dlKyyQCTPAYUz7S8fe8ULUaMr8FPh6ASIumcNXu
	 wG8jQbSNKndrSCMwF7WSfC6DbH2F5MSB275gvwJpq4gCiOkpZpGttQFAMZla2zXcGGOz7
	 DITe858qWGvi+VGgkAJK1b3uB/tVtO0PREmzzN43l8Pt4OSzFXo2ejRFr8F0AJTRk8zvU
	 CDuvTEJ8PjQzePGbv7rMmPFatuqB5hbbHcb8Ez7FFQJ5dCeGpRLAi69C8uhqaHE9YnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N/OeoTMTuhYyqWzzXN8JRlf6nMeomxynQYV7FvF4rZk=;
	b=pKzYsJETb/bthSWPI7Eh1XTPr/zm38B1nI7FZeLPLaSgWDFLGnqW8Sd25PTJ1K6EQ8mS
	 QQk+bvUd1ZB6k/cfpZ6FOT1unFGW4oNVEsnj2/g3Np04mhPPCdjI3zwMdMRWOskHi6NnA
	 dvD7Pwxd8QsKW7EyDCBjag2Byl66ReAxAeKDRxCjz3s5cK3c4OnQ92CGtQUKj/AupSx/x
	 z52emt4eC7FfxiZPWD4uVr+WPif1FGmTwhYWqOgvb/a6GC8R7DKaN9KexFxzihzE6tLC+
	 j6C/KpYom9eOleIc+Pmal5C2xtJMdfltAeJ9mCHG0IjlQm5cAPfrCa2VkXA07rSOLMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bfOKe8xi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F21606A31C;
	Wed, 18 Nov 2026 19:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bfOKe8xi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A501B1F000C4;
	Wed, 18 Nov 2026 19:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030654;
	bh=N/OeoTMTuhYyqWzzXN8JRlf6nMeomxynQYV7FvF4rZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bfOKe8xipMzG6brmU04Sb1495GzJB29uJh8PSogkzvZ6fkSg3ne82BGx2Sd3BFzym
	 H5p3qATmPeFcmvZ+8XPodm2sA1rQGvf3areL2oUn2TbMcDtzxKhtrVQvCyFXQU/m7V
	 QE7hRsZpzElpp7NtCgthMia75CjEM3XTBZG18mD8=
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
Subject: [PATCH 6.12 0780/1756] phy: rockchip: usbdp: Handle missing clock-names DT property gracefully
Date: Wed, 18 Nov 2026 15:48:27 +0100
Message-ID: <20261118150040.658795868@linuxfoundation.org>
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

[ Upstream commit 17cd5e026a6e806b811f915b8e02a8b9d14f6f41 ]

The rk_udphy_clk_init() function would currently try to do a strncmp for
a NULL pointer, if DT specifies 'clocks' property, but no 'clock-names'
property. Fix this by making sure the clock has an id string set.

Note that DT binding requires setting clock-names, so this is only a
problem when booting a non-compliant device tree.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/message/20260619154349.071321F000E9%40smtp.kernel.org
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-v15-5-80e2c11d1ce8@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index f8288f9875913..aa58b1555b9c7 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -432,6 +432,9 @@ static int rk_udphy_clk_init(struct rk_udphy *udphy, struct device *dev)
 
 	/* used for configure phy reference clock frequency */
 	for (i = 0; i < udphy->num_clks; i++) {
+		if (!udphy->clks[i].id)
+			continue;
+
 		if (!strncmp(udphy->clks[i].id, "refclk", 6)) {
 			udphy->refclk = udphy->clks[i].clk;
 			break;
-- 
2.53.0



