Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264FF355049
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301011; cv=none; b=DZ5Ml3qKuHCfROxjMyK+U+zqQIiuFHnWr8sko3WyprfIGidR1AZRqgNCWUmuR//oYXFBBNJJj2hlMHQQiPNwljADI7xueFK2sitlobdYBefJO2/kKt13PW/Hb/mr1HTE1R6jqbq1E/FW2o6zYkvzQsjOwiguV9ooB+d6rH8GGds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301011; c=relaxed/simple;
	bh=Zvkipsav9SdcPaTBTW8oMwsWodJGVHJ23ZXYJsKHV24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cA3bzzdgkz8NpsR/QTYwnejgQMnps4QJxnIHYfoW6bfSy3OVTBq/cTJcEdXh7ODrx32J2bu1IpJcgn+0+o+N2axxASfKy8wjEiVxFEUy3vgIYmjvSPLw9jXemtN5XX8UQlG8vt/d+ML38HL51Uy4sc3RY24Nrijin18tY9Z+OFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bVKJR++a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bVKJR++a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0DAC19423;
	Sat, 28 Feb 2026 17:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301010;
	bh=Zvkipsav9SdcPaTBTW8oMwsWodJGVHJ23ZXYJsKHV24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVKJR++aZ3F3JfUHmeWffonRuz+KQPI5NzOdWyQzobh/KZG1BA1No/wYYFs4e8uds
	 M/Y/miwpOVcO5YniPIj3HxVYdAu5jleH26NDWg30yOj1mfNqixY/BetTRZ0dI2lK8x
	 mKcce7HoKUt5pKET8+j13p9Yoe+BFuu6U2A5QRZEdSVzXoTOKgUYTGWOTMdGZKVWvw
	 DqNx+E6Dpd6mrMhvTMfSoLGXKIWL+t3SQ8Wp36ysfeDa9JIbcv5DR9epHJH1+cAf5k
	 r5LL72rpMNq/urGc3nz+ZkRT5UO+gImZfsRP5VEbywItAlA7FRp2tjL6S7c+0NxBA9
	 IGkZR9CIthR/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: YuBiao Wang <YuBiao.Wang@amd.com>,
	Victor Skvortsov <Victor.Skvortsov@amd.com>,
	Gavin Wan <gavin.wan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 145/752] drm/amdgpu: Skip loading SDMA_RS64 in VF
Date: Sat, 28 Feb 2026 12:37:36 -0500
Message-ID: <20260228174750.1542406-145-sashal@kernel.org>
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

From: YuBiao Wang <YuBiao.Wang@amd.com>

[ Upstream commit 39c21b81112321cbe1267b02c77ecd2161ce19aa ]

VFs use the PF SDMA ucode and are unable to load SDMA_RS64.

Signed-off-by: YuBiao Wang <YuBiao.Wang@amd.com>
Signed-off-by: Victor Skvortsov <Victor.Skvortsov@amd.com>
Reviewed-by: Gavin Wan <gavin.wan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index f96beb96c75cc..38183b4f03dfd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -972,6 +972,7 @@ bool amdgpu_virt_fw_load_skip_check(struct amdgpu_device *adev, uint32_t ucode_i
 		    || ucode_id == AMDGPU_UCODE_ID_SDMA5
 		    || ucode_id == AMDGPU_UCODE_ID_SDMA6
 		    || ucode_id == AMDGPU_UCODE_ID_SDMA7
+		    || ucode_id == AMDGPU_UCODE_ID_SDMA_RS64
 		    || ucode_id == AMDGPU_UCODE_ID_RLC_G
 		    || ucode_id == AMDGPU_UCODE_ID_RLC_RESTORE_LIST_CNTL
 		    || ucode_id == AMDGPU_UCODE_ID_RLC_RESTORE_LIST_GPM_MEM
-- 
2.51.0

