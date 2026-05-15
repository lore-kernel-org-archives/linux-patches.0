Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409B326CE11;
	Fri, 15 May 2026 16:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862134; cv=none; b=UViZG++aT34dDE4/GHwEK1f2nCSHrA55Z4IeQcFETA518g6f0SEthQyyzdAjv8YO79d1Fi5qvs8G3xPNBOcdGTXgzkuEg6pm/bKZ9jQHLYTU29HbcC5YPMpKqL49oFD+4Wmku6dvWgdjwGSrE/RLElU7ZsZVVhgZxmE2r3ZD6z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862134; c=relaxed/simple;
	bh=gRinPZ87mQmEXOEUppj0T0uurRT4FRZZtN5+NsG39uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W8eBDm/WiGVV/11jt2vEig5lrTGK+I7aXR/bqpKaAr8Sm+C7o6Nq9dIZ6Db/Poe0Xvq1oNrlNslcmPFE5Ik6Pb4HQ7u9a/cWL/4DN+9th7NSn9SjprWH/fLEOlvjMCfaSX01QI+gOO+ruEYwEL0lNsVZksjzV6mtJciblrCI1as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I20Mfvic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I20Mfvic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA47EC2BCB0;
	Fri, 15 May 2026 16:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862134;
	bh=gRinPZ87mQmEXOEUppj0T0uurRT4FRZZtN5+NsG39uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I20Mfvic/DP/2vjcS0/yu3SobAPlvu9+DFb/4YtNBAb4rut3q6UofU5gN07fVr0JF
	 AxBSY4VdUn0/Xwv3CGclTG8E022X2SCQwRl7nR9YS5N5DKpjbIiwWs+97mN7D00Dy6
	 y6cYNfShNFsrRkv/wgNAip6dOuFprzOLa3cxs2S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 122/188] drm/radeon: add missing revision check for CI
Date: Fri, 15 May 2026 17:48:59 +0200
Message-ID: <20260515154659.976741585@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3304,7 +3305,8 @@ static int ci_populate_all_memory_levels
 	pi->smc_state_table.MemoryLevel[0].EnabledForActivity = 1;
 
 	if ((dpm_table->mclk_table.count >= 2) &&
-	    ((rdev->pdev->device == 0x67B0) || (rdev->pdev->device == 0x67B1))) {
+	    ((rdev->pdev->device == 0x67B0) || (rdev->pdev->device == 0x67B1)) &&
+	    (rdev->pdev->revision == 0)) {
 		pi->smc_state_table.MemoryLevel[1].MinVddc =
 			pi->smc_state_table.MemoryLevel[0].MinVddc;
 		pi->smc_state_table.MemoryLevel[1].MinVddcPhases =
@@ -4493,7 +4495,8 @@ static int ci_register_patching_mc_seq(s
 
 	if (patch &&
 	    ((rdev->pdev->device == 0x67B0) ||
-	     (rdev->pdev->device == 0x67B1))) {
+	     (rdev->pdev->device == 0x67B1)) &&
+	    (rdev->pdev->revision == 0)) {
 		for (i = 0; i < table->last; i++) {
 			if (table->last >= SMU7_DISCRETE_MC_REGISTER_ARRAY_SIZE)
 				return -EINVAL;


