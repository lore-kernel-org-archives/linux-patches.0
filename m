Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8458433065F;
	Mon, 29 Dec 2025 16:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025293; cv=none; b=qiuFWjcpyLqC6OkutMUMChj0UyAAFn7nqi7ogqo8BS6eBsuRlvdPjQZKqgfqzzjQ18+DhYmAiGcZup4TYwNWT1vgNataExdssTif7jn3RCsgqDGE1ImeL5VMIFm3bvUXnE/x1Xu1xeLtQuIK3J0ESPIgI+A5D2+fdhUBd5KLby0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025293; c=relaxed/simple;
	bh=hvVXZGPOeeQfUAicMVekKWG2Cu1Jb1o3UcP/1vlR0xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9IxOMSceciD6LFwa7lKEeUVr5hnd8yF7d3KcF5t8nKcON2Bzuojye5yhrF1YtuIWCpVLEcCJ3pujbx9TCY0kpKPexEoo4bcDARGzW2w73qtw5C1es42G468xQ7oPAZ9bJiyn6+ku0UDU+M+AVm49lcXn/f41hczzcQPv3KJhDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUTtwr0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUTtwr0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F93C4CEF7;
	Mon, 29 Dec 2025 16:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025293;
	bh=hvVXZGPOeeQfUAicMVekKWG2Cu1Jb1o3UcP/1vlR0xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUTtwr0DPmsnYrNiH5M2LE4h9EPCT755mo/RkBb4d6aeNMSMA9DQpOCcD1DrqdqoI
	 s5hVW1WFmpPh3gEZRajTJdbSpTZyHFc0ipSCr6Ue6JYLM+9HafaiLe05IyL4Xh7BP1
	 LKcIWfRgdn74wg4h2tGgxuIqqWzbkvJHC2aFA/vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 161/430] mmc: sdhci-of-arasan: Increase CD stable timeout to 2 seconds
Date: Mon, 29 Dec 2025 17:09:23 +0100
Message-ID: <20251229160730.288254207@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>

commit a9c4c9085ec8ce3ce01be21b75184789e74f5f19 upstream.

On Xilinx/AMD platforms, the CD stable bit take slightly longer than
one second(about an additional 100ms) to assert after a host
controller reset. Although no functional failure observed with the
existing one second delay but to ensure reliable initialization, increase
the CD stable timeout to 2 seconds.

Fixes: e251709aaddb ("mmc: sdhci-of-arasan: Ensure CD logic stabilization before power-up")
Cc: stable@vger.kernel.org
Signed-off-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-arasan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -99,7 +99,7 @@
 #define HIWORD_UPDATE(val, mask, shift) \
 		((val) << (shift) | (mask) << ((shift) + 16))
 
-#define CD_STABLE_TIMEOUT_US		1000000
+#define CD_STABLE_TIMEOUT_US		2000000
 #define CD_STABLE_MAX_SLEEP_US		10
 
 /**


