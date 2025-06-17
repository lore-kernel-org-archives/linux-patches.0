Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A288A28E8;
	Tue, 17 Jun 2025 15:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175613; cv=none; b=sH+MmcyVR9gt66SAa4sw4zMRMrmhtcIXulORgjEDmHn0DnSVlCGV5qVRotQSxbJloFafVCffmGz07cUAnICWN6nhZYUJomPUmx98CNfhmYE3dDeiQsibSTzBEWlWK1+i/Nkth9Hf8y87HPGEIUv5szLWclmgbODkp5hxJjUk3bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175613; c=relaxed/simple;
	bh=nlQgucthSLVuemGGkMSKAcRw6eUSgIYtMR8NWKzxibQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RoKRvrCPHV4aI8Hq9VEQFjW0CFBJEc2AsX75u+2WeesRMloaKc7rG7YnxpDkyr4olts/WayssgzeR+3mt8lS0fubVrRA/dE69DNOYZe7r+JUyib54/q18OkxUvC0xvMEpBIT+fIs7x9ysvG3KAZ08KBptNAgD8+d71ogTwMZGNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vr0/DdDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vr0/DdDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1244FC4CEE3;
	Tue, 17 Jun 2025 15:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175613;
	bh=nlQgucthSLVuemGGkMSKAcRw6eUSgIYtMR8NWKzxibQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vr0/DdDku0dvJldQ91IZTfCKhKTQ32/ZaUzyYGeIlwsRrYM3YY0Vq9fUkvDnct1ql
	 Iq4PY3kWdpsmcFpqCDoPpvIh3IEdYSUj4vc3tit2WdaPkNFs+zlf/EX2GRjTYQJjdy
	 gwzxx91we9dFRSSw3004qa4PzU+MKWfeoQsvA1ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 106/780] drm/panthor: Fix GPU_COHERENCY_ACE[_LITE] definitions
Date: Tue, 17 Jun 2025 17:16:54 +0200
Message-ID: <20250617152455.818749591@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit d1df2907fb69df56aad8e4a0734dac0778c234a7 ]

GPU_COHERENCY_ACE and GPU_COHERENCY_ACE_LITE definitions have been
swapped.

Changes in v2:
- New patch

Changes in v3:
- Add Steve's R-b

Reported-by: Liviu Dudau <liviu.dudau@arm.com>
Fixes: 546b366600ef ("drm/panthor: Add GPU register definitions")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/r/20250404080933.2912674-2-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_regs.h b/drivers/gpu/drm/panthor/panthor_regs.h
index b7b3b3add1662..a7a323dc5cf92 100644
--- a/drivers/gpu/drm/panthor/panthor_regs.h
+++ b/drivers/gpu/drm/panthor/panthor_regs.h
@@ -133,8 +133,8 @@
 #define GPU_COHERENCY_PROT_BIT(name)			BIT(GPU_COHERENCY_  ## name)
 
 #define GPU_COHERENCY_PROTOCOL				0x304
-#define   GPU_COHERENCY_ACE				0
-#define   GPU_COHERENCY_ACE_LITE			1
+#define   GPU_COHERENCY_ACE_LITE			0
+#define   GPU_COHERENCY_ACE				1
 #define   GPU_COHERENCY_NONE				31
 
 #define MCU_CONTROL					0x700
-- 
2.39.5



