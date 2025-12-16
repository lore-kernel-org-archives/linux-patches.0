Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17C43563C8;
	Tue, 16 Dec 2025 12:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886539; cv=none; b=tnuVNzJae7plnHUPe6KxhOPAH3Q+95PRIQW2dOSHHn0X7QtDN0HdFyJiAu2fve9NimUqLLT4ChnYV4zlzTSPqx1if7IYIcZh7oprpMr0kc+7lmDjJ9n2ZJoed+srvUd4zm3JrrHwqfa7tZJeiwc23LDz5K2HYv63MqMpJ7vuo0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886539; c=relaxed/simple;
	bh=E+kjSwzz5kV/x8nrHXT2Emj+Gk2/wGx7S5klO+V/Yg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UldsZr1tgF5L2Qf9YcmpgVfdG/lR+02DmyyBUAHHnYG3btIaiwFuB6g0iriJY1bMbu0WIyaNxcbtbsXLKHbCzAVPPdNhZBmAa0JKpA5JVX9Qeczd4o+nAsv8kM3lnTdRQ3XTttUtaIhsHkswkFWZLMpuWPe9Afre3xlp0bmTGuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZZ++fXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZZ++fXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B10C4CEF1;
	Tue, 16 Dec 2025 12:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886538;
	bh=E+kjSwzz5kV/x8nrHXT2Emj+Gk2/wGx7S5klO+V/Yg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZZ++fXhrZru1wBawrWuiPMaIVHHEmIrf+wcEjuZHlIXays/GWW7umd9luxLIifmv
	 AqZlPs1eXZcMaYCPiaM6xouzR0oeMsNdvobzoT2HlgLPDqm4mACHPsGrKqhF+xyg/t
	 Ue1TkccoQyOiap75EKCpzMBWgBgqRtkjW+LQCiI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhur Kumar <madhurkumar004@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 467/507] drm/nouveau: refactor deprecated strcpy
Date: Tue, 16 Dec 2025 12:15:08 +0100
Message-ID: <20251216111402.363707205@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Madhur Kumar <madhurkumar004@gmail.com>

[ Upstream commit 2bdc2c0e12fac56e41ec05fb771ead986ea6dac0 ]

strcpy() has been deprecated because it performs no bounds checking on the
destination buffer, which can lead to buffer overflows. Use the safer
strscpy() instead.

Signed-off-by: Madhur Kumar <madhurkumar004@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Fixes: 15a996bbb697 ("drm/nouveau: assign fence_chan->name correctly")
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20251204120822.17502-1-madhurkumar004@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_fence.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.c b/drivers/gpu/drm/nouveau/nouveau_fence.c
index 869d4335c0f45..4a193b7d6d9e4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -183,11 +183,11 @@ nouveau_fence_context_new(struct nouveau_channel *chan, struct nouveau_fence_cha
 	fctx->context = drm->runl[chan->runlist].context_base + chan->chid;
 
 	if (chan == drm->cechan)
-		strcpy(fctx->name, "copy engine channel");
+		strscpy(fctx->name, "copy engine channel");
 	else if (chan == drm->channel)
-		strcpy(fctx->name, "generic kernel channel");
+		strscpy(fctx->name, "generic kernel channel");
 	else
-		strcpy(fctx->name, cli->name);
+		strscpy(fctx->name, cli->name);
 
 	kref_init(&fctx->fence_ref);
 	if (!priv->uevent)
-- 
2.51.0



