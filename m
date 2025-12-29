Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F991AF0AF;
	Mon, 29 Dec 2025 16:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025318; cv=none; b=Q7r3EPZgTMNv2OBKneS5xTC82VfUVwRA5w4fMXTB4Zs3HIH3kj0n9ldtexn6Gc56ZPeXk8OYt/yaeO4kPP2q7g2Nmt/jVbdCYFrgMtjWrJ2vgJsPxN0HzwWrgCBpRLx9OxIsjLqU+6W6tNpXfwW94Kg3tUGPEDFfKguOstIHc/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025318; c=relaxed/simple;
	bh=SYmXgv4FllHkFMPSWzxJ7WWL+G/uXvgkAEBoqgFY2PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AWd3InaaUCeTbZ9nZ8FG1z9cuEUGOhTrxVTequ3uChSbk+vnK58nwbX1XOi7v22HWhdCnCvYizmNUhI4NQcZJeweSAOfbbj90XQIzuI5ubqkyDLlJZOCLVSXRNDTzZ5HSqUk4tWbvST872Am2Xjzck9o9rMidy48HXbMoPolENU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhvzGUOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhvzGUOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279B3C4CEF7;
	Mon, 29 Dec 2025 16:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025318;
	bh=SYmXgv4FllHkFMPSWzxJ7WWL+G/uXvgkAEBoqgFY2PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhvzGUOKQBlnjjONeTkwqrb+rPbSWDWOeF4mUkuyaFooJatYS4O2PBNn0S+Qi42XL
	 Qi2hvLVJXUcUa2dyZpXyjE8+E/q7JXUP7XxN2PCbi1AaZNY+qMSRcGWkOeBYMbKu2M
	 L1GXkmJ1n7IjwxQ9fb3nmOPRGhPe/bRAlULXEBio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 138/430] drm/xe/oa: Limit num_syncs to prevent oversized allocations
Date: Mon, 29 Dec 2025 17:09:00 +0100
Message-ID: <20251229160729.442941974@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit f8dd66bfb4e184c71bd26418a00546ebe7f5c17a ]

The OA open parameters did not validate num_syncs, allowing
userspace to pass arbitrarily large values, potentially
leading to excessive allocations.

Add check to ensure that num_syncs does not exceed DRM_XE_MAX_SYNCS,
returning -EINVAL when the limit is violated.

v2: use XE_IOCTL_DBG() and drop duplicated check. (Ashutosh)

Fixes: c8507a25cebd ("drm/xe/oa/uapi: Define and parse OA sync properties")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20251205234715.2476561-6-shuicheng.lin@intel.com
(cherry picked from commit e057b2d2b8d815df3858a87dffafa2af37e5945b)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index 125698a9ecf1..10047373e184 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -1253,6 +1253,9 @@ static int xe_oa_set_no_preempt(struct xe_oa *oa, u64 value,
 static int xe_oa_set_prop_num_syncs(struct xe_oa *oa, u64 value,
 				    struct xe_oa_open_param *param)
 {
+	if (XE_IOCTL_DBG(oa->xe, value > DRM_XE_MAX_SYNCS))
+		return -EINVAL;
+
 	param->num_syncs = value;
 	return 0;
 }
-- 
2.51.0



