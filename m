Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CDB392811
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301004; cv=none; b=gVrvkQMh4GNoAZKmjC0UH1QBqTt1+gvGuQCPCUwfipUU8+6JjoSHjO+JtQ1mWMWSlg7MQfD5EMMrFNMfVBRrwexYj+yB7uwcAhvXr4nIcgaJIm2oYRiwASZOuF4GNWZSLl/oE/4VVpkrblg+JV+Erm+tG1k49cNnfvwE6cloJvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301004; c=relaxed/simple;
	bh=D7nUUwIovDpspinNd2KGl13spb6T8MiLircZ8wMKkUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egIpawJHVCgJNSkrnNcuqojgldi3cYiwk6oV1MDSyT/dId+nUAAyOSirglhYYW7ofCqyjBr7eEQo03hYvo6Dbw9sWl7ht0fAu71vPuCrn97KY1K3+QuYGswTPjySgugPeO2AytRk6RJw9mp5w32zNJMOS7rnqEtVB8LKZX4d6J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Busr4kON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Busr4kON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D35C19424;
	Sat, 28 Feb 2026 17:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301003;
	bh=D7nUUwIovDpspinNd2KGl13spb6T8MiLircZ8wMKkUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Busr4kON0Oa60crA3NYQfP9jwAk16j6zlpQSwVHsNw/7PgPzopKwDfKwl6IR9Uiq8
	 eZ1zzsJFblKCoNEsgS7RCSWfEZCKOm0m5Xsz4HcSOZNh3UMopDtndyIUS+uCl3FsGB
	 TOP7Hgn28l0JhsuTvvchuvVHIo9KLGca3q2zeGs/G3/QLkrJj3z040GDcLNdi0MnPL
	 FBgM/DdJCaprKTw1oIC+So4tJu2jn2CX5SB9sg8qk2yPoFAUY4TIwexXEyA4LHknAb
	 9ggozwOmdTzorD5jaJqo5t52lDqjdNIxryWZ2ybnbs/FjmTpQ1s9Ib67LqG1Bh5NoQ
	 GKhTA7B1rXxMA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tim Huang <tim.huang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 137/752] drm/amdgpu: add support for HDP IP version 6.1.1
Date: Sat, 28 Feb 2026 12:37:28 -0500
Message-ID: <20260228174750.1542406-137-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tim Huang <tim.huang@amd.com>

[ Upstream commit e2fd14f579b841f54a9b7162fef15234d8c0627a ]

This initializes HDP IP version 6.1.1.

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Tim Huang <tim.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index dd7b2b796427c..54a045a0bda96 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -2995,6 +2995,7 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 	case IP_VERSION(6, 0, 0):
 	case IP_VERSION(6, 0, 1):
 	case IP_VERSION(6, 1, 0):
+	case IP_VERSION(6, 1, 1):
 		adev->hdp.funcs = &hdp_v6_0_funcs;
 		break;
 	case IP_VERSION(7, 0, 0):
-- 
2.51.0

