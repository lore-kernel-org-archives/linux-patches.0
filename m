Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A220FBA34;
	Mon,  6 Jan 2025 15:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179072; cv=none; b=r80E6Mx45xTALapSQ1x0duJPf4I4AK2yrEJHw72r/CM88LS61606DLHySS6rcDas8Z+hg8AA+tYd8kNnSoiuuDhmh42Ht7gKm+7y+dQDO3Zygm9lPeKt879Df39CSQk3hQxCvKx/hnMxm86qiIsK8hFx4nwC2iSYADBcNnKGQRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179072; c=relaxed/simple;
	bh=lQg0ozWEqk820Qo5qcY1S8BUMMy0yUYq9C3WaSXtHzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vrk9kgtR9BVgUoIXk/KBLJUPJQzoV+786Rb1GIhbdTB+AD2dcvK2p6FgJIBBem8X8Pr8owKQJLbmpdPtatNtbvDooYK8e53ifPz+eFCrrCXEocc9iEL3iX9fZjo8teX/iHxbN7zG4yr2/h2pnG0uQZqGtuOGGOcJayWZn2F8M1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFMS9D36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFMS9D36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1021C4CED2;
	Mon,  6 Jan 2025 15:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179072;
	bh=lQg0ozWEqk820Qo5qcY1S8BUMMy0yUYq9C3WaSXtHzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFMS9D36p9/ABFc2rXXsaLjcpg4lQILCcdIGyfP5cDQ+hQyY5gmsdNxmpzH3YdEWH
	 jy7QBkBEJlzOgYw+z/q982ketA0O41+35ApMiCa9ECbIv96c7Fi+eJQklmuIsYfola
	 cCoON493jZRdvptyrq5tVjzDUKxk5cJqPVJ5B/rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@outlook.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/93] drm/i915: Fix memory leak by correcting cache object name in error handler
Date: Mon,  6 Jan 2025 16:16:43 +0100
Message-ID: <20250106151128.973196173@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 9bc5e7dc694d3112bbf0fa4c46ef0fa0f114937a ]

Replace "slab_priorities" with "slab_dependencies" in the error handler
to avoid memory leak.

Fixes: 32eb6bcfdda9 ("drm/i915: Make request allocation caches global")
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@outlook.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241127201042.29620-1-jiashengjiangcool@gmail.com
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_scheduler.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_scheduler.c b/drivers/gpu/drm/i915/i915_scheduler.c
index 0ef205fe5e29..7ef068dcc48b 100644
--- a/drivers/gpu/drm/i915/i915_scheduler.c
+++ b/drivers/gpu/drm/i915/i915_scheduler.c
@@ -533,6 +533,6 @@ int __init i915_global_scheduler_init(void)
 	return 0;
 
 err_priorities:
-	kmem_cache_destroy(global.slab_priorities);
+	kmem_cache_destroy(global.slab_dependencies);
 	return -ENOMEM;
 }
-- 
2.39.5



