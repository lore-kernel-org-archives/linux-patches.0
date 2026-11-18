Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017066;
	b=EDpzmok3kjud8jjcJgaeWMlOIZgpTbTdfAM6sll2/Ej9MiiS93PHspGbB31Eg45r/W9y
	 Jw19WizQPUFLkcLaPtOZFioy8vIWYrWrp5Lq32TwTiUwiyRJz4JEngw9GHBMa0pmJ4CJe
	 OCj0iLATV3XuahYN9B6VtU2HMl1hWTBN/4HI1N16tn6nRbnZLCp1rmdbQ0AS6yQNsPQ+1
	 xpfxMqE7c0TMoRsquxkrCc1iJhPLBCqFYfaHSfAOm4sQoKwA2qKw8hS32aLecd7zMedHB
	 yl/1SwWW+/EPpng2XQLDpR3USoXAPdNZL9Zq6qn561Me1GvFzyfc2YMM9Upk5/Qo/Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yNuNi+mM6wOWMvdixME4bjE4H/OUrTb0qL1aNSBt0Pw=;
	b=sjEhyKvVBDFgTkUc38YzZpmJTUf/0CvOT1jO5zGqTEshoUwWqzstdivF11077bw3MyGv
	 AzewwKdZmy4yjLXf0JcucAhhv3okoZ7VJWh3EDU8cFCyj5F+0ge0WD8XlHjPHGzJe9NZ9
	 3NwVfGVGaBDTnsklc4o8fvz70Qv2VlMVPqmlWe/Sg6cDSmHKfMp+OqjmAVpIt6FoUkAAu
	 fqRsApCP92Tg6oN6L7UzLJy5y3nZD0jhwIDDiEVm/eaTYcQ53AEhsYtncdswoaD52POY0
	 rQJcgcPmE2cZVZTG1Cxm+SKKFS6rA9d4St3/xxkYRWQYVomE0oAhbUcTc9CX5b7ZtxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhXlgDJO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD97606A320;
	Wed, 18 Nov 2026 15:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhXlgDJO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E201F000C6;
	Wed, 18 Nov 2026 15:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017066;
	bh=yNuNi+mM6wOWMvdixME4bjE4H/OUrTb0qL1aNSBt0Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MhXlgDJOoTSu32NAc1R86qRZ6wKUMFQvgIbd4Ofu8strA1BkqaPN5s4KdyyH3V3rI
	 mYzFDYqnX9WwpuKYQ2qNnkDGRaYX4A+5hCXP9PSA7tj0aLA0cKv4B8pA9MvjZEuWNw
	 jAwiuSB41f+7rLxN1qrmKdUZlqVd8thZyypK2Pg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Esteban Urrutia <esteuwu@proton.me>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0753/2651] clk: qcom: dispcc-sm8450: Fix disp_cc_mdss_mdp_clk_src ops
Date: Wed, 18 Nov 2026 15:33:13 +0100
Message-ID: <20261118150314.986599861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Esteban Urrutia <esteuwu@proton.me>

[ Upstream commit 8464e2284fec42d9fd05f3109d8b209d65864ece ]

If the clock frequency is changed at registration time, a flicker will be
visible at boot.
Switching to clk_rcg2_shared_no_init_park_ops fixes this.

Fixes: 16fb89f92ec4 ("clk: qcom: Add support for Display Clock Controller on SM8450")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Esteban Urrutia <esteuwu@proton.me>
Link: https://lore.kernel.org/r/20260713-sm8450-qol-dispcc-v3-1-56fd05822270@proton.me
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm8450.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/dispcc-sm8450.c b/drivers/clk/qcom/dispcc-sm8450.c
index 3af120e54cddb..c7e04bd315d5a 100644
--- a/drivers/clk/qcom/dispcc-sm8450.c
+++ b/drivers/clk/qcom/dispcc-sm8450.c
@@ -613,7 +613,7 @@ static struct clk_rcg2 disp_cc_mdss_mdp_clk_src = {
 		.parent_data = disp_cc_parent_data_5,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_5),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_no_init_park_ops,
 	},
 };
 
-- 
2.53.0



