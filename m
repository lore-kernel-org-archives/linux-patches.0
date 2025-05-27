Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA159276057;
	Tue, 27 May 2025 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365053; cv=none; b=EUGZJ+Tcm+bbg6SXol1WdhkMD0m4DOJz8y0h5EpCwtBKxLVSGIlB7RHYXK/JHekXhrG32cmgyn044DZE7wHoZjCkH6o+mttKHV+eCO7tBXtMU1uV/layIvZBzxv0OQTZUAQrEF/8Uc8/2i3JXhQHsrH2cYXMDYuGtKXwIbH8Zpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365053; c=relaxed/simple;
	bh=FWZSX73uSRElcEzBI8yZ57xfHjboX3iduSYahMF1n7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlgFZnAUMSOCdPV//MT/P+ZmpVFqPl8aEUIQw/W9344Cr0NMJ++wfb6teUMDNgtJ3i3pvf0Ko6/6y7upg0PJxsQF34QNqPNZQlUeuUNNonZzOervnNoQc9FLev5hCyGkkIcAkelR9WLQttJ24V4gk29NxiGjRXX5KncHLrm5Px4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmTxwBpI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmTxwBpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61142C4CEE9;
	Tue, 27 May 2025 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365052;
	bh=FWZSX73uSRElcEzBI8yZ57xfHjboX3iduSYahMF1n7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmTxwBpILejkYTQ4ej5vpKSQs1ASfuQh9rm7MjSDpItRlXhHdKGm/n/JG5dbd8caf
	 +mjx5KvqgJFtgfN5MomoFD1uFILLRPyE1p+teUJPup+y25fPJR7vC2SQDOUH87DlTL
	 aF245HtNvrsfTDXoCaRzMvPXBFBC415MOI3/wFrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>,
	Michael Riesch <michael.riesch@wolfvision.net>
Subject: [PATCH 6.12 253/626] drm/rockchip: vop2: Add uv swap for cluster window
Date: Tue, 27 May 2025 18:22:26 +0200
Message-ID: <20250527162455.292291846@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit e7aae9f6d762139f8d2b86db03793ae0ab3dd802 ]

The Cluster windows of upcoming VOP on rk3576 also support
linear YUV support, we need to set uv swap bit for it.

As the VOP2_WIN_UV_SWA register defined on rk3568/rk3588 is
0xffffffff, so this register will not be touched on these
two platforms.

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Tested-by: Michael Riesch <michael.riesch@wolfvision.net> # on RK3568
Tested-by: Detlev Casanova <detlev.casanova@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20250303034436.192400-4-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 5880d87fe6b3a..2aab2a0956788 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -1432,10 +1432,8 @@ static void vop2_plane_atomic_update(struct drm_plane *plane,
 
 	rb_swap = vop2_win_rb_swap(fb->format->format);
 	vop2_win_write(win, VOP2_WIN_RB_SWAP, rb_swap);
-	if (!vop2_cluster_window(win)) {
-		uv_swap = vop2_win_uv_swap(fb->format->format);
-		vop2_win_write(win, VOP2_WIN_UV_SWAP, uv_swap);
-	}
+	uv_swap = vop2_win_uv_swap(fb->format->format);
+	vop2_win_write(win, VOP2_WIN_UV_SWAP, uv_swap);
 
 	if (fb->format->is_yuv) {
 		vop2_win_write(win, VOP2_WIN_UV_VIR, DIV_ROUND_UP(fb->pitches[1], 4));
-- 
2.39.5



