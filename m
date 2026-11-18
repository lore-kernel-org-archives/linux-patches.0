Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052466;
	b=BvBZMroc5y9yiYvckRTAvWaj8YKQK2skgU9GyUx3/srRIpEsR56mNnJVo3P0/J/VrZVu
	 CAS7IjuRS8kJBM3T/6YIboCeWBMU7uhc2FZDml3Dh4uhppWx8xbyCJHu3r66j7rfkc9Yu
	 BI1mqqEJb63ImC6Bz6E8/eEVMKIQmoBpUKTn/NbnyzTlsdcR6lPCoSkYWKLawrrwnVzCn
	 f/xcMuLKybUWEZ1UTklELgbs3GT2p2cegeXZNhwcE9UGr/4S77O067dPUY8XLKGfxHNkg
	 571RBHZTiSwmFEgCL4m+g1RftRckEJdKbCYr0j5vSVV0BSSLM1jtlZZRm/chYELJQ/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7wbhKFIizpUidnRvWqoRyMQKjxgReayt5hT9e4aTwzo=;
	b=kRUaj5q0xROgzPhs0P5dBUXCdwpX6Gm7nIU0lG3x+WQuMSBPusrtarzCwoMrJlLim/ne
	 4M4PPcY14O9kCv99X+fqKGyXG+6mU1u4IQdAkkBDriz4tfwiMuzdFXe1PJfMkktvYFB5B
	 kHhU6jFholUEVzsQ9Vp1gGGjp2hU0XKwDSYw81kpk7ft/zOKyj/nI0lWtwoTBQTW8gtub
	 ZBXwS9I0tomyNbk6PSPceLh0afDw25mXWj9+GeVqjHsEB/jl2TKt+Y4S7wpyXDRmt57iD
	 9zh/H/bS+GbL8PiEarA8h+9fdmDdl5Ybwi2QSdK8F7LUaYoxFtrzYJDOPkrYJDFBz1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fy5sOuQx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE1F606A31C;
	Thu, 19 Nov 2026 01:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fy5sOuQx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0424A1F000C4;
	Thu, 19 Nov 2026 01:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052466;
	bh=7wbhKFIizpUidnRvWqoRyMQKjxgReayt5hT9e4aTwzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fy5sOuQxvYU4Rjcx0292jgFYZJ2aROL97OdeRyK0tsBaW5ULLAT+2rKSI4k/SDko7
	 nsb4epXM5ftWvAQL+bBgMNCYwjA1qgb5zgBLU9QQJyRhfHDq7awDm+0d3sPKljnLng
	 6+gtrjenX6eCSslIZMVipqnwCdeUTqSaVXEB8wnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0571/2214] media: mediatek: vpu: release reserved memory on remove
Date: Wed, 18 Nov 2026 15:37:27 +0100
Message-ID: <20261118150033.805293718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 8af0e2bdd9791848d9caf3761825ac51a67c2b9c ]

mtk_vpu_probe() may assign a reserved memory region to the VPU device
with of_reserved_mem_device_init(). The probe failure path releases the
assignment with of_reserved_mem_device_release(), but the normal remove
path does not perform the corresponding cleanup.

As a result, removing the VPU driver after a successful probe can leave
the reserved memory assignment associated with the device after its
lifetime has ended.

Release the reserved memory assignment after freeing the VPU external
firmware memory, matching the cleanup performed by the probe failure
path.

This issue was found by manual code inspection.

Fixes: 3003a180ef6b ("[media] VPU: mediatek: support Mediatek VPU")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vpu/mtk_vpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
index e282bbae8f668..87da09148b266 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
@@ -972,6 +972,7 @@ static int mtk_vpu_remove(struct platform_device *pdev)
 	}
 	vpu_free_ext_mem(vpu, P_FW);
 	vpu_free_ext_mem(vpu, D_FW);
+	of_reserved_mem_device_release(&pdev->dev);
 	mutex_destroy(&vpu->vpu_mutex);
 	clk_unprepare(vpu->clk);
 
-- 
2.53.0



