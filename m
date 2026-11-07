Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064418;
	b=ZEo5REVUzhsudY7Z5nQgPXxI3ABZNnWDIaepjTu2Nnu/KHoBxVFYnqovamodyT+dIwmL
	 wSY4MxRaApWXuB/7uy9XGuIX7qhg5JIdAwwdIDhF0rFjmPtjWOmE0SqDUjAJpB4nfGJcK
	 UGmd+8okZ19fvHbb028aZVasrMXVnoqEQ7CeNt0ZJrR4U2EFwcHi2l3mv/+6MON8In3kL
	 izSbX/yjiIbKiDGOJVFQmHd/SPL/lM/QFGhkdevkkngwUOYSF8OBB3v6+e6LVEdaBiT83
	 383g2XL9ynemxrGfChaPamDX7yQFaA+YpbHwwt4Jxwz2QTXOjKHvFW4PKmT4yXMy7mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i2fa9Y/IUhNs4ZDZEVgV5AVuoEy7Tvv8TZ1Anjyc2Kk=;
	b=K7QOX0UscgtZclLoNPTgrDOZ3ItChTGzpSQkZkuOP5ruCeTmy0cc5AKyFHVGUkqQdhq1
	 YzS83IpmBDy5vfPk7dS4qOWNoEE6KOeC8qlWzOu4W0R4NY9IsKlpxGOHzgGIwHnNV0FBY
	 uID55BlZTWmecveg8qnXw9ejfMFFA1VM62or7hm3Dr1N8GeZIMRa//ZKBU3YqAGSXHhX5
	 zvQ6/4pUnAM1fdptZBrAMG3wfo0L27mqqbvram9yYUxFaSlqxjbuz89ldKYdHRjez7aF5
	 abKQPn/agEal/kdIeyezK6gIhfQ/cnXtRaEPgNiw7//tinJPaTc7Mx/7iMS1rqtzYIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YlpqQOeo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60586606D834;
	Sat,  7 Nov 2026 15:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YlpqQOeo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2801F0089F;
	Sat,  7 Nov 2026 15:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064418;
	bh=i2fa9Y/IUhNs4ZDZEVgV5AVuoEy7Tvv8TZ1Anjyc2Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YlpqQOeo57Twm4CdrrO3M3U0cJ05V5DPAUBnXegthERO7HAQGfQd1IB0rKGNoFyMk
	 lXACVx38mXbLOKizHpEtdGzbdGRvTPYgwmF2O3lUbEfdrJO3izOP4vByFoDB+iaZCU
	 W7367pnWYV/BGMN/hSrqdp2bk/LgkaT508thEcX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0461/1257] media: mediatek: vpu: release reserved memory on remove
Date: Sat,  7 Nov 2026 08:45:57 -0500
Message-ID: <20261107134952.198257866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/platform/mediatek/vpu/mtk_vpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/mediatek/vpu/mtk_vpu.c b/drivers/media/platform/mediatek/vpu/mtk_vpu.c
index b6bd80b684459..9dff1d971d37c 100644
--- a/drivers/media/platform/mediatek/vpu/mtk_vpu.c
+++ b/drivers/media/platform/mediatek/vpu/mtk_vpu.c
@@ -967,6 +967,7 @@ static void mtk_vpu_remove(struct platform_device *pdev)
 		destroy_workqueue(vpu->wdt.wq);
 	vpu_free_ext_mem(vpu, P_FW);
 	vpu_free_ext_mem(vpu, D_FW);
+	of_reserved_mem_device_release(&pdev->dev);
 	mutex_destroy(&vpu->vpu_mutex);
 	clk_unprepare(vpu->clk);
 }
-- 
2.53.0



