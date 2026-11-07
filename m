Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063130;
	b=w9XpgbuYRr2cOv4gBG08GVbwSGjmQ24K4ngoTCwXOdZKHFMxBc7fPQpOQfvliuGbl6KU
	 zFUrKMRUMLDSY27pvY70MsqtXEUV+F3/XscUDWtzDthIMj9IAdGDEWU5eFU5XPm7YQ2xF
	 kVoq/9LZLC8lqatOj54YtAMyDvGX0J/w8MHBPwLSHvcc97Kz/hMMjRdUYQpW3D/0jRZI4
	 DG8b0JT9EBFoEBGIhk1ikt7QSYO/6kLmkCFF7s1ekGqGz+lFFZtaB53Xg6oJSwfIIINa2
	 0OZYbQB8eJOQuWQU5wZrMH3Onf85AHXYF4jwsi8P1VlApMHwrJdmDn/ZlamgK1eT4Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UDp3cW4JIavaHbIAix0r/CEXfdISViVQ089+o6hN0h0=;
	b=ZvAITx0+2YGpGQYZAuW0SQpk7QvCYHyRSyXPFi5hZYwP+y58A+TEi2yFs+5/efooqrwx
	 TNZuw1ySr4M/st0+rQ9MtCC3Pq7CesqPjTCZxEi/wEbTilBAGqCFdWPh2AD+w3e3PFnsj
	 CaTziL+C5+BI7hc15Bzt3pGHEy9IHyvBqUwF4IAebU26Y9rbM4ShQOQtkJoxNWr7Z4QP0
	 MnNyZpgejBK1uPd8TCcRInGDdoynvtdB4PPDDJkUpoP5dcTFaSGhyjZFdJ4sjR4e5F8VR
	 3SlxG0GrKNCdYVN06Zt9ep+x6JA9x31l9hxBsO/uh+h9zHKz2ktGCJGtLRfDtmUIXXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fi3vr3so;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D710606A330;
	Sat,  7 Nov 2026 14:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fi3vr3so
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD941F0089F;
	Sat,  7 Nov 2026 14:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063130;
	bh=UDp3cW4JIavaHbIAix0r/CEXfdISViVQ089+o6hN0h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fi3vr3soq6m/B/IJyNE1es4OLFu3PI3l7I+rkuPOJGIF7qnCM9dt3qiIYerVr8F6K
	 1UgJ0sRdilMv24yfQsjOffchWRCpZ4/TljfdD/a5eHKlu8y7da8ItvZScm8Ql83KI6
	 NF2ugk0AoyzkuGSs1zq0BynLYo13Xvhm8QXxxTIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 352/869] media: mediatek: vpu: release reserved memory on remove
Date: Sat,  7 Nov 2026 08:50:34 -0500
Message-ID: <20261107134904.313660829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



