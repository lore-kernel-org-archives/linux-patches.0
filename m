Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2402F1E8354;
	Wed, 19 Mar 2025 14:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395119; cv=none; b=Epl21SFnMNbC0razinKAwkZwwD8P6J+EFulGz/JfbkLjxnZuup4xtHJ66Jq7vg+BAC3wRDzwZAIN+ilXjJyKcCrOXPtMK0QGX03zjDl1015MhSGM1KRqP4DQkBnzFfMMP+IPoiprnyr52g4HVugW4/YKVozPaTL7fxhAvB0esN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395119; c=relaxed/simple;
	bh=EWRmG1oNn9dzW21i8Q9Ut4Vf6aNGL+wL2ju+ejEb7Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jG3T8C9Z2XzKWtnyi/nLJkTHeXaymMDPIoqh/audsSOiTGvhlog9/4B0SUaIEYc4588YNOB6oLWnS7pZtAu5JBMnDvzrTv3VttoH8/Il86FPTReIY+LF1Zt8sML988aObjZdWkcE+grx1u7JJMOA88zQg9NW7yUu4QymPAZ6b34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQxFAjZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQxFAjZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3FEC4CEE4;
	Wed, 19 Mar 2025 14:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395119;
	bh=EWRmG1oNn9dzW21i8Q9Ut4Vf6aNGL+wL2ju+ejEb7Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQxFAjZY00EBxL0wDv538tJZ0wRpkmyyFnxfmlJ/V7LIGjBJSAuGPFgKg8bQHCOOS
	 sHHncII0kV5e3xA1K7L3Qg6pjZms4eKmvLI5wu3vA6wnvTD/WTSMKAZBfzRDSa5932
	 0pbPFFo7BTouu5YV/1GCD0TqkYRHkAa2/Wkm2pwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Aliaksei Urbanski <aliaksei.urbanski@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 179/231] drm/amd/display: fix missing .is_two_pixels_per_container
Date: Wed, 19 Mar 2025 07:31:12 -0700
Message-ID: <20250319143031.260262287@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Aliaksei Urbanski <aliaksei.urbanski@gmail.com>

commit e204aab79e01bc8ff750645666993ed8b719de57 upstream.

Starting from 6.11, AMDGPU driver, while being loaded with amdgpu.dc=1,
due to lack of .is_two_pixels_per_container function in dce60_tg_funcs,
causes a NULL pointer dereference on PCs with old GPUs, such as R9 280X.

So this fix adds missing .is_two_pixels_per_container to dce60_tg_funcs.

Reported-by: Rosen Penev <rosenp@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3942
Fixes: e6a901a00822 ("drm/amd/display: use even ODM slice width for two pixels per container")
Signed-off-by: Aliaksei Urbanski <aliaksei.urbanski@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bd4b125eb949785c6f8a53b0494e32795421209d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce60/dce60_timing_generator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dce60/dce60_timing_generator.c b/drivers/gpu/drm/amd/display/dc/dce60/dce60_timing_generator.c
index e5fb0e8333e4..e691a1cf3356 100644
--- a/drivers/gpu/drm/amd/display/dc/dce60/dce60_timing_generator.c
+++ b/drivers/gpu/drm/amd/display/dc/dce60/dce60_timing_generator.c
@@ -239,6 +239,7 @@ static const struct timing_generator_funcs dce60_tg_funcs = {
 				dce60_timing_generator_enable_advanced_request,
 		.configure_crc = dce60_configure_crc,
 		.get_crc = dce110_get_crc,
+		.is_two_pixels_per_container = dce110_is_two_pixels_per_container,
 };
 
 void dce60_timing_generator_construct(
-- 
2.48.1



