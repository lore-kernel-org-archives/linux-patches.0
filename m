Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D026913A26F;
	Tue, 27 Feb 2024 14:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042972; cv=none; b=Bd+CWNHvmXAYEnQIIWGlZ47ON0a1U3kua6wa8U1fzk85NY3LDJy2EhGgtK30QzcGPuxnjwtX7JWiwaaFUVN+2aWizgK4CxkT72xJ0bQwq/DTxX0Cf6Y1U9sKETkQbgudiS7dvy4LT/aQ56ZpYk6OgGBQ0HznRPITtXV/iJm7RUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042972; c=relaxed/simple;
	bh=LnZfNZxV45xlGaX5c1+BUEQNzPllLKSHC4nCAZh7Gj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwq0uw1viNGWZbL5rFmuC/hNLJe8kqfJzUlbyQcPdUH5iJSIQGYzjRYhkPy20IJuDtcsloMr0L6RKC8R2Cr6kYBxwXizpPBtt5+wXsuo7jGjg617UuLIA/JHOQ11PFMYY2tiAr4gA+XfxIaV9Drlz9bNNNe6wxQcoZNEaQNOfhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09C52nPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09C52nPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E783C433F1;
	Tue, 27 Feb 2024 14:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042972;
	bh=LnZfNZxV45xlGaX5c1+BUEQNzPllLKSHC4nCAZh7Gj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09C52nPbeP2D8CkeYIKabv6CufK+si5cmRUYF7wbJJclcD1sa06FKwY0US3wnWUug
	 A9VRUSYnb8oKD6cmkAhp+A7kp0S+b1TxcRZgPQXYh06D3F4EP2nNhfMrBMI/Cq04Ph
	 nL4WXXeQdap6UyQBmY3i4I0kNPIbCXSM3SdxKuug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/245] PM: core: Remove static qualifier in DEFINE_SIMPLE_DEV_PM_OPS macro
Date: Tue, 27 Feb 2024 14:25:47 +0100
Message-ID: <20240227131620.379812168@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 52cc1d7f9786d2be44a3ab9b5b48416a7618e713 ]

Keep this macro in line with the other ones. This makes it possible to
use them in the cases where the underlying dev_pm_ops structure is
exported.

Restore the "static" qualifier in the two drivers where the
DEFINE_SIMPLE_DEV_PM_OPS macro was used.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 18ab69c8ca56 ("Input: iqs269a - do not poll during suspend or resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/jz4740_mmc.c | 4 ++--
 drivers/mmc/host/mxcmmc.c     | 2 +-
 include/linux/pm.h            | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/jz4740_mmc.c b/drivers/mmc/host/jz4740_mmc.c
index ef3fe837b49d2..2254db44fb02c 100644
--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -1143,8 +1143,8 @@ static int jz4740_mmc_resume(struct device *dev)
 	return pinctrl_select_default_state(dev);
 }
 
-DEFINE_SIMPLE_DEV_PM_OPS(jz4740_mmc_pm_ops, jz4740_mmc_suspend,
-	jz4740_mmc_resume);
+static DEFINE_SIMPLE_DEV_PM_OPS(jz4740_mmc_pm_ops, jz4740_mmc_suspend,
+				jz4740_mmc_resume);
 
 static struct platform_driver jz4740_mmc_driver = {
 	.probe = jz4740_mmc_probe,
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index b5f65f39ced1c..2e39b2cb1cafa 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -1212,7 +1212,7 @@ static int mxcmci_resume(struct device *dev)
 	return ret;
 }
 
-DEFINE_SIMPLE_DEV_PM_OPS(mxcmci_pm_ops, mxcmci_suspend, mxcmci_resume);
+static DEFINE_SIMPLE_DEV_PM_OPS(mxcmci_pm_ops, mxcmci_suspend, mxcmci_resume);
 
 static struct platform_driver mxcmci_driver = {
 	.probe		= mxcmci_probe,
diff --git a/include/linux/pm.h b/include/linux/pm.h
index fc9691cb01b4f..d1c19f5b1380f 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -362,7 +362,7 @@ struct dev_pm_ops {
  * to RAM and hibernation.
  */
 #define DEFINE_SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
-static const struct dev_pm_ops name = { \
+const struct dev_pm_ops name = { \
 	SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
 }
 
-- 
2.43.0



