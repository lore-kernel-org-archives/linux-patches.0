Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062236;
	b=d9ZeybjY2K4XPxIkaHhCefuO97HwHeXMPgQ5TbibIVjDg/LuODsfX6oeXPdiHgguXD92
	 cjKt4UKPiRFxIOKP7XpqYF2/Sqs0KnIiDTOhSqnj1YIv4zOeqQJB1Bge2b79ZWGDvROR7
	 xFuRGr/XuWqLx/dMgQioYvAAN0eNvHE9UAJgZ6UPaLpQ4Q1cCQoPbplpzWW//PIfLcf4Z
	 uUfUj1Wf+YFK8n8X1x2lVw5uzUaBiYf/gz9eYsBlXTDiUFEQwH2g1gR7bZPRCe1cg+r0v
	 keG5RSnsVPS91H2lBwGBefdfvZlpotxRe2xvVf9srd01R5pAa5vVIOtxoMRZU2xLuUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/leA4OKjL4JzS7hzS1sx5vGRHuZNk2kPwc4JlX/H3KY=;
	b=T4JtFLrBd/66aXWcrHRofv7E/dJJHvvZI7jHSGTxjl96GIH8ipZbgrkcgjAePIMjXdSE
	 rUHshXiEvNL8W8dP2TEVhXISFctyXT+pfx7AhzSiKMMg9CKhceqJDeJ+mHJHlSowBY691
	 6Nea5d7JeniWknpeHj6keiUfN3RYRec1ACLATdsclBBSoXtb6UixmC4x/9gRHiLwv2mFv
	 9p1UeYR3HjhioZgaw84zgoLsUDR3Z5n4SnMxMNi7WKOYFctFpHlmMUtOUzPthjQzua0S7
	 dxhBg3VJaDNh/QvKf1n60W5NtW2KVtkM8ps2f/LmdHHRPfnhaQHZGtyTD7BXGMslvHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFKQTsNp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8A5606D827;
	Sat,  7 Nov 2026 14:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFKQTsNp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F088B1F008A3;
	Sat,  7 Nov 2026 14:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062236;
	bh=/leA4OKjL4JzS7hzS1sx5vGRHuZNk2kPwc4JlX/H3KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFKQTsNpKKsJUkxxTvhC2/4o1PfNq7tBv0vO4fwL4tFRwLVaJwMnhVZkQONj45lHc
	 1lt9Tagxb6cGwER0Fe/JV2HaqErxOVFpjmJIKL0OFKSSoaJiSRrmSG6q0xKmTFP+nP
	 XGKLGi+9mmKMqqUN5p/b+hgbsI8bNPqcK3ichDcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1185/1536] clocksource/drivers/fttmr010: Fix clk reference leak in error paths
Date: Sat,  7 Nov 2026 08:53:21 -0500
Message-ID: <20261107135031.026751715@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 277e5657237a92e279ee28da2f5c07902cc6aa0b ]

fttmr010_common_init() obtains the PCLK reference with
of_clk_get_by_name() but never calls clk_put(). If clk_prepare_enable()
fails the reference is leaked directly, and every error path that jumps
to out_disable_clock only calls clk_disable_unprepare(), which releases
the prepare/enable state but not the reference obtained from
of_clk_get_by_name().

Add clk_put() to the clk_prepare_enable() failure path and to the
out_disable_clock label so the clock reference is no longer leaked. The
success path keeps PCLK enabled for the lifetime of the timer and is
left untouched.

Fixes: dd98442e17a6 ("clocksource/drivers/fttmr010: Drop Gemini specifics")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260915045426.1726805-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-fttmr010.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clocksource/timer-fttmr010.c b/drivers/clocksource/timer-fttmr010.c
index 126fb1f259b28..0003d49768f62 100644
--- a/drivers/clocksource/timer-fttmr010.c
+++ b/drivers/clocksource/timer-fttmr010.c
@@ -292,6 +292,7 @@ static int __init fttmr010_common_init(struct device_node *np,
 	ret = clk_prepare_enable(clk);
 	if (ret) {
 		pr_err("failed to enable PCLK\n");
+		clk_put(clk);
 		return ret;
 	}
 
@@ -432,6 +433,7 @@ static int __init fttmr010_common_init(struct device_node *np,
 	kfree(fttmr010);
 out_disable_clock:
 	clk_disable_unprepare(clk);
+	clk_put(clk);
 
 	return ret;
 }
-- 
2.53.0



