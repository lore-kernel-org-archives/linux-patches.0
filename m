Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B1037C90E;
	Thu, 20 Aug 2026 15:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238119; cv=none; b=YRHP9xi0nU1TLreWu8sXHtVREK5BzhV87uzucL4oY3C+AeC2V2Z623tKq4BHRUXsCH6NifxHd/FIzXEzv2fDBD9EmJVFHJJ8PK7WF2TdOKKP7JG4rsuj5msbLVNibMXfIt0qDtw/nRT48F1/UIGJZEhybNJtyFAmSj7tctZUXcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238119; c=relaxed/simple;
	bh=oqCBK1bxL/TrtbdKUkFXf/PA7ugRnHp/lJWpCldodiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqMAc6xRNS8bN8BM2IHO2qo52rGYdlkcUAIaCh6fsTY7Y9T2M0Pe90u3w2TksPibRASCyww3J1D9H8bQDMyqHK6Bzl4O2BScVB5stF1Mc+wVS/SYSOeHks/ffbvl/vSvOJGgGPvHk0B2Hfca0ir7O/MvMp4glv2zEYYA7qTxTl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHMNBjOf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHMNBjOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE8D1F000E9;
	Thu, 20 Aug 2026 15:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238118;
	bh=U+Tu7DQ+65A4ytPf5c+0x444vXwJNUhyRvki64dd610=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tHMNBjOffZFw4n2vrmN3eaT8nzZ+BD/ys6gmfnRxKyjM+EhEcpzpU0oY5Pox8g/uq
	 PA6yzlCat/w72K+mvdN7SJ2+A214pIwUhkA1LYxSoFU3XxxwilCsnm6Ju5goSsqahb
	 OmjGfZFRpU03jMNtkYvRebGrIcwzw/i9pgsbZ8rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shaoyun Liu <shaoyun.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 038/228] drm/amdgpu/gmc12.1: fix MMHUB0 check in pasid tlb flush
Date: Thu, 20 Aug 2026 16:53:00 +0200
Message-ID: <20260820145245.624042936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5227c2c77c3869cbbc680d5a61cb5d4574fd8e38 upstream.

Check for mmhub0 rather than mmhub1.  Looks like a copy
paste typo.

Fixes: d0c989a0aad3 ("drm/amd/amdgpu : Use the MES INV_TLBS API for tlb invalidation on gfx12_1")
Cc: Shaoyun Liu <shaoyun.liu@amd.com>
Reviewed-by: Shaoyun Liu <shaoyun.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0e8faef0aaa4d08f3f4f67ee7bb74e1babc8efc4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v12_1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v12_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v12_1.c
@@ -414,7 +414,7 @@ static void gmc_v12_1_flush_gpu_tlb_pasi
 
 		if (all_hub) {
 			/* invalidate mm_hub */
-			if (test_bit(AMDGPU_MMHUB1(0), adev->vmhubs_mask)) {
+			if (test_bit(AMDGPU_MMHUB0(0), adev->vmhubs_mask)) {
 				input.hub_id = AMDGPU_MMHUB0(0);
 				adev->mes.funcs->invalidate_tlbs_pasid(&adev->mes, &input);
 			}


