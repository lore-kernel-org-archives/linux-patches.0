Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F023C25A355;
	Tue, 21 Oct 2025 20:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077326; cv=none; b=nwNBOprAclzOimO/d2mbZ1M2NJNH1kjSfo8Aoxbkr6Z6esFlUHvAD3i/rXi8j7uHXQ73YWZS6nF57lavSvbq8L6aBaens0Yg+5zFZek079t2v6QiuLtQx8E61yL1EunqPvCpnwPg0czAe8aksRZmaeb3/4hXwU+Fe63pV6U/P/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077326; c=relaxed/simple;
	bh=5UCq4CeYtDwuj2LxS1TAS6Lly5G9T/wx3mONF5ni+c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5iXPuhkFeBrXQd2lv5prml/Cjr3zcXzpVGF1v+rnfm0Ef2jhahESLogZ/pd9tYLke9V7SlpWcCRSYvPxLAF1N+uHf1ZbMdLa0MRJ0SVJP4300aMOanUVL58z4gmTO+ttNE36KxXD3W9iPhfi2cmvS9QopbbHefblLCfxbzI7bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjCw9JhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjCw9JhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC49C4CEF1;
	Tue, 21 Oct 2025 20:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077325;
	bh=5UCq4CeYtDwuj2LxS1TAS6Lly5G9T/wx3mONF5ni+c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YjCw9JhDcwv/8kdiVKrCfz8Om9M2uEaEhQ0pvTVdvfu51+T2dTpNG+zkR0AthXQAD
	 5d8kVafIACREyIN7QLHKXQldww1h3kEdb1D1GlEHYrMFq/+hOdORmadovPvM8QjE54
	 a/Pac8dIuLzbL7kjGDuqY0/XtsGdGiID9yHl/5xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Graunke <kenneth@whitecape.org>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.17 043/159] drm/xe: Increase global invalidation timeout to 1000us
Date: Tue, 21 Oct 2025 21:50:20 +0200
Message-ID: <20251021195044.238391832@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

From: Kenneth Graunke <kenneth@whitecape.org>

commit e5ae8d1eb08a3e27fff4ae264af4c8056d908639 upstream.

The previous timeout of 500us seems to be too small; panning the map in
the Roll20 VTT in Firefox on a KDE/Wayland desktop reliably triggered
timeouts within a few seconds of usage, causing the monitor to freeze
and the following to be printed to dmesg:

[Jul30 13:44] xe 0000:03:00.0: [drm] *ERROR* GT0: Global invalidation timeout
[Jul30 13:48] xe 0000:03:00.0: [drm] *ERROR* [CRTC:82:pipe A] flip_done timed out

I haven't hit a single timeout since increasing it to 1000us even after
several multi-hour testing sessions.

Fixes: 0dd2dd0182bc ("drm/xe: Move DSB l2 flush to a more sensible place")
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/5710
Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
Cc: stable@vger.kernel.org
Cc: Maarten Lankhorst <dev@lankhorst.se>
Reviewed-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://lore.kernel.org/r/20250912223254.147940-1-kenneth@whitecape.org
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 146046907b56578263434107f5a7d5051847c459)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -1029,7 +1029,7 @@ void xe_device_l2_flush(struct xe_device
 	spin_lock(&gt->global_invl_lock);
 
 	xe_mmio_write32(&gt->mmio, XE2_GLOBAL_INVAL, 0x1);
-	if (xe_mmio_wait32(&gt->mmio, XE2_GLOBAL_INVAL, 0x1, 0x0, 500, NULL, true))
+	if (xe_mmio_wait32(&gt->mmio, XE2_GLOBAL_INVAL, 0x1, 0x0, 1000, NULL, true))
 		xe_gt_err_once(gt, "Global invalidation timeout\n");
 
 	spin_unlock(&gt->global_invl_lock);


