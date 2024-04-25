Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AC9131746;
	Thu, 25 Apr 2024 16:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714064183; cv=none; b=AmB/XYc7PozHsr1hYNuZRLb7o9GFxVkbs2TLituGmfFhf4Ldlipa6KH11CFGJvTxBolOCD+Hx71cbUapp3a1yis5rarayg3xzmqA+JZPO0+A1vKDtntan6mJFlY1ONEdTobwNRTxoLI/HJAHStiSUUWjjlyoDqqxQ0V3KGaW4uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714064183; c=relaxed/simple;
	bh=SXGhBnlcLWFdwE2aSUT7wEcsxWYKFItR1ihqD0HbrNk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=E7YwPzxGlgbkWKVs+hArDRjSWb4mjD8C9evVPn6n6Loss7/cV1VbVGTvPQWRw9rc+/Zv4nV9UN1u6GREFeMN2LTN82ZZqaske9uMERbqwZH5sr5B/l6c3GXgvQF8+8RCmbBqJvc0fnBt0cieu7K645Il1/FRZsr14oX+ipit1/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SXedzSuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SXedzSuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6F4C2BD10;
	Thu, 25 Apr 2024 16:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714064183;
	bh=SXGhBnlcLWFdwE2aSUT7wEcsxWYKFItR1ihqD0HbrNk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SXedzSuhCjqQhQnjFPccHZuxE/yKDIwxVATHRECZco3Ko4VUsEv60lSE+TOye2eYu
	 QqwyN4G9LJ3CluI9Vy+tMrTImddixFCOmcu0SlWNM4cjUfbGEzJGh4yPXiR1TPIZnm
	 S+ncfXh9u2E3hEPp8NZmUxAn3mS7kUOrSHJoAXLlgOklYC0LTCVNDkP353s4hN2y4A
	 Qb8u+qas5+ppBneMSTMei4tbkhYLG11I6G8gs2yuQqLeqL6X+NtsEsqs62/RAdA6oN
	 B6f/6ul9VM+H1I98hIF9GM9GuI0UvXqD4GmlE5CE7rn/LEbmv2FxFacIsa8+NfxL2X
	 tB7LMbWiOSH5Q==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 25 Apr 2024 09:55:51 -0700
Subject: [PATCH 1/2] clk: bcm: dvp: Assign ->num before accessing ->hws
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240425-cbl-bcm-assign-counted-by-val-before-access-v1-1-e2db3b82d5ef@kernel.org>
References: <20240425-cbl-bcm-assign-counted-by-val-before-access-v1-0-e2db3b82d5ef@kernel.org>
In-Reply-To: <20240425-cbl-bcm-assign-counted-by-val-before-access-v1-0-e2db3b82d5ef@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>, 
 Stephen Boyd <sboyd@kernel.org>, 
 Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Kees Cook <keescook@chromium.org>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 bcm-kernel-feedback-list@broadcom.com, linux-clk@vger.kernel.org, 
 linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-hardening@vger.kernel.org, patches@lists.linux.dev, 
 llvm@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1901; i=nathan@kernel.org;
 h=from:subject:message-id; bh=SXGhBnlcLWFdwE2aSUT7wEcsxWYKFItR1ihqD0HbrNk=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGla3aYz4qUdrfPXzgicc4iB6eMTl9Seha2nKj8tnvs76
 c/5sxzmHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAi/jcYGZZutL6S0KV8ZM8O
 Ebvl7kstffrsutoP+bAfn86/L7G5m5vhv/uLuwc3ZTDy7elOXtTQ3P7Wi22vYYusWfX2Yq8Tj9c
 0sgMA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Commit f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with
__counted_by") annotated the hws member of 'struct clk_hw_onecell_data'
with __counted_by, which informs the bounds sanitizer about the number
of elements in hws, so that it can warn when hws is accessed out of
bounds. As noted in that change, the __counted_by member must be
initialized with the number of elements before the first array access
happens, otherwise there will be a warning from each access prior to the
initialization because the number of elements is zero. This occurs in
clk_dvp_probe() due to ->num being assigned after ->hws has been
accessed:

  UBSAN: array-index-out-of-bounds in drivers/clk/bcm/clk-bcm2711-dvp.c:59:2
  index 0 is out of range for type 'struct clk_hw *[] __counted_by(num)' (aka 'struct clk_hw *[]')

Move the ->num initialization to before the first access of ->hws, which
clears up the warning.

Cc: stable@vger.kernel.org
Fixes: f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with __counted_by")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/clk/bcm/clk-bcm2711-dvp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/bcm/clk-bcm2711-dvp.c b/drivers/clk/bcm/clk-bcm2711-dvp.c
index e4fbbf3c40fe..3cb235df9d37 100644
--- a/drivers/clk/bcm/clk-bcm2711-dvp.c
+++ b/drivers/clk/bcm/clk-bcm2711-dvp.c
@@ -56,6 +56,8 @@ static int clk_dvp_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	data->num = NR_CLOCKS;
+
 	data->hws[0] = clk_hw_register_gate_parent_data(&pdev->dev,
 							"hdmi0-108MHz",
 							&clk_dvp_parent, 0,
@@ -76,7 +78,6 @@ static int clk_dvp_probe(struct platform_device *pdev)
 		goto unregister_clk0;
 	}
 
-	data->num = NR_CLOCKS;
 	ret = of_clk_add_hw_provider(pdev->dev.of_node, of_clk_hw_onecell_get,
 				     data);
 	if (ret)

-- 
2.44.0

