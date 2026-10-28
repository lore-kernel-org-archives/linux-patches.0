Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212073;
	b=hb/z4t1oVS3fhAMedh5KUCyobgpsId46nln6dNrSUoQ4xnrTOu5I7APN3mkLlZIxVuT5
	 tnXa3Ep22Yv+3sLNoljJZlveXMm3VaEU9L4fyaInRMcOBmI8++14hDbEXLaI0h9vmU+9S
	 8U/1oU30QX90H8gSnlUDlVnTJ/vNB8U2zJjZ6WqdpbCdr4Wu6eAjv7iIPPS3Mvec1p+hU
	 47PZurdEiZDyIP3hTgDdqYo68pTrpAJUCudt2dpUtkrfOksvbdXIyiFUT1bHr+m5vTuFj
	 n8e1GcMIa5O89MEukjqqXeHrr2kgWKJb2V/3AejOTu5X2vEtW8+Va33XapYl0RRiGUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9srR1PIz4PacsBYDXyND8hkerHtTNkzE5uPuzpgZiHk=;
	b=m+5oXhCNwBqFijhGgghfwQnbmb0CQ9LMpQT7VW49wJBkQqpLhYn+W1DRCBco4Hyn7odf
	 OAYweYURZyMVBffwDKWQjyCPbX/Y9LKcsywDuOMkqpJqTuoIMPlnT0wEKFAYD10mzTprv
	 lb3OJGYO9v0rM7TFUJk3jannSohtKkff4XQQMHNJj/vrI4jY/sfhcAfm3qfqzcAvrI9DH
	 Lg7jwKt0u4wa4ffDPM/L7iIqrSO/uiz6rB8DObRKfAjFSqpJnW4sg3MnpAo7uXFNC3krd
	 i9UJfwhvEh7Hdle77/LA4R48RJLiTwSQVzfxc87A9a1aKBQov1kDFQVSvJikTFxdHYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9Y7lxgq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB11606A31A;
	Wed, 28 Oct 2026 18:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9Y7lxgq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF231F01825;
	Wed, 28 Oct 2026 18:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212073;
	bh=9srR1PIz4PacsBYDXyND8hkerHtTNkzE5uPuzpgZiHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9Y7lxgqAs+r9cSf0sB0OPRuCFqalP13IuZBU+I9pTVLpwtzvdb9J4AYo0CGww+TL
	 lg9D9CeFK37CEtZGpUe15OI51Ln2vMtwSBUnmFM2ZnsAVCDewdpgkxoPUZuovs9WmH
	 4vRaU3pz7Ox1iSlr2MmnzrE49NpcwhGNgCELfRBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0029/1887] nouveau/gem: reserve the bo in the info ioctl around the vma lookup
Date: Wed, 28 Oct 2026 17:35:25 +0100
Message-ID: <20261028170459.890294119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit 5e17160d41d92823f3379c1982e1369680c5ce4d ]

In the non-uvmm path, there could be a race between the info lookup
finding the vma, and the gem close path closing the vma leading
to a use-after-free.

Spotted with the help of Opus 4.6.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Fixes: e758a3111914 ("drm/nouveau: fixup gem_info ioctl to return client-specific bo virtual")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260612020658.3176270-1-airlied@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
[ adapted VMM and UVMM handling to the legacy direct VMM selection and condition. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_gem.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index cde21cc0083b1..4c9942f651b6f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -277,11 +277,20 @@ nouveau_gem_info(struct drm_file *file_priv, struct drm_gem_object *gem,
 		rep->domain = NOUVEAU_GEM_DOMAIN_VRAM;
 	rep->offset = nvbo->offset;
 	if (vmm->vmm.object.oclass >= NVIF_CLASS_VMM_NV50) {
+		int ret;
+
+		ret = ttm_bo_reserve(&nvbo->bo, false, false, NULL);
+		if (ret)
+			return ret;
+
 		vma = nouveau_vma_find(nvbo, vmm);
-		if (!vma)
+		if (!vma) {
+			ttm_bo_unreserve(&nvbo->bo);
 			return -EINVAL;
+		}
 
 		rep->offset = vma->addr;
+		ttm_bo_unreserve(&nvbo->bo);
 	}
 
 	rep->size = nvbo->bo.base.size;
-- 
2.53.0



