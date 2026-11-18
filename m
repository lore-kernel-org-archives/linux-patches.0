Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018341;
	b=lS81ixGof0Rv5/mQPzvEyYPn7zkESXhB2MA6ldmfqIzYMVaYz800rKu3szgfVCSiGzw3
	 0ojENFbUzJ2X/fkjP2nXdVSGOsl8uNriBApDYyOfO8J8KOFRPkQGEoEBhGiENBFEejXph
	 lA6GPvqLwsWsDRRNEBxRLPpYh4pqCsB2LjEahmWLmdmP0ZEpN2+hMu0sJZAsetLA7fZJJ
	 yeUtLCgMMw/j7iXZs4U58NRSFY0C3oz4EA43KQ3lRp7BzcxcIx/6nm2tTdNbL/wMLTENV
	 jtgtO7O6U5rLL43hV59RibZbEmiZHO/xcdHPRLLTPQQCMrdJaz1gA/C30GHWqWpzgHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ppJL13DF9RRaRm1fdTFqOh6Znnw+AJmODsRonz0jLXI=;
	b=OPAcck8XCZq1t2/6zrho1XedtFkDWzfGE6tBD1dm3jLTloaJmwoRxlI13iUZPlECS1F2
	 2KUg9KVMN5DkC1rH4qpvS597bEEr5Kk9sPOwkHqCyZrJ6a1uqxowicZYRGSzD4bTzEyrI
	 zvIG62wt44LArVDWAROgcAWHuC6MCbbLEaw1Lp54MLkyoksqXwirqO7HPiORzQUfT5Kea
	 jV3xjaMh48M0LZPawpR80syyNLbVc2UmOkFpi7xCcaDpFD4VOeHt0fatfsFfMmFzom+jG
	 bdSlTn3IYBxJDcK6NYCQZLPD3KPA3/tU9k4Ii+cMNH0ddnZ9KHef19Muj+u5s4r5gvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0sGLuQ7g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FAC606A32A;
	Wed, 18 Nov 2026 16:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0sGLuQ7g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BF11F000C4;
	Wed, 18 Nov 2026 16:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018341;
	bh=ppJL13DF9RRaRm1fdTFqOh6Znnw+AJmODsRonz0jLXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0sGLuQ7gsUSMdoiU44EIoCbhmcIxIdcmgtuBPc0zz4NwWWxtSiE4f8kC2iupa4q59
	 s6TfB/8us7QfZnXLnCGzIDFBxiwoUdeVFnSQBn2hGHTPUPqkakrg3kYz9QuvQ8k9lQ
	 ao7JrVSnRbKAEPm7ZvsWBWlPFx7FQ7QiIInfN7Ko=
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
Subject: [PATCH 7.3 1205/2651] phy: rockchip: usbdp: Fix devm_clk_bulk_get_all check
Date: Wed, 18 Nov 2026 15:40:45 +0100
Message-ID: <20261118150331.377997165@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit a2ddfc60a7d3ba0f571f037371b261642f8ed208 ]

If devm_clk_bulk_get_all() returns -EPROBE_DEFER, it is replaced with
-ENODEV, permanently failing the driver probe instead of allowing it to
defer. Avoid masking the error code to fix the issue.

This effectively drops returning -ENODEV in case no clocks are being
described in DT. This special case will now be handled by the follow-up
check searching for "refclk" and exit with -EINVAL.

None of this will be hit in practice, since the driver is only used by
RK3588 and RK3576 - on these platforms the DT is validated to contain
the clocks and the clock driver is force probed early. Thus there is
no need to backport this.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-phy/20260612164107.C7DB21F000E9@smtp.kernel.org/
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/linux-phy/20260612164107.C7DB21F000E9@smtp.kernel.org/
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-v15-4-80e2c11d1ce8@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index da0fa75fc9f0d..c6cda0b80bfac 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -426,8 +426,8 @@ static int rk_udphy_clk_init(struct rk_udphy *udphy, struct device *dev)
 	int i;
 
 	udphy->num_clks = devm_clk_bulk_get_all(dev, &udphy->clks);
-	if (udphy->num_clks < 1)
-		return -ENODEV;
+	if (udphy->num_clks < 0)
+		return udphy->num_clks;
 
 	/* used for configure phy reference clock frequency */
 	for (i = 0; i < udphy->num_clks; i++) {
-- 
2.53.0



