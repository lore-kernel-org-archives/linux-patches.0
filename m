Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3073A3FF1D1;
	Fri, 15 May 2026 15:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860423; cv=none; b=H/tZNFEJftap8sCMCXypDeGJptyo57lXC81QwAlCBjCA6Ux0bUKSM+qUfL6QH5boxJXcaHPgZvRIFqxk2u868YCPKn00IhpfqQR5+WkzQRWlY9dZC4aXJRW/yJMQPiSWz9iUs6FhtFlKa1Kc2UXNhV7tWyBf4wKimaPTB3VO5PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860423; c=relaxed/simple;
	bh=YbhUueMIHBLi3JHae5TR8KSSPRsgIyz1uZ5kq239pHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qAauBnvko0c04eg615gwNIE/WZcA6sSKO2dbzkLF21dAhSauk0BtVfsjI4pXg4jbbfE5DuDDNu187zkSFS4omQ7U0vAxNJR4LhOFonx1E4iydAreiI5Bs66enxrox0KWIFVPrTK/5R/X/Yq3fJdNvWuQ3jKOgOOmBkyH70wM6ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASnuGQGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASnuGQGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B818EC2BCB0;
	Fri, 15 May 2026 15:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860423;
	bh=YbhUueMIHBLi3JHae5TR8KSSPRsgIyz1uZ5kq239pHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASnuGQGlFYAgo04CxCfKXBeUTQ4GjYmXFja5mZvFEBVLGYkN0A5O8i7+tGbf7iJJM
	 9nnNoQIKyuKqn1hIgYHyQbFpXRUPHQusjBHbOP6W23ab9aqeLHTHXdA1kjD9R0YmSc
	 PuOOY6AZC5I7q6x6eJ6gZMDX06b8DnroZiUA620k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 083/144] drm/radeon: add missing revision check for CI
Date: Fri, 15 May 2026 17:48:29 +0200
Message-ID: <20260515154655.448505086@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 17223816498f7b117d138d18eb0eba63604dc74e upstream.

The memory level workarounds only apply to revision 0 SKUs.

Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/1816
Fixes: 127e056e2a82 ("drm/radeon: fix mclk vddc configuration for cards for hawaii")
Fixes: 21b8a369046f ("drm/radeon: fix dram timing for certain hawaii boards")
Fixes: 90b2fee35cb9 ("drm/radeon: fix dpm mc init for certain hawaii boards")
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d8dcc14311515077062b5740f39f427075de5c9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/ci_dpm.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -2461,7 +2461,8 @@ static void ci_register_patching_mc_arb(
 
 	if (patch &&
 	    ((rdev->pdev->device == 0x67B0) ||
-	     (rdev->pdev->device == 0x67B1))) {
+	     (rdev->pdev->device == 0x67B1)) &&
+	    (rdev->pdev->revision == 0)) {
 		if ((memory_clock > 100000) && (memory_clock <= 125000)) {
 			tmp2 = (((0x31 * engine_clock) / 125000) - 1) & 0xff;
 			*dram_timimg2 &= ~0x00ff0000;
@@ -3302,7 +3303,8 @@ static int ci_populate_all_memory_levels
 	pi->smc_state_table.MemoryLevel[0].EnabledForActivity = 1;
 
 	if ((dpm_table->mclk_table.count >= 2) &&
-	    ((rdev->pdev->device == 0x67B0) || (rdev->pdev->device == 0x67B1))) {
+	    ((rdev->pdev->device == 0x67B0) || (rdev->pdev->device == 0x67B1)) &&
+	    (rdev->pdev->revision == 0)) {
 		pi->smc_state_table.MemoryLevel[1].MinVddc =
 			pi->smc_state_table.MemoryLevel[0].MinVddc;
 		pi->smc_state_table.MemoryLevel[1].MinVddcPhases =
@@ -4499,7 +4501,8 @@ static int ci_register_patching_mc_seq(s
 
 	if (patch &&
 	    ((rdev->pdev->device == 0x67B0) ||
-	     (rdev->pdev->device == 0x67B1))) {
+	     (rdev->pdev->device == 0x67B1)) &&
+	    (rdev->pdev->revision == 0)) {
 		for (i = 0; i < table->last; i++) {
 			if (table->last >= SMU7_DISCRETE_MC_REGISTER_ARRAY_SIZE)
 				return -EINVAL;


