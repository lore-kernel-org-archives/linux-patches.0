Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024285;
	b=YJTwmJA6hGztcAwN8ZzKQPlMBa4lMQ6WmxNimNH8dqP08gD1Vs+nMGdaXKeW5RORK0en
	 wW5o/eyN9S5jmTec0wl6jNYY+Fjx+Tii9vCKsM6zgayKRTG4hu2qQpNQ8qr0Ka7l1KA79
	 KjNAdXj96GPXDbmaRNI0hpzGrxZuzxfb3+YwhDUK5+gBkGbO/xUm6ki7BQo+K4hq4KtpF
	 7DiN+6sxQbyEjOgwC7vQQDZ3kmwwbgy88Y/AgnmtK2Sc7WANNWzpfxGBcn/W2ZrgYl5XG
	 6Aeo1yUMUGq6SPxQfq9XjTVnd854iWWwnsH3FD9cLCBQRJ514K/VsLvJn9cFgF8Cd1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FgUk63BQhJWWLODEiafR+M/TcLDWjRdd0GknTfGR+s8=;
	b=dE4RGz4O9hW3xowFQngu0txDwpVXwspE0TZKlrjV7FFHcTakUsQS2fTEoHUqoSRMR3T6
	 rNX4xEcRWA1NQtAqT5xEEgfggfhovb/Xvubh/j9TyTrs8b84gHNUKuFUOme6djbHV3uiG
	 ue2ZNPyZSzg81ZKvkb23Sj03QxlS1MMtLllOlhXLpXoHhFXqF4AIvNPxFd5N0y9x4YrH1
	 pQUn3UPjcBvjQy1varq11UtdLyreq8T0uZzGvA2e5acB/kIEHydWMDd2KKFnhdfqIyJSt
	 FEDz9MqtKYL0z/QT5HEW+lbYMHmy/7jgJ0IZasq6D/ukNHuCLbLc408/qGxMLCJ8o5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MNG/i7Aj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8532606A320;
	Wed, 18 Nov 2026 17:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MNG/i7Aj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E2C1F000C5;
	Wed, 18 Nov 2026 17:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024285;
	bh=FgUk63BQhJWWLODEiafR+M/TcLDWjRdd0GknTfGR+s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNG/i7AjjH4r5QFvIBZIGiEjzFZFJa0GGF30k9gv3IHNYq/V0drdG2mYMyegyMmxW
	 dDBKcq0J+WcCZ3hLsraeEjtoB/go0XoLv+/ySQXU/6QBrvhjW02WeYSlGMnDch4O/Y
	 TTc2IOhkyhT26AvOzuCezwpwd1KQ2UVcmQPMY6tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Esteban Urrutia <esteuwu@proton.me>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0671/2151] clk: qcom: dispcc-sm8450: Fix disp_cc_mdss_mdp_clk_src ops
Date: Wed, 18 Nov 2026 15:40:06 +0100
Message-ID: <20261118150146.263026201@linuxfoundation.org>
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
index 2e91332dd92ab..251b53dc08170 100644
--- a/drivers/clk/qcom/dispcc-sm8450.c
+++ b/drivers/clk/qcom/dispcc-sm8450.c
@@ -614,7 +614,7 @@ static struct clk_rcg2 disp_cc_mdss_mdp_clk_src = {
 		.parent_data = disp_cc_parent_data_5,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_5),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_no_init_park_ops,
 	},
 };
 
-- 
2.53.0



