Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BD038F92A
	for <patches@lists.linux.dev>; Mon, 27 Apr 2026 06:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777272735; cv=none; b=emGMjCPNc36byr0qzTqgZTgZ3MzYa3KueVrY7viZ25z6ppoCULvsWN5smlb2+sIjWcAu6hvUTAduqqiJMSJtZtYyd7uVOC0m6x5SzQRyAPV1d92qqfj9r2QJj3zaa/Pp0iLbTz11+C6kW5LgVrrsr+Vket+j3tJdDppUltkEnWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777272735; c=relaxed/simple;
	bh=LRD7oLtudIamBREpgjy5kneg6OcHg91ArzImy3XTXnA=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=Wfy7aDSE8w7cK+1WJAKVJwA0z67tCMwHihKca0WZRov+50kh6JBs3YAapKfr/+dFUMOLF6TVXJ+45iPunjq+6vrydKGhV8iaOWnirkCRg/ifOa9YAWrZDbygS33Eur0PnM9e0qu0DTt99Q/7nOCL3qwHRDRVNP6RpFmE+NgWBcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Vz5UDqoP; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Vz5UDqoP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777272721; bh=7eoDS3JbR1q53aB5qfXy+6cxeaSinsD0OmwzLxXmZTs=;
	h=From:To:Cc:Subject:Date;
	b=Vz5UDqoPV1KFYWOhm6zasnBn1UJmHrV6TgEyD7qWzhOcWjiEhTaYAPDaPgMspFcs2
	 3TiE1C4djnkmvnse2Wu0na3I/j/Is7lgoRfRMqspyQwGHtG8oNkGSy/DJQFzkh9J3K
	 YamNVvRFXfe1fg+v+tuvezi1DbVQZxlQVXs4TTYE=
Received: from NTT-kernel-dev ([60.247.85.88])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id CFA1B0D6; Mon, 27 Apr 2026 14:51:58 +0800
X-QQ-mid: xmsmtpt1777272718taqvoj5v5
Message-ID: <tencent_7000919DF2E0E898B39B6394B77AFCBA6307@qq.com>
X-QQ-XMAILINFO: OVFdYp27KdlJqcnwnva7b1H+V1NghqGV6lPV+Y5erHH8XEnlKKbfjNUiiPjfx5
	 49fNKR9ub66m2W47d7c6kChayWE933hZaniYHIjkDuDi4dByW5eQXBCD7DF7fdUpL6oy0zCc9gGZ
	 bOJBCNtdVj6O9DZG0o6U9aGCt4NvcLk9JOJ8MF3yYD7nWpwYxEVCtqoG4eFSYVGPaDlv+KGxht9g
	 F/sZvMcvp/o1A4wHmlewTiLXUJz5RXbetM68kSyStyhlLPO5HpbBLivp0PfRnu4giUjDDw44D9FT
	 PAaVv/eC3+TKYH6FyzLW7qQKB909bif66wySFecXFkcB1UXvNZG3DAeOCc1vzuqtd637ezdZTeN+
	 hJ1DEVAXBn1tkT3OuH9wfDN5o5ljcL4/FSwl1BhgzmrsuVVY1HxqHlDvbUTwp+FfAbh+GdZ8jvCK
	 cxiM/PIJDMK4u8nwPSkLtEa3nCkQxco4VoEW8KMYtOjKEeAAk+DSmbJ3B+Wc/DLrwld2uO5KaHSv
	 nzAjbo8nOEJgHRw0zklMUNh0scRZmMytZuvYMtldOjFjmnoe2dvKrnvqlzMPDlii86bsjr7HmYmf
	 /XXTFABrX0XzWCcbPm2K7i/q/rC0sOW+0qBz4eqUM5kx23vNJmoB7oG8GAVrSPMEmivNzgvifq35
	 3VnFpzJ74BqaHdL5eTqrLnIQqN6kuDdjkGA0Jg0lGljrhevM+Di/J6Bq1Qt4cf2XpFq1e7baIu9r
	 5vCTlCGIzE89h6YsZEqsuU3TFrtowuGMyszgUz40jEZ43Ep9vEY7dBxg1hscJRIx+0RSyA+L9026
	 RiLBsQ+BzPJf+2k+4UfHlxUIh/TlgAahcqU0VvBck2sEcaxwr+oeFKCjtzs/ch6p5C9avZM1I2LF
	 O0RTdBeVnm01LDGd/T2wZ1O1Q/8MWsWI9spFc4UBYZFb+7sIkrc+x0bxNu2Rx3Bb52CcHLD3KluJ
	 Fh0BFztB7/YS9dOF1VjYksBGO+5tRmb+PFEPzseJCCucVBVmEXWYXuGP7C6pNTxYSzf+4zHlSLbK
	 qDrgZGwDgPHsyIib/S
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Fang Wang <32840572@qq.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	tvrtko.ursulin@igalia.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	alexander.deucher@amd.com,
	christian.koenig@amd.com,
	Xinhui.Pan@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	Jesse.Zhang@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.12.y 2/2] drm/amdgpu: Limit BO list entry count to prevent resource exhaustion
Date: Mon, 27 Apr 2026 14:51:57 +0800
X-OQ-MSGID: <20260427065157.4118642-1-32840572@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Jesse.Zhang" <Jesse.Zhang@amd.com>

[ Upstream commit 6270b1a5dab94665d7adce3dc78bc9066ed28bdd ]

Userspace can pass an arbitrary number of BO list entries via the
bo_number field. Although the previous multiplication overflow check
prevents out-of-bounds allocation, a large number of entries could still
cause excessive memory allocation (up to potentially gigabytes) and
unnecessarily long list processing times.

Introduce a hard limit of 128k entries per BO list, which is more than
sufficient for any realistic use case (e.g., a single list containing all
buffers in a large scene). This prevents memory exhaustion attacks and
ensures predictable performance.

Return -EINVAL if the requested entry count exceeds the limit

Reviewed-by: Christian König <christian.koenig@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 688b87d39e0aa8135105b40dc167d74b5ada5332)
Cc: stable@vger.kernel.org
Signed-off-by: Fang Wang <32840572@qq.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
index 66fb37b64388..ded22f244ada 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -36,6 +36,7 @@
 
 #define AMDGPU_BO_LIST_MAX_PRIORITY	32u
 #define AMDGPU_BO_LIST_NUM_BUCKETS	(AMDGPU_BO_LIST_MAX_PRIORITY + 1)
+#define AMDGPU_BO_LIST_MAX_ENTRIES	(128 * 1024)
 
 static void amdgpu_bo_list_free_rcu(struct rcu_head *rcu)
 {
@@ -190,6 +191,9 @@ int amdgpu_bo_create_list_entry_array(struct drm_amdgpu_bo_list_in *in,
 	const uint32_t bo_number = in->bo_number;
 	struct drm_amdgpu_bo_list_entry *info;
 
+	if (bo_number > AMDGPU_BO_LIST_MAX_ENTRIES)
+		return -EINVAL;
+
 	/* copy the handle array from userspace to a kernel buffer */
 	if (likely(info_size == bo_info_size)) {
 		info = vmemdup_array_user(uptr, bo_number, info_size);
-- 
2.34.1

