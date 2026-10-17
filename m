Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F4C314B8F;
	Sat, 17 Oct 2026 17:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257705; cv=none; b=eoUDunDXt1VcM3SYLlUHD1j/eTMxuz/h7vo3qhp/BFIp1qUAWohg4s+KxFkfCl+O4nbfBOTFJP/P78l5rAKc8vRxNdZszLV/oioGQsyTtKW//t9SlYhMUcuCOotgvQHfg0BxyQeEN6yJuzj/wObH7GIuBjtBsJO8PmOcYfC9tdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257705; c=relaxed/simple;
	bh=jApg4N+JDASYgGPOqL4pmDFfL9i7Zzg+nCUlJMaidE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7v5kmRUMCarek6st5PUZokMIMNPLkhIojKXv0GzktEEjdP9VfoBR8asbzwkALpWMW0lO1myuIYQTm5kDOwJAdn9PeZGltsjdgmxP8i+bp3D9962x9S3Wd4zQX3wbbm3HZ29in44b59wzm5f5zO/quP1xAwHlv1bpXGSduuKYF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+lrv9qI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+lrv9qI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94561F000C4;
	Sat, 17 Oct 2026 17:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257704;
	bh=dq/bkj6EtT7lZqUmi+Nyefe07H6FwB5RZpM4rroeytM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p+lrv9qIhYPlaJpBbHiufQm9HCXLZpXfe38KXUdxXnntUiiQdAYmEsRaGb3RD4DwW
	 24aKNdNf6ZkqmWfQvntzwwkBETbzEC0uQPMV4awskS+xeMx4vFX99TjwFhsb5EcBvT
	 4TvzphoT8uf+S3vpneS1e5RRzoAX0dFDoCssRfHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0643/1674] drm/amd/display: Avoid overflow from uint32_t to uint8_t
Date: Sat, 17 Oct 2026 17:48:35 +0200
Message-ID: <20261017160447.609740275@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit d6b54900c564e35989cf6813e4071504fa0a90e0 ]

[WHAT & HOW]
dmub_rb_cmd's ramping_boundary has size of uint8_t and it is assigned
0xFFFF. Fix it by changing it to uint8_t with value of 0xFF.

This fixes 2 INTEGER_OVERFLOW issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_abm_lcd.c  | 2 +-
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_abm_lcd.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_abm_lcd.c
index 42c802afc4681..f5d1070e2b594 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_abm_lcd.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_abm_lcd.c
@@ -262,7 +262,7 @@ bool dmub_abm_set_pipe(struct abm *abm,
 {
 	union dmub_rb_cmd cmd;
 	struct dc_context *dc = abm->ctx;
-	uint32_t ramping_boundary = 0xFFFF;
+	uint8_t ramping_boundary = 0xFF;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.abm_set_pipe.header.type = DMUB_CMD__ABM;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
index 1b08749b084b1..840dfd2372475 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
@@ -142,7 +142,7 @@ static bool dmub_abm_set_pipe(struct abm *abm, uint32_t otg_inst,
 {
 	union dmub_rb_cmd cmd;
 	struct dc_context *dc = abm->ctx;
-	uint32_t ramping_boundary = 0xFFFF;
+	uint8_t ramping_boundary = 0xFF;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.abm_set_pipe.header.type = DMUB_CMD__ABM;
-- 
2.53.0



