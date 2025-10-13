Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5598B274B55;
	Mon, 13 Oct 2025 14:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367104; cv=none; b=VaW874V+JtXpniEw4tGOeyWhbvJ7Lkk4G2wnd1G9UtBMWiw/23dEnl20GanNEvyO7mJtPXgK+fu126jq9PUN6WKg4u2TP3mRLU6mmyL5Tt8+IbcoRP4TyOWJ5uUUjtxBO3FGspIZ8ATgbb3RKgMgjV7toqKeq7q8kH0gpO871zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367104; c=relaxed/simple;
	bh=SqntwH/2wLjAtpv/fXlGlDW0A/SVxTwm2OBwio9wIcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8Vg1xYq82fGGMUyzXqvj9D7ytjD0mUW//r3RBrw59E4mp81/pYyEfC6azpjxzlH2TlLV9nZELEpgfKzc2C8y2lSbRIbBiyxnPqmGDYUwZHRrQgLr91kNs2cNcxVHhD93IHty7FrIOyurUtm6gFEEhhNFhO1cbA580XRo1BuQbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPXpTELl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPXpTELl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF3CC4CEE7;
	Mon, 13 Oct 2025 14:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367104;
	bh=SqntwH/2wLjAtpv/fXlGlDW0A/SVxTwm2OBwio9wIcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IPXpTELl/nv+lWDnFl6kN7fl0Bey5IA9HzmBiCb7xbC6qVOTHkzy0pH4nPaUdGc4d
	 JLx5Jq7A2WMYfqbQHTl8WEN1XLelp3AA8WsoomwWVNkRrUNDI8fRg6D/NKRk7oBSdE
	 BgTh1zV5Veb42AFw/4la5v9RL/N2t/kUn9LTVRUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/196] thermal/drivers/qcom/lmh: Add missing IRQ includes
Date: Mon, 13 Oct 2025 16:44:19 +0200
Message-ID: <20251013144317.683811254@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1434ab8f6988c..c7deb7c19d7a9 100644
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



