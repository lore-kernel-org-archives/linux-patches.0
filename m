Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91172EE96D;
	Thu,  3 Jul 2025 14:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554374; cv=none; b=h/mwOsw5MRy8jNEbmy0vz6rzDQdTqmXGLEgRAk/ZvnHDc8Goeik5Gwb03Glzrila/sTlw7yeDN+V0T8aIWJxr3MkaRcym2R1lsDaPT76D7oP4tUAaVg/Z3eFrkSBVe/2zNLx+3rwOeDb5HZkKSMTFTE7ZCwUlXoyPrnGRKcV6CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554374; c=relaxed/simple;
	bh=PHv0qYv7utuS1J7yDPCJxuslr5MzFCOxN5puuDFoVCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVd1IrG4FImqCFFpSa2caHCvcVLGIoMHrfIVryMMW3K1CVQjkLoOtj2GQ9qXqcu262S3nvEURQJ3KQLQ8+XbJu9yZMcEhWv/SBA4hBl35ENzyVcuMwOGECSJhATh4a8s5EfwZ4ntxKoDCGm2UWZJ2S/n4bPcz4er8j6lLsOiuWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1v2frQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1v2frQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88F2C4CEE3;
	Thu,  3 Jul 2025 14:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554374;
	bh=PHv0qYv7utuS1J7yDPCJxuslr5MzFCOxN5puuDFoVCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1v2frQekQNZD6tTeJ3yCADbQsJnCneiDqqtLFOtBJ5Xa5JSQ8pxPaERvVcrGAchY
	 xselxOvTR8RD9s2lBEy/DnWtErASSz14TJppNUvkOLuQ5n/C7CE9FgodV+4X4ooNV8
	 o4J3YCMXRzuSIjPjuC9gSV19hcY9rxfnz5h1kgu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Yihan Zhu <Yihan.Zhu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.12 167/218] drm/amd/display: Fix RMCM programming seq errors
Date: Thu,  3 Jul 2025 16:41:55 +0200
Message-ID: <20250703144002.836774196@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Yihan Zhu <Yihan.Zhu@amd.com>

commit 158f9944ac05dafd2d3a23d0688e6cf40ef68b90 upstream.

[WHY & HOW]
Fix RMCM programming sequence errors and mapping issues to pass the RMCM
test.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Signed-off-by: Yihan Zhu <Yihan.Zhu@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 11baa4975025033547f45f5894087a0dda6efbb8)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -4651,7 +4651,10 @@ static void calculate_tdlut_setting(
 	//the tdlut is fetched during the 2 row times of prefetch.
 	if (p->setup_for_tdlut) {
 		*p->tdlut_groups_per_2row_ub = (unsigned int)math_ceil2((double) *p->tdlut_bytes_per_frame / *p->tdlut_bytes_per_group, 1);
-		*p->tdlut_opt_time = (*p->tdlut_bytes_per_frame - p->cursor_buffer_size * 1024) / tdlut_drain_rate;
+		if (*p->tdlut_bytes_per_frame > p->cursor_buffer_size * 1024)
+			*p->tdlut_opt_time = (*p->tdlut_bytes_per_frame - p->cursor_buffer_size * 1024) / tdlut_drain_rate;
+		else
+			*p->tdlut_opt_time = 0;
 		*p->tdlut_drain_time = p->cursor_buffer_size * 1024 / tdlut_drain_rate;
 	}
 


