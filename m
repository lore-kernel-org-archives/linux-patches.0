Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCB722A4D5;
	Mon, 13 Oct 2025 15:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369350; cv=none; b=EwujiDHAZNhSnMTht/I41MG5WCzbAM4arUejVPs57Jo2fUhagxSZ0gzgfark0701uNGvPKgZpguZsqBGTGsm6iK1Q6s2Zv3rr1MGyCh/znFxwj1bCIWrUOstI6ehpDsTb4ayijLXJx412KS4+n5DrqhzhqHP+pmoZDz9EBYBGf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369350; c=relaxed/simple;
	bh=RDPCOUxf69+xvClnECG92S0e190BCrCnAP2F2NjbC18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIv1dv8IZU41rE0fwJd4l9ximUpRZIwreu2BunLSdbhDOSaY4RWafplADtHzudSxRwjarfcX+sbf7JcCTpUeEIeSRfEze7vN/d3R59w/Am0efGK463nOYkyyLgBx1F/4wAMvkwD7NjbCSXtnnucSBHyBkQAZAk5krarJbk8Xslc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQnSVzSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQnSVzSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EB2C4CEE7;
	Mon, 13 Oct 2025 15:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369350;
	bh=RDPCOUxf69+xvClnECG92S0e190BCrCnAP2F2NjbC18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQnSVzSaSux1hr+xTWw5v2xBtQS1aJnJnshu+vBuk32Yg+wIpzCzGYjHj76VhgoEM
	 5gZ8oR9Mhcny+gGv4oK8ijyjptCH20UisKdMWEALKK6kKl0LfQjYMxK+m4+3wrkgw4
	 as1sIFJn5HAUFc56cKfdzwrxJWG6jP+KNxLwuNC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 198/563] thermal/drivers/qcom/lmh: Add missing IRQ includes
Date: Mon, 13 Oct 2025 16:40:59 +0200
Message-ID: <20251013144418.457837281@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 75eaa9a68ab8a..c681a3c89ffa0 100644
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



