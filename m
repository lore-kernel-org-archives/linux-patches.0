Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40BE1F1302;
	Tue, 30 Sep 2025 15:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246022; cv=none; b=cSoiFWZtEYX6WFaXR00a19teMDFWI4HrTVu6iIcmZ+IJdaKoL4tV7EdgrufOZK9J79UbD2Ky9R4+vaXgxOkTsPYasj4L+Ga1ONTZDRgL1745nt2G7xH2650STW2E4UR60ff77CbLtJ7EuxMiLjiZ4HsKAWGOSYzIZgfI+1jt2gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246022; c=relaxed/simple;
	bh=kSwFThuvQFuyjPGVS5qAYiDVjkLpAnUIhO9UocFszdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHZZCQTGVD/Iyv78sPIlx3hwNKFpC5PG6Fqb+eJeMjggwZD8JAFrDH0CAPPL10cvblqVKI1Ap1maQSJG5jK4EfnaANcCXhGvsjaxegFLvDxkeLhUSDLReKrreIOHT7Bh6+6Uz+T9MbVv6vanlbUlyLv9mi6Upw4BGVb83lUYOgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQZ04vum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQZ04vum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAC7C4CEF0;
	Tue, 30 Sep 2025 15:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246022;
	bh=kSwFThuvQFuyjPGVS5qAYiDVjkLpAnUIhO9UocFszdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQZ04vumBugHT5tdvhKrZgRdDTDe55Zwk0KBYVDE9aIQScieMyO8y+2OSzdQndF0h
	 knleDpctvJ5wZ/3SozZpMgz9QhMCMkWwgxZIGmsi07lUPuwqK3RhKIJT/0umOrFMdg
	 V+J8esdnki7EyWmRNVnR3SEXSNvANg44Xs9nt83c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 28/89] firmware: imx: Add stub functions for SCMI MISC API
Date: Tue, 30 Sep 2025 16:47:42 +0200
Message-ID: <20250930143823.073073720@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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
index 9b85a3f028d1b..61f7a02b05009 100644
--- a/include/linux/firmware/imx/sm.h
+++ b/include/linux/firmware/imx/sm.h
@@ -17,7 +17,19 @@
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
 
 #endif
-- 
2.51.0



