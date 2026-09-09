Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBFE52E054;
	Wed,  9 Sep 2026 14:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964475; cv=none; b=AtBWmhmrgxI3PKf161gQnw88F1kGkuLZX6AynChU4Z4cE/pC4HseWDEdDTUbgsldWhR8AiWwQ2JIn3Tv4LEoiYa2ufN5N6tSL6gQMDOVyHK6nXxH8gqcoAerclHEH6W9C7e70UkOBLmd/9l/vgP1pGo7R6BMREEUNIv+iBSA1r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964475; c=relaxed/simple;
	bh=DIjz/OMCF7BJ2oT7+2Vd8HXcjZEggiwUl/J8vvw09Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eozoOSTr9MziK5qhuN0qebgqR0T3d9xlligvhZcWPjrS2EqxV4EuTh2vLqk2fzeWv+qepD5BzBNRSmPOBXbPZXEWeemFVE05YBIO9lVGGvpU/owwcMUjpHbM2V+Fg7IAm3P49lKPCIJRtt221xnxuaEs0jqvbPZ9lcRvIDk5TTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZK99fzl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZK99fzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D731F00A3A;
	Wed,  9 Sep 2026 14:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964474;
	bh=dDhljjFek+M+OQYzKl/Ltk5207Ub4PtYh+FPZ+eAxm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZK99fzlPog/n4Plod4As6JB92EhlEljb/10fwaWmZEN82+Y6hjxabSYSh/1FXuIa
	 ToWfLna/beL4L1o6hr71+pv3mPF/WMMPy7rhomdmh3OBseCNuC1Ti5hvP58DdNXUGh
	 EV/kK5+UGWIHP287TQT3KqZi2Nmi1CuFo69L3hf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 397/583] drm/amdgpu: update the fw version for gfx12 userqueues
Date: Wed,  9 Sep 2026 15:41:22 +0200
Message-ID: <20260909134251.751192545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Sunil Khatri <sunil.khatri@amd.com>

commit 49a74a2388528c1a2e96f01114c4513e635605fe upstream.

Update to the latest stable fw versions where userqueues
is working as it is expected with major fixes.

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 69fa36e3ac92f2544ee7a1b719ec212b8247a2da)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -1421,10 +1421,10 @@ static int gfx_v12_0_sw_init(struct amdg
 	case IP_VERSION(12, 0, 0):
 	case IP_VERSION(12, 0, 1):
 		if (!adev->gfx.disable_uq &&
-		    adev->gfx.me_fw_version  >= 2780 &&
-		    adev->gfx.pfp_fw_version >= 2840 &&
-		    adev->gfx.mec_fw_version >= 3050 &&
-		    adev->mes.fw_version[0] >= 123) {
+		    adev->gfx.me_fw_version  >= 3090 &&
+		    adev->gfx.pfp_fw_version >= 3190 &&
+		    adev->gfx.mec_fw_version >= 3450 &&
+		    adev->mes.fw_version[0] >= 147) {
 			adev->userq_funcs[AMDGPU_HW_IP_GFX] = &userq_mes_funcs;
 			adev->userq_funcs[AMDGPU_HW_IP_COMPUTE] = &userq_mes_funcs;
 		}


