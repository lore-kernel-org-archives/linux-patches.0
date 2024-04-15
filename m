Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF80176044;
	Mon, 15 Apr 2024 14:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191524; cv=none; b=pP80mHC3Zj/vMF1qa5xQjBZA9gfSHr4OkNCc5wh96c+LBxy1aSX2zq0mpTekvWf8YUuyFWxNqg7HgPzvJrG+TgzhcBmp9xufYvJZYkQqkxNm2EF6EhztgcFtp0xbz+ZB19AHBo8Jq+ldDccv6ww1NqHck3ABZ42JPIx/lj3xzZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191524; c=relaxed/simple;
	bh=TbzevsoIUl+25r9puLhnvc2HPgelLJ9Ja6x5JQirO88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDjwucINJ5HI+ialzLbEJ/MmYBy5kDD5SRJXnVia9A7BfTqVefYvbIy9hhSDDcv9lDR5qHUIohTM7vNUkgSBA2SxIN9G3kNYZYHG9DgkCOyZEAkzpMgf8lm5gS7MrvP8LDVn8iqO95+pmQFg7r2Yb5ccIfIfE/7F+GDQ1klXAEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzqd9LOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzqd9LOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57518C113CC;
	Mon, 15 Apr 2024 14:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191524;
	bh=TbzevsoIUl+25r9puLhnvc2HPgelLJ9Ja6x5JQirO88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzqd9LOLcYCWsas82t7UD+OTvmkI8OnU8wCqvFXIutlo1szMMUPn6LeNflNjSTh7j
	 5/MSZEEvBXCsRLfQ/OjtDORJW+37ndrXoaFm1pw0LpSiop4Fr4A/8V7WUjQNLZAWJS
	 0/8TSqkuZsV7TjVILey9Sw6++xQvPEANOkXonR7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 170/172] drm/amd/display: Return max resolution supported by DWB
Date: Mon, 15 Apr 2024 16:21:09 +0200
Message-ID: <20240415142005.509804518@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit 2cc69a10d83180f3de9f5afe3a98e972b1453d4c upstream.

mode_config's max width x height is 4096x2160 and is higher than DWB's
max resolution 3840x2160 which is returned instead.

Cc: stable@vger.kernel.org
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_wb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_wb.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_wb.c
@@ -76,10 +76,8 @@ static int amdgpu_dm_wb_encoder_atomic_c
 
 static int amdgpu_dm_wb_connector_get_modes(struct drm_connector *connector)
 {
-	struct drm_device *dev = connector->dev;
-
-	return drm_add_modes_noedid(connector, dev->mode_config.max_width,
-				    dev->mode_config.max_height);
+	/* Maximum resolution supported by DWB */
+	return drm_add_modes_noedid(connector, 3840, 2160);
 }
 
 static int amdgpu_dm_wb_prepare_job(struct drm_writeback_connector *wb_connector,


