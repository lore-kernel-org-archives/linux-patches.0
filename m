Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213093;
	b=GPPR3y7Cbh62tUTX37deeHVJdvL0KE9Q8Q9pk/7cFOdKF0+tSFG1ps18AEY8chSUWAQ+
	 y6VNHFgHohV3I4o3Kdv2Gq059pcAEjLUSLhf+25jvVzyJ8ymmFEcUnUXaKsB4cibdP0HN
	 GcP5a0ArEADomI6LegQo52bKpJY0Amc1Q3Q4aJE53SMrUf1vk9Uhyg7fXm8REZqDXCylg
	 mxF4pUjOUvnlxZbSVkBEoX0Gs6mS3owx19N/GO8n6ulB+7WA2vLoTr6PDSry80sDwnYsm
	 UKyxMXzTmyfPg4CuU8s7dgPOaZ3MqLuBufCuENxn6IxmCmOheG+xi9Bc2wi/Di58LqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g0GEu+msrTkSSTwgBp3yM7A9GxKUW2omErB4tovxSnU=;
	b=JL4E5P3uDPlyU8YjWYY+hQiRWStMeSEbhotWRj3lLPHnVCG5sEFoK6+SEyJJ84e9qBO8
	 SUwMWWVsmuXoAG4Dxg4weZMkaZoBLv0kbo3enxwKchf8URVMJROVrVK+6DErgwp1HQOHx
	 ieUB7Wr8V3AS0seThsgkNv0VLcitq0qQq7cxDmjerbkBBzCW/Yh+mT8v1o6ogm69N8Gt9
	 KoABM4uX/qmG6GoytVlmDP1MiPWrnbIYTb5QPhCu71z9txdfrZUWMK14EWpHTNMc20W5D
	 dN8sLEPk/KS6STGPVo4DAU/HXW6oHt+JLGKolSg0X3BANEUg2EHATRa3hlkVREOfZVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nXv4/+vP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AB5606A31E;
	Wed, 28 Oct 2026 18:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nXv4/+vP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D55E1F01825;
	Wed, 28 Oct 2026 18:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213092;
	bh=g0GEu+msrTkSSTwgBp3yM7A9GxKUW2omErB4tovxSnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nXv4/+vPOwVTKihxwpwgUoX7H5Q+gXlpMtmxiUUkPKHzCPU66b+BWdKKbrlqqi1eB
	 expdJVN84Zc6hYPxtY1oo/Yxinwoej54v72Z2LF2pOcuYhU02Lo+/dh486f8OVOOY0
	 KgnHezL1H6R4gIHq3ScYgw2cJu8+1om/ovW6r3kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Zhang <george.zhang@amd.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0382/1887] drm/amd/display: check dc_state_create_copy() for NULL in dm_suspend
Date: Wed, 28 Oct 2026 17:41:18 +0100
Message-ID: <20261028170507.926983972@linuxfoundation.org>
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

From: Jiangshan Yi <yijiangshan@kylinos.cn>

[ Upstream commit 015e72cde567d2450e282c2790773463156b2d0a ]

dc_state_create_copy() can return NULL on allocation failure.
dm_suspend() only conditionally skips dm_gpureset_toggle_interrupts()
and continues execution, returning success.  dm_resume() then
dereferences the NULL cached_dc_state in link_enc_cfg_copy() and the
following dc_state->stream_count loop, crashing during GPU reset
recovery.

Return -ENOMEM immediately if the copy fails, so the caller aborts
suspend instead of leaving a NULL cached state for resume.

Fixes: 8092aa3ab8f7 ("drm/amd/display: Add null checker before passing variables")
Reviewed-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 84b6d7932fdd2857795a257f9f258562a3cddcab)
Cc: stable@vger.kernel.org
[ sashal: Adapted context from dc_state_create_copy() to the existing dc_copy_state() call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index deaf98957cb76..86282119252bd 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2645,9 +2645,14 @@ static int dm_suspend(void *handle)
 		dc_allow_idle_optimizations(adev->dm.dc, false);
 
 		dm->cached_dc_state = dc_copy_state(dm->dc->current_state);
+		if (!dm->cached_dc_state) {
+			drm_err(adev_to_drm(adev),
+				"Failed to allocate cached DC state during suspend\n");
+			mutex_unlock(&dm->dc_lock);
+			return -ENOMEM;
+		}
 
-		if (dm->cached_dc_state)
-			dm_gpureset_toggle_interrupts(adev, dm->cached_dc_state, false);
+		dm_gpureset_toggle_interrupts(adev, dm->cached_dc_state, false);
 
 		amdgpu_dm_commit_zero_streams(dm->dc);
 
-- 
2.53.0



