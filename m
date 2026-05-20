Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EBF423158;
	Wed, 20 May 2026 18:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302800; cv=none; b=kZN3RJqHHONnqZzGAHJsL/u0a4VTFtxSEQOagSr1caWPEzg58NmiciXlaPCoFpQaxwcf0JNvZ2tgu2NKQ+Tv5syxi2Xlc1eJs7S2DDOVMgHjWJRfyBdHl4x6OLeuuuSwlcDBBVwExQSG56853qAAOsuIN3U2/Uk2A+am5cWBbcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302800; c=relaxed/simple;
	bh=FqWUi91922gxXzw7+uEoNdfyXNDA5KDgFNGsPzK7wzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GqFd8t11xzdKK9+fwMZFzSGFYu+XdFfULPJAI6FQZYrR3DvxlDc3XPY1OtQMWwgD+X0QUc8/teMp56gE9Mc21gKqYd4e6vIpM4SYRTm+c0YUfDK/r+VQnufB8Hvhg7sc36qkH9eHifZmWZ7zmT937iyM5DO4LijE1ARBbyxl4o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rbv1nzlG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rbv1nzlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571801F000E9;
	Wed, 20 May 2026 18:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302798;
	bh=Es2tgzYYKbTEKAgYWf+66Z6/0uSKP2/74T4xnhjfIas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rbv1nzlGdRmeiBds1wb0v1E8PmLYq+hvhod94lQZP4rd9S7hTwQgiRyIWXnXxzDNz
	 tuGX5pvvC9YYzxNfRYilM7HeXZdN9l5YGQwykJ8iRJA7OAW6RccNm4BGccq0+TDcpV
	 zUQCq5o05y0bCulw0+zjsQy2m0VQt4K2e6xR2HKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 405/508] drm/amdgpu/jpeg: set no_user_fence for JPEG v3.0 ring
Date: Wed, 20 May 2026 18:23:48 +0200
Message-ID: <20260520162107.386484954@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit a2baf12eec41f246689e6a3f8619af1200031576 ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: dfd57dbf44dd ("drm/amdgpu: add JPEG3.0 support for Sienna_Cichlid")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d7d774f100efb5089c86a1fb8c5bf47c63fc9ef)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
index df4440c21bbf4..f587664cf31a7 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
@@ -562,6 +562,7 @@ static const struct amd_ip_funcs jpeg_v3_0_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v3_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v3_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v3_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v3_0_dec_ring_set_wptr,
-- 
2.53.0



