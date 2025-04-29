Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBEE251791;
	Tue, 29 Apr 2025 17:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947060; cv=none; b=ZYl95TT5tWri3++xsv5aD7tRBoXitFISgyk7A5vboJ+JpI6kbCwkiIFFZtXHScAcmeNjohBYozREM+0FOtjkCvf9qSpwFfGs1icEnc7X8EfKZwYObQOUNAFCfPpOzRQSvwpdsU+1TFgbVgcdGOKSRekO5TGXYNivoF0/ePJ/Kd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947060; c=relaxed/simple;
	bh=RkqjY7VNQaa2eD4GsZMBceRMykMKJUgnVhXDyUG8Vzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlcAvBx7c6w6TfUIGJKDXqFRPs1dKe6cesEm9JRLmgkduSjLwqOr6lYIzNLunoxeHN+lZS51siVFa3RjWdiPBv+2bTbSrakp/Mx0gnsgIlKyo2oJKXdUR8kiuRFmLKTASh6yJ7XNGEtCKJNOYtTU0ZIs6fEmWudH7Ev1ST0qauE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wO8eEGPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wO8eEGPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2023C4CEE3;
	Tue, 29 Apr 2025 17:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947060;
	bh=RkqjY7VNQaa2eD4GsZMBceRMykMKJUgnVhXDyUG8Vzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wO8eEGPwXY7a+Z82bKgbbZXLkJxLN6SHEqqG4yx6NxipfAMIEqbhcSYIIChPUzZtg
	 TTskviBp/NB6cv/NQ84qns1MwdsNoX90oLqoPlq+7d6wpikngly08nYptBXH8CkPYD
	 71GZeEOb/TSOSCbm6hrqwl7+++YzP3um1uoHlfF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.10 158/286] drm/amd/display: Stop amdgpu_dm initialize when link nums greater than max_links
Date: Tue, 29 Apr 2025 18:41:02 +0200
Message-ID: <20250429161114.385496731@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hersen Wu <hersenxs.wu@amd.com>

commit cf8b16857db702ceb8d52f9219a4613363e2b1cf upstream.

[Why]
Coverity report OVERRUN warning. There are
only max_links elements within dc->links. link
count could up to AMDGPU_DM_MAX_DISPLAY_INDEX 31.

[How]
Make sure link count less than max_links.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[Minor conflict resolved due to code context change. And the macro MAX_LINKS
 is introduced by Commit 60df5628144b ("drm/amd/display: handle invalid
 connector indices") after 6.10. So here we still use the original array
 length MAX_PIPES * 2]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3397,17 +3397,17 @@ static int amdgpu_dm_initialize_drm_devi
 			goto fail;
 		}
 
+	if (link_cnt > (MAX_PIPES * 2)) {
+		DRM_ERROR(
+			"KMS: Cannot support more than %d display indexes\n",
+				MAX_PIPES * 2);
+		goto fail;
+	}
+
 	/* loops over all connectors on the board */
 	for (i = 0; i < link_cnt; i++) {
 		struct dc_link *link = NULL;
 
-		if (i > AMDGPU_DM_MAX_DISPLAY_INDEX) {
-			DRM_ERROR(
-				"KMS: Cannot support more than %d display indexes\n",
-					AMDGPU_DM_MAX_DISPLAY_INDEX);
-			continue;
-		}
-
 		aconnector = kzalloc(sizeof(*aconnector), GFP_KERNEL);
 		if (!aconnector)
 			goto fail;


