Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9EC46AA6B;
	Tue, 21 Jul 2026 15:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648408; cv=none; b=R2iBvdkZoHTeb33IhV1ZxJifHvP5/yqipqJb93j66T/KLmkSWL0yJDZhdOGCxcoCH1/Kg7cSZ8Fdl3/u4CxpE6yROP0sbABNytXHDgTElzTxs9Xkyf2DlCu3dc8mUj83/Ht3H/X2K2Q6/EWsbK1tIB4hpuAuIZXOxYVcsKgPoU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648408; c=relaxed/simple;
	bh=2prk57r7gTgmKMXGUz5OxWrJ2Dgugt5mk2ksIVfpQP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hb1A8v7eLX/WnHV25CPrRil2+3RUjDg9sfSStWch4tBCd7A3aAjj/ZThRGTKE2TZmA247eycC8Qg5SsltxjlNhDzupMXeavvrOLDWvdQPiVnU8dlC5K8XhCgIx394C0bzuQ6wBE5F+swn06C1VLzoC4cIUnDa7HhGMu+3Bg2Oes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Em2UOnyz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Em2UOnyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CB51F000E9;
	Tue, 21 Jul 2026 15:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648407;
	bh=mj+0UxSGj/sLc7S+BzbUUZYd62bFLCa+s4sZke6Edno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Em2UOnyzlidN/rwvbxtTkx38BQdBs4L0kM+d0dckYYlpsbr4jho2WZKld8LvHZl8T
	 mH3k/4B9nYnYxVhSRdc+HwuQoHAh+sEamvRj4Gro5z5RS9f4DA97H1o4+M45BwzCJL
	 wzzeoyZkx787ORbKpwE3xDwRa+y5DEswsoSOhV0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0189/2077] drm/amdgpu: fix error return code in mes_v12_1_map_test_bo
Date: Tue, 21 Jul 2026 16:57:42 +0200
Message-ID: <20260721152557.142679701@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 5da1e1dfd15727918aab2c1a79c019f179991e80 ]

The function mes_v12_1_map_test_bo incorrectly returned 0 unconditionallyon error path,
which would hide the real error code and mislead upperlayers about the failure status.
Fix it by returning the correct error code 'r' instead of 0.

Fixes: 44e5195fa3d4 ("drm/amdgpu/mes_v12_1: add mes self test");
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v12_1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v12_1.c b/drivers/gpu/drm/amd/amdgpu/mes_v12_1.c
index cec80127812652..be86802fef33b9 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_1.c
@@ -2016,7 +2016,7 @@ static int mes_v12_1_map_test_bo(struct amdgpu_device *adev,
 
 error:
 	amdgpu_sync_free(&sync);
-	return 0;
+	return r;
 }
 
 static int mes_v12_1_test_ring(struct amdgpu_device *adev, int xcc_id,
-- 
2.53.0



