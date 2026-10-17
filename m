Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9063C3F4B;
	Sat, 17 Oct 2026 17:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258398; cv=none; b=FqLuWAhnBkMuI52ZHaAqtuPQ1DuqKT/HxySc7UX/a0I18d8+xiBUBUUC3fV6ROFmaStFUWUpbFLbIagRpYVJm1aI0VmXVZVGAdrmsZpBTq2fXYR3MKBoEEQlviAiMktD+EP/+qnKPXSf7St44Ll1CbrP33mM8dztybOrBPCHm1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258398; c=relaxed/simple;
	bh=aBpy+Bdv7ExEu3+n7eg85Ou8VJXg8M2+Fr/45SBNAGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kTUFWsG53U+rr+E74VSXiOfU0WysmFIJEvg8JDeCGEReFv/mKwFSVahan8S3Ci174JOzOYz7mDDQoc8y5lkwlHqdo2aq5aTE9GVVTLQ4H1KDgZ2hz0dn8AxyOd1PHgy+1aYZAZAi23XadzHueEkPYXU0X3PqNB0tWLzc5x4O+9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TX0DPruR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TX0DPruR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139D41F000C4;
	Sat, 17 Oct 2026 17:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258397;
	bh=g000+GuFwHU/Qu/PIO5+iu8Ab7YebfMLCoBhB0gqFtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TX0DPruRYnXZ6YNdaGr/16rZtX0lkcXoUaVEF5xa7Py//hKqfkp4tthClnhWKT6x4
	 Vrto5K0gYQWOxMCnJqU9qivW4EcgyZBrfFiqk7bm5cIxJ0J7Jw5BW09p2HSWBWurF5
	 FrHD/pA4xLjRVxiceluf6AUPtgK1abnirzq0hLYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0870/1674] drm/amdgpu: Remove usage of the deprecated ida_simple_xx() API
Date: Sat, 17 Oct 2026 17:52:22 +0200
Message-ID: <20261017160453.442694180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 8a1f7fddabe112f463c2fd5d1e41c9c87d0a9957 ]

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

Note that the upper limit of ida_simple_get() is exclusive, but the one of
ida_alloc_range() is inclusive. So a -1 has been added when needed.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 14b81abe7bdc ("drm/amdgpu: prevent immediate PASID reuse case")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
index 69dfc699d78b0..05344fa5fc0f9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
@@ -62,9 +62,8 @@ int amdgpu_pasid_alloc(unsigned int bits)
 	int pasid = -EINVAL;
 
 	for (bits = min(bits, 31U); bits > 0; bits--) {
-		pasid = ida_simple_get(&amdgpu_pasid_ida,
-				       1U << (bits - 1), 1U << bits,
-				       GFP_KERNEL);
+		pasid = ida_alloc_range(&amdgpu_pasid_ida, 1U << (bits - 1),
+					(1U << bits) - 1, GFP_KERNEL);
 		if (pasid != -ENOSPC)
 			break;
 	}
@@ -82,7 +81,7 @@ int amdgpu_pasid_alloc(unsigned int bits)
 void amdgpu_pasid_free(u32 pasid)
 {
 	trace_amdgpu_pasid_freed(pasid);
-	ida_simple_remove(&amdgpu_pasid_ida, pasid);
+	ida_free(&amdgpu_pasid_ida, pasid);
 }
 
 static void amdgpu_pasid_free_cb(struct dma_fence *fence,
-- 
2.53.0



