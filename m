Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040082;
	b=SQdl11QqaX3quEw657WCBbeTdQpJ6f0xKrcSl2Qw/1TE/ydolBoHuxQkZqWj4x9NOIs5
	 aXcWSMdIGGXTSPH4CgFw8uL9Gm0JV3l3+mlu/PwfLs4e/APZtIAFThi/kqe9iB0R9i7Kv
	 O+XdNDYM6C0RvcIPMfKb1i3tGv0tJnV4ZOx5oqG3AB2FVVlXkowT0Q+BJwt2mWTcwMPu9
	 z52wsNq9BLamgFY2TRQ8iR1O1RdO8PgscVgj2+Ps7fPEt8UmQTHqWp5dwez7DL7DWB1kw
	 0EoGAbwah4K2nR7xpTulwICAejkuzFThLHXsSAxiTlrH5wnOsauwy1FDWnKPIIKczPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6cE8AfWJoisxv5OlopULy+ox0meQulYt6ltn3/3cAKg=;
	b=EpaOID+Dpyuy+TziR7vTy97jcG7PXP+PJS9nRKAGwWKzf+wxn4Mq7JOJ40vYqbnOI7Kj
	 +2tBsEOEt7Je6G1j2tK8+9K9uXaGacUfxJjJ8aMWL9c2o1jTy4RppILhLvlYAi6fdQ+9f
	 UAj0JLH9bkAHCVx+rSvTfgqshb2/3MKR+GUzzvJpsj0aQ+LMQyze9OoWBx/3xQrHS1BPD
	 CIhnq9Dn2OV+l4ECcy2OfhIpPDK2FE+n8BFXkCMGiaU1YhY2eO3CAzOzpXiSUuo3uuM4T
	 XWuqG1FwUGj9mrImUzmEI36BstO3HpSb4oy8CLcBWFbZ3pFnfDGnR3x09XMFcDScCfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QPzoX4AS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD44606A320;
	Wed, 18 Nov 2026 22:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QPzoX4AS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581611F000C4;
	Wed, 18 Nov 2026 22:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040081;
	bh=6cE8AfWJoisxv5OlopULy+ox0meQulYt6ltn3/3cAKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QPzoX4ASacASTODWlTlV9S8ebRV4nXeAgfJtUqczVBC4xOoUzcThf7mLihf5tfXV0
	 CbyvMQLBLS2YxXK0L789+7ZwsanOw8EmqkgEn1qY2tmKrjA/hLg00s/BO2ZU8Kzhlw
	 s5i0fOe0uq4T7Top/Mq2XSEZr2P/XpaUF5QGIYxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Esteban Urrutia <esteuwu@proton.me>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2331/3318] clk: qcom: dispcc-sm8450: Fix disp_cc_mdss_mdp_clk_src ops
Date: Wed, 18 Nov 2026 15:49:13 +0100
Message-ID: <20261118150431.579600594@linuxfoundation.org>
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
index ab796f4f0ac03..e49eb7e70cd8e 100644
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



