Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4A328B51F;
	Wed, 23 Apr 2025 15:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422525; cv=none; b=hKJDrZ7gJqYcOSefxW1uSvsDK+cwkg8my94Itdy3E0j5LGN62Cg2vICZT+llFuAkHxeuhnGbsmghltohKJn8ygbqeV06VgC0xVL1EA2thh0MH2yU/s7lefFv6TRrphRPxCG1TzQW/TH4nlI5Bm5niIqJikE4Zf5JCCfMtRmI7gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422525; c=relaxed/simple;
	bh=PYSQParwnSfbLxZ/QlxIfCXlM124c+995y7tfxeyhCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4XEhpjZngJvHL0rniVC6Wke/xtv5GRBRA4/6OePX6q3PXDYp2B6sOdwnnIpNPhc61X6fz4lYLK+qGl/gcJJvEYMMBckQ1HHDD30pSDH0hAk7NxsKGW7+tqy9SPM4vQZG4G/h0qfng1AcigSc5D3ojm1SXqHv8TzD58VY23MlEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbD1mXzg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbD1mXzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724BEC4CEE3;
	Wed, 23 Apr 2025 15:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422524;
	bh=PYSQParwnSfbLxZ/QlxIfCXlM124c+995y7tfxeyhCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbD1mXzg11XYzyx3/a7R8VaINnbidmoDx7mBnincCXlxHtSbgo2BmHuP6JUfozkfm
	 t8Z6Hcx6/3qQw9YUJUCdocZl+cBgWGMmEYKlErpddoPLjr+vGVn+iBdlK5ruBowUN/
	 7oFsccvkNNeY5svlsD0ERZ9yLqP99TuCxa9JZPIg=
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
Subject: [PATCH 6.6 382/393] drm/amd/display: Stop amdgpu_dm initialize when link nums greater than max_links
Date: Wed, 23 Apr 2025 16:44:38 +0200
Message-ID: <20250423142659.103295014@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4484,17 +4484,17 @@ static int amdgpu_dm_initialize_drm_devi
 		}
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


