Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B864E2F19;
	Thu, 17 Sep 2026 15:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659278; cv=none; b=BqrllWP/6g7/jVU/rDXNDDkc4WwasCmW/FUqu3YXYDDd1KOLmSfd1wu425Gn3yAQLHuwPacXOE9Rlu3QnFJQnbO9i30CPnb+ngX21dIL4GYcnJT3St2uUPvAv2AZXCmXHjHv1A3Lli6kOoxg1YZa3qDaw8Y46vhKyzcp2Jy1abw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659278; c=relaxed/simple;
	bh=ayZEtFRDDFCpYwBYRDWvEtbRvKBum/KDz0oSHmdLah0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ELDuIxToglGEmKSTauW/xjTX2g3AFFRMZQAPrb++wXbUsou1gjKaK1L6MUi9iB54e6UcwU3u3YX1vBvLH/1Hg6FetgSEpVQEvZ1vYC2fKMHQ/rbPBDtKuOAnWCIbE/yYQMK/PbzQ8S3TAhDufwxXnYr/sWWUD9hxzY36Hw/f2MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDJ3Cs/A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDJ3Cs/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F8B1F000FF;
	Thu, 17 Sep 2026 15:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659270;
	bh=N9W1RYp3f8ceoesdDmJWjPsME1xVPh6hNQd3xzCZU0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDJ3Cs/ATd3rJQTJHOn6zKH2FqZOtgqJ7ig4SbVKEmWfb7qJZcnkyE5TTLGYd1A8Z
	 V+ltqXKLyWsz8rQ4yZylvX3ebePlZll0UpGXa6dBrKA9Y5TBTrOBNa99FTyQVuB2PA
	 V2+CdXr70bAzmcpIEoEM/JUGTSz++pSaiDa2+ZIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Mohan Marimuthu <yogesh.mohanmarimuthu@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 199/733] drm/amdgpu/userq: fix struct drm_amdgpu_info_device padding for 32bit compile
Date: Thu, 17 Sep 2026 16:08:27 +0100
Message-ID: <20260917151356.123255379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yogesh Mohan Marimuthu <yogesh.mohanmarimuthu@amd.com>

[ Upstream commit 13af55f71399f5e562f6cb59ad413476e513c4d4 ]

need to pad before __u64 tcc_disabled_mask variable.

This patch fixes 64bit Kernel + 32 bit mesa combination. But at the same
time it will break 32bit Kernel(using this patch) + older 32bit mesa(not
using this patch).

This issue was discussd with alexander.deucher@amd.com,
christian.koenig@amd.com and pierre-eric.pelloux-prayer@amd.com.
Currently today 32 bit kernel + 32 bit userspace and 64 bit kernel and
64 bit userspace work.  Mixed 64 bit kernel and 32 bit userspace is
currently broken.  Since 32 bit kernel and userspace is probably pretty
rare these days and the data affected by this is not critical, Hence
we can go ahead with this patch.

Fixes: cf21e76a6005 ("drm/amdgpu: return tcc_disabled_mask to userspace")
Signed-off-by: Yogesh Mohan Marimuthu <yogesh.mohanmarimuthu@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 497b5090f2857ef8ad9a162aa31ada0de5814663)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/drm/amdgpu_drm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/drm/amdgpu_drm.h b/include/uapi/drm/amdgpu_drm.h
index 9f3090db2f163..322aef9b54bbe 100644
--- a/include/uapi/drm/amdgpu_drm.h
+++ b/include/uapi/drm/amdgpu_drm.h
@@ -1510,6 +1510,7 @@ struct drm_amdgpu_info_device {
 	__u64 high_va_max;
 	/* gfx10 pa_sc_tile_steering_override */
 	__u32 pa_sc_tile_steering_override;
+	__u32 pad;
 	/* disabled TCCs */
 	__u64 tcc_disabled_mask;
 	__u64 min_engine_clock;
@@ -1534,7 +1535,6 @@ struct drm_amdgpu_info_device {
 	__u32 csa_alignment;
 	/* Userq IP mask (1 << AMDGPU_HW_IP_*) */
 	__u32 userq_ip_mask;
-	__u32 pad;
 };
 
 struct drm_amdgpu_info_hw_ip {
-- 
2.53.0



