Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298DC155389;
	Tue,  9 Jul 2024 11:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523608; cv=none; b=K7Z08NGetTnU7lwppC7Gu6PlqpzUEw4zrP7JkRb3GN3f1307OB0q537/cl1F9a7jiqoA+f+Q2w8dYk0aqizuOn1HwN9l3O399pWwH6bclE3lUSUFBxz0/xBrRGoaQ9M9mc2u+AkOxiF2DrhoiW/j7nndmhKUt222J8C+GEg4Ks8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523608; c=relaxed/simple;
	bh=JaMH7pB4pPx/BA7MdwlTUz+oNvyJzsHlleNTmF6kom8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ym1mmvG6k43BuVlNSG379S24xKeXcN5vLOOvbaCAmewMg37bSaQEK82Wx9ZcR92V20WHknKwkqdhZUcHub1F0j0ywllXQHCcThEkGp7i+hFSCaxN/VsFeKuB1FY42MWISSw1nE1TZp/ib9bi0VTF3Jd+o3If1tDltxcTndUVFMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hD6OdmrQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hD6OdmrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2145C32786;
	Tue,  9 Jul 2024 11:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523608;
	bh=JaMH7pB4pPx/BA7MdwlTUz+oNvyJzsHlleNTmF6kom8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hD6OdmrQMieid6qNQXJlPdlvrvwFDSt5eR+EzbXtXJwdNAnsmRyWfd9uAqPOvt66l
	 Kx8x7JGgIPxjOU5Ls56AxJgSdsrybTdkz6XoUZt/t1pt0OmuZ2VxPYeSF9VWHAsKWt
	 znucIFCVfNHZNk/7LbKta89EYVpqrGM5zjEXevsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/139] drm/amdgpu: Initialize timestamp for some legacy SOCs
Date: Tue,  9 Jul 2024 13:08:39 +0200
Message-ID: <20240709110658.905966127@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fa6d0adcec206..5978edf7ea71e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -438,6 +438,14 @@ void amdgpu_irq_dispatch(struct amdgpu_device *adev,
 
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



