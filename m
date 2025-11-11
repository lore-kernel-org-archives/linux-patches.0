Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC303192B75;
	Tue, 11 Nov 2025 00:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822323; cv=none; b=Vbjbnd3zku+nI8EbUc4xZM2iwOr06J2u63b5TbdCD1qZ/HvRgh5A/+FfCK7c/FA/FzRsELW2yDgUVVzuzzJFRG6La9Gadtwyf7t95hgwLLYM43wkL6Z1l74h9Oo44XMvzhBxrg8wv9YdwBaR9lf85kQLsHhKEUxpU+V+cIiqjPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822323; c=relaxed/simple;
	bh=919nmATKQat69N40qNRi55ijvXxD9vTMGJcsojH2SSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0/11o6S/wOYh0PISFb1f8grMx/z3yqIYKxxQTT+bxFRhaYH1gz3g77SHB2/oav4NoPBL1KuG+OBemM3biIGyF7ld7N/kbsMjT2ekLyZKW8no0QSxtcWZet64SqQXaLJFEjXiGg2kP3y46x0jeWf4XRieOOhlFTHaucE6xfiAQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=huZ/8qQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="huZ/8qQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40063C19422;
	Tue, 11 Nov 2025 00:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822322;
	bh=919nmATKQat69N40qNRi55ijvXxD9vTMGJcsojH2SSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huZ/8qQIrfQHJQOmFfUp+qGx+44KJI6PMQXmYcm2/OcVXj0T4pwucAfNNAicUvZkd
	 0UL4SIHqhG9EJfo+l2oGQ1aB7w6GxDSMaAiPCYLVtrzT7ihLRyJnR0PlzPhCLEroA5
	 PMZI4iZ767xpRMZx0S5PQxwFDas8ObFrBTFMK2lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 085/849] drm/amdgpu: fix SPDX header on amd_cper.h
Date: Tue, 11 Nov 2025 09:34:15 +0900
Message-ID: <20251111004538.474395440@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 964f8ff276a54ad7fb09168141fb6a8d891d548a ]

This should be MIT.  The driver in general is MIT and
the license text at the top of the file is MIT so fix
it.

Fixes: 523b69c65445 ("drm/amd/include: Add amd cper header")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4654
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 72c5482cb0f3d3c772c9de50e5a4265258a53f81)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/include/amd_cper.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/include/amd_cper.h b/drivers/gpu/drm/amd/include/amd_cper.h
index 086869264425c..a252ee4c7874c 100644
--- a/drivers/gpu/drm/amd/include/amd_cper.h
+++ b/drivers/gpu/drm/amd/include/amd_cper.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: MIT */
 /*
  * Copyright 2025 Advanced Micro Devices, Inc.
  *
-- 
2.51.0



