Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2813739B6AA;
	Tue, 16 Dec 2025 12:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888665; cv=none; b=bs6zP379jzk8uSRvw+vmDzI+9OjzwjHrSG7LMBYGE8WMAB3KGEb+7jYNW6H+xstJNVxV64Xz+o3pQ4zNAz2wpUw88wbsmqOYv/jqgM/19+Zjowcq0s9ZtH0qnLJOh73HeAXxP3eevgnuwbJrdHsi6LXPGVqekh7UNRCLylED5V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888665; c=relaxed/simple;
	bh=XAqe8G9i0i+c5fpAhZDe7ITHHLF+4zez6Lx3h6wQj4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxoI/ovjvCBwhdd/BVT2kKGaSD3rSfKFF08b1aIVh5it7Nv0mFr0AA3FeTBHMrtpPXX70YLxKOcr/y9MrOOyp9PKDqhDNEfXg3upVw18KlY/XQhrBt3D9MkXA5HUxBMDx4s1DkzgbNyjiLggmFCnree0sa7CL1CqTas454Iwbq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTjn94Ai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTjn94Ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84E9C4CEF1;
	Tue, 16 Dec 2025 12:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888665;
	bh=XAqe8G9i0i+c5fpAhZDe7ITHHLF+4zez6Lx3h6wQj4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eTjn94AiuteJdJcXG8+X/duqy6oRsYqfm2X1fc7gz5PYefyomfrGbBKXav/vN9mnW
	 Ul5x4h8NIZpAILg47WU+gDP0eoXCFQJ3c0Fe0EhSfMPkwN/J2nH8RXx/O+rNDRluux
	 RIjRP2JJ1n+VOfDIOZXNTzDA/HtNKwNlLS8wYYaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhur Kumar <madhurkumar004@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 568/614] drm/nouveau: refactor deprecated strcpy
Date: Tue, 16 Dec 2025 12:15:35 +0100
Message-ID: <20251216111421.964352544@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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



