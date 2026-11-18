Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018115;
	b=zt5EH4KWTagu94LRyfBCL1DVLjI+j+8RzxbQwtPY6YE3N0BcVAu2bwzIk2FLryG15seL
	 d6u8osT7D4REC4exG5U/oaulvGVS14PBdYwTk5mWJDn8j2IRnSzUbdjGidRtqpijiN+Ob
	 1t7b1+l2IwAWJDcdU3dFYFE733Jzqf54bvXFNdTOCPGlBoDMhQp6pJ087slCCI6PaNtW9
	 /ZtsNhd1IE0sR7bQbE3oNHTgGBy1EkI94FEvMFK9NqbBVZSKkoCcVNBTuRqbk/mTyvOie
	 m1ynBQCahVGnN/O9/gxVnVBJGm1OQbGeoJOZNYL1HgS47vukRI5eMmwn3rF4DJvTTVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=khCK5XGCcGvN0CcA/uFZ0ELl65S2o6dWPUzSMyWdNiA=;
	b=WzFD3+U2vYriY4kLEswpDSZPkCAr1TJzRtQl0snJ+jwNN7Tb7mHSt9lhRetpyY1xtvw2
	 4u0t18YFK8X6hJgFOekzuADLtlUgdiHyF1EYlwUN/u/MyMQewikFWiBkvypjtW+XDZZK+
	 zeCVV5YCMTNfE+3OMQOC2YEpcBJZowyS1cTdAYc3tUgZNoqphXJLIR9v0M0pQmDqqisZE
	 mKzulrHEM7Fg/mYgP1nPdzL/+Qi/sP+z3yZTbO9+zN0Edd8+T6JD5Tkj1FVbUlE4aZV5z
	 OKouVmopUpixC3ahaJfU5QNaLL+ViOpuB0f5AXO/Gc744PxH/haAVmFu9Beit/HaviQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kGN2yU87;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609AC606A335;
	Wed, 18 Nov 2026 16:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kGN2yU87
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DAC1F000C4;
	Wed, 18 Nov 2026 16:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018115;
	bh=khCK5XGCcGvN0CcA/uFZ0ELl65S2o6dWPUzSMyWdNiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kGN2yU87ijhxqZZ3SgFfGSHlb82B8vmzvvfo0omtzDZM+yfLlCeF3q22t66OIqiKE
	 8oACFTzc2yF6ktWyPyVkMuOfMfMKSZzAe1qUSh8M24uhpSEuSWYitaR+GXLnzit6nW
	 Hkxs86I40f+kE/PfIjLUFOkbHxFk3BQY4PjQrKUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <Charlene.Liu@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Leo Chen <leo.chen@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1126/2651] drm/amd/display: Fix zero dlg_reg write to program_ext_vblank
Date: Wed, 18 Nov 2026 15:39:26 +0100
Message-ID: <20261118150328.550267522@linuxfoundation.org>
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

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit 6497a922e7155d2b794ae19feadbe50c23a0fa5a ]

[why]
fix some non initialized reg_offset
allow z8_only to program_ext_vblank

[CLEANED]
for dml2.1, dlg_reg moved inside hubp_reg
add current_compbuf_size check ensure HW state reached.

Partial application: DCN42 register-list additions only.

Fixes: 0a5e0416e191 ("drm/amd/display: Add DCN42B code to DC")
Fixes: 002f32db0d42 ("drm/amd/display: Fix dcn401_optimize_bandwidth")
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Reviewed-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Reviewed-by: Leo Chen <leo.chen@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hubbub/dcn42/dcn42_hubbub.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hubbub/dcn42/dcn42_hubbub.h b/drivers/gpu/drm/amd/display/dc/hubbub/dcn42/dcn42_hubbub.h
index 926ddc156a2b3..f74d5690c89d8 100644
--- a/drivers/gpu/drm/amd/display/dc/hubbub/dcn42/dcn42_hubbub.h
+++ b/drivers/gpu/drm/amd/display/dc/hubbub/dcn42/dcn42_hubbub.h
@@ -114,7 +114,12 @@
 	SR(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_C),\
 	SR(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_D),\
 	SR(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_D),\
-	SR(DCHUBBUB_ARB_QOS_FORCE)
+	SR(DCHUBBUB_ARB_QOS_FORCE),\
+	SR(DCHUBBUB_TEST_DEBUG_INDEX),\
+	SR(DCHUBBUB_TEST_DEBUG_DATA),\
+	SR(DCHUBBUB_CTRL_STATUS),\
+	SR(DCHUBBUB_TIMEOUT_DETECTION_CTRL1),\
+	SR(DCHUBBUB_TIMEOUT_DETECTION_CTRL2)\
 
 #define HUBBUB_MASK_SH_LIST_DCN4_2(mask_sh)\
 	HUBBUB_MASK_SH_LIST_DCN32(mask_sh), \
-- 
2.53.0



