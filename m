Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064153;
	b=a3xfTbrJIkeOyU+3+M0ZAbabWuzRzVeYNCeKivnDzNtN/LQe2HCWAlyvD5O1J/ndTq+v
	 T5TLRD8YaDtzQFaxOfkRYBvwmRMu+PF/Wo2BSXOkmWN0qpG0t4AuIJRKr4lDAZfinopq3
	 7FwSqvxjg4nNF+ABLyIs4/fU/x5jchmZ7LF3Cb7ndCV79AgF+NW0wGbY44t0+sat+hfbN
	 KMCulwtHW43EerwjIURNyu5OmwFRQ4x2TwdUFT5m+r7qHpLvnQBFpS9ScOmwZ/rBjLcEP
	 BKQaSfmdsxjfeBBBAsk1IrXJUM7HQG/0WEg7IZcI6ZAq3CWN79DFfUDptdQxQdYpRsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7cQJdBifIsGrV9vSjsbiZRZiqEyJedf96ZqrKF2SaUw=;
	b=hRv1I7HRyIhGCza46tusqDhzqeIUZrILnyXNbvd/JfYN9hjT3eJS+tPT8gvMhURp4j+W
	 Td69c5zG8OUZUT4ruHjPrwvClptCGYANNwOIQ9t9/TdTqc97l/DAsDSqGouu/Gf4Wxoeu
	 szAyG6qPDNA399ZRthf6pNlTGJJPAg1ay4VE3x4/BRWJgAQKSEnnmnpBmNOtJTqj2eQlF
	 3Xp71R9ZZNJD864QJ19eM2UO4VqAwsU7vlR0eXgXOkL8T/KyBvtgYRw9ptThGul1NKL4M
	 pSPWmZSOjpwtdjhWxx0nP2uHQySQ1z8PfPBSP3LR4d5YFbKI1t/qPiBH1nlYb2qjdSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vLG0yLiG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CF5606B8AD;
	Sat,  7 Nov 2026 15:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vLG0yLiG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7236D1F008A2;
	Sat,  7 Nov 2026 15:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064152;
	bh=7cQJdBifIsGrV9vSjsbiZRZiqEyJedf96ZqrKF2SaUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vLG0yLiGojkrNtdIMxoNj6uZgiX4gGrsZL1Vh6cVAGWB3I3BXNvf2lNgTgcsXLxT4
	 ojFtD+qmBnAMf9c6KCqDx91VR7WZvaymqORGD8cTOBWnLJKVLMp7BCaV/ue/TEYkI0
	 NlPwqr7chtORnWzoh+8AgdPDSeczH+WOY0SsJvvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0302/1257] mtd: rawnand: nuvoton: fix clock cleanup on probe failure
Date: Sat,  7 Nov 2026 08:43:18 -0500
Message-ID: <20261107134947.794171367@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 8a485a40f45a19c5fcafb5cbee7387c2762af7c4 ]

ma35_nand_probe() gets and enables the NAND clock with
devm_clk_get_enabled(), but the ma35_nand_chips_init() failure path
also calls clk_disable() before returning.

devm_clk_get_enabled() registers a managed cleanup that calls
clk_disable_unprepare() on probe failure and driver removal. Calling
clk_disable() explicitly first drops the clock enable count, so the
managed cleanup attempts to disable the clock again and triggers the
clock framework warning for an already disabled clock.

Remove the redundant clk_disable() and let the managed clock cleanup
handle the clock state.

This issue was found by manual code inspection.

Fixes: 5abb5d414d55 ("mtd: rawnand: nuvoton: add new driver for the Nuvoton MA35 SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nuvoton-ma35d1-nand-controller.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/nuvoton-ma35d1-nand-controller.c b/drivers/mtd/nand/raw/nuvoton-ma35d1-nand-controller.c
index 1a285cd8fad62..f659d3a6b9ef4 100644
--- a/drivers/mtd/nand/raw/nuvoton-ma35d1-nand-controller.c
+++ b/drivers/mtd/nand/raw/nuvoton-ma35d1-nand-controller.c
@@ -993,7 +993,6 @@ static int ma35_nand_probe(struct platform_device *pdev)
 	ret = ma35_nand_chips_init(&pdev->dev, nand);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to init NAND chips\n");
-		clk_disable(nand->clk);
 		return ret;
 	}
 
-- 
2.53.0



