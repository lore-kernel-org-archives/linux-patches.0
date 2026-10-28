Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209105;
	b=3CjCntCgumNT8hHfP/C9SMrI8sgNbowi5/Cy9gBunAf5QtnXT19uFrx96AMSLTKmFxy2
	 iX0/z3nUU04B045VJC2gNvrw+gEwIFPKSSeEa3oT4mGZRbQ6RciCA5+RiX19Buc9SkfAU
	 OK9eSQHghMV6EabttdupH34VPae5Epg31Pde7XhTNLIfqFvyM8lNKWFylJe/lctIZiOQu
	 DaLBdg17QH7zNE0AKs6N7QKB6+OMZ7Ui5vkvI1obgk4sFDPfY3oZH365FzahUoMVEEU1G
	 6qMq1dk/Aq/aQNK1rdxktZgMW6znQd2fRvt2tMSkMcT/D2utSe5G5/j6dbifs7Wb/1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TzRVvekFMcPnzLO3ttqGDmAtaYd/9rotZms5Bsk7868=;
	b=yLGk4j68CSfrgxAvDR1Vvkj/hj0kJ9tLW7wtnaW/RETZxo78UI3Tqhh/HX8qDfBUfUHe
	 jGqgA1nnxZVSpsNA3tqO/zhN4tjcDyV68pppE091j2N1Lw4IodIJT07+GI+TaXw8yaqp9
	 QEkQpU5Zq/5tx3thmQkCuC5iGvVzHQfRzW3YZA366ZHEdkJNUREc1rcGHtmK7gGsJhZH8
	 edsqG9FFIPBNJenebfbnTmGDpc4zZEr7l7Kw+4hGQXlKsl66ZI2ozMoxTcy3NDrZ9z8z0
	 p52jeUTm7LFoakatShgYuVWINpHR+UFjIk/0HNpH+SholiRaR63QRyCZbjlB2AUKEZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nB/ebnm8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9DF606A325;
	Wed, 28 Oct 2026 17:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nB/ebnm8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866F21F01825;
	Wed, 28 Oct 2026 17:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209105;
	bh=TzRVvekFMcPnzLO3ttqGDmAtaYd/9rotZms5Bsk7868=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nB/ebnm8xQVR6O2bYby7xBX3AN0EnhRmzOVrPm2/AmuNDMnWZzVeng7kMHA44K5D9
	 KS0aMCeB6P00CYY6SYjxkcVTst/3Kw86su2bQZxK3bdSAcV5cbHDqbNfcy0yiBNg+b
	 rBApW4Ou1BdoExI9cBy+QBtohLgL8Vql2k7gyv1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 354/516] drm/vc4: Free the BO cache size list on teardown
Date: Wed, 28 Oct 2026 17:58:26 +0100
Message-ID: <20261028170011.875296512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit b41ff8b529278216cba22a5dcdc93fea2a3a9619 ]

vc4_bo_cache_destroy() purges the cached BOs but never frees the size
list, leaking it on every unbind.

Fixes: c826a6e10644 ("drm/vc4: Add a BO cache.")
Assisted-by: LLM
Reviewed-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://patch.msgid.link/20260930190721.1897264-1-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index 437084f7973c6..2ad422345f5bd 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -1049,6 +1049,7 @@ static void vc4_bo_cache_destroy(struct drm_device *dev, void *unused)
 	cancel_work_sync(&vc4->bo_cache.time_work);
 
 	vc4_bo_cache_purge(dev);
+	kfree(vc4->bo_cache.size_list);
 
 	for (i = 0; i < vc4->num_labels; i++) {
 		if (vc4->bo_labels[i].num_allocated) {
-- 
2.53.0



