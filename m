Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023570;
	b=qCuGFFlWNZgBGrFwW6p/1U9j7p/dKXTSOxdQAJI050bU9XrNAXUycY2mwkEDYLnpKM9l
	 VfHrWCpiZ48ArGI9kgllQ+539fzM+KNjjDBVCTlOWkTwyDTx7h2TwiJM8JTHFlsjOhm3a
	 DEMqdshdpAa6G89ITdmJB0XTI/ivxDuMMRRqwqHlS74ESpfWpmfevS9Vu3rwQoTKdD0YK
	 YkgUazifV3R2YkiFrvYgM1zGnFbGaqrHr9X2LDgFmr24B2lgRzUEG/eSPJiE/suvbDL6b
	 K3+I6BMuWjaPaiADArUX6aWEdSYL0gnuDWmBGBYl9z4Lc4MlLSVn5+VPoF7X9yO1uzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3akTTiOhgHJDC2TmfKok6FFIDBsqGKgKBnRVWo8anxA=;
	b=lXTvvwCodeFlfwwXhVJaFQT2ZvJWxt5eXUIgXCKt47RGvWEdOJ0+FtGajkjLO80RhRkT
	 1coURy7HI4FHKYAaIej+f6iW95Wp9gQxZbct6FRtXlMpl0pLXGUqAi1cLj1SDfDZtP0q7
	 KxQytBCE+p4WwszGG0RfnwOS5bwp4lMcpKjn0Mawx6PQmw0A3X/tejDvck9ZGYzL80e/K
	 0MIZmJ+mUhFKUXs8uJuo/sS+OUAh20PAfOdcDyVr9bRbv951u+vhMRRfex2sMud5lHX8T
	 J/KejuCH8GUbOR8v6zxBxuTRElWCJpKyB+0sBiGCCnPndj7ItO++7/VPk3YYGheivjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yeigN3US;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A04C60A2626;
	Wed, 18 Nov 2026 17:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yeigN3US
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACCB1F000C6;
	Wed, 18 Nov 2026 17:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023570;
	bh=3akTTiOhgHJDC2TmfKok6FFIDBsqGKgKBnRVWo8anxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeigN3USafJb424ftzHhQrBftvOYv94blR3BB9TzYBZqEgMRCYtsdkKcNsz0TjSzY
	 wbyyprZRLsOHyulzPQATwoOdiu6b2fpZ5Trkk3QCiArY7QQ1amgn/eg8vnnwa58lC2
	 fTBXhOtH2EOWjSE1n6lhQWHqwEkHHxShv/tedDdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0415/2151] clk: s2mps11: Propagate OF provider registration failures
Date: Wed, 18 Nov 2026 15:35:50 +0100
Message-ID: <20261118150137.170546128@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 276741aac3b56ba50bef59715ba18ba3f0b953a2 ]

s2mps11_clk_probe() ignores of_clk_add_hw_provider() failures, stores
driver data and returns success even though DT consumers cannot acquire the
registered clocks.

Return the provider error through the existing lookup cleanup path. Skip
empty lookup slots while unwinding because S2MPS14 omits its CP clock.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: b228fad50c00 ("clk: s2mps11: Migrate to clk_hw based OF and registration APIs")
Assisted-by: LLM
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-s2mps11.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index ff7ce12a5da6b..1b0e4b5a2f323 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -192,8 +192,10 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 		clk_data->hws[i] = &s2mps11_clks[i].hw;
 	}
 
-	of_clk_add_hw_provider(s2mps11_clks->clk_np, of_clk_hw_onecell_get,
-			       clk_data);
+	ret = of_clk_add_hw_provider(s2mps11_clks->clk_np,
+				     of_clk_hw_onecell_get, clk_data);
+	if (ret)
+		goto err_reg;
 
 	platform_set_drvdata(pdev, s2mps11_clks);
 
@@ -201,8 +203,10 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 
 err_reg:
 	of_node_put(s2mps11_clks[0].clk_np);
-	while (--i >= 0)
-		clkdev_drop(s2mps11_clks[i].lookup);
+	while (--i >= 0) {
+		if (s2mps11_clks[i].lookup)
+			clkdev_drop(s2mps11_clks[i].lookup);
+	}
 
 	return ret;
 }
-- 
2.53.0



