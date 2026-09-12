Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438C2415F17;
	Sat, 12 Sep 2026 08:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202206; cv=none; b=mogHM1GV6ANomR4LWesd8Pbl+qnhDeUgxwkg/dQa4JKtUKKd+s176h9lFL4b+84mu0iq5ldyFhJDMglC44kDIuIXQYEInUZQmNRE1iXBWW0yP2b1pwJlkMJJGJsXaB2XsbCa3mA8K8kkpx6GK1+KX6QOLcmdPO4JIZoofn4N9+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202206; c=relaxed/simple;
	bh=oBLEEjiUxe07MKssFNAErA1MOKpgAgY7Az6AV+rj1qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PHeR2fIj4BMswsmz4HL8/pvt3THp3LvgUsjFwC+Uoldx7l8AwexSATxklyuRgZrdi2j74pQetpclla42KpTlTvGODb86Omwt7g+u4/5UlLNoYfeVBpQ2P546b/ol+znG5mkY3pOzHH437AyDVMDFKxYL+W68dTmxpxkYRcKDKOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8eOM/OX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8eOM/OX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AF21F000FF;
	Sat, 12 Sep 2026 08:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202203;
	bh=6bw0+JuAILVK5NkmEXZHJ5NMn20Wcvic+s8hzieu1vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8eOM/OXQ3c8YTAQWwLlVvqtVaUAzWFvPEf3dEDGNiIDgWOOrzkRJNgFAFQjSnPUJ
	 ub3IE3nQQ2Jmqg+HmK0V88Q2PapwC6a/gYOl4VoQO8BtBOjCFsF5oKFOoTQ9mOfqN2
	 IovFJkGyfo+7z2AusM7j34j0d9YiITXqFU2T2Dyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1155/1815] drm/gfx12: Program DB_RING_CONTROL
Date: Sat, 12 Sep 2026 08:48:25 +0200
Message-ID: <20260912065716.127650461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 402ebe22b267783f3b05b714df224fad0223b278 ]

This is needed to allocate occlusion counters across
both gfx pipes. GFX 12 only has one gfx pipe, so no functional
change since the default value is 1.

Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 4261cbc7b03f ("drm/amdgpu: read TRUNCATE_COORD_MODE on gfx12")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
index e418390353b1b..6c37e760fdfae 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -1822,6 +1822,15 @@ static void gfx_v12_0_constants_init(struct amdgpu_device *adev)
 	gfx_v12_0_get_cu_info(adev, &adev->gfx.cu_info);
 	gfx_v12_0_get_tcc_info(adev);
 	adev->gfx.config.pa_sc_tile_steering_override = 0;
+	/* Program DB_RING_CONTROL for multiple GFX pipes
+	 * Default power up value is 1.
+	 * Possible values:
+	 * 0 - split occlusion counters between gfx pipes
+	 * 1 - all occlusion counters to pipe 0
+	 * 2 - all occlusion counters to pipe 1
+	 */
+	WREG32_FIELD15_PREREG(GC, 0, DB_RING_CONTROL, COUNTER_CONTROL,
+			      (adev->gfx.me.num_pipe_per_me > 1) ? 0 : 1);
 
 	/* Set whether texture coordinate truncation is conformant. */
 	tmp = RREG32_SOC15(GC, 0, regTA_CNTL2);
-- 
2.53.0



