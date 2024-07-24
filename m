Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F8418040;
	Wed, 24 Jul 2024 15:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721836182; cv=none; b=sdJBeVbXgR84I+AN4NK5DKjXuI75euTJxuH1QCCgPeuHBtbpwn+3p34hzFppcgUue/fk1muOXRgxQ1XBEpBTW3uUfBUxtYtpTcWZrPu6wSYL4HUaqfyIbiHJHqo00cch2i85IfA98X70tabfXKWgK8fmM7G+3Z7x53gl+cKssVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721836182; c=relaxed/simple;
	bh=jyuLz0h3cTvFrDOTCTiUYN/EUF5g4NsBMVHIof/f2X8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=N1rCttoz9+sbn7KcGnclps8/ZHQAsk+V4w1KMTVu1z3YdzxzEIkhJflT2x71DRHYShIygA1M+ekexszfELNuhiDvzMCvfMxf/4VpEiAYr9B69ftsVWr5wzwFwbZ/b9IgYaAJ1TgWCpUnkn+ciF/ZyS5zk8Cu2muhbfsDSIjJbhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XkqENQlT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XkqENQlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA36C32781;
	Wed, 24 Jul 2024 15:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721836181;
	bh=jyuLz0h3cTvFrDOTCTiUYN/EUF5g4NsBMVHIof/f2X8=;
	h=From:Date:Subject:To:Cc:From;
	b=XkqENQlTaMe7K1s/rgUxdiK2N+jPT1DBdlJGCJJ/Pg0/yaiwIkgipRK0NMYpBUEep
	 /niWDe8N/Dm8DLwZ2msTFg26M7uN2wZ53vY7dXuXtf3DcQFJRsjsZ4nNCvamALoZEy
	 6waXp8KphvqIDrJPGe0f2lIcUSPedKCKoApU5XYz1v8M/Ja6I0U2iY77aiYtXRhQKz
	 W6RD8ocuJTCKdvh/uBJkHxQGw9ufDFVHLk3p8vsPoXHRF1lIhTOi7viCxn6JLh6rc9
	 Dmbgc9evNVkrk1Zvz+IQWPLpYjugHRm9FlsO1ZN1xl2YfVg4m1cRJzTzHbLPS2XNAv
	 4+kooXbdjV6oQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 24 Jul 2024 08:49:35 -0700
Subject: [PATCH] drm/amd/display: Reapply 2fde4fdddc1f
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240724-amdgpu-dml2-fix-float-enum-warning-again-v1-1-740e7946f77a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAI4ioWYC/x2NQQqDMBAAvyJ7dkGT0Nh+RTwszZoumFUSbQvi3
 xt6HBhmTiichQs8mhMyv6XIqhX6toHnizQySqgMpjOu88YhpRC3A0NaDM7yxXlZaUfWI+GHsop
 GpEiieHOerPXDvbcD1NyWufr/1Thd1w+9882YegAAAA==
To: Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
 Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Xinhui Pan <Xinhui.Pan@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>, 
 Chaitanya Dhere <chaitanya.dhere@amd.com>, Jerry Zuo <jerry.zuo@amd.com>, 
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2051; i=nathan@kernel.org;
 h=from:subject:message-id; bh=jyuLz0h3cTvFrDOTCTiUYN/EUF5g4NsBMVHIof/f2X8=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGkLlaYUzNvKMqHsofY5pb4PDFNOavP0xa6wMd2y6/TV4
 8wb1if3dZSyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJlCQx/NOraD2neFt+a4TF
 wn/3Nk2WlXq91Zu5582s5KJKc3X3/6wMfziC+dT23fgtfSk/0CjP/4T58Q/tJ1wSt8S8qpl+fBH
 bORYA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Commit 2563391e57b5 ("drm/amd/display: DML2.1 resynchronization") blew
away the compiler warning fix from commit 2fde4fdddc1f
("drm/amd/display: Avoid -Wenum-float-conversion in
add_margin_and_round_to_dfs_grainularity()"), causing the warning to
reappear.

  drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_dcn4.c:183:58: error: arithmetic between enumeration type 'enum dentist_divider_range' and floating-point type 'double' [-Werror,-Wenum-float-conversion]
    183 |         divider = (unsigned int)(DFS_DIVIDER_RANGE_SCALE_FACTOR * (vco_freq_khz / clock_khz));
        |                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

Apply the fix again to resolve the warning.

Fixes: 2563391e57b5 ("drm/amd/display: DML2.1 resynchronization")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_dcn4.c    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_dcn4.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_dcn4.c
index 0021bbaa4b91..f19f6ebaae13 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_dcn4.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_dcn4.c
@@ -180,7 +180,7 @@ static bool add_margin_and_round_to_dfs_grainularity(double clock_khz, double ma
 
 	clock_khz *= 1.0 + margin;
 
-	divider = (unsigned int)(DFS_DIVIDER_RANGE_SCALE_FACTOR * (vco_freq_khz / clock_khz));
+	divider = (unsigned int)((int)DFS_DIVIDER_RANGE_SCALE_FACTOR * (vco_freq_khz / clock_khz));
 
 	/* we want to floor here to get higher clock than required rather than lower */
 	if (divider < DFS_DIVIDER_RANGE_2_START) {

---
base-commit: bd4bea5ab2bda37ddb092a978218c4d9b46927e6
change-id: 20240724-amdgpu-dml2-fix-float-enum-warning-again-647a33789138

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

