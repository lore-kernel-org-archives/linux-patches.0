Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028784;
	b=IilX6xEIKLHsIoM/MmX+nUvZJxD2OBgcH6a72sZ+bAIPWhNwjILUEW1jldM5PkqjLNOK
	 0JInKZKEOMHbShIqM03nEAnXapGd0ILfK3RHrTjBQ1lGbVwnNHwm7y23/Rl/XYBkLDYrv
	 7p2KGECxWbIVQTATgguJw3ZRvuV6vOGC/aQ9YoVSMcS2ZAfICWenXHW6vLCEsj2c+84zF
	 tc9yo0TKjKufehgvZOqIQcnZMGDerPuTp8+nU08CIaveqQtrJRRyPPgcz0g5A4ZHX9929
	 nSM+5DEHV1NXF0eT9fhEjH2suvEwfza9cWy84CcSMT+JYOT2Slt+OOLTyutUnQkURzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gfube3oPoOa1kGrpijyvmkzhONa8K1waRWdNtxpK8YY=;
	b=hlNvREUCGdgZx2p+2MSLAv5fp6KAMOJU7lreP/3RD2M3MvicUykb4R4IkhW8sMgnCgW0
	 a0ad2J+Bi8XRVMDwJrhnovPShSA6/nx92QFJYW8oDObB2H8ddkMdmj+V6z1p5nFxWhS2S
	 0FtJ0jquxnGFzYL9E9+gKp2WakopOojiyPcVNCuKnL1YsmA96yeT+pjtmyfAHuwPVxeXj
	 AjJ1zVBmplAwvOTq3YNSOMlYiau3CguUq3eickaNsjcd3dl+JPCguunqUoq2V9YUA7Bo0
	 vG+W5J/9aNDVTcFeyXjJztj3B73YEKTM6jTtXkpseGh9oLWzDnhriUNQ/ZwMzZvlikg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZK6JUqPN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43CF606A32F;
	Wed, 18 Nov 2026 19:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZK6JUqPN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1331F000C4;
	Wed, 18 Nov 2026 19:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028784;
	bh=Gfube3oPoOa1kGrpijyvmkzhONa8K1waRWdNtxpK8YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZK6JUqPNDoQvTmBjjeDook7C86fL/XYMROlqfKSNQrxMji2+ibibNKqKiVCuhzvx6
	 mRV9fS7IRJ+U3Oluq0O9wWXm8Rbmf6c19XsF35QQE0rT6WqAmKxE/ec3UWryHUkIIZ
	 JGS+05aTyNmTg4hO91FSjeQTy++g4DH0ZxwyaaH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Ilya Bakoulin <Ilya.Bakoulin@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0119/1756] drm/amd/display: Minimize wait for pending updates
Date: Wed, 18 Nov 2026 15:37:26 +0100
Message-ID: <20261118150012.925314597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Bakoulin <Ilya.Bakoulin@amd.com>

[ Upstream commit caccee7b296b1f6c37f09b5d4808606c66438e9d ]

[Why/How]
Move the wait for pending updates past prepare_bandwidth if the previous
update was not a full update to reduce the average time it takes to
complete a full update.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Ilya Bakoulin <Ilya.Bakoulin@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: f3afbf7d832a ("drm/amd/display: Reset DET of HUBPs without a plane before outstanding updates")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index ad1cc546ba48d..0975616b53004 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3802,7 +3802,7 @@ static void commit_planes_for_stream(struct dc *dc,
 	dc_exit_ips_for_hw_access(dc);
 
 	dc_z10_restore(dc);
-	if (update_type == UPDATE_TYPE_FULL)
+	if (update_type == UPDATE_TYPE_FULL && dc->optimized_required)
 		hwss_process_outstanding_hw_updates(dc, dc->current_state);
 
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {
@@ -3829,6 +3829,9 @@ static void commit_planes_for_stream(struct dc *dc,
 		context_clock_trace(dc, context);
 	}
 
+	if (update_type == UPDATE_TYPE_FULL)
+		hwss_wait_for_outstanding_hw_updates(dc, dc->current_state);
+
 	top_pipe_to_program = resource_get_otg_master_for_stream(
 				&context->res_ctx,
 				stream);
-- 
2.53.0



