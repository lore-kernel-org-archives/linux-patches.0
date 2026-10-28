Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214318;
	b=xArneaOvoscdPFPtT6wrZ1MSROc90VKGllLsxl3h2bUye+caBxjCpKIEWHuMRYf3T2fc
	 rmKdr/Md20Pucfl0yfhYpBLX+Gt45bAvE5VCKEuGs26m5+YCybuXQnLSq/R/nJjXY0GdU
	 ZjrEytPoTYQ+KoeowqKdx8QK/lpd1kn+oglS/g6/air4UbJIi7+7DTFGXJyKJNu4VJw8j
	 RF+v2Eyj3el1MwQb5cwfdYiJaKdNpwD8KBDEKFOjpNGNlSnE58OmMUkgPy4Kq0lXImqpT
	 mTZR0eC6eBtyOWJWdSvn/zQvHF4XA7vIgLvxJqksQvjuDxib7JZrNaJj9rDT3TwYELw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W9RVADkafR2p56spVf94lP0PBIiL+kcnM/YyLtenLKA=;
	b=uGqWbC+ppIDVc6Eea7nTPX18959eprOphA7OTOg4hFg0ucdbYh4RmAnNchos2cFlkMAq
	 1TU5s1N5h7SuFw40SHTRTbaWNChzCuz/2HO5Ad+B0NajRHmBW7DR3igKWKuIyHOy4vSzZ
	 vnKNBMvZjQNdiHI2DB4NjfmpU3pbmXnqlm0APubN4qhie6JVGRnqJyKpCGw/I8F8NaagM
	 p1JGY3YjgIj2xfwhigHp19h5fHxaEt/iC+E3QC2sStPCqkMkmAg3X1IJSxMDWF1tgTirP
	 MxPtDQZ3qnBDR0FXyiZLrQIAUI1d/6pLBNrCJWtH5klZ+MhKb96b/SCETCJa+Rq9Yvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HLIYkODi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353C9606A322;
	Wed, 28 Oct 2026 19:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HLIYkODi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4921D1F01825;
	Wed, 28 Oct 2026 19:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214317;
	bh=W9RVADkafR2p56spVf94lP0PBIiL+kcnM/YyLtenLKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HLIYkODiFeSaos2qIg6gqrpCR7Br+im6AwJRZfNln6oiE27x2JX/oB4G+unww0YQT
	 J8cgHWCaZDHXhONl7PMXeYFHgo/9etI/GSFGE/WhhUSRy4oAjrq0nBwkmBK3aFqGx6
	 33nkMQGMHm5TzZ/be88K9hhgwSCKm9W324eHkp+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0817/1887] drm/rockchip: vop2: fail cleanly if missing a primary plane for a video-port
Date: Wed, 28 Oct 2026 17:48:33 +0100
Message-ID: <20261028170518.018077447@linuxfoundation.org>
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

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit f9f68bf1d0efeadb6c427c9dbb30f307a7def19b ]

Each window of a vop2 is usable by a specific set of video ports, so while
binding the vop2, we look through the list of available windows trying to
find one designated as primary-plane and usable by that specific port.

The code later wants to use drm_crtc_init_with_planes with that found
primary plane, but nothing has checked so far if a primary plane was
actually found.

For whatever reason, the rk3576 vp2 does not have a usable primary window
(if vp0 is also in use) which brought the issue to light and ended in a
null-pointer dereference further down.

As we expect a primary-plane to exist for a video-port, add a check at
the end of the window-iteration and fail probing if none was found.

Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Reviewed-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250610212748.1062375-1-heiko@sntech.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 1a17e9c1e8335..608b0d681b217 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -2409,6 +2409,10 @@ static int vop2_create_crtc(struct vop2 *vop2)
 		if (!vp->crtc.port)
 			continue;
 
+		if (!vp->primary_plane)
+			return dev_err_probe(drm->dev, -ENOENT,
+					     "no primary plane for vp %d\n", i);
+
 		plane = &vp->primary_plane->base;
 
 		ret = drm_crtc_init_with_planes(drm, &vp->crtc, plane, NULL,
-- 
2.53.0



