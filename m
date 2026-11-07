Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063833;
	b=T3j82Hl1j+HSD+H4/o/99kdYbgt0aHd0Z85JLt+p+/IK0rRL5YJMGB9KMY1zyQEHOyxB
	 Bplty8T6Ith6/EIgsntgknwxOrCZfNunBCmZgu9UqEW27Hm8UFqrbVgVxgYK+kZ0cLcmj
	 FJ+oiMoU5ub+BTn2V7BvLTOWxvHi+8ljK+XwjrN7r4Nc8IAVnr9ApLF2f2tbLTcbEJd22
	 Q1cajZu2W9QmkI3hDniiDaU/ZQhmKiGpH8xCrxORUdsfthawZMM9DRZ1Cfg2VWY1vj3NK
	 zaZHSlG1TXKoqx9ZjCl7I3EUe6lbri3iRiNh8NvP8oWo0CbE5+nR3becIzKr5ykpQOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5eazfAFn18YsbQC+Z+GxznmK2VhDX3F8TDsH4ObGW40=;
	b=NIFUqtPMx5MtHxp9pXFkSeRsCUZPojj1OptcE9sTEHx0U0rnKEBwI0fM5U1p5p1kN8zN
	 nM2/VoxmCR66fpELbtiUJBYOAuXBoa6Aq1re5RDpE1DAGpgjASmxfdRXVFIlWIPtDC/p8
	 aVfNnuKZ8ZGgCek+R3dED8j7dFQMsZR1aFojWWt5XATvia1aZ4BLIkY315maYz82McV4f
	 i3nrqK1QQ7HIJqXLzM8M2YMKN+q6wmwr4xDTPk9GzleDuhsJjvnbWIUl+k7R0GVJ8LADE
	 uHR6t5qolhFoMvA6Xwz6COPlameE8yjqtZUE7R08eqrumon2FUtYhAp3xKwLBZ94WMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nHVtmoBR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2DD606A326;
	Sat,  7 Nov 2026 15:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nHVtmoBR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6271F0089F;
	Sat,  7 Nov 2026 15:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063832;
	bh=5eazfAFn18YsbQC+Z+GxznmK2VhDX3F8TDsH4ObGW40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nHVtmoBRn1lJrdSjJIhPtvzCOpefWrgBNtr8ueUj89VOQaetAsRBY9EKLBJIizA5o
	 mhl/Jc4hNbrRs7SwruuXM+Zfz4vS7HZWJnmNgLy5rYtb590CbE2fq02+juayQynCty
	 89I6KiIxFcI1kF77iF6OADJGIqX0N57KhGSZIVPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0013/1257] drm/nouveau/gsp/r570: Set GcOff = 0 in fbsr
Date: Sat,  7 Nov 2026 08:38:29 -0500
Message-ID: <20261107134939.791496971@linuxfoundation.org>
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

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit c7abe771e013848970421e5ca29c6b2f05c31965 ]

Previously, it looked as if we were able to fix suspend/resume on some
desktops by setting Gcoff based on whether or not we were entering runtime
PM. This was a mistake though - the only time suspend/resume would end up
actually working was if Gcoff = 0.

It seems like it's likely the main reason for this is the FBSR GcOff
argument actually controls GSP's behavior with regards to which buffers it
decides to save across suspend/resume. When GcOff = 1, RM reserved regions
are saved unless they are marked as LOST_ON_SUSPEND, and RM channel-context
and kernel-client buffers are also saved -including- when they are
LOST_ON_SUSPEND. This means with GcOff = 1, we end up having GSP save and
restore buffers that actually need to be reinitialized on resume - causing
the failures we're setting.

Thanks to John Hubbard from Nvidia for providing some background on what
these options do in the GSP firmware do!

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 53dac0623853 ("drm/nouveau/gsp: add support for 570.144")
Cc: <stable@vger.kernel.org> # v6.16+
Reviewed-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20260814194542.781955-3-lyude@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/fbsr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/fbsr.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/fbsr.c
index 469e7eed1d6f8..a93a39ef7c690 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/fbsr.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/fbsr.c
@@ -135,7 +135,7 @@ r570_fbsr_init(struct nvkm_gsp *gsp, struct sg_table *sgt, u64 size)
 	ctrl->hClient = gsp->internal.client.object.handle;
 	ctrl->hSysMem = memlist.handle;
 	ctrl->sysmemAddrOfSuspendResumeData = gsp->sr.meta.addr;
-	ctrl->bEnteringGcoffState = 1;
+	ctrl->bEnteringGcoffState = 0;
 
 	ret = nvkm_gsp_rm_ctrl_wr(&gsp->internal.device.subdevice, ctrl);
 	if (ret)
-- 
2.53.0



