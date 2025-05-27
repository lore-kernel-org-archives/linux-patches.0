Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F31185E7F;
	Tue, 27 May 2025 17:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366547; cv=none; b=jBEWxG8KKjPUwCREXTjlwD6qliO/NIv4Jew6DYl7oz/vRyM5ZrdORO+YuBeUs1gGbMQ0dgz9Z9B3KWtJN4IpKYCph7r3ydOPFREZXhk01bjRgDA1TOQ68VgMMohH8dluX0j0Nveh4z1g40M+LNkLKTBr0pTL0yKKtGmzapvZycY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366547; c=relaxed/simple;
	bh=EE5MaK1642J/101mTrsCIhx0eShHbE5OS06xUS5tDFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCHYZyZVkCXo7x+C/N0xgz2/vuZQyUrZ1fvSX8GgWjK7KXj+R1lDOq1EJBjwXzpgGkysNgkCRJNOkazwxk/LOY6bEeDcBhpmKnYUJAyDhoA9wWWjqnKqM+NU6/pZ8h9ow78sSIXVq5mfR1Hh4iP0S+EG1hYtODwTFugqgNZL9xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUaeJRAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUaeJRAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692ECC4CEE9;
	Tue, 27 May 2025 17:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366546;
	bh=EE5MaK1642J/101mTrsCIhx0eShHbE5OS06xUS5tDFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUaeJRAPmKiUVOmsUiTkojg7kFDtW65iw3bD+9t3Uong4TLEGLj/18HiaLPXTwtor
	 AmWRkjv0Hc3AInoog/JN0fPc2BuA9YLDV4Y9z0NuwnIfVah9WNuR0RTo5NvCV1Xbig
	 IaIzz4RmaLrSQ91UDSXFXxIcB7O3/WDQeudsHDmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Lancelot Six <lancelot.six@amd.com>,
	Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 103/783] drm/amdkfd: set precise mem ops caps to disabled for gfx 11 and 12
Date: Tue, 27 May 2025 18:18:20 +0200
Message-ID: <20250527162517.339199638@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 62a9a9ccf9bb6..334c576a75b14 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -2006,10 +2006,6 @@ static void kfd_topology_set_capabilities(struct kfd_topology_device *dev)
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



