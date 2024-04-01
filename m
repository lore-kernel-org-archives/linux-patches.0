Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D654647A6B;
	Mon,  1 Apr 2024 16:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990007; cv=none; b=JzHAfkvwDXrDXQQ5xXiv7KtqjvXaB7O8qv97q2S4Q9Vfagcg5YWMAXbknPtaGkLNzBJfSD6izq7jwlJO6GM37FSDb5/ehW+rdBNQeTALK6hHhj0PbCPTuNkPCsaBt6tkK9Bpil/A+z8Grdfg0e8j3afkr+rxEmfijYRFmNBIyvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990007; c=relaxed/simple;
	bh=bG+Mios9qKv/JM7f5IX5TdeFKSmUXfMl82RIW3qsdGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5eKqTjz3lHEQv29uTke3qKloJ2ATuzGprs5T2Ki01w0BD0MzpE2QWllpAnU3lkAavqcckmneC/UDrHUWIy3u1cCuFKLVElEkjFTXO7RsZtil0ik/huzuGNSKQYAzLAXR1d6khZ1UcWor5FVXUQWdFkB2H6IhVo1vMEOLWPZyf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWuLz8tk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWuLz8tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FB4C433F1;
	Mon,  1 Apr 2024 16:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990007;
	bh=bG+Mios9qKv/JM7f5IX5TdeFKSmUXfMl82RIW3qsdGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OWuLz8tkgLOYUcBFa/BZx4QNIkimiv6QUHHhsvhP+S2i0pWjgEJ26UC4K13lmxioV
	 Ko7fh7MLyUrykInDIfscY4b739Nk/oJ6U6KFIJb4BwQD5bBep1Z7L6XjtwhU0yxy7m
	 /DexvlKkYnPGnIs1icrkgV8Buoa9uL5Z3hROfRC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Shawn Lee <shawn.c.lee@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.6 219/396] drm/i915: Check before removing mm notifier
Date: Mon,  1 Apr 2024 17:44:28 +0200
Message-ID: <20240401152554.449769604@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoy.das@intel.com>

commit 01bb1ae35006e473138c90711bad1a6b614a1823 upstream.

Error in mmu_interval_notifier_insert() can leave a NULL
notifier.mm pointer. Catch that and return early.

Fixes: ed29c2691188 ("drm/i915: Fix userptr so we do not have to worry about obj->mm.lock, v7.")
Cc: <stable@vger.kernel.org> # v5.13+
[tursulin: Added Fixes and cc stable.]
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Shawn Lee <shawn.c.lee@intel.com>
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240219125047.28906-1-nirmoy.das@intel.com
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
(cherry picked from commit db7bbd13f08774cde0332c705f042e327fe21e73)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -379,6 +379,9 @@ i915_gem_userptr_release(struct drm_i915
 {
 	GEM_WARN_ON(obj->userptr.page_ref);
 
+	if (!obj->userptr.notifier.mm)
+		return;
+
 	mmu_interval_notifier_remove(&obj->userptr.notifier);
 	obj->userptr.notifier.mm = NULL;
 }


