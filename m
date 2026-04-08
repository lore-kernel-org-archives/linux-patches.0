Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A1732A3FD;
	Wed,  8 Apr 2026 18:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674564; cv=none; b=IPsQfRKGuKWhHvWtxKtwU00GORZGk8WzYbNKcToooRL8GSiIM1r4fn7jNwP6+3FAXFnzdqpnlyLKps++DFWI49A0nNkxjpKW4TODsoOXAUvBNbVx8BOpXx6Bk5i485SQlq2XKT/KH5ORWlPH/KylsW3TDNpdMouBxTzi0gptaKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674564; c=relaxed/simple;
	bh=4DG/VGxNV6s4nDdnQCOyPctoESdrYsglRxk3qwWCC/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVFGwEXzEUJIDhflcZmLgPOR5ZwKoAR1Y1PvGLlCGErTm+cVxJBuckN2z+fIsOpThq35sXuFRvuJXn0M/oSZXNjGwiIl+an4HeS3BIu33A09VnbFidvdxVO+6jfGdkkamb4JMMTn2gQCAoFBGKj2a1+0gFeQLdSDNcHh4U5t48c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Vu/UZVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Vu/UZVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7035C19421;
	Wed,  8 Apr 2026 18:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674564;
	bh=4DG/VGxNV6s4nDdnQCOyPctoESdrYsglRxk3qwWCC/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Vu/UZVdzUVEXJ/DH2OD0QHDFsOauRFD/3znf1LYPSE93k/XrDLPrvMLf2q1sDh2y
	 OrcJAHqp0ENY5dLoVw0lrQamyhVbX+ZN/q0bknZscwTpG5OQZyYN57i7uDtQlAGXOw
	 dh43jDKc4nG/kFKe7fZGqgw690jWTfhK8sRtYxak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 147/311] drm/xe/pxp: Clear restart flag in pxp_start after jumping back
Date: Wed,  8 Apr 2026 20:02:27 +0200
Message-ID: <20260408175944.899881289@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit 76903b2057c8677c2c006e87fede15f496555dc0 ]

If we don't clear the flag we'll keep jumping back at the beginning of
the function once we reach the end.

Fixes: ccd3c6820a90 ("drm/xe/pxp: Decouple queue addition from PXP start")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Julia Filipchuk <julia.filipchuk@intel.com>
Reviewed-by: Julia Filipchuk <julia.filipchuk@intel.com>
Link: https://patch.msgid.link/20260324153718.3155504-9-daniele.ceraolospurio@intel.com
(cherry picked from commit 0850ec7bb2459602351639dccf7a68a03c9d1ee0)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pxp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_pxp.c b/drivers/gpu/drm/xe/xe_pxp.c
index fdcecc026e937..9261a8412b64f 100644
--- a/drivers/gpu/drm/xe/xe_pxp.c
+++ b/drivers/gpu/drm/xe/xe_pxp.c
@@ -532,7 +532,7 @@ static int __exec_queue_add(struct xe_pxp *pxp, struct xe_exec_queue *q)
 static int pxp_start(struct xe_pxp *pxp, u8 type)
 {
 	int ret = 0;
-	bool restart = false;
+	bool restart;
 
 	if (!xe_pxp_is_enabled(pxp))
 		return -ENODEV;
@@ -561,6 +561,8 @@ static int pxp_start(struct xe_pxp *pxp, u8 type)
 					 msecs_to_jiffies(PXP_ACTIVATION_TIMEOUT_MS)))
 		return -ETIMEDOUT;
 
+	restart = false;
+
 	mutex_lock(&pxp->mutex);
 
 	/* If PXP is not already active, turn it on */
-- 
2.53.0



