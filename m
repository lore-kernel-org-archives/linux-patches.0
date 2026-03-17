Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E673BFE59;
	Tue, 17 Mar 2026 16:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766598; cv=none; b=nTcEBPednqx042ysSLXWIeD9kI4nlstZACSoLJJN4wVOj2thb9HZOgbTA2AR7DWfHUfkid9iWwlMVaL6F+J3v86ptQ+wFCVatiEMvhs8Lo4jMCubTsAmRdkWwUvXEO+/SbHWtRjDcYldTZ1XxF0betzN+AWyhyaB09qNI01/BJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766598; c=relaxed/simple;
	bh=MDUbQW9ejEv9xsA/W6qj/mSPjWub6qFlZbZxHay44fY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uA6bN+C+FbxR+vrB3Qr2QsKypagxbsoLsJtvaCUBa/tKROuX3aYNOOKvkJCdPR5uEU9CaZWGjJTPD14Vjna18jPAfBAE4Ck60fJNS9hxV6amhI33I6Sm8mVo6rGBEBh75E+4afzo3QKT0RzX3IoUzg+5Zy5rsahwwPOWAELzUAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqAfsSjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqAfsSjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57DBC4CEF7;
	Tue, 17 Mar 2026 16:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766598;
	bh=MDUbQW9ejEv9xsA/W6qj/mSPjWub6qFlZbZxHay44fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqAfsSjWWXlL/M6qHR3m3AdjhO51aIC60RVHuUhunByflTAz33JjVrMRmU+5HwZ6+
	 Gg7rEQcDS8cFOTedm/ciiP+AAqr4hhDA4R8DfKi42cRs0xNXQyJ/agcorJouHh8aC3
	 HawjeP7ysgxTMkr3osmHgjG3QfxA0DkqnWwTEZmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	dri-devel@lists.freedesktop.org,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.19 281/378] drm/ttm: Fix ttm_pool_beneficial_order() return type
Date: Tue, 17 Mar 2026 17:33:58 +0100
Message-ID: <20260317163017.342447546@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit 6e3f4514e3b432871ac81717d24f56b441857f77 upstream.

Fix a nasty copy and paste bug, where the incorrect boolean return type of
the ttm_pool_beneficial_order() helper had a consequence of avoiding
direct reclaim too eagerly for drivers which use this feature (currently
amdgpu).

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: 7e9c548d3709 ("drm/ttm: Allow drivers to specify maximum beneficial TTM pool size")
Cc: Christian König <christian.koenig@amd.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.19+
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Link: https://lore.kernel.org/r/20260227124901.3177-1-tvrtko.ursulin@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_pool_internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_pool_internal.h b/drivers/gpu/drm/ttm/ttm_pool_internal.h
index 82c4b7e56a99..24c179fd69d1 100644
--- a/drivers/gpu/drm/ttm/ttm_pool_internal.h
+++ b/drivers/gpu/drm/ttm/ttm_pool_internal.h
@@ -17,7 +17,7 @@ static inline bool ttm_pool_uses_dma32(struct ttm_pool *pool)
 	return pool->alloc_flags & TTM_ALLOCATION_POOL_USE_DMA32;
 }
 
-static inline bool ttm_pool_beneficial_order(struct ttm_pool *pool)
+static inline unsigned int ttm_pool_beneficial_order(struct ttm_pool *pool)
 {
 	return pool->alloc_flags & 0xff;
 }
-- 
2.53.0



