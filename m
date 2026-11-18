Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035815;
	b=PH+a9S7Sj9RgUsQ7eAjX0j2RznHRPVdFw4FuyGPfj1ydE8kemEcJLGJxAWIDetZvzfOr
	 mTc3dXJ/LxeWjhRX42mACFUsZgT9twQAbmObt3LBowbkR4WX6vpDX8GPX+Gt85bFPRSYz
	 1mbnYGdSNOmH66yaExsg8QdyOiiqgAA1t6l7PGhj6RK/rbikbBl5Wb9N0T9xTa9YoZwNj
	 2ai2cuSkh08p1xAezVJTViTkRNqbDDkD2epfvp+FyvtdKPGeM+dGuw/gKVY5TF9yPuXVT
	 tY32YAV9LXe4xNJe4Uq2HUWB1UsNVlT7liLKFnFzXr8RGXUO/9ga+B/TXsc2XVeBjGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FO1YIxJf0XCMsbv9Xa4+sHqWivpZk5B8LymMUotrrjI=;
	b=hBhue/StA7+gOnXbndni5O4Wn1Lhda3ZZFv7yxq4sgLNWztDIaYQf/3pElmUl6RJGzFo
	 frD7GwoglbrLYNZx0dTlE+TYdGS3ZN+0JhajMsSRRjdUov7wNuLWtBX9iN1dEtGQwbxkM
	 nirkXdW1jF6OrZXz8KLq9qyZHOqEoUDTf7U/wH5+pcUSkQU+FhiShmAiI8cfW8gjjlbI4
	 xZmwWx3aARDI91XxNN/fCUWkQ793heZAZvwpHxkLip18T8X8HVrKwDmVu2xjKI1tPwTVH
	 1fV9z3MnxhKjWGVt/MMKUWVKl6tf9oww9fEmQlsMFyqqKBWlNXfB4GNHf5GZ/PyNHyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K/SNPjgN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07AF606A325;
	Wed, 18 Nov 2026 21:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K/SNPjgN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4D11F000C4;
	Wed, 18 Nov 2026 21:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035815;
	bh=FO1YIxJf0XCMsbv9Xa4+sHqWivpZk5B8LymMUotrrjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/SNPjgN92Urv5GLCXOpOPJV+QTl8SWVYtzmRCVNgk4WFBkZhvmSU9pqv3Ui+yaVB
	 hHXyk3MtZ3lKxYYbUMsJFm6AS9kKC1W376WB1ZPdKGSd0+A0Q9mVBaH/N08kvPhy/v
	 R6Ebl8lhJWOlZ3GZyQj8vDOkg8HreDCnbmHGbCz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Czernohous <marek@czernohous.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0795/3318] drm/nouveau: dont dereference outp before checking it in nouveau_dp_irq
Date: Wed, 18 Nov 2026 15:23:37 +0100
Message-ID: <20261118150342.747875208@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bf2ae67b03d94..f48fbd7dfa1ef 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -232,7 +232,7 @@ nouveau_dp_irq(struct work_struct *work)
 		container_of(work, typeof(*nv_connector), irq_work);
 	struct drm_connector *connector = &nv_connector->base;
 	struct nouveau_encoder *outp = find_encoder(connector, DCB_OUTPUT_DP);
-	struct nouveau_drm *drm = nouveau_drm(outp->base.base.dev);
+	struct nouveau_drm *drm;
 	struct nv50_mstm *mstm;
 	u64 hpd = 0;
 	int ret;
@@ -240,6 +240,8 @@ nouveau_dp_irq(struct work_struct *work)
 	if (!outp)
 		return;
 
+	drm = nouveau_drm(outp->base.base.dev);
+
 	mstm = outp->dp.mstm;
 	NV_DEBUG(drm, "service %s\n", connector->name);
 
-- 
2.53.0



