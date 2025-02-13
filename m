Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E50281349;
	Thu, 13 Feb 2025 14:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457742; cv=none; b=CcYeMtVGqy2FDovB6VKuNysr66TY3GZ+P9S0TilqJS6Q0uMNXqhX6YCw5tyhRkpIcpOYbYWZY7M4MgxANSOY9l8zNH9YMGi7vQwqaad5A4lNAo7kBjNxet22dcjirM2mYbdtyLAyIluGPVEKu6dleVBDtMcZ1od+8N2sppdVXPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457742; c=relaxed/simple;
	bh=aRM8xcOLAMmzZRzqVxdM+F9wXrhLvTyXvuiYYMCvMA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikHiF4k5loDXIiZvAwh8sTW2HDisFVagaUGuyp82tT71juaA3hF4AWd7+8nZeu+YpZ//naRax9eGqBQHYXJjsGkubNmlsUbzFqm8M4c9Ttb/A0yz2C0mOmLTPh9ZlbTO1G02/m3f8tNapbmd15Y4xsxZg4o0hC8wIgGYIdjDQe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3+yVXkK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3+yVXkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BE4C4CEE2;
	Thu, 13 Feb 2025 14:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457741;
	bh=aRM8xcOLAMmzZRzqVxdM+F9wXrhLvTyXvuiYYMCvMA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3+yVXkKQP67cOeRp95F9lEGtZ2swGJUu8IMiz1iikVeC6OlIdffKWzPMnduKeCbU
	 64ERRKNyUPaoeSejg3Pe9T27b+LaOW3BAYCogfJGvlv1Q06ttyapcc5+waiqKF/KUO
	 hkbyOOnWUSupi2jLUi/VxFhnxxWLKGpcKbJaoENg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 158/422] drm/amd/amdgpu: change the config of cgcg on gfx12
Date: Thu, 13 Feb 2025 15:25:07 +0100
Message-ID: <20250213142442.641831373@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3981,17 +3981,6 @@ static void gfx_v12_0_update_coarse_grai
 
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
 


