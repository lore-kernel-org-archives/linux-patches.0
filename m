Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A3F3806B8;
	Tue, 10 Mar 2026 11:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141647; cv=none; b=omTbUojm4GICoszlkvITt+h35qmZkcIsHfHKEtKr+tPnJTMBLaXCQrjBbrjy15wWtviz2pCXGJPFEKzNESdxyK5+botSbk2n3sR3ZSBZOOvIDCH+yYXaYQEKIzfvSUcRWyk7lRTDqmRryEOQWePYVKCufKM1DgzfORiBdWue4rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141647; c=relaxed/simple;
	bh=3e7TQKccLFwilDSKd9WJX2HmRo4WAn+2kEV1gm2wQxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plAV8Q5w13i21UTyzljiXZsqrtztVAMfAsqUdDaCiyvCaC2CVMTLulywoxhWgDX8OH3ul6Bnf0+tQN8ovkydnofDVujd0+EVTl18ku5b28+thilG7rlPUr/c66N1rPPJEaw9bt7fk3w6H0tmgRAxpPCyDXypxfSRb90mMyOjGaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJOYdS6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJOYdS6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E668AC2BC86;
	Tue, 10 Mar 2026 11:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141647;
	bh=3e7TQKccLFwilDSKd9WJX2HmRo4WAn+2kEV1gm2wQxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJOYdS6Wn6mrZqBlt1bh4JfbtnMSlJPmQaef+7Cff50Jdt/ckRNg1SE/sIxViP1+M
	 +3JyTSt35jMLUhjuSLoWp3de37qB0cxmrpyYvuEOrWzw7N3HtDK5UUYXwNEVll49kW
	 7cJcQEP8qAFLi4pbiKw+BtnYUrNFqGszik5uGLW4zNuTwavQGoMOIzKr3wIR7tZ5OO
	 W8nHw6OTttG5c2A3KO+ugoPh55peYSplvnaTUsqClEAFsOb0231uDTo/yE8l6+88++
	 xnwPNOlyJmXyiR9LlwFKJj+73eNM05QhL+KzJzvblCychAd7T7qJMChIk20IAFlcKT
	 5aQn9ZYuhJO0g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen Ni <nichen@iscas.ac.cn>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 013/314] drm/imx: parallel-display: check return value of devm_drm_bridge_add() in imx_pd_probe()
Date: Tue, 10 Mar 2026 07:14:32 -0400
Message-ID: <0d61471ace630b804374d43f14cddccd00f2dc2b.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit c5f8658f97ec392eeaf355d4e9775ae1f23ca1d3 ]

Return the value of devm_drm_bridge_add() in order to propagate the
error properly, if it fails due to resource allocation failure or bridge
registration failure.

This ensures that the probe function fails safely rather than proceeding
with a potentially incomplete bridge setup.

Fixes: bf7e97910b9f ("drm/imx: parallel-display: add the bridge before attaching it")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260204090629.2209542-1-nichen@iscas.ac.cn
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3/parallel-display.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imx/ipuv3/parallel-display.c b/drivers/gpu/drm/imx/ipuv3/parallel-display.c
index 7fc6af7033078..d5f2ee41c03fe 100644
--- a/drivers/gpu/drm/imx/ipuv3/parallel-display.c
+++ b/drivers/gpu/drm/imx/ipuv3/parallel-display.c
@@ -256,7 +256,9 @@ static int imx_pd_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, imxpd);
 
-	devm_drm_bridge_add(dev, &imxpd->bridge);
+	ret = devm_drm_bridge_add(dev, &imxpd->bridge);
+	if (ret)
+		return ret;
 
 	return component_add(dev, &imx_pd_ops);
 }
-- 
2.51.0

