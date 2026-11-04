Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829337;
	b=2XOOs88IiuA2gFfb4kyNdGZH1VXkQIcWGJQJWISWvUBS/4JeUVJIcZYJhraz3OLbL4Wd
	 iJOtn3mBf4RtRnNrq1zXuJ8Y+8z83XXjHHJnwAd11DiwS0PRSzhGIXyn2ONrvA0QZdti4
	 1qfm3OVquqACmbRFSu0ktyhL6NIBMy4CAIr4vQQDbinSeFVysnkie/DWVMOvaMqnY/P4C
	 8X8+TC98kTCofAhmI4hnj5fg46fKzGhDEMGOewQQPWXLN1w50bRJ22ZPX14OGwODblJqg
	 TPN/ziJTqE1ENP4NAmvKUcwJxIbK/1b7nckW2SX1a++ltDD3G8b7im8nygAe2b8DAEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TIvQNQXmjyr1zVwX/GqFHo13s98HSYLsAkPEukrzJtw=;
	b=cMczPqpk1gc0aSKHL/0Zw87A2CrwX9QHl3iU53IiXXMfjp6EX8dYlBgbKf22GqI/7my6
	 SdzIhaUeAkWSsZYMc6AosFOb3e4ibEcga9wAQlvjr6u0r8jg6eHnG+11S0FxOyOJDbpsw
	 CYsVjBRo8iTaySrztO61lQlbAZqSXNJh+L1RobORqDQ8xSFHwXhq26T45/XYgfoMwvmgZ
	 x2YLew90LzFHGdJ/sWn+wVfFm2tE49ZKqKxuf6aNmxDsh3Bf8LjkfxA/2FmReK1XCDvlo
	 k0nvxvlVa842pJ1xqQ8fmZ1ybV9Eu8/N1DbVwUVbswdMeqg/gMQfUdqcCV25rPMSanA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pi8D9EdH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D19E60A3834;
	Wed,  4 Nov 2026 21:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pi8D9EdH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA3E1F000C1;
	Wed,  4 Nov 2026 21:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829337;
	bh=TIvQNQXmjyr1zVwX/GqFHo13s98HSYLsAkPEukrzJtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pi8D9EdH+a3bbvZZ+q5Dl99ztetutugwB6qrAIXrq5y87iG8YF+jNosTWmMAf7END
	 TJ6CbvuWyebJbZP6oXnrffyp1pXnJEsI+vlRed352NYjuyHEMn8vJ79D46uhbxYu3b
	 foboKdSp+7uMunGy3iKdRSOkINeAC0VYN57335w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0063/1005] drm/amdgpu: Fix kobject cleanup in xcp sysfs
Date: Wed,  4 Nov 2026 15:56:36 -0500
Message-ID: <20261104211045.366407743@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 62d8b452615fd7a61976a1372bb81937807968c3 ]

Fix the indexing issue. Release the kobject whose init/add failed, and
unwind the successfully added ones.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
index 1083db8cea2eb..6059227c53150 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
@@ -901,7 +901,7 @@ static void amdgpu_xcp_cfg_sysfs_init(struct amdgpu_device *adev)
 {
 	struct amdgpu_xcp_res_details *xcp_res;
 	struct amdgpu_xcp_cfg *xcp_cfg;
-	int i, r, j, rid, mode;
+	int i, r, rid, mode;
 
 	if (!adev->xcp_mgr)
 		return;
@@ -947,14 +947,16 @@ static void amdgpu_xcp_cfg_sysfs_init(struct amdgpu_device *adev)
 					 &xcp_cfg_res_sysfs_ktype,
 					 &xcp_cfg->kobj, "%s",
 					 xcp_res_names[rid]);
-		if (r)
+		if (r) {
+			kobject_put(&xcp_res->kobj);
 			goto err;
+		}
 	}
 
 	adev->xcp_mgr->xcp_cfg = xcp_cfg;
 	return;
 err:
-	for (j = 0; j < i; j++) {
+	while (i--) {
 		xcp_res = &xcp_cfg->xcp_res[i];
 		kobject_put(&xcp_res->kobj);
 	}
-- 
2.53.0



