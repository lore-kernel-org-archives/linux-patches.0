Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2DB381B1;
	Tue,  3 Dec 2024 15:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241431; cv=none; b=YJIBYjatLdRx9bHggNWVwPlNjLhj80+9r/nR99DgA3E+3x0+3oB4JbNK3p1SLBeu/n66JB05jN8Qc5mMbCMKLLXTdhMcrhYYhJjgRqyVA/VMuNO2vSv59S7DUWL4Y+NeO12OaP/MpNRaeCNFQ6whChQU5tJTdu6ppCPB9K/7/AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241431; c=relaxed/simple;
	bh=VA1RNUaEnji6e2umlhprJnxOjM9oN6mRYfxCYzSiJRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfGNHWbqivBMsn6av7ru3kTgdfzPEVQV9oYMeIZ+SnnTvnDjo+ViHX/gHysU+RT572Fi9RW4ZmeR5puz1vrB81NJdztO+rtFAlQi+n3SezA/M2OvQQEVXTPywDEC8+Sc85i5ygBSAzaIpt2DI7mY4bPaYLvFbD2xsKffJV71VB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTLmuzLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTLmuzLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9396CC4CECF;
	Tue,  3 Dec 2024 15:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241431;
	bh=VA1RNUaEnji6e2umlhprJnxOjM9oN6mRYfxCYzSiJRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTLmuzLoluyHLkR9gIG0UBYC0WNs6nEdVp/4QnADjFyBIqIY3kXvTOLI7mfellWuM
	 2HWZv+9i+gEiDhDiVrjP46rI+f+3MFk7qFEJO6G+NRxZ5JwnJsOhjcGKFbJ7J4l2CO
	 gQrrdbgKb556raQRKJ3FBVy5v/dEz+eXhTkhKZwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 409/826] clk: imx: imx8-acm: Fix return value check in clk_imx_acm_attach_pm_domains()
Date: Tue,  3 Dec 2024 15:42:16 +0100
Message-ID: <20241203144759.716850978@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 81a206d736c19139d3863b79e7174f9e98b45499 ]

If device_link_add() fails, it returns NULL pointer not ERR_PTR(),
replace IS_ERR() with NULL pointer check, and return -EINVAL.

Fixes: d3a0946d7ac9 ("clk: imx: imx8: add audio clock mux driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20241026112452.1523-1-yangyingliang@huaweicloud.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8-acm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8-acm.c b/drivers/clk/imx/clk-imx8-acm.c
index 6c351050b82ae..c169fe53a35f8 100644
--- a/drivers/clk/imx/clk-imx8-acm.c
+++ b/drivers/clk/imx/clk-imx8-acm.c
@@ -294,9 +294,9 @@ static int clk_imx_acm_attach_pm_domains(struct device *dev,
 							 DL_FLAG_STATELESS |
 							 DL_FLAG_PM_RUNTIME |
 							 DL_FLAG_RPM_ACTIVE);
-		if (IS_ERR(dev_pm->pd_dev_link[i])) {
+		if (!dev_pm->pd_dev_link[i]) {
 			dev_pm_domain_detach(dev_pm->pd_dev[i], false);
-			ret = PTR_ERR(dev_pm->pd_dev_link[i]);
+			ret = -EINVAL;
 			goto detach_pm;
 		}
 	}
-- 
2.43.0



