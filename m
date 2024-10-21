Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288DF1E3787;
	Mon, 21 Oct 2024 10:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506611; cv=none; b=gpX6A4U7hNGOy7Wqsl3RRoe3pZcqAMIc+1nkJL0zruu50W5ivXEBb/SB5bR6HICki6E1vBQ25Og6XdQPlas2Vaakk+JBsQGkEVxG3Om9OVcKd2oJ5IbEWVGTdkn6EVxwWjr1WJ0MzELOT9O3yS7NxnISR2vrYusUZXS/10VAqac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506611; c=relaxed/simple;
	bh=THk2odyZgx46c+ylFziFfLGFUmE0jzErtXvtqs5BDa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oT8ZYNfNxexdWE+/2+LSZZbnDHmMIHLQHicRRaYDoZ60UuwI0MoymZrksnzRun635PTddXNhqeUWEB8ap9fpaZvfJ19VDcPh/F0a8ajp0+Pbjp3/5qNkxu6KdbU4FYPKEg/j8eGUpx65LogXAojI+++AHED2id+QW4v2WAqK3Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khqziLQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khqziLQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7A6C4CEC3;
	Mon, 21 Oct 2024 10:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506611;
	bh=THk2odyZgx46c+ylFziFfLGFUmE0jzErtXvtqs5BDa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khqziLQPCOULDgAE6kwStypcIrqQK/SSGpHcTBH5gfBM0EthxC+Z1WDJUk6fFcEEr
	 HjE+xKMpi2OWqGxwx/yvWxOKovT1lIayR5lF/fjkviZMrEdBmxTy16+HnSWhfHGt4D
	 8MXZIb+qA5iH0riCjyzIT9p8cGKayRXZjeVtsbiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Mika Kuoppala <mika.kuoppala@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 062/135] drm/xe/xe_sync: initialise ufence.signalled
Date: Mon, 21 Oct 2024 12:23:38 +0200
Message-ID: <20241021102301.754133877@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

From: Matthew Auld <matthew.auld@intel.com>

commit 816b186ce2e87df7c7ead4ad44f70f3b10a04c91 upstream.

We can incorrectly think that the fence has signalled, if we get a
non-zero value here from the kmalloc, which is quite plausible. Just use
kzalloc to prevent stuff like this.

Fixes: 977e5b82e090 ("drm/xe: Expose user fence from xe_sync_entry")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Cc: <stable@vger.kernel.org> # v6.10+
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241011133633.388008-2-matthew.auld@intel.com
(cherry picked from commit 26f69e88dcc95fffc62ed2aea30ad7b1fdf31fdb)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_sync.c b/drivers/gpu/drm/xe/xe_sync.c
index bb3c2a830362..c6cf227ead40 100644
--- a/drivers/gpu/drm/xe/xe_sync.c
+++ b/drivers/gpu/drm/xe/xe_sync.c
@@ -58,7 +58,7 @@ static struct xe_user_fence *user_fence_create(struct xe_device *xe, u64 addr,
 	if (!access_ok(ptr, sizeof(*ptr)))
 		return ERR_PTR(-EFAULT);
 
-	ufence = kmalloc(sizeof(*ufence), GFP_KERNEL);
+	ufence = kzalloc(sizeof(*ufence), GFP_KERNEL);
 	if (!ufence)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.47.0



