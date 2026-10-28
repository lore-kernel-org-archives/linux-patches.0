Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211618;
	b=gCBIRqTKjiGvD8tQEFByoF+D0DkTRU+zM3hE7E+3lCUOIO4r1KEboNMP8a1xZ8tP4Lug
	 ISdiWGhIraPoi5gH1l4azGlg2HLMxSrK4R9jMjxGolKXLP/lL+xi8PhDCup7h+cy31G95
	 J63y94mr1sMmqmhlRLVaOneZm/U4BT+hdTWZcVT5A6t2yUZG0MkflaTLJpN5S44gW3YFv
	 xMy0gWWAt3pdHfgpNYUvakvMxusu43NpbXdpcTzPekLeqLg8vyiphUFlSEGK4S4WFVU+T
	 F4f6bBz1UUxF74+Yt1tTshgwdRZVhqjfnO8uGJjsVx5z3zPVtCO3Nx9wQ8IAGvCRr3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S73wmbrzJHtBKfyjU6HLhc6rDnY/uGujE+JHeJlrUqc=;
	b=dk6W/94cvkHUpJsJw/5Jl/hFy2aZTqShs5xp18gpj1deZsNWhnQtYyKngMzDmiY67+Ue
	 VeobX6SntPvvBmCIJom9UmkeTdN7w99C7x9HBCQAhLkcO43C/rV6LzMzJGID0RQ2iDWtC
	 CtxudCIZLOUlQdIso/ifexwTu3BrUXdABYsbqvvWxFXLi4/lEddDyup9yZ2GDSLMqgAR6
	 bgNlLzMkXvd/GdBZimCtnuaPv+SBxVH5M8SkUtk/HcNw+FbtJ80J8Tm2VDi05YSpVwimZ
	 5cDcPO0UABz/LIQFljTOFUZcIKIBGYBvRTJfAq1+wYGZtx6+dg+E7VgWgZxW2Uesx3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r41whoEP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8297A606A327;
	Wed, 28 Oct 2026 18:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r41whoEP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C621F01828;
	Wed, 28 Oct 2026 18:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211618;
	bh=S73wmbrzJHtBKfyjU6HLhc6rDnY/uGujE+JHeJlrUqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r41whoEPrPBTxrYwxVzIRTSgWvCIUDycJUrfUk3EWiZJJSK6AXUoYepUsxQsBoJlt
	 tH0/DUhmcypisc7cukUmWUgoxC/SIr/PxtKp0ec+VBJe7HSBzQg98eWwGiwHOJCkKh
	 mr9bN4/XgMsfoAl+GmCRlV3D7NQPVCEzkte1tv+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 441/571] pmdomain: rockchip: dont ignore clock lookup errors on attach
Date: Wed, 28 Oct 2026 17:59:48 +0100
Message-ID: <20261028170018.488165883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit 4c66c423593e26273ea0d644906ed007630c6f6d ]

rockchip_pd_attach_dev() treated every of_clk_get() error as the end
of the clock list, so a clock that exists but is not available yet
(e.g. -EPROBE_DEFER) was silently skipped and the device ended up
without pm_clk management.  Only -ENOENT means there are no more
clocks.

Fixes: 7c696693a4f5 ("soc: rockchip: power-domain: Add power domain driver")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/rockchip/pm_domains.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/rockchip/pm_domains.c b/drivers/soc/rockchip/pm_domains.c
index 67f78378d7f13..5e73b74a85f58 100644
--- a/drivers/soc/rockchip/pm_domains.c
+++ b/drivers/soc/rockchip/pm_domains.c
@@ -364,7 +364,19 @@ static int rockchip_pd_attach_dev(struct generic_pm_domain *genpd,
 	}
 
 	i = 0;
-	while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
+	while (1) {
+		clk = of_clk_get(dev->of_node, i++);
+		if (IS_ERR(clk)) {
+			error = PTR_ERR(clk);
+			if (error == -ENOENT)
+				break;
+
+			dev_err(dev, "failed to get clock %d: %d\n", i - 1,
+				error);
+			pm_clk_destroy(dev);
+			return error;
+		}
+
 		dev_dbg(dev, "adding clock '%pC' to list of PM clocks\n", clk);
 		error = pm_clk_add_clk(dev, clk);
 		if (error) {
-- 
2.53.0



