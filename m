Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FD4259C80;
	Thu, 17 Sep 2026 18:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668941; cv=none; b=SkJS2HGWVpSw7hpQUyAnnAuVIMdJbyfwoEzLJbk+kW9tobo7Qs5uRxBpIazEZmkJAWnXRjj9kKZ+G+0dKOnglhZtgShwjAhDRWpS+Fy6UkOHBiCrCPJ/bQ1brbzFwMe16oSaqzXluynIx+5GGW+8Bqo5WoLkGuoctwzouxClVIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668941; c=relaxed/simple;
	bh=8HWcUuPzViFxc4uTyWOZxMK5TtfR89HzUHOF8rYMCwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtBv4k4SKWkysfBmxocdw6zpmrYPeLODKXDBVLYHnAtr1FWHhNW+5Xsy30/kxyMZRP+87AmteXVy9naWGmmNL7YRKvVlGc6Ot9thfky8GmJRmC08jQLjptPWVvFNHmP7jssBDGf1wX9AT6xDBmIXgz8+EIFPLPcQvr8U3FnFYXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/9ZlgQx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/9ZlgQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7F61F000FF;
	Thu, 17 Sep 2026 18:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668940;
	bh=14QbtIdDfmrN42W9wa1FPE7bMCu+rBS/8RrHS3sNHgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/9ZlgQx89P7XsAt7DS/5zXQ+OFKxXdGXNn0xlKxrAyg59FAwaiWj/Lu09pJPgAL0
	 LiJntJEjpGZeFW2t9SJPY8sVxb8OPdOidejUCwiPBhtkI6KUMiImQa7BzoM9Gxu7bE
	 Ded9Te2wAYptXpmVzQWGyuA2npn55B44qaQGX4Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0590/1102] drm/xe/oa: Remove sysfs entry on idr_alloc failure in xe_oa_add_config_ioctl()
Date: Thu, 17 Sep 2026 16:08:53 +0100
Message-ID: <20260917151554.782002280@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Lu Yao <yaolu@kylinos.cn>

[ Upstream commit 3663c8d1f31e65771bd73ee3259f35fd397f9933 ]

If idr_alloc() fails after create_dynamic_oa_sysfs_entry() has
succeeded, the error path frees the OA config without removing the
metrics sysfs group.

Remove the sysfs group before releasing the config, and fix up the
misleading error message copied from the sysfs creation failure path.

Fixes: cdf02fe1a94a ("drm/xe/oa/uapi: Add/remove OA config perf ops")
Signed-off-by: Lu Yao <yaolu@kylinos.cn>
Link: https://patch.msgid.link/20260831014218.28515-1-yaolu@kylinos.cn
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 2c6fbda5fdde461d6dedb82a59285182720b8fef)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index ad55c7f2b09f9..58af9556bf2cb 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -2389,9 +2389,9 @@ int xe_oa_add_config_ioctl(struct drm_device *dev, u64 data, struct drm_file *fi
 
 	oa_config->id = idr_alloc(&oa->metrics_idr, oa_config, 1, 0, GFP_KERNEL);
 	if (oa_config->id < 0) {
-		drm_dbg(&oa->xe->drm, "Failed to create sysfs entry for OA config\n");
+		drm_dbg(&oa->xe->drm, "Failed to allocate id for OA config\n");
 		err = oa_config->id;
-		goto sysfs_err;
+		goto id_alloc_err;
 	}
 
 	id = oa_config->id;
@@ -2402,6 +2402,8 @@ int xe_oa_add_config_ioctl(struct drm_device *dev, u64 data, struct drm_file *fi
 
 	return id;
 
+id_alloc_err:
+	sysfs_remove_group(oa->metrics_kobj, &oa_config->sysfs_metric);
 sysfs_err:
 	mutex_unlock(&oa->metrics_lock);
 reg_err:
-- 
2.53.0



