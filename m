Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216A92E62C;
	Mon,  8 Apr 2024 13:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581812; cv=none; b=jIrJIKoHswwxczOQMXbjxd7n3xl4g8Y+O3Y/PPDguEAPKDElFVZ/8D1w8q2oTiJmCURblb2eaCnB54KJO4UEdB6zPtIBpil1zQ68eSbKZVi1uTLf7NzZ/o8BNi2Plz/w/tOr88fdgRS7zaPyoEWzmAMNUACdfScXzjkPMBPAeDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581812; c=relaxed/simple;
	bh=c92MWDbZbtzJv8pdC4nfnPBCw//hGba42gzenEtehSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xw1B9pMT7PrSHYvM5GRAVaQ1XmoAMvTCLCEhIZrp0zfDwyNQy0aqehFL+G1/m/Wk173N99GOxB4zRdXJrzQ39QZ7PQkvitojpkKrrv+eJQiZynTPudPCqs+nJ8ytsEHpta4EK/P9QFVlg/5OHnYMrZ2ynRRXkghBkWX7FdQwWQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbSpNHrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbSpNHrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F562C433F1;
	Mon,  8 Apr 2024 13:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581812;
	bh=c92MWDbZbtzJv8pdC4nfnPBCw//hGba42gzenEtehSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbSpNHrRGvK5IxYp4qoyXwl7rcAqcc7lBtg0VY1Nyw/Zx4ioIrod2Q6bqGsoUG8Xf
	 XDuRqWnibjKQhhiu6SopDomWP5J7CBy/tPuVo5IboGXG15NAWmIvYgldv3ay2lVHKJ
	 BA+IwCsNG+htxseCGU05ta6fKPOVddmYAsj4ynCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 022/273] drm/xe/queue: fix engine_class bounds check
Date: Mon,  8 Apr 2024 14:54:57 +0200
Message-ID: <20240408125309.982402668@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit b7dce525c4fcc92b373136288309f8c9ca6c375f ]

The engine_class is the index into the user_to_xe_engine_class,
therefore it needs to be less than.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240318180532.57522-4-matthew.auld@intel.com
(cherry picked from commit fe87b7dfcb204a161d1e38b0e787b2f5ab520f32)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index a176d9ad6d1b8..5093c56d60ab6 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -405,7 +405,7 @@ find_hw_engine(struct xe_device *xe,
 {
 	u32 idx;
 
-	if (eci.engine_class > ARRAY_SIZE(user_to_xe_engine_class))
+	if (eci.engine_class >= ARRAY_SIZE(user_to_xe_engine_class))
 		return NULL;
 
 	if (eci.gt_id >= xe->info.gt_count)
-- 
2.43.0



