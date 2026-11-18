Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030003;
	b=rygoCTTv3FSCo1SGxIek+MDnUVXEGZuVf1t50uVsP3wvo1K+MMeHt1+fnrULfYXyHc6p
	 WkBFuJyUzrh+T3r01eAhsVfR8Bw2+o3Tcb4uY01ovprHnsb1t/FrTZ2KyhA9VUTzUCrBF
	 wbhrIv+LlyDGLBG7NpNhonM5fMggYEUBvfPSDnigsJqgF7tIUJnsptlbYUDdSQ4yNrnHx
	 qwnwfVua+y2wcWESgM/FTkBYXPcqCiCQso3bguyDjjND+Ti1GGBP4ZOJS6hpjc0Ccsi95
	 LygTQZQWXiczk6LkqH2OsAFYTMmqDyy9P4Bj1daE4YieLKeRpILD/Av/QgOPxhWVpjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bWNNN1OHSJjPsZOjYvR+7zYQ1vS8G9BcC/V444NG0LY=;
	b=zaMwFnQw0GSw4ckY2haKkuKusbikaYjCWyImrK6vZzDYsfGDMItx7eI4ieTk5u3pVkS4
	 dB1BYIKYqq9udXaEKGZZqzSpS3ptR3bSeRhiNNFDsW8OlFVoEkpwUV7/+h7vUxgkOTnK4
	 JFZdCqWLGjSOfRf0G+7ZfnqZ7z3IoNfooJ7rkBD8FgA5oJ3Hz7deEGEgyHEtnXlPucsix
	 nvGqcyyebesp8gJuAvzMtrKQQBErs/Tb2uGPSTr8D4qt9dDrxE5SmFn5C4gBUC3JG0SFy
	 lQzyfB7bf0dsnhU0roEVEwxvIcOMJa0mi8uQPsVjHeg3Ju3mam9yya7j2uLA7CXgFRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ND10ZFpK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4FA606A32C;
	Wed, 18 Nov 2026 19:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ND10ZFpK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7701F000C4;
	Wed, 18 Nov 2026 19:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030003;
	bh=bWNNN1OHSJjPsZOjYvR+7zYQ1vS8G9BcC/V444NG0LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ND10ZFpK7FzAEa2E5OoJieV4frtnrBf5Ec4RiBNs2do3JL7tfMPrRRlYj1seW6cDA
	 FBX9D4M66cYjOQ0Rv0O4PXkD2Z9KA2q+AqaFHYHJYDXn7aO0FY5AF6Murt0V3uUkgD
	 kYjlN8Q27FDzurZAfMdBuTKF3LpiT6N+q4LuOWVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Esteban Urrutia <esteuwu@proton.me>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0549/1756] clk: qcom: dispcc-sm8450: Fix disp_cc_mdss_mdp_clk_src ops
Date: Wed, 18 Nov 2026 15:44:36 +0100
Message-ID: <20261118150030.981192679@linuxfoundation.org>
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
index 8baaf94a119e3..8bb49da19bf03 100644
--- a/drivers/clk/qcom/dispcc-sm8450.c
+++ b/drivers/clk/qcom/dispcc-sm8450.c
@@ -569,7 +569,7 @@ static struct clk_rcg2 disp_cc_mdss_mdp_clk_src = {
 		.parent_data = disp_cc_parent_data_5,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_5),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_no_init_park_ops,
 	},
 };
 
-- 
2.53.0



