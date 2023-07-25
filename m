Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539A115ACF
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C384BC433C9;
	Tue, 25 Jul 2023 11:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282882;
	bh=ezgSoTYi1g+jNIZ/5p3EVpILf5wKaxdEdsiJU++VcMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GG7/IAJ9CRO7XIOEcvK0sF8pGSO7A1fyYWgtSaU+ZYLizd2eFR9Cpz9dtbfyFSlzC
	 0HJfdMd+TgNh1RhTtHcF9QtaKRA3fbB7ii/9g8Dh2BjSbXT5ThLgWJZ8q1giJlOWRF
	 EN+CA7tQ/1HkGk9eOGxMi46iOkRVb0NtrukWCAiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Alan Liu <haoping.liu@amd.com>,
	Zhikai Zhai <zhikai.zhai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.1 033/183] drm/amd/display: Disable MPC split by default on special asic
Date: Tue, 25 Jul 2023 12:44:21 +0200
Message-ID: <20230725104509.112176377@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhikai Zhai <zhikai.zhai@amd.com>

commit a460beefe77d780ac48f19d39333852a7f93ffc1 upstream.

[WHY]
All of pipes will be used when the MPC split enable on the dcn
which just has 2 pipes. Then MPO enter will trigger the minimal
transition which need programe dcn from 2 pipes MPC split to 2
pipes MPO. This action will cause lag if happen frequently.

[HOW]
Disable the MPC split for the platform which dcn resource is limited

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Alan Liu <haoping.liu@amd.com>
Signed-off-by: Zhikai Zhai <zhikai.zhai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
@@ -65,7 +65,7 @@ static const struct dc_debug_options deb
 		.timing_trace = false,
 		.clock_trace = true,
 		.disable_pplib_clock_request = true,
-		.pipe_split_policy = MPC_SPLIT_DYNAMIC,
+		.pipe_split_policy = MPC_SPLIT_AVOID,
 		.force_single_disp_pipe_split = false,
 		.disable_dcc = DCC_ENABLE,
 		.vsr_support = true,


