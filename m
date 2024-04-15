Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B02974E25;
	Mon, 15 Apr 2024 14:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191127; cv=none; b=gTo9FOdijFnXQIoRXUEQBaFmhFR6mYlyyijo/CFYc554E+po8Ce1US8cpwEGPSwXsfZE4a4jcYsQQgVIOaJTgixjWDaL2ZW8VLH7MV/P4Pv1CVTAMBiQy2/V9fLMq5yfbBE+aQvsaslyZ10yHoaVC4H0D0qbvlvY9OMQMXQb/Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191127; c=relaxed/simple;
	bh=JGI7fdQbi0bT0bshxi2HqnkerpqtrKnobYgGF/7eLJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQAOFmqC9BxmMUp0cA0JD5wcU4+YN83jn+S/s7VZcaconfR7GYS9fCSKYiPgQhsbGV01LSBbGsdYAKQIVdnSQ1hRObo/PdGZ0vbX/sn/CBSONT3/AWZ2Pw6R60hLnq2+Bipd3be8pdYy55JprLjksJ/Q+bSMKaNUwOZSvFW51dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHNgBzNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHNgBzNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9982C3277B;
	Mon, 15 Apr 2024 14:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191127;
	bh=JGI7fdQbi0bT0bshxi2HqnkerpqtrKnobYgGF/7eLJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHNgBzNJoMJZlgwuB11PHYd1gPFql6FlDrrseI9Ls5b6o0kb9EvO7bbGBR47952jQ
	 1vX1Bvvoy3VEfJ6k7WeZ1HZrtR/gsfOSVI6uZ4NQZ0ZLdXN98kGzEqdksGL4REF7n7
	 LdYzDW4Gj66ZzJJJFU6X8KYCkMsvmJYF7HbsUgLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 040/172] drm/msm/adreno: Set highest_bank_bit for A619
Date: Mon, 15 Apr 2024 16:18:59 +0200
Message-ID: <20240415142001.642223533@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 9dc23cba0927d09cb481da064c8413eb9df42e2b ]

The default highest_bank_bit of 15 didn't seem to cause issues so far
but downstream defines it to be 14. But similar to [0] leaving it on 14
(or 15 for that matter) causes some corruption issues with some
resolutions with DisplayPort, like 1920x1200.

So set it to 13 for now so that there's no screen corruption.

[0] commit 6a0dbcd20ef2 ("drm/msm/a6xx: set highest_bank_bit to 13 for a610")

Fixes: b7616b5c69e6 ("drm/msm/adreno: Add A619 support")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Patchwork: https://patchwork.freedesktop.org/patch/585215/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index fd60e49b8ec4d..792a4c60a20c2 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1295,6 +1295,10 @@ static void a6xx_calc_ubwc_config(struct adreno_gpu *gpu)
 	if (adreno_is_a618(gpu))
 		gpu->ubwc_config.highest_bank_bit = 14;
 
+	if (adreno_is_a619(gpu))
+		/* TODO: Should be 14 but causes corruption at e.g. 1920x1200 on DP */
+		gpu->ubwc_config.highest_bank_bit = 13;
+
 	if (adreno_is_a619_holi(gpu))
 		gpu->ubwc_config.highest_bank_bit = 13;
 
-- 
2.43.0



