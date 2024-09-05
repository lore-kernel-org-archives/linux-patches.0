Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B99198822;
	Thu,  5 Sep 2024 09:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530334; cv=none; b=BJv0L4EJfqK413CJjmbR3+TVXfXIHmmo1fwV2xPdEIqxSC/2l5j8vJ9UXoMQtiuvPWa/8bzEYQykgjesjVExtJZGqPlzPNfwb6vLL/BxVwVsHCRJhzBefVBCuoAeNfLQuefqo32D3ngTr2WSgrMM6KHu1aEIsJ3Elt8JFi+Id90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530334; c=relaxed/simple;
	bh=niSO8lyBPC6IWrHJqQBR4KbswuD2+uV5Wjqy/Esy4mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOTTajwku0k3pZNCDPKv9/+VbcO7j44gd3SsWrrYZFcB9jxmxVA2HhiEH2Kh/LO3kxDetVwobgOVAia4ij4hnt3G3bq7Jv4bDxbuhmGzVf5jK/M5Fv2oUWZYucg6RdHQgoNRknfyxeAJsaS3cmE5Xb+qbUXDaEDiAtLOvfUrDZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odKTUcIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odKTUcIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58676C4CEC3;
	Thu,  5 Sep 2024 09:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530333;
	bh=niSO8lyBPC6IWrHJqQBR4KbswuD2+uV5Wjqy/Esy4mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odKTUcIvNfrBJFGGDI+lu+JzEGnHYQLjD36OtGJAiYhlUz61Mrcby9McRP99WV0q6
	 6zFaCVkFcCRlIj5cDJkuvMk/xM/WvXUppUEi86GF0p9XRaR7d780oXZoO+YZpsxUTt
	 TIWBdPmaZgLdk1qofDJOF11XYhJpvVYvfXZOpJTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	winstang <winstang@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/132] drm/amd/display: added NULL check at start of dc_validate_stream
Date: Thu,  5 Sep 2024 11:41:51 +0200
Message-ID: <20240905093727.038074240@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: winstang <winstang@amd.com>

[ Upstream commit 26c56049cc4f1705b498df013949427692a4b0d5 ]

[Why]
prevent invalid memory access

[How]
check if dc and stream are NULL

Co-authored-by: winstang <winstang@amd.com>
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: winstang <winstang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 84923c5400d3..733e445331ea 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -3927,6 +3927,9 @@ void resource_build_bit_depth_reduction_params(struct dc_stream_state *stream,
 
 enum dc_status dc_validate_stream(struct dc *dc, struct dc_stream_state *stream)
 {
+	if (dc == NULL || stream == NULL)
+		return DC_ERROR_UNEXPECTED;
+
 	struct dc_link *link = stream->link;
 	struct timing_generator *tg = dc->res_pool->timing_generators[0];
 	enum dc_status res = DC_OK;
-- 
2.43.0



