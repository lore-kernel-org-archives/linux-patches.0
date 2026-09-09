Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E119563FC2;
	Wed,  9 Sep 2026 14:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963082; cv=none; b=LnVEFBVvaS2WdwX7Cz7XWTmyRmNfXIRg4vEwZuSLbjD/TUFcf+DrNBD4uPFB4qZoPcncgC/2oyROlrqKjAHRyT4fzyXL76E20UFo83WwTmy18s8oJL4Wj/x3xFvkH5naxiX5NhQ7eU9UupmmPiebU1JX2D8vci7e7Tdz95EeyEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963082; c=relaxed/simple;
	bh=+JRmi2jCLUjr3ZSmTVGllB1ifmHUGTT3bVV5u1mj1cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtF+q9tb6AutYmmb9wpZLN0gAM7sVw9ley+KeyP/Sqw4q6MIf5peZndCGNQwLnfD3wsRB4K+s/7xd5LVoyDXc/9icsekQ0ZgexY62p21fBAIuSUYFFIo5bwgIUxriexPsqDYdwBXyg/oH0bZV4FDZ8K2jFg391DCktt65yzvwd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gaHck8h0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gaHck8h0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BE41F00A3A;
	Wed,  9 Sep 2026 14:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963081;
	bh=/coiL1zXP168Tvpo1UNlqcmbO3prYq3lcoQwPfz0eaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gaHck8h0T2TutHJZMrMQwezTcRKwwrc2DbK7ujDFrs71bSiPT86waxF73OzaSd8sS
	 93YC2YN3oESG14a5jgVk4siHYViJwrkcuhFxGgpqtQWo9tOzGov9o/QM8bnH3voJmg
	 IPNtwDyhb+W03CchDm0TOfSX8ALgsWJw4zqE29Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 512/556] drm/amdgpu: update the fw version for gfx12 userqueues
Date: Wed,  9 Sep 2026 15:43:12 +0200
Message-ID: <20260909134248.459624922@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1434,10 +1434,10 @@ static int gfx_v12_0_sw_init(struct amdg
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


