Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036281;
	b=bP8kXSOERrcD8musd0/rdHHVbXjj6uK/Rmgd3mXfoqNY8uvRbbQoVakRFjGqvUPRDOXh
	 MOgapcJPZV3FfituwlFgyuki3Sgk98hZntvueaibxcV42lYdKLm/fKJgln7EQVtIE3E7G
	 Hi8Nx24sheNQy8cFQHNQqXSszGMfu26V0kEwlcOGEw03nHcyMb0oehagG1b+vjZC+ncaG
	 lrSF6Sug6VAzGMZ4SCtKIoi9GNarT7r627pmUjg1+KBwyjJtfoURAJwTQ1Zo0B/tNi+HD
	 75HFuI31rTqV6xPHODSB8EXJOCQ0fBx1K2D9aKK8f8s18N2r6EENa0vElL55PU1LICQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9QRPlwWNQd2FUeCpccIh6KUvMWxes+M8IfEkK+Aumm8=;
	b=h64aD5o+yF6MbloaNemHC20MOmfdof4qS4d1ixbPS1VgH3debfPH6JFNO2cPui5vec1R
	 ADLS1rHgH9lL7fDj/u+u1qhYtvxOjImoDM1EPR+4LVSBKOtx8QVYMHLvDSocnxIXCt0jg
	 WislJzy96tAzHdjq9E4Ku78Ubwrm7vJM0DtTc19Yt+MQsBcU8pEmmsXc/0Am860sudGe8
	 v5AmCLTt0NQGI0kPQgTLWlBvU+gfI64/YBYbGy1awAHX7z2dTkXcqxr5XV2+w/LDVgqE6
	 Gq4ydjo9EGNuuxZI5qmrjj4+zbavpKpGUSHzM8WJ1SRB7g0BbA9wWKSHGbV39HkbXLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WbXEIUKF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF30606A32F;
	Wed, 18 Nov 2026 21:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WbXEIUKF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709C61F000C4;
	Wed, 18 Nov 2026 21:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036281;
	bh=9QRPlwWNQd2FUeCpccIh6KUvMWxes+M8IfEkK+Aumm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WbXEIUKFDNe2rLjEYhLZvCTVS2PuXlfI7y6efqmRczWp5w/+tbCYnqHh9kCxE8616
	 PjcLCWHZ23DEHI1skoBw9uPt116gD3E9nPEU62quJKxd5gaNL/VJPWuFQwjvnbKYsE
	 IIPvWtCOjdbiV1N/pdOKy0TsG2iMMIjjz08lxuIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1002/3318] media: mediatek: vpu: release reserved memory on remove
Date: Wed, 18 Nov 2026 15:27:04 +0100
Message-ID: <20261118150349.930744546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3d437898e1f47..e0357dd21a427 100644
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



