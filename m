Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216688;
	b=BFpuHyUcV8aQizK7d47Ie5JQIzs35DFJyHOT9NCRHBGstr6qu3KTiq+kzkZHS7hOn8Vi
	 /YN5l3sSCrpy+hVSchF8cIxo/c6FPkA+JQ9K2y36eIUk6QVj7hZg8LeWXk8tznOkYDEGE
	 Qh0AXE/r8hF0mXJR5yRwOJWyA+5PA0A2l7NYIlk/IB6zzsFbFiwV1RXrQD0nVjsTfC6iG
	 XeWyyCrJybtu+q/J+xnpENlulFS1UfevxihJ6b0tfDqehPOOyWNTGVN1EjjRXVxWl0PDR
	 c2AJdQWZwoaB/hbn319gIRIyAubRg70PQuCSRDOQTGqn2GWjn3SvpOCcYDyCr8OgLcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NKa8r24WrLHnZEbVNxoeBxgIAiah1Svoxa9f8VreJBY=;
	b=Vj1c03kJsGGlXSFoCynjFeOSHBMIsGh2jrvyEIuSybsYrCrhIidyYtiGa4N6eNVLeCQj
	 A7DXp2f/r9s6C85deSTl3VDyLW07l5rSV7L8j+AF1Di6R2rdd10hNEU+y0BwRza1Zv2QE
	 k2xupzjnuz6/tLJtmqQyHMQLmqe1Y/1lElS2YKukELjgOiQN9PIzj5wMv7o1Ifjn6FY5z
	 ioaEHqzic2B0MgKuU3mmw92iX+BslRMx08ZVuQ9HGGY1Q/iqEQOW45rKlak7V4eyj4WfF
	 B3Yoa7fMYUjsG792yVpR1soVCLFAyu6CG+muL1ZQy1T9RdeZXAy+55AF0+RXD4eDhYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="y/hUzsa6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F9D606A320;
	Wed, 28 Oct 2026 19:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y/hUzsa6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29BB1F01825;
	Wed, 28 Oct 2026 19:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216688;
	bh=NKa8r24WrLHnZEbVNxoeBxgIAiah1Svoxa9f8VreJBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y/hUzsa6IbLhV8z6MSLeoZfh9INMOgxhoZLGw6bjtng9VdpH/vHZT52a4Yff1K9IA
	 q9c9nTS8jY+FxArlof4DNhNYFi6O6Zn6J1J7owVIjnEwI8JE/Al5/EIDSzOxU0oR+2
	 Q3OFq9PjCfw+zDvUHj7rPoSOzL349x79MXbfM9SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1642/1887] drm/amd/display: Fix dangling pointer in plane reset function
Date: Wed, 28 Oct 2026 18:02:18 +0100
Message-ID: <20261028170536.830509480@linuxfoundation.org>
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

[ Upstream commit 98cad4bd1443975d972f4c7f705980da03722a22 ]

amdgpu_dm_plane_drm_plane_reset() frees the old state before allocating
a new one. If kzalloc() fails, the function returns without updating
the state pointer, leaving a dangling pointer to already freed memory.

Fix this by allocating the new state first. On allocation failure, the
old state remains untouched and the function safely returns.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 5d945cbcd4b1 ("drm/amd/display: Create a file dedicated to planes")
Signed-off-by: Evgenii Burenchev <evg28bur@yandex.ru>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260629090435.9729-3-evg28bur@yandex.ru
[adjust for movement around current amd-staging-drm-next]
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c   | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index b3a1dbeac4839..bf80846192641 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -1336,19 +1336,18 @@ static const struct drm_plane_helper_funcs dm_plane_helper_funcs = {
 
 static void dm_drm_plane_reset(struct drm_plane *plane)
 {
-	struct dm_plane_state *amdgpu_state = NULL;
+	struct dm_plane_state *amdgpu_state;
+
+	amdgpu_state = kzalloc(sizeof(*amdgpu_state), GFP_KERNEL);
+	if (!amdgpu_state)
+		return;
 
 	if (plane->state)
 		plane->funcs->atomic_destroy_state(plane, plane->state);
 
-	amdgpu_state = kzalloc(sizeof(*amdgpu_state), GFP_KERNEL);
-	WARN_ON(amdgpu_state == NULL);
-
-	if (amdgpu_state)
-		__drm_atomic_helper_plane_reset(plane, &amdgpu_state->base);
+	__drm_atomic_helper_plane_reset(plane, &amdgpu_state->base);
 #ifdef CONFIG_DRM_AMD_DC_HDR
-	if (amdgpu_state)
-		amdgpu_state->sdr_boost = DEFAULT_SDR_BOOST;
+	amdgpu_state->sdr_boost = DEFAULT_SDR_BOOST;
 #endif
 }
 
-- 
2.53.0



