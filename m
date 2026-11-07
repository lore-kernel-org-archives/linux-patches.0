Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062702;
	b=inWR6BThGsPCxlSz8KbjBrNaUnqCSUVGp9IbOM65GKqDHL/aWuXjZ+yuJwBqoqr6q/01
	 w5OZsKxF5PWnAv/fmfofGD7/llj/aLhsuPiuLi6B6fcG1uGIYNzDAnAFxc1BIYWHjMtKC
	 JnT+FHUdFoWN/eqa7tjdThgM7NEByZps/CSdPgwAB4avtukso+X2J1QIYI4bjv3rC37gw
	 t7OPmVDn62XGiBiyBI6Om3bm45A3VWVOlO+kgeDFCDW3vDHBZVoe9ZNDx/jZbAqv8f5Df
	 4u+dKoF8nb3l+P45/cnuHTPuwsOhLVHYzgs73xgd1UC+4FaSjuzXTjliqaKRC3TFL1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=whjyFgzrIXVJq1O3bS4wCfahhtSgKku1hg1UDQhWBrM=;
	b=BuW5qvJPgPnpSiJbumKnshDyAt/AedOM9LFnyuNp6Ik4ZSSAfmJ41Dn5s/CcmQ9kMbfw
	 wg8DpTivynv65EV/0iylaMfSWjJ+pnJfUuG22wZfUWD/9EEUOcmbfKr063mBw/F7BEYpo
	 zAkxlwxLc9jWBgAkbboPCr41SQj/IYj+FqXsqbAjHVNBdMJA7ui//TA9xad+ejDiZYUja
	 v0oGivViaWScLRmL8LnN8Uoy1RcFFkUfDojTRV7x5d3jSuQ/KHBA72OR6v4p0twNBtTwP
	 E9HJ9pPBVjdmH0JXOaT1ohFz8iMCBVZ6/dzrZczK2MGLNw3D8kan9o3fQUAmCrHaUVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hh6Mpv/Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C89606A337;
	Sat,  7 Nov 2026 14:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hh6Mpv/Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8621F008A1;
	Sat,  7 Nov 2026 14:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062702;
	bh=whjyFgzrIXVJq1O3bS4wCfahhtSgKku1hg1UDQhWBrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hh6Mpv/Y4/CEShejsXx6PSC7C94jZshc19GX/iFYMV7bL59oPPW/tzvRdY7RwHhWR
	 IOjpJcFFGW1U1ZfR54CaGDAR5ICh/Ql5CJXoVGfSOqD9+vQVu5P+YURfj3And7GBBZ
	 SFhhss8/IAozr3IyRaxu9QBCeikW77lDVEwteR+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Czernohous <marek@czernohous.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 026/869] drm/nouveau: dont dereference outp before checking it in nouveau_dp_irq
Date: Sat,  7 Nov 2026 08:45:08 -0500
Message-ID: <20261107134852.982656396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Czernohous <marek@czernohous.de>

[ Upstream commit 843bc34db94bff0612c8294861b156489958897b ]

nouveau_dp_irq() looks the encoder up and dereferences it in the same
breath, five lines before testing it:

	struct nouveau_encoder *outp = find_encoder(connector, DCB_OUTPUT_DP);
	struct nouveau_drm *drm = nouveau_drm(outp->base.base.dev);
	...
	if (!outp)
		return;

find_encoder() walks the connector's possible encoders and returns NULL
when none of them matches the requested type, so the NULL test is not
decoration: it is the author saying this can happen. The initialiser
above it dereferences the same pointer regardless.

The NULL test predates the dereference. commit 773eb04d14a1
("drm/nouveau/disp: expose conn event class") turned nouveau_dp_irq()
into a work callback, and since the drm pointer was no longer passed in
as an argument it was recovered from the encoder in the declaration
block, which put the dereference above the existing test.

Move the drm lookup below the test. No functional change when outp is
non-NULL.

Fixes: 773eb04d14a1 ("drm/nouveau/disp: expose conn event class")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Marek Czernohous <marek@czernohous.de>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/178682366004.3748010.14933649768375463967@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_dp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_dp.c b/drivers/gpu/drm/nouveau/nouveau_dp.c
index 55691ec44abaa..738802358d85c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -486,7 +486,7 @@ nouveau_dp_irq(struct work_struct *work)
 		container_of(work, typeof(*nv_connector), irq_work);
 	struct drm_connector *connector = &nv_connector->base;
 	struct nouveau_encoder *outp = find_encoder(connector, DCB_OUTPUT_DP);
-	struct nouveau_drm *drm = nouveau_drm(outp->base.base.dev);
+	struct nouveau_drm *drm;
 	struct nv50_mstm *mstm;
 	u64 hpd = 0;
 	int ret;
@@ -494,6 +494,8 @@ nouveau_dp_irq(struct work_struct *work)
 	if (!outp)
 		return;
 
+	drm = nouveau_drm(outp->base.base.dev);
+
 	mstm = outp->dp.mstm;
 	NV_DEBUG(drm, "service %s\n", connector->name);
 
-- 
2.53.0



