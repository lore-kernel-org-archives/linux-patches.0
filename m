Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015046;
	b=p+jnMwNKUvcApcwfR4Ypw7igvQ3fYLV+QrKChzj5ypTXkFfk49TbFatHtOqxG6f3a3V+
	 /E9Upl0am1iQ8Y8seH3du6vAhNNwm67HdAFGL0othlxd4jkoL2RG4BgsV/4tYnCFADaOC
	 MNvmV6iLSQiNaAmPLt2d4PUELfAyCgUgPpg3aXOH7Mirf7FFcuY0zidDqTfkVF90ZMbod
	 OMjR1Ae+h/jt7CheS/cNafhRU2PBIAwDLVNoJuIsxvKSzALzQg/bWis0us7urlG4jThos
	 nwCV7diiON+I0ed7AqpmiJPvVwsAu1jssCfnnU121PCzHCtDvVuVUwOBVO4iS/JPtnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nuwRnq/L43ruRdZSdXvRCfsUIMPuQkSfKvHuTWWjRgg=;
	b=jPnC2w8xv6F/qZZNQl+f0wNtKUUxgouU4rc5yUhaybIKxJrDgZCmjSRbvJCpyIQTrMyZ
	 vpON9pA5HaHY/KZEYBX+ZStq4/1+UKhe2Lt+0WMCjUKkAWWRXuHI/jWrTfw8V5yMi3Z9M
	 KIl86dLs0rc8WECAOUOwJyjjzNRX6PU1m9PoeoqWS8V6mTrY6xfiExW12MGugs4x0afZY
	 Vy/dj5nS7xsWQQzEYXBlOskdeJ4oMHhVKkQkEhMw2/dTRUxMTLRvF9Y9sEcJnCyD3VSux
	 XzImlKHTKZeeVWVibx0teCcDBvSkxwQEzieQilEm1TaDUJaAWxC6UrmI5rmTHAcuFIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kriPBBU2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8A8606A31C;
	Wed, 18 Nov 2026 15:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kriPBBU2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B6F1F000C4;
	Wed, 18 Nov 2026 15:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015046;
	bh=nuwRnq/L43ruRdZSdXvRCfsUIMPuQkSfKvHuTWWjRgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kriPBBU271l+YygvOzzs5HhRvn7iCJ7olOQiWroOjQrekWDo/UTtl43yPHIAK/a6U
	 nsFr5S3DeMWB+C8C4qHdOLN4zRiV165wCgJAqqVSIjIdD8hJ/s0wiVJAAaf4bHeVC0
	 +DAg9kNpy4xWiDq2JXOW4sNkhShNHDeCn6FV3Iq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Calvin Owens <calvin@wbinvd.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0026/2651] Revert "drm/amd/display: Allocate DCN32/1 dmub memory to GTT"
Date: Wed, 18 Nov 2026 15:21:06 +0100
Message-ID: <20261118150248.922098601@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Calvin Owens <calvin@wbinvd.org>

[ Upstream commit 5b3717a14ef602c961a4abeb2ce8039f0394bebb ]

After commit a637a140ab860310 ("drm/amd/display: Allocate DCN32/1 dmub
memory to GTT"), a machine with a Radeon RX 7900 shows random garbage on
the screen. It reproduces sporadically, but at times it is so bad the
machine is more or less unusable.

The garbage is always horizontal bars extending across the entire
screen, always approximately 200 pixels tall on a 3840x2160 screen,
for what looks like a single frame. The bars are mostly black, but will
sometimes exhibit striping and periodic artifacts which smell like
non-framebuffer data is being rendered to the screen.

It took some patience on the "good" side, but I was able to nail it down
to commit a637a140ab860310818a14fb4d37e39e51a06be4 with this bisect:

  bad: [cee9395acd8043be0644b25c34bfa86623f2b935] Linux 7.3-rc1
  good: [8d3ae59288f1e7d58d76558a6ee96d533bc5019f] Linux 7.2
  good: [55ab7e14222e5f0b0fd9f7711ca391d2924b35e3] Merge tag 'for-7.3/block-20260819' of git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux
  bad: [df51bdc5e80dae43cab81f6cc641e98638303c88] Merge tag 'mtd/for-7.3' of git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux
  bad: [29daacacf4cd84e6917f09de6a99fb170071c14c] Merge tag 'drm-rust-next-2026-08-08' of https://gitlab.freedesktop.org/drm/rust/kernel into drm-next
  good: [fff648aec5e2790d117a0ec5c849a284d9d33d70] drm/amdgpu: include amdgpu_video_codecs.h only where needed
  bad: [336e0cd576817ac64a4b394ca2b3680029f3e37f] Revert "drm/amdgpu: fix aperture mapping leak"
  bad: [789f7486a384ca58b9d7a76abba5efa0e80e8dab] drm/amd/display: Test plane colorop helper walkers
  good: [e0e426f10ad653c5e9dd33fb4a76d55f06101992] drm/amd/display: Test helper_check_state rejects
  bad: [982b2a43682b55e7d9800000f2592832ff2865ba] drm/amdgpu: Fix IP block NULL check during soft reset
  bad: [9102b39fa924dcc3dc75a3137bfa9633c40b88c0] drm/amdgpu/userq: fix indefinite fence wait during GPU reset
  bad: [b23470a026afe64de5c1df4ad181587b49c22923] drm/amd/display: Exit LS for ISHARP before coefficient write
  bad: [f02b2e47355e9d381a7f34acc997e1c47879ca21] drm/amd/display: Add KUnit test for wb jobs
  bad: [c6a13d145cc811b19c8a0620f25868cf7d5700c0] drm/amd/display: remove unused dcn42 socbb values
  good: [1d8327353de6f1f34063840f362c208c84064f54] drm/amd/display: Fix VABC Init and OLED Support
  bad: [a637a140ab860310818a14fb4d37e39e51a06be4] drm/amd/display: Allocate DCN32/1 dmub memory to GTT
  first 'bad' commit: [a637a140ab860310818a14fb4d37e39e51a06be4] drm/amd/display: Allocate DCN32/1 dmub memory to GTT

Sure enough, reverting a637a140ab860310818a14fb4d37e39e51a06be4 on top
of v7.3 completely and totally eliminates the problem for me.

Mikhail has separately reported this regression:

  https://lore.kernel.org/all/20260829010525.29935-1-mikhail.v.gavrilov@gmail.com/

...but it seems to be much more consistent for me than for Mikhail, it's
never taken more than 30 minutes even when the machine is completely
idle. I've also never been able to reproduce any artifact one single
time without commit a637a140, despite a lot of effort.

I'm not sure reverting this is the right way forward, since presumably
this would re-regress the timing issue Fangzhi alluded to in the
original commit. But nobody has proposed anything concrete yet... so
let's start the discussion here.

I'm happy to help test other better ideas as well :)

Fixes: a637a140ab86 ("drm/amd/display: Allocate DCN32/1 dmub memory to GTT")
Closes: https://lore.kernel.org/all/20260829010525.29935-1-mikhail.v.gavrilov@gmail.com/
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5714
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 899489d2e2aa854cf5e933677d6561dfcbb94529)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_dmub.c    | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_dmub.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_dmub.c
index 9ff25bc8ee5ae..870534b7cf46d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_dmub.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_dmub.c
@@ -511,7 +511,6 @@ int dm_dmub_sw_init(struct amdgpu_device *adev)
 		DMUB_WINDOW_MEMORY_TYPE_FB,		/* DMUB_WINDOW_CURSOR_OFFLOAD */
 	};
 	int r;
-	int mem_domain = AMDGPU_GEM_DOMAIN_GTT;
 
 	switch (amdgpu_ip_version(adev, DCE_HWIP, 0)) {
 	case IP_VERSION(2, 1, 0):
@@ -648,19 +647,13 @@ int dm_dmub_sw_init(struct amdgpu_device *adev)
 		return -EINVAL;
 	}
 
-	/* Limit to allocate dmub to GTT on DCN32/1
-	 * TODO: Other asics with GDDR7 may have worse latency
-	 */
-	if (dmub_asic != DMUB_ASIC_DCN32 &&
-	    dmub_asic != DMUB_ASIC_DCN321)
-		mem_domain |= AMDGPU_GEM_DOMAIN_VRAM;
-
 	/*
 	 * Allocate a framebuffer based on the total size of all the regions.
 	 * TODO: Move this into GART.
 	 */
 	r = amdgpu_bo_create_kernel(adev, region_info.fb_size, PAGE_SIZE,
-				    mem_domain,
+				    AMDGPU_GEM_DOMAIN_VRAM |
+				    AMDGPU_GEM_DOMAIN_GTT,
 				    &adev->dm.dmub_bo,
 				    &adev->dm.dmub_bo_gpu_addr,
 				    &adev->dm.dmub_bo_cpu_addr);
-- 
2.53.0



