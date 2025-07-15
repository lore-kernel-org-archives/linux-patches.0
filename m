Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89132E62C3;
	Tue, 15 Jul 2025 13:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586687; cv=none; b=ESU0bYcoLFfsmqSZWA7wJ8HqR0WhKWYWtajwURLw7rpuxdRgIv/S6g17Zg2bcZrVLXzBvu/u5MRNWut/xapDKcxu1sM2e+L5OPuBqCjsO6NnNQiJKLozQey2zfHf/wlC+AEmxkzuktzqa0llznvQC1E7BoKdozK4sq+fU6xyyH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586687; c=relaxed/simple;
	bh=695M3zrmWPUSK5BOiLjY0kumoB+mJvFfWJgdG3Km10I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t62236fzJH8BHuLJOYFi9hrqBgr/hdCzjJgzPWB8SzKD8jRiq3NFBRbMl8UccPIoLHP6zBXKw/mx3ya3WSwOth5s+2yEWVbjWCMIyPyz3KdoogyHXWN0ykD2ctkJh5CDZoDO+aK/dX0Ei8Iq9fktv2F/lfIWKPTU6T4b0QjwE7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujTkiBJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujTkiBJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B190C4CEF1;
	Tue, 15 Jul 2025 13:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586687;
	bh=695M3zrmWPUSK5BOiLjY0kumoB+mJvFfWJgdG3Km10I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujTkiBJ+mEFPureZCXYepcUGy7yKTqOYaNgpgu2V4nR05ejhv+Cw5JKOzpyHk0zKl
	 fWZgHd5dZo+fb1GzJJBRMFsN7ZWpTy0mzV6tbQ15eWor2QtLPly2ZR4nQFJKQbAESO
	 5Ibuz14+MY5WjdpErvuySpN+bEr/HySbyO8CNjj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Nam Cao <namcao@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 011/192] irqchip/irq-msi-lib: Select CONFIG_GENERIC_MSI_IRQ
Date: Tue, 15 Jul 2025 15:11:46 +0200
Message-ID: <20250715130815.315043507@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit eb2c93e7028b4c9fe4761734d65ee40712d1c242 ]

irq-msi-lib directly uses struct msi_domain_info and more things which are
only available when CONFIG_GENERIC_MSI_IRQ=y.

However, there is no dependency specified and CONFIG_IRQ_MSI_LIB can be
enabled without CONFIG_GENERIC_MSI_IRQ, which causes the kernel build fail.

Make IRQ_MSI_LIB select GENEREIC_MSI_IRQ to prevent that.

Fixes: 72e257c6f058 ("irqchip: Provide irq-msi-lib")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/b0c44007f3b7e062228349a2395f8d850050db33.1751277765.git.namcao@linutronix.de
Closes: https://lore.kernel.org/oe-kbuild-all/202506282256.cHlEHrdc-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 08bb3b031f230..6539869759b9e 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -74,6 +74,7 @@ config ARM_VIC_NR
 
 config IRQ_MSI_LIB
 	bool
+	select GENERIC_MSI_IRQ
 
 config ARMADA_370_XP_IRQ
 	bool
-- 
2.39.5



