Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213487;
	b=pBWFTcVaEjzamopuGVwzK28AKchDT3wOiOpy089OuINBFtQYo7EScKkG33haED43MrJT
	 SPAytg1cZedXQXeIGIb3SbjFI+h7+JTNW0eL1hUoTupWt3btYXmTY+VQn3pTKiMTqvOsG
	 1TIE/LBA58Tktg15FsO4kxls14jyN1jrLX4gz8jzOeE5u90eULBnljZ1cL+se0ghCDFn/
	 p5SqY5qzoFYmnQp4IiJUxPEuc0VUXh0PPGVK6wIrxhBBllwPvJIHV79KV3S/Any+Saa8x
	 eqpPRZk//85BZ6QoVAlUUtva6HTEIHfN17bEaotgcIZtMBmyk24QOE86/SoeatIKObQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xgj0wwxF+V3fedikhz8CGnsVTBjcA6XV4z8FY6NteUM=;
	b=RnpW2v2Tft1OC4A3y7JmovcOzKIxEInbGaM/lhqJqqS5JOprMOlKbHsixaL8ggYydIc8
	 Qed0ghWbaewscd0GNft6pRpusxztz7ECejzyBt8NDcQm1nvuIbD58hZtcHbrzD3GGa85p
	 HfxRtRT/gulN+Y3djs/sTi12qDf1yMr8FeuTIQcvaGcHwwBhShM+bdcEdh1swBtdEuSRd
	 mAuNg5KwuLI33RWlfMxIF3DtAU2mdKu0q2TAhv2j4oufyR1e9XuiBd3Cm3IMaWWiBqcwR
	 xARyxKB8HJG/kBJB0yNzj/ZRRx431EE61don3xGIm+TgBs+NnkiJDtH5Antj3E/UPEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGuSJveB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C7E606A31D;
	Wed, 28 Oct 2026 18:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGuSJveB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583AD1F01825;
	Wed, 28 Oct 2026 18:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213486;
	bh=xgj0wwxF+V3fedikhz8CGnsVTBjcA6XV4z8FY6NteUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGuSJveBRccYSAUg+XW6smPX0LTik8LcxVwtSjlVEhEcxUQtvlePHusRs+9cc1Ivr
	 npyLzGmMTvQaHgf1Q/Unr50NsYVtnBJvEnLd/PdSXqYfWJ5BXKPHhdPn+JTto9EkTr
	 sM8URnA40MLzHsStO0y+CBcRBi3DgLzytwHGoGGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0486/1887] drm/vc4: Free the BO cache size list on teardown
Date: Wed, 28 Oct 2026 17:43:02 +0100
Message-ID: <20261028170510.324785501@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9028a56dd12b8..d687afb3c4426 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -1054,6 +1054,7 @@ static void vc4_bo_cache_destroy(struct drm_device *dev, void *unused)
 	cancel_work_sync(&vc4->bo_cache.time_work);
 
 	vc4_bo_cache_purge(dev);
+	kfree(vc4->bo_cache.size_list);
 
 	for (i = 0; i < vc4->num_labels; i++) {
 		if (vc4->bo_labels[i].num_allocated) {
-- 
2.53.0



