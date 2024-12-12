Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A37A223C79;
	Thu, 12 Dec 2024 16:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021546; cv=none; b=r7G/NXqwQ8DBH+M0ha5Q+Dp0KZV4U0yYupUkSr/RFSNJswPvkbrUrR1E3qKuYJTUXCmF3p4tIIp/BM6Bw9NVmVCvVTEpaOU8sLMnu6/qtrHzEj2MCS8tEUfBd9PYGsrtgBKltrMPNC3ik8+qTdv2nx/6/ckcYbDzM3DZnLKepqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021546; c=relaxed/simple;
	bh=Hs5VIvyiKEKPXehDiNCK9wPwCu05qa2+TAzfRbl9u30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mr1tolsqwh8WfgpdSTtZgsa+zm4pq+weNBilx47tfS5zazBlD0oXQGifFkEOn6zKCIFyFmm1qNRo7jmFMLe2ADMmhAsgPydcIk31MRwBTe2RUzgypUgDWfUVpqJaUNBgfSshSMlgQyxLMC17BNkDw3Cp4yCosOsg2laH3oahSQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTk6g0F7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTk6g0F7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07282C4CED3;
	Thu, 12 Dec 2024 16:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021546;
	bh=Hs5VIvyiKEKPXehDiNCK9wPwCu05qa2+TAzfRbl9u30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTk6g0F7PJv/xCNIbyNM3L/PNN0jIm4Jb9ZuiDSyMT33IIrghSKkkxpY0V4FPjApB
	 heEplfsFTgOJNVwwtl56B87TgZXVd7mSFq0zjv6PMdUj4/OzDUERDnI6si0aaRyVfE
	 ciE5sGOm5XPVsfjUaK2Ls8mcZi1MJBnR62hEW0Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 6.1 768/772] PM / devfreq: Fix build issues with devfreq disabled
Date: Thu, 12 Dec 2024 16:01:53 +0100
Message-ID: <20241212144421.667694659@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Rob Clark <robdclark@chromium.org>

commit dbd7a2a941b8cbf9e5f79a777ed9fe0090eebb61 upstream.

The existing no-op shims for when PM_DEVFREQ (or an individual governor)
only do half the job.  The governor specific config/tuning structs need
to be available to avoid compile errors in drivers using devfreq.

Fixes: 6563f60f14cb ("drm/msm/gpu: Add devfreq tuning debugfs")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Patchwork: https://patchwork.freedesktop.org/patch/519801/
Link: https://lore.kernel.org/r/20230123153745.3185032-1-robdclark@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/devfreq.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -273,8 +273,8 @@ void devm_devfreq_unregister_notifier(st
 struct devfreq *devfreq_get_devfreq_by_node(struct device_node *node);
 struct devfreq *devfreq_get_devfreq_by_phandle(struct device *dev,
 				const char *phandle_name, int index);
+#endif /* CONFIG_PM_DEVFREQ */
 
-#if IS_ENABLED(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)
 /**
  * struct devfreq_simple_ondemand_data - ``void *data`` fed to struct devfreq
  *	and devfreq_add_device
@@ -292,9 +292,7 @@ struct devfreq_simple_ondemand_data {
 	unsigned int upthreshold;
 	unsigned int downdifferential;
 };
-#endif
 
-#if IS_ENABLED(CONFIG_DEVFREQ_GOV_PASSIVE)
 enum devfreq_parent_dev_type {
 	DEVFREQ_PARENT_DEV,
 	CPUFREQ_PARENT_DEV,
@@ -337,9 +335,8 @@ struct devfreq_passive_data {
 	struct notifier_block nb;
 	struct list_head cpu_data_list;
 };
-#endif
 
-#else /* !CONFIG_PM_DEVFREQ */
+#if !defined(CONFIG_PM_DEVFREQ)
 static inline struct devfreq *devfreq_add_device(struct device *dev,
 					struct devfreq_dev_profile *profile,
 					const char *governor_name,


