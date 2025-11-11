Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243B0253951;
	Tue, 11 Nov 2025 01:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825549; cv=none; b=kJDajQ1gufI9ckaPFpnzXiQDPw4MqLOofuL1hh9NfsZbCPF434hG3+g5N4MwtMlYRQKRzEpy6FZqFRxJiju/fUqUkqVP0Yph8Hy/4aX+Jc7plPsk99LYZTgryUwnwcVeGWgCN7skNJvQ8LX56pHUfjuqmZPelg8WoM5Iks+7ylo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825549; c=relaxed/simple;
	bh=sGPBebGV7Vsy/1nsYbaGcfxY0AIUF5PjZOGDc6AGBHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glJccGepSfv8Zao062i1yloTL20J5sqmlTbNtFyPZWP+cSpg3HDd0l/eB5D0PG9nw4J75et9yCNAZk+6B1v945zU44BTLMPtfZln1fbeV1Y68uUt5mTLEMH2EmcP7r951i7RbaQ0nThQAsAKQXYoe4GeG9/g6BkhLda/wcbMwto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kRlGt6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kRlGt6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70074C4AF09;
	Tue, 11 Nov 2025 01:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825547;
	bh=sGPBebGV7Vsy/1nsYbaGcfxY0AIUF5PjZOGDc6AGBHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kRlGt6fUOu6vViUTQj2KIh+95Xb4EgL9wMKmfXFV/HOEJmKqAX19BeFcWo5QEVvH
	 SJlGVnAl3TzhXcGgKlpWI0LPp9LZ2zDpp00VsgaHeuWq4PJBS8D/Q/pXOI08+ZjMtp
	 PGQYGTJO6fKwkrVo7JmG/jZlmNtlEak0pK1a4MvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Sun peng (Leo) Li" <sunpeng.li@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>
Subject: [PATCH 6.17 847/849] drm/amd/display: use GFP_NOWAIT for allocation in interrupt handler
Date: Tue, 11 Nov 2025 09:46:57 +0900
Message-ID: <20251111004556.896562736@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

commit 72a1eb3cf573ab957ae412f0efb0cf6ff0876234 upstream.

schedule_dc_vmin_vmax() is called by dm_crtc_high_irq(). Hence, we
cannot have the former sleep. Use GFP_NOWAIT for allocation in this
function.

Fixes: c210b757b400 ("drm/amd/display: fix dmub access race condition")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Sun peng (Leo) Li <sunpeng.li@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c04812cbe2f247a1c1e53a9b6c5e659963fe4065)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -561,13 +561,13 @@ static void schedule_dc_vmin_vmax(struct
 	struct dc_stream_state *stream,
 	struct dc_crtc_timing_adjust *adjust)
 {
-	struct vupdate_offload_work *offload_work = kzalloc(sizeof(*offload_work), GFP_KERNEL);
+	struct vupdate_offload_work *offload_work = kzalloc(sizeof(*offload_work), GFP_NOWAIT);
 	if (!offload_work) {
 		drm_dbg_driver(adev_to_drm(adev), "Failed to allocate vupdate_offload_work\n");
 		return;
 	}
 
-	struct dc_crtc_timing_adjust *adjust_copy = kzalloc(sizeof(*adjust_copy), GFP_KERNEL);
+	struct dc_crtc_timing_adjust *adjust_copy = kzalloc(sizeof(*adjust_copy), GFP_NOWAIT);
 	if (!adjust_copy) {
 		drm_dbg_driver(adev_to_drm(adev), "Failed to allocate adjust_copy\n");
 		kfree(offload_work);


