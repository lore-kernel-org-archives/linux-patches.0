Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215139;
	b=tBAjGxjWACHkvQnYfD+0ZvPuBzcT1IrXr/YlLtmNfwJbibMelbBMO6gCe2xOP0RpMDr6
	 SknXN/xNAr5CVQzXlUO7uhEw5cyhXUP1vBy0kdGtO354EGmUvffidHtY5lGf36L5UCaha
	 OXQ+dLSPTOt2Xn3QGc2/kq991El3Cd1SxkANmJKDjkBc0DGlx3xTDDG9djORz37ZsRE1+
	 wspDaql+DrLwUWroduNQssBjrNC6+dUOr5Y+NHRYzixffnp4wV2QARdAkQjqHOo/Ka1FV
	 rS/fKpHyDPA7RRJ0w85HM3d6stNQfi5RZKLgIM+AV+AP/+r3D6WvtUImeMuMB/Xk7Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IQcMkcn8I9XjAYF7UX8bhDNGcSIHmpeOzervrkHKimk=;
	b=2J+jbtyFeXdJC0x4hfPZ4sSv34ilY89uoe5mpU5xZs2Bmy4WWWj/+Rx8pMYgFoS4adPN
	 aR6+8T7fGl6a0PwjsunrBm7MYUMmRxl8MVq5O8QB6RG7mtnNIjy2KfMarwe3BvgaxS8Zy
	 eH8tR+w/omYPnb0L1nqeZd1OkV3fmW4qkXh0GiRM2aqnZrteDZUYthPQKWmXY5iG4nImN
	 vaFBM1RElcOQQvYtO10/UY77JRopJ39z+tTRBlnubrX/UMuHl8vBgmpfOMzwnFnkJxgKs
	 QRLgnVn1mFJAJbTT2tqwKrkO0/lsIPyzEDlQ3bXLbl9aNoL9emJqd0aFPo/ac081hSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lyp2PxrT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D4760A2623;
	Wed, 28 Oct 2026 19:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lyp2PxrT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967BB1F01825;
	Wed, 28 Oct 2026 19:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215139;
	bh=IQcMkcn8I9XjAYF7UX8bhDNGcSIHmpeOzervrkHKimk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lyp2PxrTRonttGA7EI+F6Jy670kqc0vGLpMe0dCeat24cqMtQEkPtncw0fbI1IEWP
	 gbPeJte3+yRbRuMbS9ZhhqGb/jmzg4u+10l/XYR/3kmCALT24EY3MArNKbq77vdMoH
	 t9v2/p4S6mK+D0ctaLIJ8UNRySF7noMiqWIHE41s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1106/1887] drm/amd/display: Avoid NULL dereference in dc_dmub_srv error paths
Date: Wed, 28 Oct 2026 17:53:22 +0100
Message-ID: <20261028170524.573745018@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 4ae3e16f4b3bf64140f773629b765d605ee079a9 ]

In dc_dmub_srv_log_diagnostic_data() and
dc_dmub_srv_enable_dpia_trace().

Both functions check:

  if (!dc_dmub_srv || !dc_dmub_srv->dmub)

and then call DC_LOG_ERROR() inside that block.

DC_LOG_ERROR() uses dc_dmub_srv->ctx internally. So if
dc_dmub_srv is NULL, the logging itself can dereference a
NULL pointer and cause a crash.

Fix this by splitting the checks.

First check if dc_dmub_srv is NULL and return immediately.
Then check dc_dmub_srv->dmub and log the error only when
dc_dmub_srv is valid.

Fixes the below:
../display/dc/dc_dmub_srv.c:962 dc_dmub_srv_log_diagnostic_data() error: we previously assumed 'dc_dmub_srv' could be null (see line 961)
../display/dc/dc_dmub_srv.c:1167 dc_dmub_srv_enable_dpia_trace() error: we previously assumed 'dc_dmub_srv' could be null (see line 1166)

Fixes: 2631ac1ac328 ("drm/amd/display: add DMUB registers to crash dump diagnostic data.")
Fixes: 71ba6b577a35 ("drm/amd/display: Add interface to enable DPIA trace")
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
index 784c8144d2d0f..51e2debcf1c8c 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -804,7 +804,10 @@ void dc_dmub_srv_log_diagnostic_data(struct dc_dmub_srv *dc_dmub_srv)
 {
 	struct dmub_diagnostic_data diag_data = {0};
 
-	if (!dc_dmub_srv || !dc_dmub_srv->dmub) {
+	if (!dc_dmub_srv)
+		return;
+
+	if (!dc_dmub_srv->dmub) {
 		DC_LOG_ERROR("%s: invalid parameters.", __func__);
 		return;
 	}
@@ -1042,7 +1045,10 @@ void dc_dmub_srv_enable_dpia_trace(const struct dc *dc)
 	enum dmub_status status;
 	static const uint32_t timeout_us = 30;
 
-	if (!dc_dmub_srv || !dc_dmub_srv->dmub) {
+	if (!dc_dmub_srv)
+		return;
+
+	if (!dc_dmub_srv->dmub) {
 		DC_LOG_ERROR("%s: invalid parameters.", __func__);
 		return;
 	}
-- 
2.53.0



