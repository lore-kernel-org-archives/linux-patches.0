Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76ECB1EA91;
	Tue, 27 May 2025 16:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364548; cv=none; b=PuyM5vV2NVr+w0zXTOxHOgWJOfeDQa3ZSslWyuwjc64okXS5HiJUpQQjsZqyhy2Eb/Feuqud5lPooqvrhwrwK5CVlNPAL3te2qgqcwshYHU/MB2skTMxBY8jGv8bCGbRPJd2l29+a29olDCgNtPefXMaeertIUAo2mnrUE5mdtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364548; c=relaxed/simple;
	bh=FErFQXh+gj1gMhxenZvz+I7qhSCKj69OcjbKVpTsh20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXxZ+uBRKUt3H6ZcyRSH1cAv3mjDYzy9Ha2d0GlmBu49v3MjSvmOZvhaH60AV+ZXJtjEbEgUpLcgbJM83zbduJWZ6w7f/QImo4n34bGnGBf51+v3x8E2V+YBLWKFbdxrdilIg0uH9MhPg4GdBViEQmmqrsn5FM/DmYEUn5uzdVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6v0JL7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6v0JL7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00332C4CEEF;
	Tue, 27 May 2025 16:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364548;
	bh=FErFQXh+gj1gMhxenZvz+I7qhSCKj69OcjbKVpTsh20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6v0JL7LQl7eKA29wRrfKg1lN5oQV3BvQT5rGmoqFGD/Q9JOi9NJ43Vs8reSN0lFf
	 Yx2FSERjhqfGZ1FlhNkIfo1qXFqfArBhsY32DqMvqgYI7dlFrSU1FQ0Cx3/NJN9noS
	 AYZVQV6JIcwQf/HW4FaGe+N+kFbvO/28oSsH/k8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Lancelot Six <lancelot.six@amd.com>,
	Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/626] drm/amdkfd: set precise mem ops caps to disabled for gfx 11 and 12
Date: Tue, 27 May 2025 18:19:45 +0200
Message-ID: <20250527162448.787705862@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Jonathan Kim <jonathan.kim@amd.com>

[ Upstream commit f82d27dcff939d3cbecbc60e1b71e2518c37e81d ]

Clause instructions with precise memory enabled currently hang the
shader so set capabilities flag to disabled since it's unsafe to use
for debugging.

Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Tested-by: Lancelot Six <lancelot.six@amd.com>
Reviewed-by: Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
index 3871591c9aec9..bcb5cdc4a9d81 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -2002,10 +2002,6 @@ static void kfd_topology_set_capabilities(struct kfd_topology_device *dev)
 		dev->node_props.debug_prop |= HSA_DBG_WATCH_ADDR_MASK_LO_BIT_GFX10 |
 					HSA_DBG_WATCH_ADDR_MASK_HI_BIT;
 
-		if (KFD_GC_VERSION(dev->gpu) >= IP_VERSION(11, 0, 0))
-			dev->node_props.capability |=
-				HSA_CAP_TRAP_DEBUG_PRECISE_MEMORY_OPERATIONS_SUPPORTED;
-
 		if (KFD_GC_VERSION(dev->gpu) >= IP_VERSION(12, 0, 0))
 			dev->node_props.capability |=
 				HSA_CAP_TRAP_DEBUG_PRECISE_ALU_OPERATIONS_SUPPORTED;
-- 
2.39.5



