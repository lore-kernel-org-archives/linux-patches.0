Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD2D23AF
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26C2C433EF;
	Wed, 28 Dec 2022 16:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246742;
	bh=+ZBWsdBJ8gxCGd67TKJ2XGMeL6EHNuE7JFfxx4DWnLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p35WeFoORSW7GY9/7BPE512Kg3KBJ1NRJgmpHqAM+y+mr8bZVuDXMWRpGPYG3/DRb
	 Ru+CEQN4YkcP9i3J65VsyxfyToOF+H1mVhbIgjJRRPKLOCdaSbrNWNjUtx2P/uWh+2
	 KDqEo7nHYEsgSF4GWTl+rGDOIDhIgbxr/Em7jcGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Chalmers <Wesley.Chalmers@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Martin Leung <Martin.Leung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 1146/1146] drm/amd/display: revert Disable DRR actions during state commit
Date: Wed, 28 Dec 2022 15:44:45 +0100
Message-Id: <20221228144401.270786378@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Leung <Martin.Leung@amd.com>

commit 6f8816261db9251f2635533572f95ab8e530266c upstream.

why and how:
causes unstable on certain surface format/mpo transitions

This reverts commit de020e5fa9ebc6fc32e82ae6ccb0282451ed937c

Reviewed-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Martin Leung <Martin.Leung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -992,5 +992,8 @@ void dcn30_prepare_bandwidth(struct dc *
 			dc->clk_mgr->funcs->set_max_memclk(dc->clk_mgr, dc->clk_mgr->bw_params->clk_table.entries[dc->clk_mgr->bw_params->clk_table.num_entries - 1].memclk_mhz);
 
 	dcn20_prepare_bandwidth(dc, context);
+
+	dc_dmub_srv_p_state_delegate(dc,
+		context->bw_ctx.bw.dcn.clk.fw_based_mclk_switching, context);
 }
 


