Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB0A269AE4;
	Tue,  8 Apr 2025 12:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116209; cv=none; b=d9nL0G2e+F6jP+NvUtUPu0rDYK8HTmXN2Ck2t+gmP9aQB2i+dAZnGkNyNXvKRTi3/vrH4O5Q+hSUSfzXaiuMCFBFQ+vTH2GN7U/ysnKFHxbzrNxrwmYBiiE2j66zYRH5qCUwF99Ajl9saXtUzQYYgzTjXTnesvD7F3/XxVEwBKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116209; c=relaxed/simple;
	bh=oBKMAXT7gfcsAgJwOyRUZgDW3NH+I3Cor0BwWYqsv+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsU7KgXJgjL/kEV2Fl01flHye8s2ws7oxZw7sMppph8R2GVhV9pvKxqgl0Ajitzw9X1G08MiimLoM5xh/8AMRSx+3APs6Trl0Ox1bC/nT7cjypwcXC4mjaYjWqeNYAqIZ+ftYtPhghcB5+N9XF0mka+uLyQgUOC1q1ctgPsnP18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVv+H/kj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVv+H/kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A040DC4CEEA;
	Tue,  8 Apr 2025 12:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116209;
	bh=oBKMAXT7gfcsAgJwOyRUZgDW3NH+I3Cor0BwWYqsv+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVv+H/kjGl6j3qj7QljuO+zbDYHV8+ujh7ChTNMYYQ9MjbtIbkOQHMNOb4Ma2g9/7
	 Nyi0u/TO2Jvo1zDki/SaI4xjG8KTUvnRDsOqU2fUOFXAuGKVnqZFMpaS/MBTeSoixz
	 Lp0UnmbVwdz5Gy5rpLVnIVfyQZHfl49WvKXMt27k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/423] drm/amdgpu: refine smu send msg debug log format
Date: Tue,  8 Apr 2025 12:46:22 +0200
Message-ID: <20250408104847.055436193@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 8c6631234557515a7567c6251505a98e9793c8a6 ]

remove unnecessary line breaks.

[   51.280860] amdgpu 0000:24:00.0: amdgpu: smu send message: GetEnabledSmuFeaturesHigh(13) param: 0x00000000, resp: 0x00000001,                        readval: 0x00003763

Fixes: 0cd2bc06de72 ("drm/amd/pm: enable amdgpu smu send message log")
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
index 0d71db7be325d..0ce1766c859f5 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -459,8 +459,7 @@ int smu_cmn_send_smc_msg_with_param(struct smu_context *smu,
 	}
 	if (read_arg) {
 		smu_cmn_read_arg(smu, read_arg);
-		dev_dbg(adev->dev, "smu send message: %s(%d) param: 0x%08x, resp: 0x%08x,\
-			readval: 0x%08x\n",
+		dev_dbg(adev->dev, "smu send message: %s(%d) param: 0x%08x, resp: 0x%08x, readval: 0x%08x\n",
 			smu_get_message_name(smu, msg), index, param, reg, *read_arg);
 	} else {
 		dev_dbg(adev->dev, "smu send message: %s(%d) param: 0x%08x, resp: 0x%08x\n",
-- 
2.39.5



