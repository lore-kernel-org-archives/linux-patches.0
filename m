Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C8F38FB0;
	Tue, 29 Apr 2025 17:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947663; cv=none; b=VqcR9xaSfdFKZ+uFc6azTrHsbKWlCGCMXpanUJ94p18gD3Jg9yN8EO0Y8wT7g4MQAd2GWPx4oU5fZGyWU4liSKcd/cB6jxyRrKrEp04XCSqctFkmL7QrWOiGizHVedRdWTiWrQYAZtF1MRuHVmlFmmkDZAf3Oj8AgcySuzoDBkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947663; c=relaxed/simple;
	bh=b+fHEg+70uEbGKyfrcHRFgqDa6yb800pW7HtK2MD9MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwaGD8d9eaWujdfOkrskDIHNMxzcPB5CL2MYYWlu3mgU7g41KPJPbR57CZ+MtJROWe3jYr2QsCJM07ClwnJcj5EWNWvycnXr6R20V1lk58WBu6xUHyG6FHUFB9Cw3z0qSiO0Q4lLseG3B2ZKkM5qkvWEeYOvnqABwezbZp2XOUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xoKaoseh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xoKaoseh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF03C4CEE9;
	Tue, 29 Apr 2025 17:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947663;
	bh=b+fHEg+70uEbGKyfrcHRFgqDa6yb800pW7HtK2MD9MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xoKaosehJ8maAuvYjBh6xg8etpGmPL+E+a2Yk+mmLraBfk1b6ZQ1VIC+Jg5i9kqHt
	 qy6DZ7QHIc2HkTcKZE8QdIv8b3YN+cHsEH9eCg8hap9SU4+CCvwf7az+oWDPpgL4/R
	 uY2RwiBld2hX8N497P/iyZEa+5uukP62ENKSjPNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/280] scsi: ufs: exynos: Remove empty drv_init method
Date: Tue, 29 Apr 2025 18:39:41 +0200
Message-ID: <20250429161116.762920673@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit 07c2a737504457c41678c5c30abe9107cd28dce6 ]

Remove empty method. When the method is not set, the call is not made,
saving a few cycles.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20241031150033.3440894-2-peter.griffin@linaro.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 68f5ef7eebf0 ("scsi: ufs: exynos: Move UFS shareability value to drvdata")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-exynos.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index f2cbfc2d399cd..69fcfffb1c89d 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -198,11 +198,6 @@ static inline void exynos_ufs_ungate_clks(struct exynos_ufs *ufs)
 	exynos_ufs_ctrl_clkstop(ufs, false);
 }
 
-static int exynos7_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
-{
-	return 0;
-}
-
 static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
 {
 	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
@@ -2044,7 +2039,6 @@ static const struct exynos_ufs_drv_data exynos_ufs_drvs = {
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
 				  EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB |
 				  EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER,
-	.drv_init		= exynos7_ufs_drv_init,
 	.pre_link		= exynos7_ufs_pre_link,
 	.post_link		= exynos7_ufs_post_link,
 	.pre_pwr_change		= exynos7_ufs_pre_pwr_change,
-- 
2.39.5



