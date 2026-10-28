Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215390;
	b=29bqz1OXfgqOBU7fZgBNvDD7gUiLS83tKtBjCay/bO8Iwaf6S9roeew3M8187jMoSHeW
	 qs28+IjX1VPxpR6WthYL2q0Vrg8XynGq1jMGvU3SwcAuxbo1Ct3L91sFH3PGKnoETyXhX
	 bGsjq6BCozsJpR+90wP6ZUuDljbGa1dfyWrTQVFcfUoVxHtYlFFBHIK+uw871q2DTsktp
	 L4WFGxeOhrv6ybX8RYWnnhzAFr0xQFW6r0u2nuRNwgSjtrluNzjp3wLpn92BS3PSYP1wr
	 RM812KQ1YSn0H+aewIfWSm2eGJAMedg+22GkesSM75sYn1ipp76BpKdcKOJ2mvWCRKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=im7kbvgKq/9cjQWniFD3tQAt+6OqZNAgf7lS9s3Zm6k=;
	b=zrAgqLfC+ZVpqcBkV76rIfgKVtirmNffsJq1rh93O5M2lZ+exmJcSw4brPXYMfucMJfC
	 AyZyr7IVANO4Gjtufun4qMGVqa21x4F6uvbQBnOK8V2PVPtzMeIRQhB7/v+GPjWrPOLKW
	 piMBhmVIZs0cUTJd7cZ81a2+liFNkFq2VLnqRJ7X0wFLsZFWTmzTZB5sXljJ1kO2pHRWh
	 y56hgGHg68Bs7z3Ol6oRggAhabstqFyOad7SVQMPAZJH1wEkZ9cpFmvl6XrPPCV8kF1Ga
	 hxbZTuc6gnA/txgbFDMQwORX81ulP0vc+X1Hy0OnLrnpNlFqtH2P5xmPsmZGSPMoHMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LM1pOhtx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151D8606A31A;
	Wed, 28 Oct 2026 19:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LM1pOhtx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECB31F01828;
	Wed, 28 Oct 2026 19:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215389;
	bh=im7kbvgKq/9cjQWniFD3tQAt+6OqZNAgf7lS9s3Zm6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LM1pOhtxjWVOno1xwVGJMwl0HrRsxRmhc+jidy39GmQMkcINPrWAa7XOrV8mWohKd
	 68mWm3mH5bSr+qdpwfbcKzRl2mPyWqycIX3/vwosCWESre0g0cicIWi5IC4IXoarbS
	 j8fLnIWA2dIdSJ1w2VUz2bfR/2qo+g/sPa896ViM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Linmao Li <lilinmao@kylinos.cn>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1195/1887] drm/vc4: Prevent shader BO mappings from becoming writable
Date: Wed, 28 Oct 2026 17:54:51 +0100
Message-ID: <20261028170526.600080358@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 0c9e6367639548307d3f578f6943ce72c9d39087 ]

vc4_gem_object_mmap() rejects a writable mapping of a validated shader
BO, but leaves VM_MAYWRITE set.  Userspace can map the BO read-only and
then turn it writable with mprotect().

Validated shader BOs must stay read-only: the validator checks the
instructions once and the GPU trusts them afterwards.  A writable
mapping lets userspace rewrite the code after validation, bypassing the
validator.

Clear VM_MAYWRITE on the read-only path so the mapping cannot be
upgraded, as i915 already does for its read-only objects.

Fixes: 463873d57014 ("drm/vc4: Add an API for creating GPU shaders in GEM BOs.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/dri-devel/20260720085554.B0AF01F000E9@smtp.kernel.org/
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260721011558.1672477-1-lilinmao@kylinos.cn
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index 898aabca45a71..df1b8bfb1c215 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -733,9 +733,13 @@ static int vc4_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_struct
 {
 	struct vc4_bo *bo = to_vc4_bo(obj);
 
-	if (bo->validated_shader && (vma->vm_flags & VM_WRITE)) {
-		DRM_DEBUG("mmaping of shader BOs for writing not allowed.\n");
-		return -EINVAL;
+	if (bo->validated_shader) {
+		if (vma->vm_flags & VM_WRITE) {
+			DRM_DEBUG("mmaping of shader BOs for writing not allowed.\n");
+			return -EINVAL;
+		}
+
+		vma->vm_flags &= ~VM_MAYWRITE;
 	}
 
 	mutex_lock(&bo->madv_lock);
-- 
2.53.0



