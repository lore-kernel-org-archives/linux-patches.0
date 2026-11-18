Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023606;
	b=anYPqsmmFhFqey+0KcOS/9f5+YENqG1mmm5ut7wRY+f39m/hJriPl+cAv/mfDRXcIXuM
	 iPlvzXk7G9MEd3ikyalaOpoQcjark/73m+4L9ElTvX/WxOw1Eo0Ixgn8wjfUNWIfRYQA0
	 akzMWpPOcQoWlBmCcL5dtR7j0vAAIvtPUpeH+QDGoBcnYSMDaxY/q+6YOMqqWer22UaHg
	 C3Jn1Mj1S4/+ShP68MtV3pW2wQhM6A/zTfDRI5JumTKXCiBz2wyqETzijqacKbsu7Dss9
	 622BRz14NpywL0xYu+Jv1/gK4PycIfJ7aiXGug1vl6tGO9CrChgDrheDGB8kPC7HTFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/J7vbX+m1aC9wONWeqsOhA4ACqGayDATsRUB0nHafbQ=;
	b=biF1gF2Jh2AwhW79FiENpCRuxrUkT6+/EJXrzz1E4iDpPlQtdi3kX6uS70u6YhZ34US+
	 2FbuLZFRDV/I48tENyg0i+hCkIvw1xV4JSey1daE2D4pE4e+qaKfNYW3OPJN4xXpGIJ9R
	 hb8zk8FC59C68Ct2gjq+A5/AmjwyGjwyNKCGVhWx+TkFFvPHlytYMKMfAcXI1JaApHLF4
	 qVog/Uy8s5zMjwy7C6jSoDZSz54IpZGGbQzTHALlxe9EH5VghVNVXem9+iIGxcd7j+V9C
	 8mZuVcjLOzEPdRz8j45/k+e5bTAevbjzy+mnJXMcVRHObbB4kYi0XsvAhZdGKdofLpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GoeW3Sgk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D39606A337;
	Wed, 18 Nov 2026 17:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GoeW3Sgk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61C11F000CC;
	Wed, 18 Nov 2026 17:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023606;
	bh=/J7vbX+m1aC9wONWeqsOhA4ACqGayDATsRUB0nHafbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GoeW3SgkJC91iDhh96fbcUWZi7S6QYku6qOUIq/GYKxr0gP4+ky4VW6tOYJc7Mo/3
	 rU1kmpzFXup1LDcRls0YzI/FZ3E7x0kYopnrz4p3QvxSM1T6OaRPkY1hyEu4mPoc7o
	 irG6VvjbsJyq2vvDWBKhRB19wY1sosQD2nR+chpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0388/2151] memory: exynos5422-dmc: handle clock enable failures
Date: Wed, 18 Nov 2026 15:35:23 +0100
Message-ID: <20261118150136.204975426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit cce46902ea9fcd585cd200fffa3166f63bc571f1 ]

Check the return values of clk_prepare_enable() for fout_bpll and
mout_bpll.

If enabling fout_bpll fails, propagate the error. If enabling mout_bpll
fails, disable fout_bpll before returning. This keeps the clock enable
count balanced on probe error paths.

Fixes: 6e7674c3c6df ("memory: Add DMC driver for Exynos5422")
Signed-off-by: Jiawen Liu <1298662399@qq.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/tencent_B0189529F550458590E3BA614EAB800FBF08@qq.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/samsung/exynos5422-dmc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/samsung/exynos5422-dmc.c b/drivers/memory/samsung/exynos5422-dmc.c
index 788d49c688b1d..98c3195525831 100644
--- a/drivers/memory/samsung/exynos5422-dmc.c
+++ b/drivers/memory/samsung/exynos5422-dmc.c
@@ -1297,8 +1297,15 @@ static int exynos5_dmc_init_clks(struct exynos5_dmc *dmc)
 	if (ret)
 		return ret;
 
-	clk_prepare_enable(dmc->fout_bpll);
-	clk_prepare_enable(dmc->mout_bpll);
+	ret = clk_prepare_enable(dmc->fout_bpll);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(dmc->mout_bpll);
+	if (ret) {
+		clk_disable_unprepare(dmc->fout_bpll);
+		return ret;
+	}
 
 	/*
 	 * Some bootloaders do not set clock routes correctly.
-- 
2.53.0



