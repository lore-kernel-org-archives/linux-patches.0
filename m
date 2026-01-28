Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9702F30F552;
	Wed, 28 Jan 2026 16:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616117; cv=none; b=RFS3peaCqN2iX8lX7w6CsXXbVntou6iaahHiir0wvtciWoJ/yXi2FBY87/I+p55BV/+AN3gNYZjAxsCo4BNKgln7v3r87FIz2YBl6T2XGHUdrXzLZX/Wo8pCnRE5o04BdxmUrAS/r9UkGf0yNWPVUlmgzVlQm9nij/Gq1w6WAXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616117; c=relaxed/simple;
	bh=9tJrE60kCt1GeiF2IDq4W5SsGAIsCfwpc6qtabSsAQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gr6K8hJjywSApTczLTxTt/+QFbj1+qfCf2EAQTScZPnb/DS4/462HUvXPTe/G13ZemQzTcPGB6Dlx2lFj7f/Z/wlo4tXT/z5MrT5bXjb/+R0mMcrquOf6TkFysCSFcTkyjdGUT81NHk0Nkbzf1KjeCyG87egd/L8LLArIHsK/m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhFNzNS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhFNzNS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4B7C4CEF1;
	Wed, 28 Jan 2026 16:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616117;
	bh=9tJrE60kCt1GeiF2IDq4W5SsGAIsCfwpc6qtabSsAQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhFNzNS+I1pFkbKLbri6rcQPEbP68+wJyPXEDBuDqQKmAQ0PUNNHsinElQ0b+48P4
	 zHwegsxPV5JcXQx4lufkVgGYBkkmr6P/2NbGDSNNjvNxBS467TBjYoR455w31tHfe7
	 aVqzIZBjXmroZVmHP6//grXxpG44k51Ma301AoI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Likun Gao <Likun.Gao@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 212/227] drm/amdgpu: remove frame cntl for gfx v12
Date: Wed, 28 Jan 2026 16:24:17 +0100
Message-ID: <20260128145352.063741305@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Likun Gao <Likun.Gao@amd.com>

commit 10343253328e0dbdb465bff709a2619a08fe01ad upstream.

Remove emit_frame_cntl function for gfx v12, which is not support.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5aaa5058dec5bfdcb24c42fe17ad91565a3037ca)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -278,7 +278,6 @@ static void gfx_v12_0_select_se_sh(struc
 				   u32 sh_num, u32 instance, int xcc_id);
 static u32 gfx_v12_0_get_wgp_active_bitmap_per_sh(struct amdgpu_device *adev);
 
-static void gfx_v12_0_ring_emit_frame_cntl(struct amdgpu_ring *ring, bool start, bool secure);
 static void gfx_v12_0_ring_emit_wreg(struct amdgpu_ring *ring, uint32_t reg,
 				     uint32_t val);
 static int gfx_v12_0_wait_for_rlc_autoload_complete(struct amdgpu_device *adev);
@@ -4633,16 +4632,6 @@ static int gfx_v12_0_ring_preempt_ib(str
 	return r;
 }
 
-static void gfx_v12_0_ring_emit_frame_cntl(struct amdgpu_ring *ring,
-					   bool start,
-					   bool secure)
-{
-	uint32_t v = secure ? FRAME_TMZ : 0;
-
-	amdgpu_ring_write(ring, PACKET3(PACKET3_FRAME_CONTROL, 0));
-	amdgpu_ring_write(ring, v | FRAME_CMD(start ? 0 : 1));
-}
-
 static void gfx_v12_0_ring_emit_rreg(struct amdgpu_ring *ring, uint32_t reg,
 				     uint32_t reg_val_offs)
 {
@@ -5519,7 +5508,6 @@ static const struct amdgpu_ring_funcs gf
 	.emit_cntxcntl = gfx_v12_0_ring_emit_cntxcntl,
 	.init_cond_exec = gfx_v12_0_ring_emit_init_cond_exec,
 	.preempt_ib = gfx_v12_0_ring_preempt_ib,
-	.emit_frame_cntl = gfx_v12_0_ring_emit_frame_cntl,
 	.emit_wreg = gfx_v12_0_ring_emit_wreg,
 	.emit_reg_wait = gfx_v12_0_ring_emit_reg_wait,
 	.emit_reg_write_reg_wait = gfx_v12_0_ring_emit_reg_write_reg_wait,


