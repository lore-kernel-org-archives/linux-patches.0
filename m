Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045295;
	b=iQUCdomDcaBSZ1zBh5oDE7rR+l8zgD34GQYw6fSDNy9LVMmrGIKqlhgiaDVgSHTaMeTt
	 /D00hF7rI27bvAyf8IMrltMVOPBz0u7Eba0UpAGZBmszt+2sz9wiu22Vj3UvpWjQZInUL
	 VIDEMqzWXmPjVR84KJnJGfS242wHUhEAjXMQGGmMCfBnwx8DN+tQ4IVud8wChu+wD/i3W
	 HhZ9b4isMZ6tNzwXW9JeE5gPobk6pMduSJbzqQmw0R67msYxTcuMw/0zZEacxUrs01kaw
	 SfRRjA4GZ8x0Ba7eQKCXi6JcOQ7DFXSnmzisYpbqPGIE6cd1t+/x5IAWxtyt/WeRLJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EfQ7cwiM0kmaWhA/yExiOgQAHoKX/cDFxyXnMrnGSz0=;
	b=zZtc3g7zmIc9VHvaEi26aPfGcVz53itRWBW5mRDvJv9e+ZNJaY3iwkfI0xIfXIzR4n0C
	 eu2rXYfFLhhAxXnTwE8YmqfEeBmVPAEKGtkRUbLUCdL6zSUKfiv+ge8lLPXu94NZW3UCu
	 HFlNioxHLvHiqqgzbxnqeCH8O9hv5zlkEk4ekMFp6QA/RVNiC5zUeQgfBM1/ta8HLgQS0
	 pG/RZ+a7yUnzUTux5vxhsSKWovdROe9NuXi85A3c/cqk3c75qOU48IjfH/D+nKwk0MMwX
	 4JoX+iTCZfpbCemKe5P4eSfGOyw9YqJUCJqHR0prW5AAU5WBJNfJh5firC+R3NoqBxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uwZxpA8n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36F4606A32A;
	Wed, 18 Nov 2026 23:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uwZxpA8n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FDD1F000C9;
	Wed, 18 Nov 2026 23:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045294;
	bh=EfQ7cwiM0kmaWhA/yExiOgQAHoKX/cDFxyXnMrnGSz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uwZxpA8nBC5Q034k/qplkNLyU5fU99pXh6m528jdHbWxizYrSmofJkdL6g0y7293j
	 tWZRx/O4F5XlA6s2So9VVDWS1Oek4zTPDzaU6sNwWC6zIWSL2+omlYsqoTna+hmk6H
	 ItdP6+mqhKez0XUNO5Dg77VMa3MJXt2+U0Juv5xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0871/2857] media: mediatek: vpu: release reserved memory on remove
Date: Wed, 18 Nov 2026 15:31:45 +0100
Message-ID: <20261118150232.923218550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 37c0a4abfe8df..cfcaddda96443 100644
--- a/drivers/media/platform/mediatek/vpu/mtk_vpu.c
+++ b/drivers/media/platform/mediatek/vpu/mtk_vpu.c
@@ -967,6 +967,7 @@ static int mtk_vpu_remove(struct platform_device *pdev)
 		destroy_workqueue(vpu->wdt.wq);
 	vpu_free_ext_mem(vpu, P_FW);
 	vpu_free_ext_mem(vpu, D_FW);
+	of_reserved_mem_device_release(&pdev->dev);
 	mutex_destroy(&vpu->vpu_mutex);
 	clk_unprepare(vpu->clk);
 
-- 
2.53.0



