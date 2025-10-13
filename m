Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DB02701B8;
	Mon, 13 Oct 2025 14:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367569; cv=none; b=P+N+KJTW0abIgYEI9yqpWsZSdF2eauuiRfAJFz/oQZaWw8+zuAfAWrd0umWLeq8fohEEDM7XJWFRpsawyBHlm3jL56HMsUiuWiBxyXkZKHBMHy1EJBziJi30lYCC2AsKl738BssV12lFUO487glzo8z3/cPjt1dwUKGVaIXS9xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367569; c=relaxed/simple;
	bh=T+Y+b0noHjUun1nrwhM7bNXOu88b/NrOK4CBDhMhOVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlFD8yR5g2piITEOcupfIFR0bG4NcU8mC9qMP/ZzUHG/GyVuQtrqo43bysJXVg6XpIUUwdQx+SnkNbIcSKsKUxHqqDjuYdApWoqzFbjtDceYQDLsXeTwNqXHaO2xqUQoYnw3nqEiT/sVTLwuWoHZxFYj/w1gQgvygHVG4gIFvZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udgr+1VL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udgr+1VL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E609DC4CEE7;
	Mon, 13 Oct 2025 14:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367569;
	bh=T+Y+b0noHjUun1nrwhM7bNXOu88b/NrOK4CBDhMhOVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udgr+1VLlQmwda3rBNOricPsADCcF9DoCM7VYHAB12QKkiEMasOapC9x6r4PVgCwm
	 coNfEo/CVbaT9R4chJkt3yXbN3wm/dfP5WeYTJS4ckQpbjAoJbFtBNy2sGp4d2ZaqK
	 aMF/3vQcms//zCi2mjStaVLAEP5tJbkA7+zU3Iv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/196] thermal/drivers/qcom/lmh: Add missing IRQ includes
Date: Mon, 13 Oct 2025 16:44:08 +0200
Message-ID: <20251013144317.260291415@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



