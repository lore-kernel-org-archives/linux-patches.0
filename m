Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CF54D5A1;
	Sat, 12 Sep 2026 07:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198715; cv=none; b=kzDxSrE4q6/aCn2NWdGI+ZQPAVMWo+xgLmZlPPV81X7rY4c7kYhe7PHGlEer0ptd8PCBP3/TaI2xEBe3kBbxLqtE4C+M4IzUBqVZI6y8AzPqf+QayPu5tD7HgeQ/Oyr0F8NjyuXm3dWx9ze4T5k/IZrjU/8sbANmAimWCmm1xvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198715; c=relaxed/simple;
	bh=CiT7otKKugXdsdI55zfDnkHQXHo08gxsT8kNHsrnjl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IX6EnUbF/dyDu2FOugKNjZ9etYs0j5ArSzGsF27NUmuIi+TCayJGMJo89JMSIBL5nekysBSELN3IFT3dj7sNH2pfmfe7fHMPeV6WhJxRhhr1J7QP5JtCFArV2LnSibcgYDTjQjkLY2oht0/sOUJOHjv8hWhiJbgAhwpioWw3d2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kI1UggzF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kI1UggzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDE71F000FF;
	Sat, 12 Sep 2026 07:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198713;
	bh=M/pEPHvUBffzQ8TOJQNI0gmakuv/imwxUDv8Rfn77HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kI1UggzFjdzVnmoe80cJ9u0Rhvk6oCpAvTnUroaD9y/MHefHwM7+4g5VmI0Kaxuqv
	 UfLFnbu88Q2qZVldwfJnO3T6yxrwppaC3RLsp0Tetav1CQVg8792+WSt8b+K6bDS2n
	 bKVOV0KErmkWqp7Ty8Uj2cTEJk2A1dFo7/vh8UqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anas Khan <anxkhn28@gmail.com>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0437/1815] drm/amd/display: remove duplicate link_dp_panel_replay.h include
Date: Sat, 12 Sep 2026 08:36:27 +0200
Message-ID: <20260912065659.151217499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anas Khan <anxkhn28@gmail.com>

[ Upstream commit dcda83715716ac828454094ed9c6e17150a0092f ]

link_dp_irq_handler.c includes "link_dp_panel_replay.h" twice. Drop the
redundant second include; this is a non-functional cleanup flagged by
scripts/checkincludes.pl.

Fixes: 1e5cd4adfc54 ("drm/amd/display: move panel replay out from edp")
Signed-off-by: Anas Khan <anxkhn28@gmail.com>
Reviewed-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c  | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c
index 54ce768ae6ad9..da679fb7d89c7 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c
@@ -39,7 +39,6 @@
 #include "link/link_dpms.h"
 #include "dm_helpers.h"
 #include "link_dp_dpia_bw.h"
-#include "link_dp_panel_replay.h"
 
 #define DC_LOGGER \
 	link->ctx->logger
-- 
2.53.0



