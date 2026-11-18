Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038635;
	b=G/2fTjCCMVQ1b6BpV+a/XX26BIPFMXGZDVz5ZoQJ/Py1idRBElp1EJYB6ezf3hQ4V+Ur
	 AtU44dmyya5ZsdC34aE7WIUhZfm1VGFAwNLq1e6AL8bKo4rpWN1xZPnwYvgXnwhSTdo1e
	 54PlImVcDVaZd06bhs8NgA2F4SeAb/WKy6rh8dJExKQVp/atU/s5X09OnmdRe1Rl/JOpO
	 Y6gqJXGCgXeCkBVV79dzA6taYbjgeZ+XvE15dk0eKYGHfNNkFf4gHNP/LRn7pfT0KjHvq
	 WE/1Jg9MVVliHGjS8xCQEcLGlUu8WUKRkIHL4KpFyajmD4PQrEHIlb8UIXpGPDCljOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YMIG0h0imVsXBng66e2mHRkFDcNmxYYR3TfusOvf4Ok=;
	b=sw3BjbAOJ+S3wRU29YYL9dKbXE3WRVpMwXF5xvQvYFPVL4jZpI2PRFxF/7U814lZpF/2
	 erwuDPYmXkbgJgs1ePNOLWhBi2dzGpVU/hahVYSh/WO2d4qMMOnHV71/NWXmzHWtZWopN
	 ZyemQljuIsj/RyVkmK7joLhbq11AzDl4+G3d4/0JbmzvW0Iz1xEkttEaLB8WAAyTjLUSH
	 g1ZtRrv0zSiutrujxn00FlYtLWxVzwJHu4DLHY8yOGHbmvBXrxoizZOwuaGnYgZc44J8c
	 L3R8W/T1qUsCYjlIphlGZEKYsohhmbVWF0O3710qcEU+SU7xPG7Vt3ZmOgqGIIrySGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZwTdbuZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980EA606A31C;
	Wed, 18 Nov 2026 21:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZwTdbuZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC17E1F000C4;
	Wed, 18 Nov 2026 21:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038635;
	bh=YMIG0h0imVsXBng66e2mHRkFDcNmxYYR3TfusOvf4Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZwTdbuZVKvpE5chRPL3onH9uDwNxBJxdrQBVXzATAAm5Dam6D1C/H9L2JjtUgQ5o
	 TWioRE52wSRZN6QtybKzCnRMuXoBY3O5bN8mWjCzlOgf/6lXtS4FQ9RECv9HqL/YGt
	 t3EZ0WAbtRSkeWTvhWcGEk5jPbFt6dLPMFSbu7gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1812/3318] clk: nuvoton: ma35d1: Keep the clock count in the driver
Date: Wed, 18 Nov 2026 15:40:34 +0100
Message-ID: <20261118150416.214927441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 26ec588063d9b6c70773b8729372e2bf6d3ea95a ]

The number of clocks is not a binding since this is a value that can
change. As such, in order to support the missing watchdog clocks and
allow the deprecation and removal of CLK_MAX_IDX from the bindings, we
need to switch to a local definition first.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260930-perso-ma35d1-upstream-clk-v6-1-48937ee6c9bb@bootlin.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Stable-dep-of: 1dc3871ce7ec ("clk: nuvoton: ma35d1: Add missing WDT/WWDT parent clocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/nuvoton/clk-ma35d1.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/nuvoton/clk-ma35d1.c b/drivers/clk/nuvoton/clk-ma35d1.c
index 9f65d0623517a..6aa42a3e1be3b 100644
--- a/drivers/clk/nuvoton/clk-ma35d1.c
+++ b/drivers/clk/nuvoton/clk-ma35d1.c
@@ -17,6 +17,7 @@
 static DEFINE_SPINLOCK(ma35d1_lock);
 
 #define PLL_MAX_NUM		5
+#define	MA35D1_CLK_COUNT	236
 
 /* Clock Control Registers Offset */
 #define REG_CLK_PWRCTL		0x00
@@ -467,12 +468,12 @@ static int ma35d1_clocks_probe(struct platform_device *pdev)
 	int ret;
 
 	ma35d1_hw_data = devm_kzalloc(dev,
-				      struct_size(ma35d1_hw_data, hws, CLK_MAX_IDX),
+				      struct_size(ma35d1_hw_data, hws, MA35D1_CLK_COUNT),
 				      GFP_KERNEL);
 	if (!ma35d1_hw_data)
 		return -ENOMEM;
 
-	ma35d1_hw_data->num = CLK_MAX_IDX;
+	ma35d1_hw_data->num = MA35D1_CLK_COUNT;
 	hws = ma35d1_hw_data->hws;
 
 	clk_base = devm_platform_ioremap_resource(pdev, 0);
-- 
2.53.0



