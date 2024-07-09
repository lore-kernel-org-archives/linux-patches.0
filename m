Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B617156F57;
	Tue,  9 Jul 2024 11:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523962; cv=none; b=V0QyIwWq+jAKMwss/cUWxYQLR0f90s4rPbG4pmdBM9we6kEWf5q/kLAAC34jYWeSb3UZKqyOrn8CiVWYgdNSYIS8mo7YLDazGkOCb19Y6ZEbH5pUeNLLxy4dreAwwtj22PyOqsGcnLaRvZhmisnrhRIYq4hjtZuMNca9MGrxKMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523962; c=relaxed/simple;
	bh=T2oMMU4tK13DYhYxdsLwRcO0V4rjJbNfYe3gQBJ6IBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e90RhlsdUQaUkyw9jgKQSsZ1Gn5es3wsjbs3XEk61Iy/za4V6YTgYNpKK3ykEneDQUvQ6vn1/fimSv0p4o8RknVdhWFOUiyhglCZzu44f+5pn6D7sF9Cadw5ziW6+0Fe/3oDrWEIDrZnYAmJPmCE/G58ZdBmTBQ5hjgzkjRUzT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlsFK1sH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlsFK1sH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1F4C3277B;
	Tue,  9 Jul 2024 11:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523962;
	bh=T2oMMU4tK13DYhYxdsLwRcO0V4rjJbNfYe3gQBJ6IBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qlsFK1sHwyUn8zbZ464I4rX1ktPwu5Qnr3N7MFA4AqQQH1EdeQ6DBLQYlDdWIlV6i
	 C2MBy72q8RNzJQwmE1uIipUXQ3NHe+hQBL81Q4l5101jVmKwW3WkP9ycDkLyNfaSAR
	 tFE6Tf0KQhUYOOVigiRetoyn4jni7zLixRwhIm4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 026/197] drm/amdgpu: Initialize timestamp for some legacy SOCs
Date: Tue,  9 Jul 2024 13:08:00 +0200
Message-ID: <20240709110709.929930567@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit 2e55bcf3d742a4946d862b86e39e75a95cc6f1c0 ]

Initialize the interrupt timestamp for some legacy SOCs
to fix the coverity issue "Uninitialized scalar variable"

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
index 7e6d09730e6d3..665c63f552787 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -445,6 +445,14 @@ void amdgpu_irq_dispatch(struct amdgpu_device *adev,
 
 	entry.ih = ih;
 	entry.iv_entry = (const uint32_t *)&ih->ring[ring_index];
+
+	/*
+	 * timestamp is not supported on some legacy SOCs (cik, cz, iceland,
+	 * si and tonga), so initialize timestamp and timestamp_src to 0
+	 */
+	entry.timestamp = 0;
+	entry.timestamp_src = 0;
+
 	amdgpu_ih_decode_iv(adev, &entry);
 
 	trace_amdgpu_iv(ih - &adev->irq.ih, &entry);
-- 
2.43.0



