Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018CC4F8B3;
	Sat,  3 Feb 2024 04:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933863; cv=none; b=sWQSfP6zYugkK53dkV0cwCDyP4XeA9YZeNowAO6gYWCSZcFDPdg2J/HM8utnSCIM79JxRog8rD4FL0DcT6+O8R+qGtkCHQx8qVDuPelbtHpSAvRj+5ewTb1DWHcccRbfTGuu2r3LdbPOzSgOTWpf7DV2wRYf5ztSgs61ZrH/uik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933863; c=relaxed/simple;
	bh=AhO2FiS+lfR1TOSAFs+jzic6VpYAme9Wxu8LwCqhboI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7hgVrpVmw7AguhSPAXfxV162So23scuLyxGBKsLHH43aTbiIKsswClDlSEx2gMqgZueqjGrDYlxDGfFA/4EPSj/HOp7sS6UOqEDzlcg3KhF4il2iuEiPgJhCYKvakMH4FYZVvI2pC2DpNQyHZRwzJCYZJ9a4Sm/MjaehHsYPlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heUIb4Pj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heUIb4Pj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E9FC43390;
	Sat,  3 Feb 2024 04:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933862;
	bh=AhO2FiS+lfR1TOSAFs+jzic6VpYAme9Wxu8LwCqhboI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=heUIb4PjO+dPd6sQk6ESE6Mp2OAO+JWEGQ8v2Ehv/E9jHiUUYU0KHHJWXK7lAel+l
	 OeN+MXqESIbXHu7mVdHSWl8WiDVjR6i848ifo577tn1IEcnCoaZKgkftZmVDluRdpm
	 b2l7qN4iYpwcVG1XVesDns4QMyhcslwZa5pUzuug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Syed Hassan <syed.hassan@amd.com>,
	Allen Pan <allen.pan@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 174/353] drm/amd/display: initialize all the dpm levels stutter latency
Date: Fri,  2 Feb 2024 20:04:52 -0800
Message-ID: <20240203035409.144765856@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlene Liu <charlene.liu@amd.com>

[ Upstream commit 885c71ad791c1709f668a37f701d33e6872a902f ]

Fix issue when override level bigger than default. Levels 5, 6, and 7
had zero stutter latency, this is because override level being
initialized after stutter latency inits.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Syed Hassan <syed.hassan@amd.com>
Reviewed-by: Allen Pan <allen.pan@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
index bcc03b184e5e..9f84d17f4658 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
@@ -341,6 +341,9 @@ void dml2_init_soc_states(struct dml2_context *dml2, const struct dc *in_dc,
 		break;
 	}
 
+	if (dml2->config.bbox_overrides.clks_table.num_states)
+			p->in_states->num_states = dml2->config.bbox_overrides.clks_table.num_states;
+
 	/* Override from passed values, if available */
 	for (i = 0; i < p->in_states->num_states; i++) {
 		if (dml2->config.bbox_overrides.sr_exit_latency_us) {
@@ -397,7 +400,6 @@ void dml2_init_soc_states(struct dml2_context *dml2, const struct dc *in_dc,
 	}
 	/* Copy clocks tables entries, if available */
 	if (dml2->config.bbox_overrides.clks_table.num_states) {
-		p->in_states->num_states = dml2->config.bbox_overrides.clks_table.num_states;
 
 		for (i = 0; i < dml2->config.bbox_overrides.clks_table.num_entries_per_clk.num_dcfclk_levels; i++) {
 			p->in_states->state_array[i].dcfclk_mhz = dml2->config.bbox_overrides.clks_table.clk_entries[i].dcfclk_mhz;
-- 
2.43.0



