Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FE3258ED5;
	Wed, 25 Feb 2026 01:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983644; cv=none; b=V/I03EeV+PhxFZLp2xv8YBxkhuHlrup38Ci9KNVd3B2O4SxgITZ6WeHmDMjUgwQpXjjpMVGfi6HuyvOsvrgsSzVVFg5/8s0H7N99Rkj19t4ccYYdxcueCnT/XcDI+XFKACH1syKl6O2yPKGaX/ZrRnEAn9+K9wAhfkp/1Eusr+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983644; c=relaxed/simple;
	bh=dIv2FCd7w3YEf00fhntKa9PBrHb9mSYDX1e5LUjBIsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuSs74PaY/CPmy5dJ204dcLSeyeqCTnK/Asa6b1yxcp9KT02Ou4SxCGEGETJsAGsmVYHETA8hR6zx2KjGZvJgUZYB/AKp8OA0NNl7HfGTk5CL3YBaqQ0P8Df+t6aDSjUwgu7vvh5rqthoyo7AKmZMN826PzYAwH7HkM58rhX1tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+XvEKF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+XvEKF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E7BC116D0;
	Wed, 25 Feb 2026 01:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983644;
	bh=dIv2FCd7w3YEf00fhntKa9PBrHb9mSYDX1e5LUjBIsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+XvEKF7SEWAQBLK2CN0Qf6fxVJX8TiqQxrX8Jd2nlxYk8FxJuyqJcGGYv67AUcEm
	 OKPl/9/q6dqt2/SJzUqxPTBi7n8r/5STK3lX2gFu+EfhI/ZK+FUEE3ckgIYRu1wfWT
	 VYXm5+wE8T1+/GekgmBbtk7pjLkf3pu8hxy+p/gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 732/781] drm/xe: Make xe_modparam.force_vram_bar_size signed
Date: Tue, 24 Feb 2026 17:24:01 -0800
Message-ID: <20260225012417.687191378@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 1acec6ef0511b92e7974cc5a8768bfd3a659feaf ]

vram_bar_size is registered as an int module parameter and is documented
to accept negative values to disable BAR resizing.
Store it as an int in xe_modparam as well, so negative values work as
intended and the module_param type matches.

Fixes: 80742a1aa26e ("drm/xe: Allow to drop vram resizing")
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://patch.msgid.link/20260202181853.1095736-2-shuicheng.lin@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 25c9aa4dcb5ef2ad9f354d19f8f1eeb690d1c161)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_module.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_module.h b/drivers/gpu/drm/xe/xe_module.h
index 5a3bfea8b7b4c..b668495392701 100644
--- a/drivers/gpu/drm/xe/xe_module.h
+++ b/drivers/gpu/drm/xe/xe_module.h
@@ -12,7 +12,7 @@
 struct xe_modparam {
 	bool force_execlist;
 	bool probe_display;
-	u32 force_vram_bar_size;
+	int force_vram_bar_size;
 	int guc_log_level;
 	char *guc_firmware_path;
 	char *huc_firmware_path;
-- 
2.51.0



