Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6EC2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44198C433EF;
	Sun, 22 Jan 2023 15:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401290;
	bh=ACi9bGeE56MbxBD51EC2LeNKmPVen7QG8lIDUQ0sR+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/D8EnHsDCnehDxjKixs9Vzm9QelAQK76q1Fn7spjRWmj7jDDQtkxvij8BRypnR9h
	 wNSQUSl2cdvMO7yR8kVR+OSAAYmddoe5ALNJK6dFkY9u1cYtKu+vtFxXsUQUU170KW
	 Oq45xNBAI5MHlDpMgnohSiUrQ6DAGhl7fZhSdv3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lang Yu <Lang.Yu@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 182/193] drm/amdgpu: correct MEC number for gfx11 APUs
Date: Sun, 22 Jan 2023 16:05:11 +0100
Message-Id: <20230122150254.751370633@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lang Yu <Lang.Yu@amd.com>

commit 0ddadc3a2208aedb1b27dbb76d0b4e722b5b527a upstream.

There is only one MEC on these APUs.

Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1288,10 +1288,8 @@ static int gfx_v11_0_sw_init(void *handl
 
 	switch (adev->ip_versions[GC_HWIP][0]) {
 	case IP_VERSION(11, 0, 0):
-	case IP_VERSION(11, 0, 1):
 	case IP_VERSION(11, 0, 2):
 	case IP_VERSION(11, 0, 3):
-	case IP_VERSION(11, 0, 4):
 		adev->gfx.me.num_me = 1;
 		adev->gfx.me.num_pipe_per_me = 1;
 		adev->gfx.me.num_queue_per_pipe = 1;
@@ -1299,6 +1297,15 @@ static int gfx_v11_0_sw_init(void *handl
 		adev->gfx.mec.num_pipe_per_mec = 4;
 		adev->gfx.mec.num_queue_per_pipe = 4;
 		break;
+	case IP_VERSION(11, 0, 1):
+	case IP_VERSION(11, 0, 4):
+		adev->gfx.me.num_me = 1;
+		adev->gfx.me.num_pipe_per_me = 1;
+		adev->gfx.me.num_queue_per_pipe = 1;
+		adev->gfx.mec.num_mec = 1;
+		adev->gfx.mec.num_pipe_per_mec = 4;
+		adev->gfx.mec.num_queue_per_pipe = 4;
+		break;
 	default:
 		adev->gfx.me.num_me = 1;
 		adev->gfx.me.num_pipe_per_me = 1;


