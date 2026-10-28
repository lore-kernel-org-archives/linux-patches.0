Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213640;
	b=f86w7XFmxXRL4y1a9BPpSS1cX0YAB87ZAWbzkHxAejCg9OMkvWAbM0xSs7LyflxJsmhB
	 wUZLGABbrhWJ/8PpBBb4G6S7QTs/Qx8rAmCtDnlk12WcVgaApGDr0H4EnwmuxX+zUxvaA
	 qMFEfM7qpcD7TQSPViTNd8R+9OpLgrDEHCIJ/UC7g5s6v/2vdRC9c7/Z3zgP8uv05ggBD
	 KIBXzN/p8b7BucXeo+ALNyM70GihOiBRhAB6w5TnOTAUoM9EtzkatyJ5ad8bl3/s1KrC8
	 4YeR3y6mx806fYDFFGTI0ORpsZu0hVnvv2gkhWAhTktA59dAm2auUCEmGPv1v+lmmJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YHmV1zKOHL1PGjuClAQALmCe9zdM90DzEBN7wDbnuUY=;
	b=A6IYs8hq/naplPVMWsXepQbAV0Oliwl+wLgZeGclR8ymbDH0vaXujqlRvtaMrvR3+WbX
	 jMFMdUfh0QLNMvwW64FbZttEwO/lYKTfmqtS84wxfelRBJtyggWeH5CSYIPsQfFIZB5ny
	 OQ/nJLMj/fQqr78o2v3qre0PMVCUs3lVaSogOWGl7h3cBVs9AIybDRaOshYzpBesARDTr
	 x7z0Xk7NCszeiWsXg+JIrK+pWqSqw3g3kQ9aXQAEndvF81gOVGNTBsQZLDp50uaYRIlIj
	 wl2WG3J/3bmPur7sx/VyfNmCRaeBm8A/pm+XHWttTyoJK3HBw8bvtsHeAPHPnOy+6ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQHs37+Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053EE606A31A;
	Wed, 28 Oct 2026 18:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQHs37+Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540441F01825;
	Wed, 28 Oct 2026 18:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213639;
	bh=YHmV1zKOHL1PGjuClAQALmCe9zdM90DzEBN7wDbnuUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQHs37+YXKArSa5qouO5KdhjCSFnl7gJtrcqja9lu3G2oAPyfPSayuB6CKwkmGyIe
	 MF5Qmt3U6CLvspZW81bSIMl1zNwli0kdbXgEspYDNa9KLME3sNFU+BTInSx+q6msyM
	 /joSHGCnpEhJbBZ1/kr2O3n4bgh+RmLs6dsAhT4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0533/1887] pmdomain: rockchip: dont ignore clock lookup errors on attach
Date: Wed, 28 Oct 2026 17:43:49 +0100
Message-ID: <20261028170511.472389181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 32ea21cd39133..1146fdf477aa8 100644
--- a/drivers/soc/rockchip/pm_domains.c
+++ b/drivers/soc/rockchip/pm_domains.c
@@ -507,7 +507,19 @@ static int rockchip_pd_attach_dev(struct generic_pm_domain *genpd,
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



