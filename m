Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DD91F8910;
	Tue,  3 Dec 2024 15:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238882; cv=none; b=lgc3Dnpxb2vcByf4UED/WCaMz2Sn//CVEPL+Hex/dJnBO9RTr/aDbnHDKDOX5AbasiKan1hq9gK1HOMUa4EQuseActxsE37WYDvFJpg5jaYONi5giQUXhvLa7kv7UvLwKeVE8cqf9rvlpc2Km4fpLSZzCGJbl45ApwQj1k0s07s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238882; c=relaxed/simple;
	bh=ECjP2yOZjFcRowgA0a85dcKihyyCydCWoGMTgSI1yb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFTfwBVj8gtZfv00Ad06CY90qZXVJYG5EZSd2dmrfzTqG4feBiOW9tQ3y05AOUqYRZykNtcjrSmCUBg168KdZB14Lb0YC3aBeBfU/0EBfG5apZ89GGRnvn8O5ZovrcZOdfZzYiTFzeKUGsKTWjf1UzZd+TBF2YBJNn4LQD+RsUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGaNZ0Av; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGaNZ0Av"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546E7C4CECF;
	Tue,  3 Dec 2024 15:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238882;
	bh=ECjP2yOZjFcRowgA0a85dcKihyyCydCWoGMTgSI1yb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGaNZ0AvUw+JqIRnXxL/yFR3Ymnmvw0lwuLez9MKRhErfpA5ML23mBtXEnjSKD7T8
	 S+Bz1JobIQSXkrOJvVGKPXz9WceT4x5pYjHjlM+GefvW+4rWS9yO/G6KfNOhCYVIqn
	 25OuuYmWUHS3ITKZQBbpL3Ox3cgBrCnBepUwPT9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 429/817] clk: imx: imx8-acm: Fix return value check in clk_imx_acm_attach_pm_domains()
Date: Tue,  3 Dec 2024 15:40:01 +0100
Message-ID: <20241203144012.629262338@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 1bdb480cc96c6..37c61d10f213c 100644
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



