Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039806;
	b=k3zaV46lz/gQ8wihwLE8vKwMuojSeZ7p6Z+CGlprhFSKaoeU2pVPc65UHzUrQf5szxwR
	 u9QgHMZFl/9/+/LATo/Mr7p4zkZKSDv1yBq1U0ZLd2is3iel5UalYrCFcZzLnxF92vh9P
	 HdvcEJlgI35oJ4HSitFUjej/j32SZy8YKLK13UHrshXtQN5yiScJEJJCmJwFzjsfxPDjg
	 65uvd8/VVO/et55dYCgR88v1SaGlDbMeXpM87aoP6ChDCLgqckPqrLJvjG4igzV2J6NJ1
	 Mo1DAxob3RFPGrpumiRTFJjyShtaulAZrLcKFen9webSMBah32B3fIC/tbp5hRP1Npw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j80eycmKaD8rJtmD4qN3IvDQjaAcBpmtT3enB1bZ5Qo=;
	b=oUy7JIyL4BfNrh6ueIsUsNNM3ucp9EVeZ1nzEbz6X9X2l2KkVQF7eRp3lUrhWvvqkAyR
	 KVqgbYKMkXt7dpsmHEp81IT6L2oh67NIZxNehh74sJL8CpqgeD8NvvoS50huH9EEPuktl
	 UT6eXF36sWgLZzjXocwaX6+tnH5fROssFZ3BvqVtt6ILwUtXdkvlKPKdQya/CoFhHG06/
	 8FTmqgJTaDJYskRBUainUiQycb5a1z+SnmqcYensa5QyzI6XrCh5jQSuWaIrTtT+4+qh6
	 sIB51ytvJ+GG+8P73K9fJY1LLrAWMOdTmk9T4JKg4UxHdX1PTAfrlJVEDIFPkgJ4gLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0mjLmuhQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA19D606A31C;
	Wed, 18 Nov 2026 22:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0mjLmuhQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B96B1F000C5;
	Wed, 18 Nov 2026 22:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039806;
	bh=j80eycmKaD8rJtmD4qN3IvDQjaAcBpmtT3enB1bZ5Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0mjLmuhQRJYS6IjfREDhID4EyFDLA1dbU8oNbIQuYYBDJOfZCEi+j4TI+x8wNpn3W
	 srTXeXEx6dozCTlt4Co2OYuCz0kHJJxQO5kpmXUTK8NfnGLMaH0cnTI6wSFHHEj2aK
	 YR7iMkn5SZ9A2yLJupRoNGOTWBaMYEVVeVwo9AYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2191/3318] clk: s2mps11: Propagate OF provider registration failures
Date: Wed, 18 Nov 2026 15:46:53 +0100
Message-ID: <20261118150427.681451215@linuxfoundation.org>
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
index 337144570fafa..687572bc17e68 100644
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



