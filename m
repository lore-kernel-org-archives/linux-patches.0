Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC629425CEE;
	Tue, 16 Jun 2026 17:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629492; cv=none; b=PqbjqaKBw40H1Hhu7YcuEwPW7NcbalLl/u3gq/df08RTJSskf4htXYyVN+zdKyN69gc0B9Lc0oTvBXoKiqiEiRD0Jzno8j/Qkt4yWeAB0knYCeaJTADUzUEfW9P92m0QYzKz8WtzR76NiFrDWRecEMjBD+y0VdGCTGdoY2TRMyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629492; c=relaxed/simple;
	bh=+I1kCeE+qT/rD9g7fyv9tV/WzHavLLfRPNxoei5JKCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Se5oSG6gUoWZ8J2ra+J8xMzkJNFFTnx1JvD+3KSZPhaVW2DnC8l/tnDUvlf0NrVoEgPlPMCVC31ZYCzd0/WJf7bAGNbjiP7YQ4HnEle66LREP5Q1Nqaf57TXGtYf8b5GtLezB/laaQRjibMDF5Cxs/JyN1YSZyA0sgo/GPPmalU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXDCELVt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXDCELVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1A51F000E9;
	Tue, 16 Jun 2026 17:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629491;
	bh=FFxI+ZyVzobVcsqe9WiKdYEwPc1Jzz/961f+oAV5Ts4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXDCELVtG5FeO1g/DdkkzWKpcmM9wzzM/use5mWc1WP3T/m19euA8MANS73851Rfl
	 Dj+CVOPMP0T8ZCpDMPxMt4d1FUVZQtQmTwiaTs0b0ZXvvf3EZnonO//0QdhH11Tlam
	 AMGVlDy7FIUpG9HnUIb4azDCICkYJTUrIrK0B4gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20de=20Bretagne?= <jerome.debretagne@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 288/452] clk: qcom: dispcc-sc8280xp: Dont park mdp_clk_src at registration time
Date: Tue, 16 Jun 2026 20:28:35 +0530
Message-ID: <20260616145132.716648189@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit 5285b046757844435d1db96c1b5c3a6621b2979a ]

Parking disp{0,1}_cc_mdss_mdp_clk_src clk broke simplefb on HUAWEI
Gaokun3, the image will stuck at grey for seconds until msm takes
over framebuffer. Use clk_rcg2_shared_no_init_park_ops to skip it.

Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Tested-by: Jérôme de Bretagne <jerome.debretagne@gmail.com>
Fixes: 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon registration")
Link: https://lore.kernel.org/r/20260303150152.90685-1-mitltlatltl@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sc8280xp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sc8280xp.c b/drivers/clk/qcom/dispcc-sc8280xp.c
index 7f8819ece5eb01..40fc57eb9f7981 100644
--- a/drivers/clk/qcom/dispcc-sc8280xp.c
+++ b/drivers/clk/qcom/dispcc-sc8280xp.c
@@ -978,7 +978,7 @@ static struct clk_rcg2 disp0_cc_mdss_mdp_clk_src = {
 		.name = "disp0_cc_mdss_mdp_clk_src",
 		.parent_data = disp0_cc_parent_data_5,
 		.num_parents = ARRAY_SIZE(disp0_cc_parent_data_5),
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_no_init_park_ops,
 	},
 };
 
@@ -992,7 +992,7 @@ static struct clk_rcg2 disp1_cc_mdss_mdp_clk_src = {
 		.name = "disp1_cc_mdss_mdp_clk_src",
 		.parent_data = disp1_cc_parent_data_5,
 		.num_parents = ARRAY_SIZE(disp1_cc_parent_data_5),
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_no_init_park_ops,
 	},
 };
 
-- 
2.53.0



