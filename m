Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591218;
	b=g041jd8yGxb9bYgtB7gnT1XhvwpWubE2QStFWkum1kITpDoK2sv/VW2rU3nYpRhORLAQ
	 KV/AIGXi9HZLMlUPvkuXMo/opVkNadgEyzi0dfjepIm/zqeDfZvxLeHYwrnKcaZEAywpl
	 QTDIOsUpwjlGKNQs/JDe6KTXWLMFPi5sAJpIt5yu+a2+GCfk7PuxGtLbXXTEFnXvC818T
	 biao/RTR1SDIAmpBjAVBu0GAD4s38FwVIP5AjPB//n60OMvjPaoMT9rnlQCREQ6t81Rbw
	 wR5foPEalQTAiWVOeNwIQSSB3tvrUs6pV0c1gMDn0U2h83Cm/B3wrUMwUmJRt5wiX3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5DprGU+LnD4cjhU7uHgJ9v4luczDn+qHAyMkTtxBSAE=;
	b=VNiRkor5pjMgdv0QqbAMfznzAaljmnlNX83c1O+9u+1FTfaT+2ZbkZc6kpcpDc/Vg70j
	 brtt/2FEgzT8M+rxgA0t9VGCU8zJuBXCaQ9itEQXJfhCX1yGj1J89wurvOB3LYdPk8zmA
	 rnrpqY3OPCrWfdLahC9gXSCs12xaBNekIibKQ/dKFOqE9cdMgGFLAZlXr7RMfWqJKlmYG
	 RQu0y+baufUrEU28RMnG4DxCrpMntIC2maJNYU8HqOZimSSiPP4HYNS33TBuyEELQXbS9
	 cVhbiCxyy0N0U3+TyRH01VDYO5tuiDP61Z69YC8BzjpNPyu5jJ2n7sWQ6/c8uQc4TYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qB5TzdeP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C643607587C;
	Fri, 13 Nov 2026 17:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qB5TzdeP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092EA1F000C6;
	Fri, 13 Nov 2026 17:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591218;
	bh=5DprGU+LnD4cjhU7uHgJ9v4luczDn+qHAyMkTtxBSAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qB5TzdePmtdW8w/ZQnr44o5maybg44KLlikyhbbefAgpoI5+LOCN/oC4gHIjCsSOQ
	 97AMBlMPlk4VhZ9csM6uXRqE7AP4idC0Bq42DZZLKWQDYNfvkX87GwnbLt0Lcs5Kcz
	 z3v4sw4qY5Ytfwz71+jHccWOMvka0dGx20BTpJ7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Erhan Bilgili <erhan.bilgili@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 351/670] drm/amdgpu: Report MES ring wait timeouts.
Date: Fri, 13 Nov 2026 10:48:35 -0500
Message-ID: <20261113153823.722090996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erhan Bilgili <erhan.bilgili@gmail.com>

[ Upstream commit 122e864861144150e905012b5fb52e63ad5de68d ]

Return -ETIMEDOUT when the fence wait before submission expires instead
of reporting success without submitting the packet.

Fixes: 34e087e8920e ("drm/amdgpu/mes: fix mes ring buffer overflow")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Erhan Bilgili <erhan.bilgili@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 34341594a87b4a3f28be41e3e70a4787f02b3d9e)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c | 4 +++-
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
index 236fedc5b1838..63762ea6f87cb 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -201,8 +201,10 @@ static int mes_v11_0_submit_pkt_and_poll_completion(struct amdgpu_mes *mes,
 	r = amdgpu_fence_wait_polling(ring,
 				      seq - ring->fence_drv.num_fences_mask,
 				      timeout);
-	if (r < 1)
+	if (r < 1) {
+		r = -ETIMEDOUT;
 		goto error_undo;
+	}
 
 	api_status = (struct MES_API_STATUS *)((char *)pkt + api_status_off);
 	api_status->api_completion_fence_addr = status_gpu_addr;
diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
index c432a2a3405d6..98c706fa97fe8 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -187,8 +187,10 @@ static int mes_v12_0_submit_pkt_and_poll_completion(struct amdgpu_mes *mes,
 	r = amdgpu_fence_wait_polling(ring,
 				      seq - ring->fence_drv.num_fences_mask,
 				      timeout);
-	if (r < 1)
+	if (r < 1) {
+		r = -ETIMEDOUT;
 		goto error_undo;
+	}
 
 	api_status = (struct MES_API_STATUS *)((char *)pkt + api_status_off);
 	api_status->api_completion_fence_addr = status_gpu_addr;
-- 
2.53.0



