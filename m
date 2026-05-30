Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD7639478D;
	Sat, 30 May 2026 18:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166110; cv=none; b=IGxcCOIssrEkUrbhLqUAYQ99mLfNftxaezox0BZDuG8N7GP3VttRO+d1k/ARQrTALnPAcNDzqBQtmll0YJIicYbMAqaFzJD1CdazOSoC/UWzOtL5j/0y9C6mBXiva6e/pogxXP9RA9mb9VYSDfxxAGWfnzKViKH3uSfmyheRo1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166110; c=relaxed/simple;
	bh=StJnOftMZqMech7GgFjDUfdNW9/BASmXun0YYrLmh3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QBM/ZYwyKcX/8RzD/Sk1U979U6XloV6+8zzXOmyVDiybjaPNMYAAaj2FxYGIX450e1qFNdqrecdHsxrpYqwgLZ7KUNQY4mvRyLmWLHTyMIaX/Bw6MeGfNu/Y/3dxtGdXHAWLfjCl+VuE0Pkxt1SwVPEUYq0qCuNILfCd2nn2tdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1R2ha4ax; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1R2ha4ax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6DF1F00893;
	Sat, 30 May 2026 18:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166108;
	bh=azqkgn3KgdlUA9UX8ozhtvWH99OEKwd97Q3jFlEubNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1R2ha4axO4WFl90jcvj0cmzEIS0MX4jVMf0WKTODIeXS5Iw1rusEQ/UJ4ODaMzv4d
	 I1nMu0xF0cIw9LNqgXqOoEWXXa/uFjqblUvwG70Y7VeDRGD4Keh9JuzHDVghuriwu9
	 r8ZT4uGyGKcXaKqpqgh5rndKA8QAUe8CmbRR49IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 275/589] drm/radeon: add missing revision check for CI
Date: Sat, 30 May 2026 18:02:36 +0200
Message-ID: <20260530160232.199708002@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2490,7 +2490,8 @@ static void ci_register_patching_mc_arb(
 
 	if (patch &&
 	    ((rdev->pdev->device == 0x67B0) ||
-	     (rdev->pdev->device == 0x67B1))) {
+	     (rdev->pdev->device == 0x67B1)) &&
+	    (rdev->pdev->revision == 0)) {
 		if ((memory_clock > 100000) && (memory_clock <= 125000)) {
 			tmp2 = (((0x31 * engine_clock) / 125000) - 1) & 0xff;
 			*dram_timimg2 &= ~0x00ff0000;
@@ -3331,7 +3332,8 @@ static int ci_populate_all_memory_levels
 	pi->smc_state_table.MemoryLevel[0].EnabledForActivity = 1;
 
 	if ((dpm_table->mclk_table.count >= 2) &&
-	    ((rdev->pdev->device == 0x67B0) || (rdev->pdev->device == 0x67B1))) {
+	    ((rdev->pdev->device == 0x67B0) || (rdev->pdev->device == 0x67B1)) &&
+	    (rdev->pdev->revision == 0)) {
 		pi->smc_state_table.MemoryLevel[1].MinVddc =
 			pi->smc_state_table.MemoryLevel[0].MinVddc;
 		pi->smc_state_table.MemoryLevel[1].MinVddcPhases =
@@ -4528,7 +4530,8 @@ static int ci_register_patching_mc_seq(s
 
 	if (patch &&
 	    ((rdev->pdev->device == 0x67B0) ||
-	     (rdev->pdev->device == 0x67B1))) {
+	     (rdev->pdev->device == 0x67B1)) &&
+	    (rdev->pdev->revision == 0)) {
 		for (i = 0; i < table->last; i++) {
 			if (table->last >= SMU7_DISCRETE_MC_REGISTER_ARRAY_SIZE)
 				return -EINVAL;


