Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B483955F4;
	Tue, 21 Jul 2026 15:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649412; cv=none; b=XvrGs3D1GXdcMMa7S5OVO/c7/5HZMsVICefvxpBIQSFOlSHXt+D+wxPH77IUmhvz8NNd2OJz/Yb6WytdmG65RMDkpn7iL3Km6Yxl8Fw5VtoRbMGBwHpSnpdCYnRmI+xoKn+GBM9e4WsyaJHGGlA6at7cl9LsaveoMFudVU/UI50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649412; c=relaxed/simple;
	bh=JC7xEh66VmMuDYTGi8aPvHaX5Fz5l8cR7pfpcF4illI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqznqC/jmV0Ekg4KAtiqlKbEiWywWdglmbT6K9Da5ArvurV9/6j++KAlT7FdujX5POvVSQlkbnp5J+4Vcl+7CvgnlBsRmyVc6yw9xbZiyCfmSSfDhfFU8L91gKvuUzsOknCD3Mv1z+ZhT1iFtfWkZAUqn4yhakK7/qkvr3ykNlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9kIEPWP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9kIEPWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B151F000E9;
	Tue, 21 Jul 2026 15:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649411;
	bh=2YF2GxXvGSICA4hdEguPiK0bhQNkmQq4+ovO/dCknmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n9kIEPWPyIl7rhFNEqR3UHIjyz0e9FKSOMpkhYS3eim7xgU1b1GHE9XpmutV4Z0vz
	 xlAVL9MbY075QdRBCtXXb6/8YHIXxfUsiyY4+UrsI0vTHC/Q+HszUL6oe7d/O67Oyo
	 COVkT4+EJQYcCnnk9Eg34qZZNpQU08f2iwfLRTbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0568/2077] pinctrl: PINCTRL_STMFX should depend on CONFIG_OF
Date: Tue, 21 Jul 2026 17:04:01 +0200
Message-ID: <20260721152606.207571117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Tabi <ttabi@nvidia.com>

[ Upstream commit fd9490bdd4536a8e0911578f62164176b9000552 ]

Commit e785c990adcc ("pinctrl: Kconfig: drop unneeded dependencies
on OF_GPIO") removed a redundant dependecy on CONFIG_OF_GPIO for
several pinctrl drivers, but this change also removed a dependency
on CONFIG_OF for some of those drivers.

Normally, this wouldn't be a problem, but PINCTRL_STMFX also selected
MFD_STMFX, which does depend on CONFIG_OF.  This conflict allows
MFD_STMFX to be enabled even if CONFIG_OF is disabled.

Fix this by also having PINCTRL_STMFX depend on CONFIG_OF.  This is
okay because the pinctrl-stmfx driver actually does depend on CONFIG_OF
functions.

Fixes: e785c990adcc ("pinctrl: Kconfig: drop unneeded dependencies on OF_GPIO")
Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 03f2e3ee065f42..75131b6e6eeac9 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -548,6 +548,7 @@ config PINCTRL_ST
 
 config PINCTRL_STMFX
 	tristate "STMicroelectronics STMFX GPIO expander pinctrl driver"
+	depends on OF
 	depends on I2C
 	depends on HAS_IOMEM
 	select GENERIC_PINCONF
-- 
2.53.0



