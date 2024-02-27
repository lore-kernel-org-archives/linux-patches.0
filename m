Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E63B16423;
	Tue, 27 Feb 2024 14:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043074; cv=none; b=X8mKVlNDUvJoFQmLr0Xyb/gEWwM1Yp3nTPWgyvxzRm3X4OwerHEuzwKAOhCkEL3y29a75cAXW0lPpRVF3sw9NAgmkDE20nzHaYDvUC7+yQtJHWvrIuhEd9rqRQZG5Nrz1c7tV51ByBMtBA7kPKfEEC1THFjwOQft65PDX2OSwMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043074; c=relaxed/simple;
	bh=adOJkY5pC74bvbAPKqgcInHugdmGJEPXXjB5i/5+0/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSBmc2ppBmk9EIA0Vn8Cpqv2tjHK5vnuBkhyZLXrvyNdXKPfCqNQSCtDE5mBReLYJKeyhrS2cOOGZFqHQL6NiyOfAeaF9fpNx8EaCOlRPeghoYuhxrIAJcb0DvR49dnkXUv+9Rj36p306N6I8p3uzpDPtTfV2JmfBCPxEFQK3SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uz1r5cu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uz1r5cu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E927C433F1;
	Tue, 27 Feb 2024 14:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043074;
	bh=adOJkY5pC74bvbAPKqgcInHugdmGJEPXXjB5i/5+0/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uz1r5cu1K4vjEW0Ddtk6Y/5W3zfA1y1/GCPcBec8MNHtVGus+17D/W0Zgv2clffMY
	 pr2W55qcnLN5hHFkPIi4AB+J76F3lru+K6WyPanJQlUXRNu0jTgYtXLe01SJIf0EY7
	 goB0jcoXofmGm8/vvwW0y76/sBFwZ9AVdrCG85qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Zhengkui <guozhengkui@vivo.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 225/245] drm/nouveau/instmem: fix uninitialized_var.cocci warning
Date: Tue, 27 Feb 2024 14:26:53 +0100
Message-ID: <20240227131622.502285448@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guo Zhengkui <guozhengkui@vivo.com>

[ Upstream commit 2046e733e125fa58ed997f3d26d43543faf82c95 ]

Fix following coccicheck warning:
drivers/gpu/drm/nouveau/nvkm/subdev/instmem/nv50.c:316:11-12:
WARNING this kind of initialization is deprecated.

`void *map = map` has the same form of
uninitialized_var() macro. I remove the redundant assignement. It has
been tested with gcc (Debian 8.3.0-6) 8.3.0.

The patch which removed uninitialized_var() is:
https://lore.kernel.org/all/20121028102007.GA7547@gmail.com/
And there is very few "/* GCC */" comments in the Linux kernel code now.

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220228142352.18006-1-guozhengkui@vivo.com
Stable-dep-of: 3b1ae9b71c2a ("octeontx2-af: Consider the action set by PF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/instmem/nv50.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/nv50.c b/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/nv50.c
index 96aca0edfa3c0..c51bac76174c1 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/nv50.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/nv50.c
@@ -313,7 +313,7 @@ nv50_instobj_dtor(struct nvkm_memory *memory)
 	struct nv50_instobj *iobj = nv50_instobj(memory);
 	struct nvkm_instmem *imem = &iobj->imem->base;
 	struct nvkm_vma *bar;
-	void *map = map;
+	void *map;
 
 	mutex_lock(&imem->mutex);
 	if (likely(iobj->lru.next))
-- 
2.43.0



