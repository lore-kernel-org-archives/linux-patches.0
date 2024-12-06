Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E0553A7;
	Fri,  6 Dec 2024 15:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497442; cv=none; b=S0zcs26b2l2/LsI/PpnmwRwlssJ5BRFTsOKJX8eP2nN00hRlCofHWZMERcZYofYXyHPPdz3pOUflng0rv8iOJvymx6Ucb5WmKs9jFDy3W6HFf2VeT9ysB3Jy8VgEzcMT9jzwBGLj5XKQCLXE/vGFx+OdTGIj5hFd/RcXSVtzK9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497442; c=relaxed/simple;
	bh=9hc4PXkQgnwkiD1J+cQkTj5N8oo95VRZs1d21F5wED8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILM7nSRGs6Z0UU4de7BKzA7aKd+7SCcjsPLqK19UD1HNlkLFG4B6gvfRPG7dA2hS6prJNmEnxlxfMJT6US1jrKhnfBV6lvSlAfeNmsFaG4+Eoy7bT+3vb4d3Vq9eudlp5K2JyLYdAsa9Xh7WxdQQptriHAuFjcqZr+3mhJ+HdrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxG77vyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxG77vyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EFEC4CED1;
	Fri,  6 Dec 2024 15:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497442;
	bh=9hc4PXkQgnwkiD1J+cQkTj5N8oo95VRZs1d21F5wED8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxG77vyPTguQI2GUihLeP0WWZWjFGbnyANak0klEVHt2b+zDeHjT4/ojGq9Eccab3
	 HvrjkAQS1kMFDaJnxXzr6Q6oTQmRgKyi8mtAMUndqSaK/ovnjxcnu//tH8udpcyIA+
	 0WviAhJn0rQOaou7r4viPE7fvvKqh4WeCFzNeejc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 294/676] clk: imx: imx8-acm: Fix return value check in clk_imx_acm_attach_pm_domains()
Date: Fri,  6 Dec 2024 15:31:53 +0100
Message-ID: <20241206143704.826614669@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1c95ae905eec8..b9ddb74b86f7a 100644
--- a/drivers/clk/imx/clk-imx8-acm.c
+++ b/drivers/clk/imx/clk-imx8-acm.c
@@ -289,9 +289,9 @@ static int clk_imx_acm_attach_pm_domains(struct device *dev,
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



