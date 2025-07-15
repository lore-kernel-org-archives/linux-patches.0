Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F338C2E5413;
	Tue, 15 Jul 2025 13:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586881; cv=none; b=d8Rd/EMd1t0CQ7JI1LF6gWjwy0QqjoTDsIpbvBrPTu6RFY7B68RWaKH7QRwBl9tI2vG7IvlMBDTN0AAxA3k/Fb2bpy1SjsvowXNoPOniEezRlg9xhCFapgxd9nqYZFKzyeOWXeP3U+3ea943zXik8EB6hPEqDGpUFZTSOfu9Q78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586881; c=relaxed/simple;
	bh=lswOJUpPYepB3IncIuCSxiRyvtSC1Iwfq7bZGifuK88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAkaahlkzU4HZ+ByfCmIfosO1GF23CYYcs+bG13zjs0oxRXnKCg5tWt5MFS+6kZm8p75ItO1q2K9Rfnd1et5T5io1tt2HVX3kQnKoYwzbO+0FN1vuKfhneDxlFFIC086BorKCmBwE0VUhLTSRJj9ytqcPFnEE2Ay0+7FZECJuCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWtI7PS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWtI7PS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873F0C4CEE3;
	Tue, 15 Jul 2025 13:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586880;
	bh=lswOJUpPYepB3IncIuCSxiRyvtSC1Iwfq7bZGifuK88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wWtI7PS1pwXbr6v2XnJA8t6JyC92arV2VzabPEqk6f5IlUIpL6o2REMVI+OQsprOe
	 PyhnQM71a3RxtolM5OmuE723b3bMDYYhy2Fh9SxKAE6PImlF+zo49GkfGWgBz4TMnU
	 wKrsVXKf2/DyIoBlWsxCWDegwTYhfOk5Y+HF99vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 083/192] drm/amdgpu: Include sdma_4_4_4.bin
Date: Tue, 15 Jul 2025 15:12:58 +0200
Message-ID: <20250715130818.251052230@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Russell <kent.russell@amd.com>

commit e54c5de901ea56fc68f8d56b3cce9940169346f4 upstream.

This got missed during SDMA 4.4.4 support.

Fixes: 968e3811c3e8 ("drm/amdgpu: add initial support for sdma444")
Signed-off-by: Kent Russell <kent.russell@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 51526efe02714339ed6139f7bc348377d363200a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
index cef68df4c663..bb82c652e4c0 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
@@ -45,6 +45,7 @@
 #include "amdgpu_ras.h"
 
 MODULE_FIRMWARE("amdgpu/sdma_4_4_2.bin");
+MODULE_FIRMWARE("amdgpu/sdma_4_4_4.bin");
 MODULE_FIRMWARE("amdgpu/sdma_4_4_5.bin");
 
 static const struct amdgpu_hwip_reg_entry sdma_reg_list_4_4_2[] = {
-- 
2.50.1



