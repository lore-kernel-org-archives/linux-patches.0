Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C8654B1A9;
	Mon, 31 Aug 2026 13:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183993; cv=none; b=Yd+y7E1qAZqMkXfpDkBXRkzo63c8SawnFb7AboOMQQIdT4KfgOHnHz3r85nLo0dHL/4IMqB5UTFi1voqZNCGH6iHtQ6hVQtWjux0JBg1wMq4lmg7OuccSJUan3v93/bq+nzR0/BaOYv2rrmPwjMyWdpXa4x/n4/qzuIWx4SLBlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183993; c=relaxed/simple;
	bh=b50/KqRZSJrHvJ8PwKh3O7g4rpGkItYfHFgIF24gGR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AXB8k0B8a+obV1xq837NSAsp0tJLLcoxFu64+yH/xb2els/tHjRQwtQz+ngke/s/aEwYDBSC5VCW/1NvWbqPi9df49OkLyzqaglc+qTuTmefMYFDO5EmBEEF424huiMV+8bYw5NYM+GT7RUvK/Ep4OY3YJKt6VMALRAbIaNvPZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMs3i6qB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMs3i6qB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3AA1F0155F;
	Mon, 31 Aug 2026 13:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183988;
	bh=Zsg5DFM8qbnxLXoFp7knS8OQtY1ex2yXqdZ6YrS4ARQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fMs3i6qBtUx9bWGgo1iCu0ElWS34+GbAePGuD2R83W3cHvj8q98hQEEwcAJEIxMVq
	 cH+fg0Ih/XPU+ZK378jZPWX2KgGRovL/C1AvQFT7i293b8BjXy6UZOvD/l/ByuIRyW
	 nH5xbFf2z+QwWR3aJb3J1rxXdTecU5ZwxzxBcvhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Jia Yao <jia.yao@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 05/83] drm/xe/guc_ads: use uncached mapping for UM queue BO
Date: Mon, 31 Aug 2026 15:33:41 +0200
Message-ID: <20260831133359.462253447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Yao <jia.yao@intel.com>

commit 8d5134ae4177fa4f5a9bc8e71e6656cfc2852882 upstream.

On Pre-Xe3p platform, the GAM write the UM queue through DPA using UC.
if GuC reads the queue via GGTT (WB), stale data may be observed
when the cacheline has been polluted by another agent.

To match the GAM's UC writes, configure the GuC mapping as UC as well.

Fixes: 9c57bc08652a ("drm/xe/lnl: Drop force_probe requirement")
Cc: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v6.12+
Signed-off-by: Jia Yao <jia.yao@intel.com>
Reviewed by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20260804165057.129529-4-jia.yao@intel.com
(cherry picked from commit 8d5134ae4177fa4f5a9bc8e71e6656cfc2852882)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_ads.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_ads.c b/drivers/gpu/drm/xe/xe_guc_ads.c
index 4f48356ae622b..63017ae2c3818 100644
--- a/drivers/gpu/drm/xe/xe_guc_ads.c
+++ b/drivers/gpu/drm/xe/xe_guc_ads.c
@@ -405,7 +405,8 @@ int xe_guc_ads_init(struct xe_guc_ads *ads)
 		u32 um_flags = XE_BO_FLAG_VRAM_IF_DGFX(tile) |
 			       XE_BO_FLAG_GGTT |
 			       XE_BO_FLAG_GGTT_INVALIDATE |
-			       XE_BO_FLAG_PINNED_NORESTORE;
+			       XE_BO_FLAG_PINNED_NORESTORE |
+			       XE_BO_FLAG_NEEDS_UC;
 
 		bo = xe_managed_bo_create_pin_map(xe, tile, um_size, um_flags);
 		if (IS_ERR(bo))
-- 
2.53.0



