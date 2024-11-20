Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1851A9B5A;
	Wed, 20 Nov 2024 12:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107546; cv=none; b=JL/skg0uOvTPOh9HT4KB75xvOYvr7wh2xCVtBtasW63JqhwZVUTkOAWpnVlr1ZEM+SbUKN7Jn7QI7y6+aoSazIXoRYKc1bUz2dnH1/deV019/ctNzH3h64OQM7+GL50PlA1sukFvtAMNDkfnuAKCip8f8Oiw12IRI9xiW9/8Vi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107546; c=relaxed/simple;
	bh=3k+sMIyyINBVFg/3O15eqRqPgPhMex8NkWJmaiE7KMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mL9imEsPafFQbtiISwtj3OfRH4IV5A7cauMX+2nurzpOZGE2jia5sWGVScA9/T9k0FZqEwnJURaQBuch5upfoCwcob3+iiw9NLl/OX3XBl1emTsRczU7uiFtAxVy7pg5GMEahiNoMoeL38qfkaY44yod3BgCWujhfxEZJ3Bv1qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmvoc/D6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmvoc/D6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D06C4CECD;
	Wed, 20 Nov 2024 12:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107546;
	bh=3k+sMIyyINBVFg/3O15eqRqPgPhMex8NkWJmaiE7KMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmvoc/D6Zyzrod4dxyH1rVzg2jVSBSCdnlXVmKSxWrDwRCLC1X7Y6Bf6g+OrETT6/
	 mhtvBxQzvcQGFs841ed4gGl3CO5Z8o+NHKTelmMRYx6gJo+QhmGG4urKKDrFcbyf+f
	 vjGuoYXsoVvTjWasmMJsgqt9+pqsgCuiXkOzFAnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Harrison <john.c.harrison@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 085/107] drm/xe/oa: Fix "Missing outer runtime PM protection" warning
Date: Wed, 20 Nov 2024 13:57:00 +0100
Message-ID: <20241120125631.612610728@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

commit c0403e4ceecaefbeaf78263dffcd3e3f06a19f6b upstream.

Fix the following drm_WARN:

[953.586396] xe 0000:00:02.0: [drm] Missing outer runtime PM protection
...
<4> [953.587090]  ? xe_pm_runtime_get_noresume+0x8d/0xa0 [xe]
<4> [953.587208]  guc_exec_queue_add_msg+0x28/0x130 [xe]
<4> [953.587319]  guc_exec_queue_fini+0x3a/0x40 [xe]
<4> [953.587425]  xe_exec_queue_destroy+0xb3/0xf0 [xe]
<4> [953.587515]  xe_oa_release+0x9c/0xc0 [xe]

Suggested-by: John Harrison <john.c.harrison@intel.com>
Suggested-by: Matthew Brost <matthew.brost@intel.com>
Fixes: e936f885f1e9 ("drm/xe/oa/uapi: Expose OA stream fd")
Cc: stable@vger.kernel.org
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241109032003.3093811-1-ashutosh.dixit@intel.com
(cherry picked from commit b107c63d2953907908fd0cafb0e543b3c3167b75)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_oa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index 2804f14f8f29..78823f53d290 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -1206,9 +1206,11 @@ static int xe_oa_release(struct inode *inode, struct file *file)
 	struct xe_oa_stream *stream = file->private_data;
 	struct xe_gt *gt = stream->gt;
 
+	xe_pm_runtime_get(gt_to_xe(gt));
 	mutex_lock(&gt->oa.gt_lock);
 	xe_oa_destroy_locked(stream);
 	mutex_unlock(&gt->oa.gt_lock);
+	xe_pm_runtime_put(gt_to_xe(gt));
 
 	/* Release the reference the OA stream kept on the driver */
 	drm_dev_put(&gt_to_xe(gt)->drm);
-- 
2.47.0



