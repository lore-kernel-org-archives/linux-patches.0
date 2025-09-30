Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A16173;
	Tue, 30 Sep 2025 15:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244548; cv=none; b=ZHuSCOyJ7soPGFXlPqA3YF+ChU2fxQopMHHii4VyC/sIxnNCrR1VRyvILbRnCvYSA0ss0DewByGkBAuXr3ef4RpT/MwhqPmN7EZ7DI4ZLCDVypNoRnFzcYz4sy9wsrTY3vbtYjqyQ+Cc/d8LDfy+9/4DIWQuGvPQca6S3u3tF74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244548; c=relaxed/simple;
	bh=D1vDyDbTJ1dk6ycpzOc1OtvDo9+IjHZtPNuS3k0WQsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjBvnwjK6bHIVth+15966N3CkdV2iDjFo9J9tJpp5d5QErMmhSTHn+2CwAokVUcQIQ7ltzogmN15uDEtXN7Fe1RVW2X7n0GLb2qFqTXyujbaZD9XUo98LnOqiN/c0LR8RAI0aB2MME3Z41EpHkio4mLV/rMLE5l+XEk+hC//NCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZT2L9MHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZT2L9MHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7933BC4CEF0;
	Tue, 30 Sep 2025 15:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244547;
	bh=D1vDyDbTJ1dk6ycpzOc1OtvDo9+IjHZtPNuS3k0WQsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZT2L9MHjwiQQ3AxGVR2ff9njqJOJYjMvX1TmRBnTLkcvrS2uA0mWPFlKnshj/d8Kn
	 2zTSyRLH8Ft78cgXVZbGTzmJ6V95jW2NpZS1wYtQ0K1Y3IUe1u0ufTznG4H29o7G7C
	 UQdNZrSNlGctskMl6bHZjQyW/IOqtZNcRCoLbGtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 040/143] firmware: imx: Add stub functions for SCMI LMM API
Date: Tue, 30 Sep 2025 16:46:04 +0200
Message-ID: <20250930143832.835751623@linuxfoundation.org>
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

[ Upstream commit 3fb91b5c86d0fb5ff6f65c30a4f20193166e22fe ]

To ensure successful builds when CONFIG_IMX_SCMI_LMM_DRV is not enabled,
this patch adds static inline stub implementations for the following
functions:

  - scmi_imx_lmm_operation()
  - scmi_imx_lmm_info()
  - scmi_imx_lmm_reset_vector_set()

These stubs return -EOPNOTSUPP to indicate that the functionality is not
supported in the current configuration. This avoids potential build or
link errors in code that conditionally calls these functions based on
feature availability.

Fixes: 7242bbf418f0 ("firmware: imx: Add i.MX95 SCMI LMM driver")
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/firmware/imx/sm.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/firmware/imx/sm.h b/include/linux/firmware/imx/sm.h
index 67fb1d624d285..6e700e455934e 100644
--- a/include/linux/firmware/imx/sm.h
+++ b/include/linux/firmware/imx/sm.h
@@ -48,7 +48,24 @@ enum scmi_imx_lmm_op {
 #define SCMI_IMX_LMM_OP_FORCEFUL	0
 #define SCMI_IMX_LMM_OP_GRACEFUL	BIT(0)
 
+#if IS_ENABLED(CONFIG_IMX_SCMI_LMM_DRV)
 int scmi_imx_lmm_operation(u32 lmid, enum scmi_imx_lmm_op op, u32 flags);
 int scmi_imx_lmm_info(u32 lmid, struct scmi_imx_lmm_info *info);
 int scmi_imx_lmm_reset_vector_set(u32 lmid, u32 cpuid, u32 flags, u64 vector);
+#else
+static inline int scmi_imx_lmm_operation(u32 lmid, enum scmi_imx_lmm_op op, u32 flags)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int scmi_imx_lmm_info(u32 lmid, struct scmi_imx_lmm_info *info)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int scmi_imx_lmm_reset_vector_set(u32 lmid, u32 cpuid, u32 flags, u64 vector)
+{
+	return -EOPNOTSUPP;
+}
+#endif
 #endif
-- 
2.51.0



