Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278451C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55984C433C1;
	Wed, 23 Nov 2022 09:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196501;
	bh=EuzErssSyHjynzOKeKg6p5l3yLMRR0f+GKAXW2NIwjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8qzsJzZ/b6zheghuBoSXoIeB7XIDl5xe7AElsewl56YZwfYWIvxCYKPy0l+erJEu
	 E8599I+kAcSCJWaNkGk8yveTAz/ZSTDivvq0TqjLb50HU8VC6TbAdRc9H4WoxUWxi3
	 /CMo0xGqOVWdTR58B8v9pn9Mfp2l6mH/8n93nUAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Broadworth <mark.broadworth@amd.com>,
	Martin Leung <Martin.Leung@amd.com>,
	Jun Lei <Jun.Lei@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 050/314] drm/amd/display: Enable timing sync on DCN32
Date: Wed, 23 Nov 2022 09:48:15 +0100
Message-Id: <20221123084627.777704624@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alvin Lee <Alvin.Lee2@amd.com>

[ Upstream commit c3d3f35b725bf9c93bec6d3c056f6bb7cfd27403 ]

Missed enabling timing sync on DCN32 because DCN32 has a different DML
param.

Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
index d34e0f1314d9..bc4f48ea8d4c 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
@@ -1228,6 +1228,7 @@ int dcn20_populate_dml_pipes_from_context(
 		pipes[pipe_cnt].pipe.src.dcc = false;
 		pipes[pipe_cnt].pipe.src.dcc_rate = 1;
 		pipes[pipe_cnt].pipe.dest.synchronized_vblank_all_planes = synchronized_vblank;
+		pipes[pipe_cnt].pipe.dest.synchronize_timings = synchronized_vblank;
 		pipes[pipe_cnt].pipe.dest.hblank_start = timing->h_total - timing->h_front_porch;
 		pipes[pipe_cnt].pipe.dest.hblank_end = pipes[pipe_cnt].pipe.dest.hblank_start
 				- timing->h_addressable
-- 
2.35.1



