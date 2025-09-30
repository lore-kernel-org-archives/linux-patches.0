Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F031F1302;
	Tue, 30 Sep 2025 15:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244551; cv=none; b=rGXkSCSSPAUYFmRSqRzFgttqZ512beht5gVo02hFFxBy1sGLCAyW0ZH4LbJQ+qtGBwyS3UUTV1DpTLLKAlOQW3K5E1YMNS0HY3W3eoq8awleqKVjXvOBdEwbPT8T0Duo+6hAXYi95vi9k+z1DYyz7QGirZN4f2EKCq6QWm+kB/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244551; c=relaxed/simple;
	bh=vW5MF/aMrjfBFnTngnBYrukpGkaFQdXS3Jn7axAs/60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWbXR2kWQwV8PO1LNAOlmIzuFYfwcuzH6giDZBt5qn70QdSnubhdXxCec95kqfrKJI34nPxsEvwy91oUOZHGgyo2rpKRZc7jJmoWY9mp5+PXXlEF/7MGU+MG1nlfOCXdae/Xh5SpmgSZs7pnakkt5kTVLHIBfuD82e39MfEArdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OO4G1n/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OO4G1n/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98128C4CEF0;
	Tue, 30 Sep 2025 15:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244551;
	bh=vW5MF/aMrjfBFnTngnBYrukpGkaFQdXS3Jn7axAs/60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OO4G1n/F0/s3tpGJ+db4I+crRpPcDzdN4trb+E1v2fCnYWZYj1lmNv8dzXl3Rj5Op
	 wtMtt+v9v4HeL4f0AdZtKCiUTOZ8erpFLSNRgua4Lu2PL1wl8pxMGh4IzPXVlp5Nml
	 SulbJCfjkr8weE91Ssu8ipPfepqx+Jx8X328RySk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 041/143] firmware: imx: Add stub functions for SCMI CPU API
Date: Tue, 30 Sep 2025 16:46:05 +0200
Message-ID: <20250930143832.873989606@linuxfoundation.org>
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

[ Upstream commit 222accf05fc42f68ae02065d9c1542c20315118b ]

To ensure successful builds when CONFIG_IMX_SCMI_CPU_DRV is not enabled,
this patch adds static inline stub implementations for the following
functions:

  - scmi_imx_cpu_start()
  - scmi_imx_cpu_started()
  - scmi_imx_cpu_reset_vector_set()

These stubs return -EOPNOTSUPP to indicate that the functionality is not
supported in the current configuration. This avoids potential build or
link errors in code that conditionally calls these functions based on
feature availability.

Fixes: 1055faa5d660 ("firmware: imx: Add i.MX95 SCMI CPU driver")
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/firmware/imx/sm.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/firmware/imx/sm.h b/include/linux/firmware/imx/sm.h
index 6e700e455934e..1817df9aceac8 100644
--- a/include/linux/firmware/imx/sm.h
+++ b/include/linux/firmware/imx/sm.h
@@ -33,10 +33,28 @@ static inline int scmi_imx_misc_ctrl_set(u32 id, u32 val)
 }
 #endif
 
+#if IS_ENABLED(CONFIG_IMX_SCMI_CPU_DRV)
 int scmi_imx_cpu_start(u32 cpuid, bool start);
 int scmi_imx_cpu_started(u32 cpuid, bool *started);
 int scmi_imx_cpu_reset_vector_set(u32 cpuid, u64 vector, bool start, bool boot,
 				  bool resume);
+#else
+static inline int scmi_imx_cpu_start(u32 cpuid, bool start)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int scmi_imx_cpu_started(u32 cpuid, bool *started)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int scmi_imx_cpu_reset_vector_set(u32 cpuid, u64 vector, bool start,
+						bool boot, bool resume)
+{
+	return -EOPNOTSUPP;
+}
+#endif
 
 enum scmi_imx_lmm_op {
 	SCMI_IMX_LMM_BOOT,
-- 
2.51.0



