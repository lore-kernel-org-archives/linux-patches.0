Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2FE3E3161;
	Mon, 20 Apr 2026 13:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691478; cv=none; b=SyuXV6pwD4o1BLpwXW/6Y2Q3+AllUGASpekUcEJRi5se7NXJtPhcNnFTkY6T6asJM8tR0OB/HeJeoYmqUHgMWRpJmExjwGXimc2tYwM9jge+cZ6pjtgrwwpCXS6a5EB7q/5QooPQwf26X02cOp+ZOLTC38qbpv72HL8doUBJigU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691478; c=relaxed/simple;
	bh=z5zY5vSxlxaAK3rev+R5sLYjXq65u0sb9k9Dj+AXCtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEDklhsS2F1K6kHpJvBRtX6vSETTKC4unxVc9R64YR8bzflD/XGayjABtI3Y+D5R7EvS2wY6NJYKL+R9RwMQrggcR5Z1b9V4Hc+kOjMEjfWyW/erRlZPt4upjYf4VyvaieGFBmVi+QqRg6YRhmlLdAvevDGyCiKMn2OaD8sYsE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sD0qdCOv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sD0qdCOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65F8C2BCB6;
	Mon, 20 Apr 2026 13:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691478;
	bh=z5zY5vSxlxaAK3rev+R5sLYjXq65u0sb9k9Dj+AXCtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sD0qdCOvo+8kKd0Ae8VMNBvhQwStMz9zmzrm9E3j50jSGw/+ZLfaqJgq5nG/ibTlA
	 gUauDvlZxh+oiqz7kYCqW+S9GaE9fJyY0a5ywa4739No2soestBWxbw6Yh6+fARNEa
	 VQwONO9TMRvm9uMW7gzaClWnGSu6H2Sa4/gZfoIZy/QDYeI+/mqHUh6TQl0DR9O4xZ
	 PADn3EPrBvtZfYzUPPQTPjZnrZd5qmBl9aZ1jEpOiDagWdoWQGkafqkcvvD0ccp8sQ
	 C9SNvm/3iQWHPK0IYyWcPnNKS8noxeC1KHgIpUWFOnW29eSgkGcoDVtpOlCXVX7uTi
	 eggL29f9yYQhw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	matthew.brost@intel.com,
	thomas.hellstrom@linux.intel.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	John.C.Harrison@Intel.com,
	daniele.ceraolospurio@intel.com,
	matthew.d.roper@intel.com,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/xe: Fix bug in idledly unit conversion
Date: Mon, 20 Apr 2026 09:17:27 -0400
Message-ID: <20260420132314.1023554-53-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit 7596459f3c93d8d45a1bf12d4d7526b50c15baa2 ]

We only need to convert to picosecond units before writing to RING_IDLEDLY.

Fixes: 7c53ff050ba8 ("drm/xe: Apply Wa_16023105232")
Cc: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>
Acked-by: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://patch.msgid.link/20260401012710.4165547-1-vinay.belgaumkar@intel.com
(cherry picked from commit 13743bd628bc9d9a0e2fe53488b2891aedf7cc74)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/gpu/drm/xe/xe_hw_engine.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_hw_engine.c b/drivers/gpu/drm/xe/xe_hw_engine.c
index 1cf623b4a5bcc..d8f16e25b817d 100644
--- a/drivers/gpu/drm/xe/xe_hw_engine.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine.c
@@ -587,9 +587,8 @@ static void adjust_idledly(struct xe_hw_engine *hwe)
 		maxcnt *= maxcnt_units_ns;
 
 		if (xe_gt_WARN_ON(gt, idledly >= maxcnt || inhibit_switch)) {
-			idledly = DIV_ROUND_CLOSEST(((maxcnt - 1) * maxcnt_units_ns),
+			idledly = DIV_ROUND_CLOSEST(((maxcnt - 1) * 1000),
 						    idledly_units_ps);
-			idledly = DIV_ROUND_CLOSEST(idledly, 1000);
 			xe_mmio_write32(&gt->mmio, RING_IDLEDLY(hwe->mmio_base), idledly);
 		}
 	}
-- 
2.53.0

