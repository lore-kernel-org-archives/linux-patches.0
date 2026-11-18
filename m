Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029646;
	b=pA/2GGCIB2h/dy9kApW0XXD8ShGYHgk6bnZD+o2kg/ehVkWwGpisIUY2CRULkJ9pXUbb
	 snscsRGOY/WOrFEFNAXHrd5c1f+oAbuCViwvjPTU1ZXTN/q6As2Ty/ro4U7ojDDBCZSx0
	 rLK//M3HTLkdRGF4fMr9IrNQENAW9H5at22eEDiw6+f3v9CiUTmpjqV+pqIX45XsbS9Vf
	 0FniDq1537oonElXO0D72R3Ync5af+a0eTwDCLfFcThvzlxfeTT9YqCWwctqqvp6PLa2k
	 CdSCEtrguvdlJQ9qP6UlXkkVUGaQvmR5KKjo4WCgOMgTYs6qxTOb9ssrmYgJRxCTo+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z7tlLqAcvs668jOGQQXOc/6Ie45KlWDUO5t6qD+LfUo=;
	b=dwAwpw+Nv4CJJlzZZr9VO/ZDovnMPW1X/QvQ2yAl2GEIvd/oAiIvlkytys8kh3D0RpOM
	 oGuAhy6Wt2uLWGRhAjCnPZAb8RC5WEnE7h1/SwZALdikEx2lIkQWPpBnvd8LA0KMpz8f9
	 sC9ThJ6RyCmCwyL4wsvKFgS6GFz5d7RFx/M2ilZ/0sxdtyXL9jfYBEqVNrd9gP71O6U74
	 ExgtkIzP5Bs0nqKI8iYEXMNhFXQ9bBvTHMofMtSZVhXecSBc9dKT/7Ibv/G0WCn1aLHx/
	 LQPQD2FbzDJzTjxttwGDRdqqdvSF54N9URl3HP66hV6gpcb56BLqQFKtTKReY270a3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uuHO5gnV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29E0606A330;
	Wed, 18 Nov 2026 19:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uuHO5gnV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CE61F000C4;
	Wed, 18 Nov 2026 19:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029646;
	bh=Z7tlLqAcvs668jOGQQXOc/6Ie45KlWDUO5t6qD+LfUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uuHO5gnVqTFTid79TpA5ARYdgq5b1mLS610qL3g0sY4eTE7Ut73uUah+MNHqCho59
	 b2lAxZpnRPqD8e0AOswnsW5bAZg2tUhV4p95Fpa4pVcWn2/zrHTuMazsMWaLLl8hab
	 SE/cqN+Bzuhbeuvjw0PK5MgvDupoA7mI+FW4zxpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0379/1756] clk: s2mps11: Propagate OF provider registration failures
Date: Wed, 18 Nov 2026 15:41:46 +0100
Message-ID: <20261118150023.556813007@linuxfoundation.org>
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
index 8ddf3a9a53dfd..ce52c3aeb6920 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -188,8 +188,10 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 		clk_data->hws[i] = &s2mps11_clks[i].hw;
 	}
 
-	of_clk_add_hw_provider(s2mps11_clks->clk_np, of_clk_hw_onecell_get,
-			       clk_data);
+	ret = of_clk_add_hw_provider(s2mps11_clks->clk_np,
+				     of_clk_hw_onecell_get, clk_data);
+	if (ret)
+		goto err_reg;
 
 	platform_set_drvdata(pdev, s2mps11_clks);
 
@@ -197,8 +199,10 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 
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



