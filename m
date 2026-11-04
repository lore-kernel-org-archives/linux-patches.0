Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829325;
	b=EbNHk5uwZcTMN1rYNwpkXv5aVao9LFZ07iD1z6YrTmnJwK9EUElDMkwOGZEXUmqRD5Vh
	 bk4Sh2sieDcYXmUTwSC6VHQf9ir9WKNDE4Mo/NHjv2rBaCKHTCYCzvwB4SGlJfqkbvZNz
	 oB1QWwZ6V5IkSs/U5ScedfdG7s0Q8nC/GMUAr1lzBuuPDvneR3Fd29nWRLowwoM3N5Cnl
	 DW93h8vsaVyC2obTmYS+u3PLwrxEMAGRZXJYwXc/AdUH3QxD1xAjjTQC5XrmC5RcYXtov
	 S9eAUetBix1ZZEqPLNdqcw9k4UsbIkiaW8/QgUBhTwmU8oDpPnR7ApXr4unzDkL7pIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7mxOAjkzrjE0likM7LGkSAeOSLnCsCODWdxAEAzUUHM=;
	b=kSZ08zveZIEzA/g+CB+9Uirc0+DQV0ob+H1jBEbAxLdnyCL95qjIDw1h/4W87/fRqBCn
	 fdRnWcdQn1U9hhw1NCJ5P8Ol5k98DaL0Dh3APD1af1Ru6UMwSzVlVFLbevwWbKz9ec8SZ
	 uS4DeyFsixynPR+5JU5E+TnEKwz3dbbppWkVm1icgafv9KWL8yZS5OJ+tp7jkU1WrJPip
	 +AG/79Ti/eFVbLxDSWjdVJsiTHqc2kgoIxwYs3hKxcYHy/L4FDv/R4gLyYopYhnEfgbCu
	 uzjRsRmFe2pqqDcKZZg9we2HOc62F8+Oya7M5LAr2J6worO0Mv3+43GKrqSj++B1Olg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b+HXtGxC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DE46070AAB;
	Wed,  4 Nov 2026 21:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b+HXtGxC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716171F00A02;
	Wed,  4 Nov 2026 21:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829324;
	bh=7mxOAjkzrjE0likM7LGkSAeOSLnCsCODWdxAEAzUUHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b+HXtGxCFPCQURiF80KrMSXNyxQmyqzSejdF98/9YGm72YTHjorkax47epK6d3vbs
	 FO1cQH4QOst3+14hR4OqIA7cmtd0/abyfTvTlYE6XgluXJluQxyppGc0/4xvnrA1eQ
	 lD7GOWaXYQM1VLMVnaXZx9HY/WO6tFEx6AKnm71k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0024/1005] drm/amdgpu: add bounds check to prevent array overflow
Date: Wed,  4 Nov 2026 15:55:57 -0500
Message-ID: <20261104211044.234014761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YiPeng Chai <YiPeng.Chai@amd.com>

[ Upstream commit db15c49a17b8fab9ada38f3a548e5353d7d6b1a8 ]

Add bounds check to prevent array overflow.

v2:
  Add warning messages.

Signed-off-by: YiPeng Chai <YiPeng.Chai@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 16ae44e131ad4..b03d422572589 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -4814,6 +4814,13 @@ static void amdgpu_register_bad_pages_mca_notifier(struct amdgpu_device *adev)
 	 * Use this list instead of mgpu_info to find the amdgpu
 	 * device on which the UMC error was reported.
 	 */
+	if (mce_adev_list.num_gpu >= MAX_GPU_INSTANCE) {
+		dev_warn_ratelimited(adev->dev,
+			"mce_adev_list full, skip notifier registration (max=%d)\n",
+			MAX_GPU_INSTANCE);
+		return;
+	}
+
 	mce_adev_list.devs[mce_adev_list.num_gpu++] = adev;
 
 	/*
-- 
2.53.0



