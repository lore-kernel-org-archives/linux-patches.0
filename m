Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F6B2DEA9D;
	Tue, 17 Mar 2026 17:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767897; cv=none; b=l+bqGTVyaZoSCu5nyMfaCk3i3piT1jNNmSx0OFJZ6BTlf4l0X08Pm1nWjlnpqSz5nu3Gj+WxD1hC6oPj++i/D274G4gfVQ8h7rvUm+C5wfM8CD77wTNTM5VJQPi06JgpzhaJtzP3hPz5wsnczGIn6d60g2vxcdVSuhf/vayMh7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767897; c=relaxed/simple;
	bh=r0z/zix7udYCVwpwAcZbGL/PRRMc5+X6R8MYdMaEEVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sU4tJcqtaiPRnFJZI1cHDB6ZhpGhmf4GY0ROj+XpD3E363/OKrlFeEWPx54mgDLHHnnzImk8hDP+uLKwcf0S023b7u4+V4W8HjVESoCZYv9CS9LHFGcrkWBqU6QmISwtpVEGtbO2zAnh+4fGG5XcONCzcDfYj3cvNrFAok90hzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+A4507K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+A4507K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98FCC4CEF7;
	Tue, 17 Mar 2026 17:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767897;
	bh=r0z/zix7udYCVwpwAcZbGL/PRRMc5+X6R8MYdMaEEVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+A4507KKXwooLewhtDmHELC56IKz+tWPP2ZPBVCuE9sHpAFbTfKLv97OKywR+V+H
	 5tZvTtAukYdBa6bkv404U0rxfHqVR/xwnpLgw3h54yrzAvalGn2LQZzUK60gc0bQ9n
	 x+OY4qtFd5B12qu98se9YyJHS22hVr7CVAoEjqfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.18 184/333] drm/amdgpu/userq: Fix reference leak in amdgpu_userq_wait_ioctl
Date: Tue, 17 Mar 2026 17:33:33 +0100
Message-ID: <20260317163006.178238513@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -879,6 +879,7 @@ int amdgpu_userq_wait_ioctl(struct drm_d
 				dma_fence_unwrap_for_each(f, &iter, fence) {
 					if (num_fences >= wait_info->num_fences) {
 						r = -EINVAL;
+						dma_fence_put(fence);
 						goto free_fences;
 					}
 
@@ -903,6 +904,7 @@ int amdgpu_userq_wait_ioctl(struct drm_d
 
 			if (num_fences >= wait_info->num_fences) {
 				r = -EINVAL;
+				dma_fence_put(fence);
 				goto free_fences;
 			}
 


