Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6E28F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B132EC433C8;
	Sun, 16 Jul 2023 20:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540082;
	bh=t/TYWDCOeYX6MMhr1xnokdmnP2tjOveGRxeU3fbIfVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKLIJLxSdpsTqZjLMsQgIqN1htpoETsZop130ZguhyTRNHuHu5u35JtLAh/8bCgaY
	 fkJ8e63jCdd4854puOBXzIP0qqALqYOTGWPwB82lgn801VbBFLUSKn2RJOCF+07caV
	 CbB81WmvDOqQXHfgapTiObnHQTCHhK0HChhfe+dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 237/591] drm/amd/display: Fix a test dml32_rq_dlg_get_rq_reg()
Date: Sun, 16 Jul 2023 21:46:16 +0200
Message-ID: <20230716194930.000766525@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit bafc31166aa7df5fa26ae0ad8196d1717e6cdea9 ]

It is likely p1_min_meta_chunk_bytes was expected here, instead of
min_meta_chunk_bytes.

Test the correct variable.

Fixes: dda4fb85e433 ("drm/amd/display: DML changes for DCN32/321")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c   | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
index 395ae8761980f..9ba6cb67655f4 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
@@ -116,7 +116,7 @@ void dml32_rq_dlg_get_rq_reg(display_rq_regs_st *rq_regs,
 	else
 		rq_regs->rq_regs_l.min_meta_chunk_size = dml_log2(min_meta_chunk_bytes) - 6 + 1;
 
-	if (min_meta_chunk_bytes == 0)
+	if (p1_min_meta_chunk_bytes == 0)
 		rq_regs->rq_regs_c.min_meta_chunk_size = 0;
 	else
 		rq_regs->rq_regs_c.min_meta_chunk_size = dml_log2(p1_min_meta_chunk_bytes) - 6 + 1;
-- 
2.39.2



