Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B042726B09D;
	Thu, 13 Feb 2025 15:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459242; cv=none; b=mlsyGB2d+MZxHpZIQxA5I+Luwy5e2O2vfTexLiaYIJjJE/UqIrWG5DgS82yHM059gqHRSvXN/FCo977v/NCnWiYKlOCbZuNWk6qyB7lhCqaGTRZO+QYLctWFel6FO16qQq86f8JNk0GxxNAnA/HgNtEbIRSt3TsoivTxzlXcQvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459242; c=relaxed/simple;
	bh=Yv310Ee3oZfVw8s46BeE1O+cFioS9f5jGyKkr0ho/0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HidpVM5Q0Vq9UX8Pok+PXd3tTo99OuRPZZjokq68O2luYb5BJ4tRXSJ1HBtnfpFuPMrYIEEyywLH7uwdZDXATyqg+gmz6Vuacy00O6xqbUMI1dDCLMqhZKl7xsXi0L++NwijYxfucVX6VS8zOcBuot4n0nby+mPRdqG9a0JLwpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZBundi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZBundi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DA9C4CED1;
	Thu, 13 Feb 2025 15:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459242;
	bh=Yv310Ee3oZfVw8s46BeE1O+cFioS9f5jGyKkr0ho/0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZBundi7VlfNK2xdOFaNQ7Rhp2H/q15As1uxJjcOs7IHcmA5pxkvO1tZqadsN/4ha
	 uUgroqbbxAawzTe2E2IBMHIkcuDyV/oj7PHR/5hu1WIYCke9MVeiJU/LhugNvyRFEo
	 cYFNYQtnrCY06WELsNWr4WQ9ZbEMZnLnrmFl/sTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 175/443] drm/amd/amdgpu: change the config of cgcg on gfx12
Date: Thu, 13 Feb 2025 15:25:40 +0100
Message-ID: <20250213142447.356851425@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Feng <kenneth.feng@amd.com>

commit 5cda56bd86c455341087dca29c65dc7c87f84340 upstream.

change the config of cgcg on gfx12

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -3999,17 +3999,6 @@ static void gfx_v12_0_update_coarse_grai
 
 		if (def != data)
 			WREG32_SOC15(GC, 0, regRLC_CGCG_CGLS_CTRL_3D, data);
-
-		data = RREG32_SOC15(GC, 0, regSDMA0_RLC_CGCG_CTRL);
-		data &= ~SDMA0_RLC_CGCG_CTRL__CGCG_INT_ENABLE_MASK;
-		WREG32_SOC15(GC, 0, regSDMA0_RLC_CGCG_CTRL, data);
-
-		/* Some ASICs only have one SDMA instance, not need to configure SDMA1 */
-		if (adev->sdma.num_instances > 1) {
-			data = RREG32_SOC15(GC, 0, regSDMA1_RLC_CGCG_CTRL);
-			data &= ~SDMA1_RLC_CGCG_CTRL__CGCG_INT_ENABLE_MASK;
-			WREG32_SOC15(GC, 0, regSDMA1_RLC_CGCG_CTRL, data);
-		}
 	}
 }
 


