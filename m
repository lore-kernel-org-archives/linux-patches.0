Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028855;
	b=2kuD9tiRn9TFaKdpnOr82f5CgexAE4ehrOFK+DI772K2pnhUOT7FilaG5P/sZLv9mFmC
	 meaHKTnCH3w0U3emhapn4/klez8FNpVq10RCXnymqjfY35nNgvPv0R1pM2bSLGFY9ea84
	 mcydkRSze8oynAH9M4JzDimU/gSRbwoQZ+fA5/5akv7vGHCI24h1nJsK+7lZMQdp8v2Fk
	 mvXvqr+7s7Eic4wPhrr2O0P4nTw4qj/X/9wYxeyZUReYl54PfdqBCqikZYMqUYWYe09Ad
	 dQW3hkSZmVg2PGs5O/vS9ZzfmAwvmlPDk4eJeiS9sF1qVnp56pnbe04zrtI/n8fZmpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+XrDL8ZMtrN6oZ/mtDfZ3SyjtZOobrS7RviPuwfuonM=;
	b=jWBmtk+LfmmXYkpMU+Ex35XLAiGX494bzOkB167pUqDtO7oW/4bcSYSxZGM5L4K9A+ra
	 zR4i5p2XZ+tKP8nzk/zcqknM775WikbmwnzltfQiidtxWpekd7U48LTuppwJS6cfVACY4
	 iac/FIkeUJeiCjOzKXR20DcUE60yj86aZvyZ5ihdJaK3LYKtU5L4o2J95Dk034361L6xr
	 3aZbtAPF52voynrGKNsy3B1SQ69w2LB/1+tGANPF7UgPN2C3XuSg0+6vUFCxNJjk4HU6k
	 DIK2oq0BofEvxj3WALOH+fCmRLd8ecSVicHo9hdurkKRTnqJ3b3A5jtYjMioVRgtCFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKekQxpw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514BE606A32F;
	Wed, 18 Nov 2026 19:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKekQxpw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB411F000C4;
	Wed, 18 Nov 2026 19:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028855;
	bh=+XrDL8ZMtrN6oZ/mtDfZ3SyjtZOobrS7RviPuwfuonM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKekQxpwowj5aCmrvq+dsUsgKNQcg7owIpzWoe4Q6GtjNw4AY3zk+v0fpJcQ1VpZ3
	 PdaX/K41nAcl2SOvLxARTX1yLG39LFKFYGWB6+ODT7mCok+iWqbEV5q3/IArSLKWQH
	 wk7p3txK2ziU4O85YBQqBQMd0NB+pl9/Zi0q3YrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0142/1756] drm/panthor: Take reqs_lock in soft_reset for clearing pending_reqs
Date: Wed, 18 Nov 2026 15:37:49 +0100
Message-ID: <20261118150013.807931357@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit 2d354adc5bbabe2e818be09bbe13f6bfde4a30c7 ]

panthor_gpu_soft_reset() sets pending_reqs to 0 without taking the
requisite reqs_lock.

Fix this by taking the lock for the duration of the modification.

Fixes: 5cd894e258c4 ("drm/panthor: Add the GPU logical block")
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260812-panthor-cache-flush-fix-v4-3-751e32901898@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_gpu.c b/drivers/gpu/drm/panthor/panthor_gpu.c
index 15e4371d98945..038f59df38d95 100644
--- a/drivers/gpu/drm/panthor/panthor_gpu.c
+++ b/drivers/gpu/drm/panthor/panthor_gpu.c
@@ -459,7 +459,10 @@ int panthor_gpu_soft_reset(struct panthor_device *ptdev)
 		return -ETIMEDOUT;
 	}
 
-	ptdev->gpu->pending_reqs = 0;
+	scoped_guard(spinlock, &ptdev->gpu->reqs_lock) {
+		ptdev->gpu->pending_reqs = 0;
+	}
+
 	return 0;
 }
 
-- 
2.53.0



