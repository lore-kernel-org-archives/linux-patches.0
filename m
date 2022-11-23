Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BC71C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F09DC433C1;
	Wed, 23 Nov 2022 09:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196520;
	bh=oidhLC0L4GAvaunSYFFtf10iPFYKvphjPeoVXma+CRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtYzryEQ2Xum915f7EMK39C/3Tnkn2r8oqIYt8lr4iC65F8Y11XwfWll8El+KTfuA
	 cl4YJNDoqh6oiWaZPWcUddAQfDxkUlHP/trVRJl1o/d9gU3KasHGjNPJD78lhQ2HUd
	 B6pJYmLlXBoxvk1YcPW89eGujDKh6RYoFgwZso0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	George Shen <george.shen@amd.com>,
	Mark Broadworth <mark.broadworth@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 055/314] drm/amd/display: Round up DST_after_scaler to nearest int
Date: Wed, 23 Nov 2022 09:48:20 +0100
Message-Id: <20221123084627.991704637@linuxfoundation.org>
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

From: George Shen <george.shen@amd.com>

[ Upstream commit 8dc323133d74518e3b5b07242e2b2f088799ea6e ]

[Why]
The DST_after_scaler value that DML spreadsheet outputs is
generally the driver value round up to the nearest int.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
index a1276f6b9581..395ae8761980 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
@@ -291,8 +291,8 @@ void dml32_rq_dlg_get_dlg_reg(struct display_mode_lib *mode_lib,
 
 	dml_print("DML_DLG: %s: vready_after_vcount0 = %d\n", __func__, dlg_regs->vready_after_vcount0);
 
-	dst_x_after_scaler = get_dst_x_after_scaler(mode_lib, e2e_pipe_param, num_pipes, pipe_idx);
-	dst_y_after_scaler = get_dst_y_after_scaler(mode_lib, e2e_pipe_param, num_pipes, pipe_idx);
+	dst_x_after_scaler = dml_ceil(get_dst_x_after_scaler(mode_lib, e2e_pipe_param, num_pipes, pipe_idx), 1);
+	dst_y_after_scaler = dml_ceil(get_dst_y_after_scaler(mode_lib, e2e_pipe_param, num_pipes, pipe_idx), 1);
 
 	// do some adjustment on the dst_after scaler to account for odm combine mode
 	dml_print("DML_DLG: %s: input dst_x_after_scaler   = %d\n", __func__, dst_x_after_scaler);
-- 
2.35.1



