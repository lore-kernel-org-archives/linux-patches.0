Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B368E2DE1E2;
	Tue, 12 Aug 2025 17:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021138; cv=none; b=nfsv4HHRralrbkYclm7hCc/wX6j1RzaWp2w46uMuqYW0/ztz5IY0TTEFN5bY4eEx+LI3lzrwqp5SslNVtA5jsfeY7uM+ttFEd8FZ4RatGjuipLv21Lbq2pQRri9hXjqQbCa6f1cwbNA0c+qCh4d/2dsyqLWFPnU+9MK3Kl5oDI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021138; c=relaxed/simple;
	bh=ZrUoHG/LUQjctgmhIWtJTSXqMfDWK4YKKE5u3FIt8Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzhQKjoQRmXrWL+pDiWuExH/10fYtzPqT/UxPdj+rioDT3ZQQx2pilnx/hgrQvGhaPrnHOPEyJxaJd5sk+C3lG+5wovulLX3aJdzgwxeB1KMvLoO4bOlIvZ2RlNOwzlb8xTk2uqpZk7+e4fsBv6JJCGAi6QNx47kAGznCDUVHnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dV2/otzW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dV2/otzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3152C4CEF0;
	Tue, 12 Aug 2025 17:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021138;
	bh=ZrUoHG/LUQjctgmhIWtJTSXqMfDWK4YKKE5u3FIt8Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dV2/otzWtLw66vSOr4D0c0R0Zza/HELb6FHkUIOdA4LQtTdBena+sGzo/YbnNh3dU
	 uuwxgdf7bz5PZ5s57/QwR+DuaR4KJxBVURrryprcfyXykCXPX5dnO1sszIWYuTQ5Gn
	 aWX7ArMhhVnckJYPhiLPiNCAOiNGq0rJmy5o8pLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/262] drm/amd/pm/powerplay/hwmgr/smu_helper: fix order of mask and value
Date: Tue, 12 Aug 2025 19:27:36 +0200
Message-ID: <20250812172955.896133404@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit a54e4639c4ef37a0241bac7d2a77f2e6ffb57099 ]

There is a small typo in phm_wait_on_indirect_register().

Swap mask and value arguments provided to phm_wait_on_register() so that
they satisfy the function signature and actual usage scheme.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

In practice this doesn't fix any issues because the only place this
function is used uses the same value for the value and mask.

Fixes: 3bace3591493 ("drm/amd/powerplay: add hardware manager sub-component")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c
index 79a566f3564a..c305ea4ec17d 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c
@@ -149,7 +149,7 @@ int phm_wait_on_indirect_register(struct pp_hwmgr *hwmgr,
 	}
 
 	cgs_write_register(hwmgr->device, indirect_port, index);
-	return phm_wait_on_register(hwmgr, indirect_port + 1, mask, value);
+	return phm_wait_on_register(hwmgr, indirect_port + 1, value, mask);
 }
 
 int phm_wait_for_register_unequal(struct pp_hwmgr *hwmgr,
-- 
2.39.5



