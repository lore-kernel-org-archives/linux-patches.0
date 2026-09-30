Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2686C3B3BE1;
	Wed, 30 Sep 2026 18:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794326; cv=none; b=b8AaVYI/b/zkIVYsgUC5WMuxEL9vK/ydG/YYwxjit9WFqmdR/0u3BkRJIjMH99RbpeG/TvAO6vFrNEOg3UqPfZbjd6JBh4KWhhWxBZmAkfASe5qKQ5aLfWRfSxdDgcjUSL8mnlflIUosEOpF19SjoGBLk5DEWgV3/fcojU7qU44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794326; c=relaxed/simple;
	bh=Y6IirX2i9lTBFI1z/92kjH8Hz1DdbgBIRQMR2UNGmnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzUekjjDQDOrGLC6G5yQa4QZATiQ5ZtpsUiWV2OCA2rk1DRuf+qUkWh3p+PQMJWmc2qIlS+Aq8oEiWSbJGGSmbMxe48GEfy/JMwNj66cISflLoKfhoLTyvNrevjIcAFG+mbDWsG3FKRfNQ7RPpnNikltHIRRoQi0yyg0ANj6AOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrdDJEid; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrdDJEid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8331F000FF;
	Wed, 30 Sep 2026 18:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794325;
	bh=MORODLX80Bk6WkeavZHm4weWpGNT4s9sBxDybPYI/0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wrdDJEidkpDUtnUM1VDaTE2utznnSui0Yx1Rf0j1CJRTVVi+48hLR1g0w9KNC1oDK
	 1GMjDW8ZouilT0luc2JfNxgzzZSVA44L4A9qYcMXVQHD3O3B7/34br/HyD2cq+QZDj
	 F9y/uig+BgQP5BWFHyD2ZJatmHhqGgKktARVkSqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiwu Zhang <shiwu.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0171/1193] drm/amdgpu: fix buffer overflow during vBIOS update
Date: Wed, 30 Sep 2026 17:14:15 +0200
Message-ID: <20260930152437.991910680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiwu Zhang <shiwu.zhang@amd.com>

[ Upstream commit 6229898d46c0cbc238a6fe9f11c1ea12cf8bb9c5 ]

Clamp the buffer postion to write by setting the bin attribute
to the maximum buffer size so that VFS layer will block the
out-of-bounds accessing.

Signed-off-by: Shiwu Zhang <shiwu.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 2ef87646e6bb1..91eebf85596b7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -3694,7 +3694,7 @@ static ssize_t amdgpu_psp_vbflash_read(struct file *filp, struct kobject *kobj,
  */
 static struct bin_attribute psp_vbflash_bin_attr = {
 	.attr = {.name = "psp_vbflash", .mode = 0660},
-	.size = 0,
+	.size = AMD_VBIOS_FILE_MAX_SIZE_B,
 	.write = amdgpu_psp_vbflash_write,
 	.read = amdgpu_psp_vbflash_read,
 };
-- 
2.53.0



