Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5175E51AEE0;
	Thu, 17 Sep 2026 17:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665663; cv=none; b=q3GwZNxNtnpMeY1674P672zlRH+dYEA1NuuYsuU3S5Os1rPahqs4Y+Gm0jgojEDR5z12uwLxV+crcIfxRgBfgtxNuVtC4TnfQmydQzbN0KBihk/mRpaeX/Rj0OW7CsEDxLyGtJ+Kq7NR5EBZs7GtnxNjeiso5WE3nwnLhGxWYjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665663; c=relaxed/simple;
	bh=+jvES+rAavtP9S4CQuBfiTN4fUl91Rx6WVQmsTHSNn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fYeOVZPkG4gfmYKC4JqSfAvHYMdw6RuyBQh3HtKHqQMuZD9gF3isipK4+C68aWxA/NbLvk/WDR72bMmxuHoLKBqSvWy1D29Cpb7vqAdukGvEhld5WjV1/To/an8Xgwu9dso/vVFAN9ccP03tbU0AD1hl2E6HvgZ47hBgFNxH9dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hotgbct1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hotgbct1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA82E1F000FF;
	Thu, 17 Sep 2026 17:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665662;
	bh=52a4AhQTJnTe+S+3taWx7GITUFF16lOMsklWNDffZ2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hotgbct1ViFMUlyEwMoiSCC020DIvUi85otjW2FR/W8+q5y9l+JFpHdUl17TVdJ2m
	 xQBOH8gJJsPF4I7ysR7312OcI1mtj2ZXrnPTHkU7JbfRNDmd5z5m0R6UcLuRIf//y6
	 piFdQCzOyuz9IYL0JLlgLWLEKypJbj/0HLHXag1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Mohan Marimuthu <yogesh.mohanmarimuthu@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0731/1250] drm/amdgpu/userq: fix struct drm_amdgpu_info_device padding for 32bit compile
Date: Thu, 17 Sep 2026 16:08:46 +0100
Message-ID: <20260917151611.703031782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 406a42be429b2..adcfdc8d13441 100644
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



