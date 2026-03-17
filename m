Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9B93EAC6F;
	Tue, 17 Mar 2026 16:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766320; cv=none; b=ua8Y1j7pXISA7wO+OWDx6Gt1TQD8I77KSGbFJeEmTplcPhb2TCJPbr4vI8C7oqhiPx6mJm/4JvCWXagmhxZRliPaXrR0qLZut0R4sRLw7As57zw+prihBUJikqfs/4SulEvgxGlbk1o4Sb1i7/AdEKK0P2Kvvis1zDwNtjYmhQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766320; c=relaxed/simple;
	bh=WT1MSkKr17WHZgbWTW/ew+TITKG7DltKEUHS9OESgys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gyoZeXOWGMaPky9e5mjDqqwyyNtS44IkGozdtrDI5ROmow6uhSasHfYzLpN5ob5clYqCZ+bvb9tV4usPXDHkHVpSunmyWZJhne3fMB8TWNtiWnZyQ0qATLvqV/BCynIWXE2DMViFX+YGX3NVlxoEN36+OAi25+IWR/HmBRjIQTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZmSzksV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZmSzksV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4932C4CEF7;
	Tue, 17 Mar 2026 16:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766320;
	bh=WT1MSkKr17WHZgbWTW/ew+TITKG7DltKEUHS9OESgys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZmSzksV9BN4Tvz61Q+0eEqdmuMqY9wkcglvq/UdKvLIZXjv8I8IfL+wIibPMpwVK
	 JSek5QERg62zL+EsU8pc5uhHUv7/9kpGBni083OvDOilbISUrmJoVBTOQrObt/yDKy
	 z4U16IpN4GBq5o09LaYBxOc1jTB5q1W+d0Kv1fwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.19 218/378] drm/amdgpu/userq: Fix reference leak in amdgpu_userq_wait_ioctl
Date: Tue, 17 Mar 2026 17:32:55 +0100
Message-ID: <20260317163015.031516289@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit 49abfa812617a7f2d0132c70d23ac98b389c6ec1 upstream.

Drop reference to syncobj and timeline fence when aborting the ioctl due
output array being too small.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: a292fdecd728 ("drm/amdgpu: Implement userqueue signal/wait IOCTL")
Cc: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 68951e9c3e6bb22396bc42ef2359751c8315dd27)
Cc: <stable@vger.kernel.org> # v6.16+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -880,6 +880,7 @@ int amdgpu_userq_wait_ioctl(struct drm_d
 				dma_fence_unwrap_for_each(f, &iter, fence) {
 					if (num_fences >= wait_info->num_fences) {
 						r = -EINVAL;
+						dma_fence_put(fence);
 						goto free_fences;
 					}
 
@@ -904,6 +905,7 @@ int amdgpu_userq_wait_ioctl(struct drm_d
 
 			if (num_fences >= wait_info->num_fences) {
 				r = -EINVAL;
+				dma_fence_put(fence);
 				goto free_fences;
 			}
 


