Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC276173;
	Tue, 30 Sep 2025 15:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244544; cv=none; b=RyH+GFR01j0eBbEESycxEhEjXcBmDt0mgsv8kaBStMtPnQvcoAL1/YyWOAFNfmoi6xb6MyeUWNLSwbzB7cJ/MpAIUp2jrX2Xal6sk7oJ4HRekNgVhXhKuvrByBw4+x91MCfSuwwLR3PYrqysx2ZPTuR4WTiMhRmarxwY0niPSP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244544; c=relaxed/simple;
	bh=T4MA5dKXeEw4lJzconJ2ag+/oJWkB/+TYxdmNciZSl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIYTFzxMT3pyjx3FVHO4WI4Vkv89eANsESnZsz/0YzrRBgW2kIcIxwMTqRMLWY1hNr7jpURS6pm77MZkOxTwk6inM8uC/NPKTwDDcik1i++2SDjTPKEGmDMOiZ0JzpMtK5pqyxJi5zuTzvo4S6pd/0Io8yUKJHliLSZbOCHBDwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kk3iYruu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kk3iYruu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CECCC4CEF0;
	Tue, 30 Sep 2025 15:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244544;
	bh=T4MA5dKXeEw4lJzconJ2ag+/oJWkB/+TYxdmNciZSl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kk3iYruuPCK83Hp9/JXS+3g8qcBjYHZGKnwDQ6a1a05+Ss2WssnoutlgvUnNlkCG6
	 1Q846Hp3hqjKjXt2RMIYltBQF8ougOHMcDjHfqU3piox+7RUDLhI2dlJ5vLnd8TcCg
	 1Ob8iJFnx7nt6B0hjE9hgvFdUFgaFFRyOff7ryZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 039/143] firmware: imx: Add stub functions for SCMI MISC API
Date: Tue, 30 Sep 2025 16:46:03 +0200
Message-ID: <20250930143832.796921913@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit b2461e20fa9ac18b1305bba5bc7e22ebf644ea01 ]

To ensure successful builds when CONFIG_IMX_SCMI_MISC_DRV is not enabled,
this patch adds static inline stub implementations for the following
functions:

  - scmi_imx_misc_ctrl_get()
  - scmi_imx_misc_ctrl_set()

These stubs return -EOPNOTSUPP to indicate that the functionality is not
supported in the current configuration. This avoids potential build or
link errors in code that conditionally calls these functions based on
feature availability.

This patch also drops the changes in commit 540c830212ed ("firmware: imx:
remove duplicate scmi_imx_misc_ctrl_get()").

The original change aimed to simplify the handling of optional features by
removing conditional stubs. However, the use of conditional stubs is
necessary when CONFIG_IMX_SCMI_MISC_DRV is n, while consumer driver is
set to y.

This is not a matter of preserving legacy patterns, but rather to ensure
that there is no link error whether for module or built-in.

Fixes: 0b4f8a68b292 ("firmware: imx: Add i.MX95 MISC driver")
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/firmware/imx/sm.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/firmware/imx/sm.h b/include/linux/firmware/imx/sm.h
index a8a17eeb7d907..67fb1d624d285 100644
--- a/include/linux/firmware/imx/sm.h
+++ b/include/linux/firmware/imx/sm.h
@@ -18,8 +18,20 @@
 #define SCMI_IMX_CTRL_SAI4_MCLK		4	/* WAKE SAI4 MCLK */
 #define SCMI_IMX_CTRL_SAI5_MCLK		5	/* WAKE SAI5 MCLK */
 
+#if IS_ENABLED(CONFIG_IMX_SCMI_MISC_DRV)
 int scmi_imx_misc_ctrl_get(u32 id, u32 *num, u32 *val);
 int scmi_imx_misc_ctrl_set(u32 id, u32 val);
+#else
+static inline int scmi_imx_misc_ctrl_get(u32 id, u32 *num, u32 *val)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int scmi_imx_misc_ctrl_set(u32 id, u32 val)
+{
+	return -EOPNOTSUPP;
+}
+#endif
 
 int scmi_imx_cpu_start(u32 cpuid, bool start);
 int scmi_imx_cpu_started(u32 cpuid, bool *started);
-- 
2.51.0



