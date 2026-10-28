Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213875;
	b=CH7Odh1zGcJaVE1ZdFUnaz4saGVbs9MylVfrsia+7dfQUzD7zgFGmBIjIRWALI6QXezd
	 BIq1ktUb69VzPFHSZMFcBLbAN+GhGLMkBfKeM+sBmmyrelE407+2brTV7WkcCsT2kig8o
	 TLmndEiFd6/h1hqH0oX5FnrmCU87jsQoIxkdtt1GKucxkWoXeVOSgqEEWyJ9hxHzuhiDa
	 B1Br+ty4uONfRXMMBCkvE9RiXj64Ikg5khpN5kbxQ3yOhr1prfX9xSZau9W/O3OdYpPiV
	 OIgqV+1X0aT7C52bxmJdO4NEqpWDW5APhrwmYYkIp8+neCsLTyyWR9x4/Mmv/dv0XnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RexffTnStg3ZBFdxtPZ37Dx3HsfXvd5ocfYovK/f26I=;
	b=RxatyshKDieMJKMe772EPVLkgq+WRrwXoLfZOWM8d/j4AUjg5TS+tyjUfea/hIe6mY1n
	 1axAHzuXenppcrLQLTwYBth8z5hmdjy9GQ9fDazdNs1v1GNNSnu11/JMQlI69o6WjnMS1
	 PcPUAUM99Ta+4BgTyS8RKbBtnTPdHs++KaSROaHTk81qU74X6tzkHs8gqVYoRc7WybPH+
	 CYMQ3WkvDloQrE4lRFG8Dj4p+4hRJXjNiD0NRKH2rZTygkt6iCyymTnQtOyAKRAL433/k
	 VFA5S/8SZ2JtZJmTkgdHKBV5J5iOO/ug+QpobO3AXPkNoXs5jm+emZY2hxNXhWQi4lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rt+8Z6hv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1287D606A31A;
	Wed, 28 Oct 2026 18:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rt+8Z6hv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BACC1F01825;
	Wed, 28 Oct 2026 18:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213874;
	bh=RexffTnStg3ZBFdxtPZ37Dx3HsfXvd5ocfYovK/f26I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rt+8Z6hvyqZSJviT41H6qy85FPf6sQuJm1p+DPRzs/gCijbM/mnDD8nZygtIidTi5
	 CIY7lyCExRk3yQeJHpdQeIZjm7yBLivrG+TIiarignYieTsqtlfeMTO+YgxRuco4X2
	 DX4wTKJnAllMIKgyjFhJCXhAf4ywOqGs/yxFpEvs=
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
Subject: [PATCH 6.1 0659/1887] drm/amd/display: Avoid overflow from uint32_t to uint8_t
Date: Wed, 28 Oct 2026 17:45:55 +0100
Message-ID: <20261028170514.408983991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4055d271ac57f..19a97da77df88 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_abm_lcd.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_abm_lcd.c
@@ -242,7 +242,7 @@ bool dmub_abm_set_pipe(struct abm *abm, uint32_t otg_inst, uint32_t option, uint
 {
 	union dmub_rb_cmd cmd;
 	struct dc_context *dc = abm->ctx;
-	uint32_t ramping_boundary = 0xFFFF;
+	uint8_t ramping_boundary = 0xFF;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.abm_set_pipe.header.type = DMUB_CMD__ABM;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
index 5910cde0408d0..10c63c47097a5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
@@ -141,7 +141,7 @@ static bool dmub_abm_set_pipe(struct abm *abm, uint32_t otg_inst, uint32_t optio
 {
 	union dmub_rb_cmd cmd;
 	struct dc_context *dc = abm->ctx;
-	uint32_t ramping_boundary = 0xFFFF;
+	uint8_t ramping_boundary = 0xFF;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.abm_set_pipe.header.type = DMUB_CMD__ABM;
-- 
2.53.0



