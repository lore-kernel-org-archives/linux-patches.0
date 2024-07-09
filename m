Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B45B27713;
	Tue,  9 Jul 2024 11:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524524; cv=none; b=BB/sjPFmHrwUoIIXCm0IIYnKml+mMXAGc8bQVVkLXbDUbNtdsA0lvloxFYemfm/lIh4kywiHyCbLd/9LLgtJXGc77Qnu3DUnj9n9R3OKxCC4mxVzPzmLnsEHYeqqvCD1xqv5YCDeHRcv00/NFL4Y2RvfdorfyU7g79SCS+EwDAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524524; c=relaxed/simple;
	bh=AQyR/z6qOoMtcXu+bOq60n8KZ4C8Yq3CdFY9sKY+T8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SoVswR1HFNIu7MaoFbmK11dAhoxqM4+LK677TCJrY+BIK5m63rdw5UfsyhR84K9lFbzNo8kUXC/qZvsCEaRjvfyznuTkSiXx2fNezSarrRXEom9bCru/FhjLhRHew0RHAGsTfAWB6IGFpnfuxaeg8jiTtn/HV7mfZgJvj3QtIm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9yg5dba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9yg5dba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2122C32786;
	Tue,  9 Jul 2024 11:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524524;
	bh=AQyR/z6qOoMtcXu+bOq60n8KZ4C8Yq3CdFY9sKY+T8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9yg5dba87n6UbvX1ideXt5N5QXEJrz4mTo8tggNGuz6/Payn2k+Lpz/8zWk66gEn
	 ws4VI532SGm5gI0yzuv3e4EHiXhKZIqYvGnMZoWK0Axfs14Jd8W6jN41gxRVRFrJCY
	 /DbcawbEVIEB0V3WfjTIRreUPNE2UyHNMAirQBwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/102] drm/amdgpu: Initialize timestamp for some legacy SOCs
Date: Tue,  9 Jul 2024 13:09:35 +0200
Message-ID: <20240709110651.844051176@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9efbc0f7c6bdf..c3da333f09de4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -480,6 +480,14 @@ void amdgpu_irq_dispatch(struct amdgpu_device *adev,
 
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



