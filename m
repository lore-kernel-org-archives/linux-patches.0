Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B44430C601;
	Mon, 13 Oct 2025 15:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368214; cv=none; b=EB7qz0OQBqH4qFLQgOZ2Z/8B4alugFTws1qVWFEbeQY09yde4Tk/RvE2CvuemT3vJpJHU9N39fAZAcA2zswod1wYkB2wgkxWpSUXrQCzHGKnBdfwIfJ9bXzBg3F0iReDTx9S4gE2LmaBk5SyNs5Zn+v/hwgsrGiMjzQpS+FHPLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368214; c=relaxed/simple;
	bh=uA0MyUQ0PGsYOftqnEtIBveFZOVvJxqEhZft1U7p258=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgwxK5FkzCH3T/YGFmPA0W2n1oYvxTzuU2Vxh8kdRBc0vyWymlaKt7hPV9shuBpfFn+OOqtxvj3TVc/EHXI7oHxXF1ReCRCjwU4sQkguMtk73UU714PzKGGkTOedSY3tF3V8xRYkDoIVOT+bi4bZQA7xZrNXkNZ6jCFtqQG6Vx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbFFo6LM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbFFo6LM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86C0C4CEE7;
	Mon, 13 Oct 2025 15:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368214;
	bh=uA0MyUQ0PGsYOftqnEtIBveFZOVvJxqEhZft1U7p258=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RbFFo6LM4t7tHUgG9wDP46RXp/BU2Ih9pGZeLEG4fY7ympKgi4Sl3Hg7pIfwlu5Rm
	 hQkdIjL4HAh5txJuux6Ie1df1+FEioPoV/qRd60O34nUCzNT2pKV4m66I6IfHbT7gD
	 OoC4f6hV4L/d3XMqCZK8CP7SrQr+Hqo0G/gYHCqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/262] thermal/drivers/qcom/lmh: Add missing IRQ includes
Date: Mon, 13 Oct 2025 16:43:46 +0200
Message-ID: <20251013144329.154894692@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit b50b2c53f98fcdb6957e184eb488c16502db9575 ]

As reported by LKP, the Qualcomm LMH driver needs to include several
IRQ-related headers, which decrlare necessary IRQ functionality.
Currently driver builds on ARM64 platforms, where the headers are pulled
in implicitly by other headers, but fails to build on other platforms.

Fixes: 53bca371cdf7 ("thermal/drivers/qcom: Add support for LMh driver")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507270042.KdK0KKht-lkp@intel.com/
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20250728-lmh-scm-v2-2-33bc58388ca5@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/lmh.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/thermal/qcom/lmh.c b/drivers/thermal/qcom/lmh.c
index d2d49264cf83a..7c299184c59b1 100644
--- a/drivers/thermal/qcom/lmh.c
+++ b/drivers/thermal/qcom/lmh.c
@@ -5,6 +5,8 @@
  */
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdesc.h>
 #include <linux/irqdomain.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
-- 
2.51.0



