Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618843;
	b=wJEevVPfIdRoqNzfxM0EbGCHmw6QUue6pjKoaqm7TuVc/3E9w6oAC+2MlAVG8EJ5/y3r
	 +di/hHoLK3bq1M7J2xxITUvcYIh49yU2Hcy3bg/lljbEmsXhkMdWM4uwjDISow09tz674
	 q+z3h/uRG7JsSpSGPs94/+d8azENny9Bhi/TmrBGO4i245GHSs+97cwMyYDVb4lTgiL4Z
	 Zngky7zFl/IAX6ioleVmKd3UkOYUH/9OhQ2cimwPNz3F/nDljrHmKCgFMXy1I03O2hP8Y
	 NQ9GBcMy6ISZh15lQMaGr1SYWbFX4w6bKgxWPGnu242UTG+75xWK4VkaDEm2dT/WC+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dECGgWJ9KI8manjf6Ax/HIiu4R6mUlY6FKgoY9xNp8k=;
	b=U5H2fWqNmg/ji1hN9y9NZTWGPPUqbVD+GY321kMOOKecadQB5o3R8eMIx11b3opyFnZo
	 qS87+M+S8EDPVl+TukLVpIK0AjFJ0VykQ4MA5VRGvMTLsZCVTy8RBV1vHFwUb4oY2gsT6
	 XYiCYG1lFVlQ7W6Yi6tinlH043AcS/Nkax9jcEvx0D+f4h/Vhd7XezCooAMTpHzCrga0V
	 x9Eou4qmin81PWsr0j/2QObAFZN93xsle/GaK8hNxNJsz9k1zpcUOU9zVmRTXcQPGkNDJ
	 u8BIokzjM68WySVDREQvU92b8Z2yoUwVCIZ46h69i1c7LBCiVGDCpJRy4VrGYYn5jAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tXGK2pyI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6467B606A321;
	Wed, 25 Nov 2026 15:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tXGK2pyI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9A01F000C0;
	Wed, 25 Nov 2026 15:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618842;
	bh=dECGgWJ9KI8manjf6Ax/HIiu4R6mUlY6FKgoY9xNp8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tXGK2pyIA4stcmWMwKAE68rUmC0b1VahYZqmDkcPyBAunZ1wSpzQK3eEFmhrO5xg9
	 8LQaGjjfH6qhmTFPjM670eokWNIRf9aWs0tTM1QQxIpUyHz07HkzOTMiK83ScplnuX
	 S5GkYFjHuMX2Lan7xbuMiUbDpi1Q23nEmoTUA0os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Arvind Yadav <arvind.yadav@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0404/1005] drm/xe/svm: Preserve default PAT index when resetting VMA attributes
Date: Wed, 25 Nov 2026 15:29:02 +0100
Message-ID: <20261125143831.217050290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arvind Yadav <arvind.yadav@intel.com>

[ Upstream commit e800602296e8668b4cf143fc12d7cee4b31e64aa ]

xe_vma_set_default_attributes() replaces the VMA attributes with a
default structure. It sets pat_index to the saved default PAT index,
but leaves default_pat_index zero.

When the saved default is non-zero, the two fields no longer match.
xe_vma_has_default_mem_attrs() then reports that the reset VMA has
non-default attributes, triggering a warning in xe_vm_alloc_vma()
during SVM garbage collection. A later reset also uses the incorrect
zero value.

Preserve default_pat_index when restoring the default attributes.

Fixes: 4a938d3886d6 ("drm/xe: Merge adjacent default-attribute VMAs during garbage collection")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20261027085952.2882874-1-arvind.yadav@intel.com
(cherry picked from commit ce155027427a0c76be173f19f911b414d9d686bc)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xe/xe_svm.c b/drivers/gpu/drm/xe/xe_svm.c
index b228a737cfd6d..281b81c28e16d 100644
--- a/drivers/gpu/drm/xe/xe_svm.c
+++ b/drivers/gpu/drm/xe/xe_svm.c
@@ -330,6 +330,7 @@ static void xe_vma_set_default_attributes(struct xe_vma *vma)
 	struct xe_vma_mem_attr default_attr = {
 		.preferred_loc.devmem_fd = DRM_XE_PREFERRED_LOC_DEFAULT_DEVICE,
 		.preferred_loc.migration_policy = DRM_XE_MIGRATE_ALL_PAGES,
+		.default_pat_index = vma->attr.default_pat_index,
 		.pat_index = vma->attr.default_pat_index,
 		.atomic_access = DRM_XE_ATOMIC_UNDEFINED,
 		.purgeable_state = XE_MADV_PURGEABLE_WILLNEED,
-- 
2.53.0



