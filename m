Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061876;
	b=pSzkpai0R11gSaDTud5AV2hjkQJvEDlvClyAzaFkJcTNlJjCiDcUNQZDypz4HdlD3OG6
	 Y30QlYniBWrlnBpTy64381E723I2sWt/a+8eN/0qOv5cjytOXTIg3L7BSlGikTrcZrQqf
	 2WGmfdFKsFjGTCYzfLIM8JnwHRaKr2HoWYXg+5LDWRv5uTAKnpa2HNvZ6Dv/zyWShTmgq
	 FPlIOhGqZCT/hq3e7kVBQptFDz0YMhpd4aHH9EC5rTykWFl529WMI8s/b3SInw4pX4J8O
	 FXaA704sNDQq74ooBYlbglLvIfDDDL3zzVkx9h8sC6ULecdYB8QThrLoMYxAGcZ4Imw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TsReOO5c389YUyNIdUqss2OG8Xie3jFhq0efJ6nSx8o=;
	b=0ebWZ4GF2VqhIUndrhOjhESlUYKZsy2MMGk1XlGmiCE/3uZK8vf3vcrIFFJo1gJ/zCeA
	 uaw2rb0kwsmMgPcmKH2Z6MQrNIdcd8xR1unic1jI9D0VXKBbrzl99GnUP6nXNJ3ZQOzwv
	 uVULYW76Yp/oPZRgiTm1Myanh80sy0Ya9T38f27zdNBpwMZ92sT4CgJGolTm5eC0ZqGRf
	 Y2YBaPaM360OmF86rqnlPE8qnIJTN7vp3a+cyJLpua8TCiYTncmaVrx/ddPC0W9XCDHhm
	 XwlkvVGXoInrwNXvNlHyOUGAlZtyROnmsIBI861lo4jiXTIk1Mp/dP8PX8z+hgTDqcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYo7XFPA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B49606A32C;
	Sat,  7 Nov 2026 14:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYo7XFPA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D851F008A1;
	Sat,  7 Nov 2026 14:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061876;
	bh=TsReOO5c389YUyNIdUqss2OG8Xie3jFhq0efJ6nSx8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYo7XFPArpH+dl1/p+LFCdZas8vfbGIczVRH3kpsNDsajhg/7yH0aSTLAp07GmHNy
	 DCVK/kKEBssR9n/v/hPY8XiH+Y2mmC08JTn3KNK7dps2FPpfQf6wN1Er05OKEbQKdx
	 I44RsQvt/MQovcUNobXgqgnWJUR2QRmQzmQ88t6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Czernohous <marek@czernohous.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0890/1536] drm/nouveau: dont dereference outp before checking it in nouveau_dp_irq
Date: Sat,  7 Nov 2026 08:48:26 -0500
Message-ID: <20261107135022.622692847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bcda0105160f1..213f5e005e1a7 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -499,7 +499,7 @@ nouveau_dp_irq(struct work_struct *work)
 		container_of(work, typeof(*nv_connector), irq_work);
 	struct drm_connector *connector = &nv_connector->base;
 	struct nouveau_encoder *outp = find_encoder(connector, DCB_OUTPUT_DP);
-	struct nouveau_drm *drm = nouveau_drm(outp->base.base.dev);
+	struct nouveau_drm *drm;
 	struct nv50_mstm *mstm;
 	u64 hpd = 0;
 	int ret;
@@ -507,6 +507,8 @@ nouveau_dp_irq(struct work_struct *work)
 	if (!outp)
 		return;
 
+	drm = nouveau_drm(outp->base.base.dev);
+
 	mstm = outp->dp.mstm;
 	NV_DEBUG(drm, "service %s\n", connector->name);
 
-- 
2.53.0



