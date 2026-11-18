Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048666;
	b=roI41vO8SmjnVUnnx06hlTTYxDCKCeJXRh3umWnzgQcCV9+EctZS+IKxyU+IoPL8q49O
	 XiNf/DkED6DkCi2rhwl8h4eypX830XM5gH7ODqTsIfCw+2VEqMW76Co3cbkz9f6ew3/Hl
	 2ZUD4OBBlF1smcYaJkTgE7yOOrJ+t9ekY9q/w3LCFiQc25Nf3BLmsA+QnY/3tWRyz16pI
	 4yhl2KJknHlXcIcXQ4VnwolkVwgJJxpMEfhqVjeIaEQTK1CLlADoQ30RDlkSJ1jiuTAw2
	 IcLbHonc9xbP7OehXqoIV0jtnIYvhJtRwqJAZoZk2oye4ScvoJc1pJ7gA+nj8/J9MRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6YmFPxf0Xmy1gQetdH7voN9JacQQUcpMQWZTNPqnoYc=;
	b=ZJnKQ1o743ZbeQ2vNEu4zlMUBgoMU5xi4l93oC06LDbwlRJAlrD2c53r/FZxNouPJHN6
	 X3NpTHSAGOvYEbtesmwFdgxuPj4PP/GH+NuSjvJhlo/SgXUZCe2fjYoocd+PvVYw9BbDZ
	 vHe9bgClwXqvVDOKjFqoaktI8+EMqyCezUQKO6Ibc3TIOWIrrYvWvUsJ2oGcO6qjDWzEu
	 O6Z3kFGZKpmcL/L5JERn1poKbcrA2b1mgsY96AhVhvxFcu2XRp863xNzvrCkYTiHWtDKt
	 AG/Ur1lIt6jRS0oIfD5PldxFEzzOoM7dIb9xYgyvnFLqfvqTiAgFVt+03xn70oB4EaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fgf6kFsb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A88606A32A;
	Thu, 19 Nov 2026 00:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fgf6kFsb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783221F000C4;
	Thu, 19 Nov 2026 00:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048666;
	bh=6YmFPxf0Xmy1gQetdH7voN9JacQQUcpMQWZTNPqnoYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fgf6kFsbJ2rxSFTtOd9f82gnFRByNmfrdVnQ90BuvqSUkVpXr8/ZvsF+iLKdF95zc
	 cB5oUNx/Gjm4CL/QG8dVcCSRhbG3itiBuTF1OUAaXi4dz6vvh1JRoxcNir7XgATqYz
	 WU9SOS0wtkRMS3JQmQZzaC4Dk2+HMdRnoI12cR6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Esteban Urrutia <esteuwu@proton.me>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2036/2857] clk: qcom: dispcc-sm8450: Fix disp_cc_mdss_mdp_clk_src ops
Date: Wed, 18 Nov 2026 15:51:10 +0100
Message-ID: <20261118150314.715851227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index e7fab9d38f85e..62d44372d4633 100644
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



