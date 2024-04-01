Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B603D961;
	Mon,  1 Apr 2024 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988782; cv=none; b=abSc+VLEMnQGTts7vmkEkH9jQCDj/IUK76i+qz9PN3LxgSxl8c7repPICdAmF+LfX4q3TBi8SCK4NVpOb86pw/Yt9o87e25LkqQPvQ35kJ+lF+bnqcSVLzT9VBacih75d8bKZ9cxiLBbGtsgA2S4OulY0LfCzRFXlMS25+Ttp2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988782; c=relaxed/simple;
	bh=eQRjCSHRfP0qhbXu0/qcY/3bJaxhLPakun/FnXcfu4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPngGT2Ce5mOBkA0mwhbKETWC3+6qayBdffCHEvqoJycCvhSha0buPIpt0BbdJqQn4Wk+1wUINwbcgw1yIwDG4pMwmX2QKPFNcNd7nUoDbldTXFmhYzrhNzJjDi8TxD1oRUsYAfLZw8f9LHqiBD9eoTrOBYBAom3cdKLWrNPSew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUgEuA7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUgEuA7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D05CC433F1;
	Mon,  1 Apr 2024 16:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988782;
	bh=eQRjCSHRfP0qhbXu0/qcY/3bJaxhLPakun/FnXcfu4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUgEuA7Bi3jCRg5abBHD4Z6hZKt4UIuaV1fj2lsEBvtJKxgtUvy13PAxrbm9N+3J1
	 drxNMndhShkyao6df6CBQ/vM6AsuvgYsJ5JOILXKMPeYSaFuxM2GCA0g5OLW+ClCf9
	 W3mTaK1/hzksx6Eo81//L575NwH1HGvJRQhrxPDE=
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
Subject: [PATCH 6.7 259/432] drm/i915: Check before removing mm notifier
Date: Mon,  1 Apr 2024 17:44:06 +0200
Message-ID: <20240401152600.874052498@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


