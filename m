Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DF213BC0C;
	Mon, 23 Dec 2024 16:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970015; cv=none; b=QzQVRQK1/vCooudyH0aurF/xDSsIuRgFNIUg0Vjgm8FnbGTM18Pb3TEJoRi3OrtP/aLmYmI1pRg+0vVyGFTTkAYTts465Q8f389YDqUM9duZMvUgo44MSlDK45ogQzVqbbVM6I1krjRrepbiS+P7+8T7wBePXLHJoe6w5diYsk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970015; c=relaxed/simple;
	bh=PB9GSeIolkF9ED+1V6Wkz/KjC06E4bPi3YGnANygt70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMVGmcHD8imGuH00fGzUJp7dz10Kvz9wfX9w70PRIKvmSTs1NKGGq4uUleOyAVuvGJF6HDOpV3cutqbyvTeolA5cT+EkCzRn+kW+VLDv1qbnBvrIOdMpmo5JWAm4tztdgJbvZUIsiohYKe8wecdNdjv2+belr7l2SzF2QaXqS+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQNZbpSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQNZbpSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0565FC4CED3;
	Mon, 23 Dec 2024 16:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970015;
	bh=PB9GSeIolkF9ED+1V6Wkz/KjC06E4bPi3YGnANygt70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQNZbpSGZ1ln4jj29DrNBYWF3HAXfbGil6srOL8CyzLXw7h/8Zi3yvTvcUgPTo+XN
	 rzbjGRLlI2GX5D+HKTJjnJ8LWD7tlTu64McUIQvQQOvdZ6jBV3+tG+Iw88Amye3aIL
	 4icgZg6qTwZb6ABsrKqklkNBSLHUIAlNKkJtdk+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 120/160] drm/amdgpu/gfx12: fix IP version check
Date: Mon, 23 Dec 2024 16:58:51 +0100
Message-ID: <20241223155413.405167863@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 41be00f839e9ee7753892a73a36ce4c14c6f5cbf upstream.

Use the helper function rather than reading it directly.

Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f1fd1d0f40272948aa6ab82a3a82ecbbc76dff53)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -4105,7 +4105,7 @@ static int gfx_v12_0_set_clockgating_sta
 	if (amdgpu_sriov_vf(adev))
 		return 0;
 
-	switch (adev->ip_versions[GC_HWIP][0]) {
+	switch (amdgpu_ip_version(adev, GC_HWIP, 0)) {
 	case IP_VERSION(12, 0, 0):
 	case IP_VERSION(12, 0, 1):
 		gfx_v12_0_update_gfx_clock_gating(adev,


