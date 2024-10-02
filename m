Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E5E29CE7;
	Wed,  2 Oct 2024 13:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875845; cv=none; b=kZNytk4MUVB/GCefap0MdSXAbPxi8EaMKn4SKH3VjmAK2+o+m7Z1MZVsRnKX/U7s6ZUnmqEe7UitPNqMTsInqWe/82qQtwTFGVvBAsrXj0ohkzQWI7GDfwVe/vt+Mc5hJ5jxwlUHarZ9TRZGMZV/ZOa1Ilobdha/rP6NYg0pihs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875845; c=relaxed/simple;
	bh=FqNZdTU7c49hLzrYg6vKsQIWNN+kDBhOJZsCr1zpVhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwChouz8TGJL5Pah6ljklv4eYiwSWUFwG6WTuXCBiCg6+mzHkjqP7Jyfidx2qxVXMZx7zhHDKCSQqGsHv7YBUX61q+jD3x67rC97AxLD+7+7AD+BsMr//BeqX43H5Qy/O5H9dJiRHhkMRCaRGuV5QjSgCdxaooQvxdMpqKI1giE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoKA28nw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoKA28nw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D38C4CEC5;
	Wed,  2 Oct 2024 13:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875844;
	bh=FqNZdTU7c49hLzrYg6vKsQIWNN+kDBhOJZsCr1zpVhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoKA28nw8joHcavLsqVk2nqvEM0pjnolWTwt3XRS1Vu3mp9dISF+z1AMsfFjIyav0
	 3c0eo8kLcg6uoBc+IghAnvr4VRSDyFkjEEtp6zPmSia8vtyqx+0tKKOshRQ4T3kxxR
	 5oprihUDYctzhhYx9fEp3WcWMmA+Lmwa+4qCsd48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuesong Li <liyuesong@vivo.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 240/695] drivers:drm:exynos_drm_gsc:Fix wrong assignment in gsc_bind()
Date: Wed,  2 Oct 2024 14:53:58 +0200
Message-ID: <20241002125832.031515042@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuesong Li <liyuesong@vivo.com>

[ Upstream commit 94ebc3d3235c5c516f67315059ce657e5090e94b ]

cocci reported a double assignment problem. Upon reviewing previous
commits, it appears this may actually be an incorrect assignment.

Fixes: 8b9550344d39 ("drm/ipp: clean up debug messages")
Signed-off-by: Yuesong Li <liyuesong@vivo.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_gsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
index 1b111e2c33472..752339d33f39a 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1174,7 +1174,7 @@ static int gsc_bind(struct device *dev, struct device *master, void *data)
 	struct exynos_drm_ipp *ipp = &ctx->ipp;
 
 	ctx->drm_dev = drm_dev;
-	ctx->drm_dev = drm_dev;
+	ipp->drm_dev = drm_dev;
 	exynos_drm_register_dma(drm_dev, dev, &ctx->dma_priv);
 
 	exynos_drm_ipp_register(dev, ipp, &ipp_funcs,
-- 
2.43.0



