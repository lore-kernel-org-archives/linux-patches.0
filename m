Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5835351599C;
	Thu, 17 Sep 2026 16:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664166; cv=none; b=P9KDdTaLWMATf2X+XF2qKBoJ+ZKWepSM6Srxt5YRwUzsx2cCdB/igZ5BPK/7kO9hpd/stth8ZxqNuEYMOg/EL+3dCo4cV0IG1GdsoznVez2ksFgbaH1PBtTjZqjaQwDvgMQrrhZ8YjbRMtPhLLR6yB4OJXT90DnMQgpTHEZVHlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664166; c=relaxed/simple;
	bh=lFPEUIUMKFp9Kxu5aGc58cjx6Y0WNyTYn6Ug5XIrdrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOBZGnw+uqZVFzRWMlgH5v+XpDwoqnA5fe3be6E88cZYYFUwyG6mk3BvscuXg3s1WkU4BGn5SD092kcpEQK2vQWzNBe1zlEgpOm0NM4pvhg8s4iwMcGsuIj8dKBoSR5SzwKix6LPHndhOGOlIoFLhHiz1ADkJvKhLGiNwlpmvbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shK/HKul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shK/HKul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8326A1F000FF;
	Thu, 17 Sep 2026 16:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664165;
	bh=5o4AS0Qjd6qZ55rWVJiQy9DRgP0TBJ1pQCXqMOCKzOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=shK/HKulD6/rEynksGQb5TCtb/t6fqabVKgNIZzDAZ6vsUlvwDJrqmM/SLWfr74Nk
	 CV2jif5T+uK+OL3M3iqDVA1VQYA2NysQOezQXVRQehSMth8rSRJyiLmQ7tG90nWQFP
	 wMT8tVqAp3s0ftXrDWVq85KYqxlhj42ZK8m5gS9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0254/1250] drm/nouveau/gsp: add SEC2 to GA100 chip table
Date: Thu, 17 Sep 2026 16:00:49 +0100
Message-ID: <20260917151559.039828211@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Tabi <ttabi@nvidia.com>

[ Upstream commit 604d0efb17cc0dd197e089134736ac2698d5fca7 ]

The booter-load and booter-unload firmware run on the SEC2 falcon.
During tu102_gsp_oneinit(), the booter constructor needs device->sec2
to access the SEC2 falcon.

Without the .sec2 entry, device->sec2 is NULL and this dereference
crashes during GSP-RM boot.

Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Link: https://patch.msgid.link/20260430223838.2530778-3-ttabi@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
index 33db3a010efd4..3738c4664fb6a 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -2529,6 +2529,7 @@ nv170_chipset = {
 	.vfn      = { 0x00000001, ga100_vfn_new },
 	.ce       = { 0x000003ff, ga100_ce_new },
 	.fifo     = { 0x00000001, ga100_fifo_new },
+	.sec2     = { 0x00000001, tu102_sec2_new },
 };
 
 static const struct nvkm_device_chip
-- 
2.53.0



