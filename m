Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063798;
	b=YKT8N8JJSAMVvdUoZD580ycFDeSN3DJYdaB918U2Kr84iWzx+IDrkpTksyt2SI1EWw24
	 EAb9a2KhDSWS1KLPuWWo/E8+Tr3nmgounLZRAaRSij0Rs/fl/qUlkekgnFExxXc0RVuj4
	 Td7NCHVivpqIqbl6sO5QjzMSnvsq8B5ZCC02WAZsNdOS4COrXjkONS+VugE3YrV9btu9n
	 G2qc2sldF/V+WUSJCnn+vzk24XJyqTBM7Eqy3sJfc9AdYPb68JBIxv6jlQU7d5bThpaWL
	 m9hANalQ3m5ITbSk7G9VO8AGm+yVq+Cqiks6znVUd+DUAAqsyQ6PlQ+gE7uV8zv2BHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vg5ycn0gl62T+kEHIkgUO/xn0fOhQ5U+Qb1pfUOSYFk=;
	b=gLSWrYYDmd+/kuPr2HOQ71hKlbAa7qzYwZ7Ig5W9kPQSzm6lglviqaX3Lp0uvDFZy0Dn
	 A4Ndz1HatjWiLbvEmk8SRzVzMYTCdMxPOAtUn0yUPHbvXcOHsndkGVFpWRzx/kGK3CWi8
	 kTBsNSgM6/gfbz1brqecRyae2pbSFcFbyDdxWLxoLlZ1Gp0TUZ5iLaaIwfJEtFsa33EhU
	 piS52y1ArG/9zKBe9daWlKZen+lsY0fy9vRSYzSm9upauonjMf/nEf8B2I8SOSsxS/iSD
	 fc4Pgk9Uiu3poUtS7EovuWO7SIXtx9QPhZG7GESdpU/1SEhPWask3ZOVre1Ka67PCmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g8yhvyD+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63821606EE81;
	Sat,  7 Nov 2026 15:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g8yhvyD+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115381F0089F;
	Sat,  7 Nov 2026 15:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063798;
	bh=vg5ycn0gl62T+kEHIkgUO/xn0fOhQ5U+Qb1pfUOSYFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8yhvyD+LnnctPee9wiQRPc/pt3SX+X9zRpA8uyyhh720UQjvfLY6IDnB4cTSXTmp
	 qR4UZ2ouX9xAWyMf+BxnE2r8QSpZfKK2ruPXnV8kbjBiK+isVYDTRsvNY4T44yTR1p
	 RqkrELrpivCwwFcjr5sg17Qq0td+h6swsqnnCtDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Czernohous <marek@czernohous.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0019/1257] drm/nouveau: dont dereference outp before checking it in nouveau_dp_irq
Date: Sat,  7 Nov 2026 08:38:35 -0500
Message-ID: <20261107134939.949592763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



