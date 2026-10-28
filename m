Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216686;
	b=GugEVYzTfb6YBesL9R9Fx0hTWcHs6uX+goRDwRS50AGB4IWXMDSPBQPeNwd37isYubfN
	 t3Jyj0uXSrbilIB+kYnzZ6pQXX82uLcZohiTcvhEj6FjgNtZpCLGcizthtPWaO0o1pVFb
	 LZrJoCyaJSkmCaLdbARgrjltURw44qID66H7H8ldIgOf5ZgA9pQTI/j0ZAFrw2CemhsR0
	 doqvdNa08N7e3E4S+Fqgk1mrMUerLx2qrOWQW6dPovfy9ZsD0W0fbmE50YlN/VGNVeH9T
	 7Z4dX4Hw47PIxTfv1CKtmxEK40qh5FwGZFgUVRiwfwm+ts4Wz1S+fJJjYYyIj5IyWzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7j2x9OEEpLbOGzU5X5o7mXYVk11eJRTGq4Qi76xFNAI=;
	b=JDgeaIKnD/tUdyQMgZFoZh8W1nHMdmj82/yyYXEdENiFnK+rOsVHG1JiX9W3mN0MjCFZ
	 CzZnwLKQTbPgiLlptPFS1YMI9RW2HAfybe1PUPG3BNL3rPUOxmBsqfG4qv8iHmxy76WnG
	 qOmJVTALv+K+UD+0dy1rkbF4UbtoV8iPHA8m80QjhIJp19dkWmKNsH+NWlXQF6Z8faGj9
	 d7rKJvVo8jI/RHW7+BvldC31nFm/zPHCkbX/+0JIpU+SE8GI74f8MVozjJV7Z36whXMcs
	 W1lmsUW5gNiaM/gNWv+ojuyM1r3bYBH7wmoWydZ5nsnDEJmFPFnj1YJ5mxV9Cta92fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vwPFfsNI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84BB606A31A;
	Wed, 28 Oct 2026 19:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vwPFfsNI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD7E1F01825;
	Wed, 28 Oct 2026 19:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216685;
	bh=7j2x9OEEpLbOGzU5X5o7mXYVk11eJRTGq4Qi76xFNAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vwPFfsNIUQmTxlq2LY6+V47bGuqrVuy4OAaceu0t6YYlLXEd6orhQ/pBM4eqIAe6V
	 RZFlYhBQ68q87V4ddgTcVPl8Ys5TZcRO4EW8MqFubJGyICCTly3kVBJnAFQi2wROiG
	 /Z8l5HcxAoOcapLTW0gOqYYktIF1qHgQUNx141Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1641/1887] drm/amd/display: Fix dangling pointer in CRTC reset function
Date: Wed, 28 Oct 2026 18:02:17 +0100
Message-ID: <20261028170536.808595658@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Evgenii Burenchev <evg28bur@yandex.ru>

[ Upstream commit 0aeed866cb938943908c3ba46422128e49d2d080 ]

amdgpu_dm_crtc_reset_state() frees the old state before allocating
a new one. If kzalloc() fails, the function returns without updating
the state pointer, leaving a dangling pointer to already freed memory.

Fix this by allocating the new state first. On allocation failure, the
old state remains untouched and the function safely returns.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e7b07ceef2a6 ("drm/amd/display: Merge amdgpu_dm_crtc and dm_crtc_state")
Signed-off-by: Evgenii Burenchev <evg28bur@yandex.ru>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260629090435.9729-4-evg28bur@yandex.ru
[adjust for movement around current amd-staging-drm-next]
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
index 1ec643a0d00d2..ca2edba4c0f7f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -278,13 +278,13 @@ static void dm_crtc_reset_state(struct drm_crtc *crtc)
 {
 	struct dm_crtc_state *state;
 
-	if (crtc->state)
-		dm_crtc_destroy_state(crtc, crtc->state);
-
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (WARN_ON(!state))
+	if (!state)
 		return;
 
+	if (crtc->state)
+		dm_crtc_destroy_state(crtc, crtc->state);
+
 	__drm_atomic_helper_crtc_reset(crtc, &state->base);
 }
 
-- 
2.53.0



