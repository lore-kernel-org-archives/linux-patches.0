Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FB919F485;
	Tue, 27 Aug 2024 15:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771046; cv=none; b=UH/zzrgK0j+jCBDu8Hk3SvyCXFGlA5vJa0RTd7NIEOsj1HdsgQp69YsLN5hOBU3ApjPYU3Bw5ooGNwCt00XrVML74m4VRTj4CwRx+W8dDl/17k3JPAttUnMx88AgA8Jj6YAJJ8iRzOPURx4JGDxlRWT0HQQ1yroRVqT/hUFhaGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771046; c=relaxed/simple;
	bh=olwMzO0l2Kx3JmcBZR3xrBBRvNe8ad7aYH0QW/NuKt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qy/3ysUfh4RGr9/GPNC+Y2aicII2NVfOJOnGJ7ZBZOXGJ7To1xpwkL319HBskCuG1fLDv4LC4AQcPQh8uSAH6ipZUG2XfzN0rhQE/r/FBn1h3VmzIRn23y6oR4QwYw/wnIZ3muM5jqu3dbq8s+UQU1zkJKnhUibP3tBQ13jtUkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+JbBSuH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+JbBSuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F53FC6104C;
	Tue, 27 Aug 2024 15:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771045;
	bh=olwMzO0l2Kx3JmcBZR3xrBBRvNe8ad7aYH0QW/NuKt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+JbBSuH/JeBmBr6LQ9deBbPg0tnGb7HOMd7uj4ngb0YzP6+1Ui2Zk0uiRpOoYgHh
	 bHNZLyn4QwyxgeK0qzAc1j/kjBzd3UQaE05K79gc2p494dlvvpuTy32JVUW5DZq5CL
	 kqLOTepij2+B4b7yQDuakYaKRN76F7+1G8wNEavk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Loan Chen <lo-an.chen@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.10 071/273] drm/amd/display: Enable otg synchronization logic for DCN321
Date: Tue, 27 Aug 2024 16:36:35 +0200
Message-ID: <20240827143836.118832866@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loan Chen <lo-an.chen@amd.com>

commit 0dbb81d44108a2a1004e5b485ef3fca5bc078424 upstream.

[Why]
Tiled display cannot synchronize properly after S3.
The fix for commit 5f0c74915815 ("drm/amd/display: Fix for otg
synchronization logic") is not enable in DCN321, which causes
the otg is excluded from synchronization.

[How]
Enable otg synchronization logic in dcn321.

Fixes: 5f0c74915815 ("drm/amd/display: Fix for otg synchronization logic")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Loan Chen <lo-an.chen@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d6ed53712f583423db61fbb802606759e023bf7b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
@@ -1778,6 +1778,9 @@ static bool dcn321_resource_construct(
 	dc->caps.color.mpc.ogam_rom_caps.hlg = 0;
 	dc->caps.color.mpc.ocsc = 1;
 
+	/* Use pipe context based otg sync logic */
+	dc->config.use_pipe_ctx_sync_logic = true;
+
 	dc->config.dc_mode_clk_limit_support = true;
 	dc->config.enable_windowed_mpo_odm = true;
 	/* read VBIOS LTTPR caps */


