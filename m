Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38CE1A2392;
	Wed, 17 Sep 2025 12:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112822; cv=none; b=lOBdYi/keq5YY2ER8Fj+UHkpR/YP5UoCMLCvOUdHyKaIU8W7hZi+LuRU+RqvUJmPiwLqzeX+GCjGAI42E2EEEaUX3gdMu1/gskCNAEM3dG9fwXkCRv5WX6JuM87DCpj5lSSTmuc9fl26Ww3E/M0TDAmoducvA9PcvYmabr0y0JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112822; c=relaxed/simple;
	bh=4tEzqz2WSVPVslxmhsnu3g04/OAhjS9DBYfrcR0bwAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HJiX2nOWz9zW7X5mo3xYLp2Ppa239ozC36+pYLShmb5b8xCnvx6ZoBFYeJGwrtKkRdI4cHUMYT1jtYyc/xmPhgGqdiPn9lnN6TzukvVmCdUF0cNImD53Y4G03WzBAI/mVHXyWYfJvKFAf3NTKt3O7ncsgn2t+KAbXhy36NGR5ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZF/vFV9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZF/vFV9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27D0C4CEF0;
	Wed, 17 Sep 2025 12:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112821;
	bh=4tEzqz2WSVPVslxmhsnu3g04/OAhjS9DBYfrcR0bwAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZF/vFV9g13yePgoQeGZ1aDxdh5l7AkAYvEyz0V/8oVe6hPhS0vgfYeRXW7FLfIYMA
	 B2UtVgXCouEL92azlzvjizRjjEjzxtAupD1kHMTyFsMAoQbh9Rdh8RHEVY40/9Vn1I
	 Zruk7NBTfGMKay7GI78MGEnwGq+YYqByJDLYHStw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.16 086/189] drm/xe: Allow the pm notifier to continue on failure
Date: Wed, 17 Sep 2025 14:33:16 +0200
Message-ID: <20250917123353.957966815@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit d84820309ed34cc412ce76ecfa9471dae7d7d144 upstream.

Its actions are opportunistic anyway and will be completed
on device suspend.

Marking as a fix to simplify backporting of the fix
that follows in the series.

v2:
- Keep the runtime pm reference over suspend / hibernate and
  document why. (Matt Auld, Rodrigo Vivi):

Fixes: c6a4d46ec1d7 ("drm/xe: evict user memory in PM notifier")
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: <stable@vger.kernel.org> # v6.16+
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://lore.kernel.org/r/20250904160715.2613-3-thomas.hellstrom@linux.intel.com
(cherry picked from commit ebd546fdffddfcaeab08afdd68ec93052c8fa740)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_pm.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -296,17 +296,17 @@ static int xe_pm_notifier_callback(struc
 	case PM_SUSPEND_PREPARE:
 		xe_pm_runtime_get(xe);
 		err = xe_bo_evict_all_user(xe);
-		if (err) {
+		if (err)
 			drm_dbg(&xe->drm, "Notifier evict user failed (%d)\n", err);
-			xe_pm_runtime_put(xe);
-			break;
-		}
 
 		err = xe_bo_notifier_prepare_all_pinned(xe);
-		if (err) {
+		if (err)
 			drm_dbg(&xe->drm, "Notifier prepare pin failed (%d)\n", err);
-			xe_pm_runtime_put(xe);
-		}
+		/*
+		 * Keep the runtime pm reference until post hibernation / post suspend to
+		 * avoid a runtime suspend interfering with evicted objects or backup
+		 * allocations.
+		 */
 		break;
 	case PM_POST_HIBERNATION:
 	case PM_POST_SUSPEND:
@@ -315,9 +315,6 @@ static int xe_pm_notifier_callback(struc
 		break;
 	}
 
-	if (err)
-		return NOTIFY_BAD;
-
 	return NOTIFY_DONE;
 }
 


