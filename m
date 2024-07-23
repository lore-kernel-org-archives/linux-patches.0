Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B18158211;
	Tue, 23 Jul 2024 18:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760281; cv=none; b=XUJzgOeACZ/Z0K+F1lJsxnixnZzH9gZNu+KIc9MpOw8O2QQYqS1pwEvX+/LAlGDBZTQBEMEKKV23AK3s9PxH6/XnrYlNrADvc7vfSrt+uSAqEYNxBs77Ujl4p9l+1IznaCEK7tL7t4LaGe5Iboz47qWR+OhKgbdRKtuT/uhgHsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760281; c=relaxed/simple;
	bh=uvk5+bAdHKthUjIVeKQAW198mf+EPGVSu6Wzz7Z27Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uI2XM7vfU9cAxSyMG6pCGGOVCflZAA12ShOGyoYY3HzIF5nV+k4zfv986TPHOw2oNTFVQgeD/pYdf0rAg2a5NgfsH3o/mLKZPmUnJwlDx+lE0gCoW1FzZa0OgsmrvEvQSEfwPWF49UogtS4vKVwiP/5uCta8fCaOo1ycqkMbfAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDIXPvQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDIXPvQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564B0C4AF09;
	Tue, 23 Jul 2024 18:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760281;
	bh=uvk5+bAdHKthUjIVeKQAW198mf+EPGVSu6Wzz7Z27Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDIXPvQaFH0e6XLyDlJ7sw5fDZSE965j7aoc9wIlsKg47DVbb8Sq/edosh0n4MRrI
	 JJ1gLh6u1pLXFJFrJ344XiN3s4Lk+IStRzlyfwu5/Tc6fVNabxrT2yKyF1PXQT5bWP
	 EK2aYjBF1WUsuwMpeXQG28fuGP6hNA2HuJ/gc4Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 136/163] drm/amd/display: Update efficiency bandwidth for dcn351
Date: Tue, 23 Jul 2024 20:24:25 +0200
Message-ID: <20240723180148.727612258@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit 7ae37db29a8bc4d3d116a409308dd98fc3a0b1b3 ]

Fix 4k240 underflow on dcn351

Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
index a20f28a5d2e7b..3af759dca6ebf 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
@@ -233,6 +233,7 @@ void dml2_init_socbb_params(struct dml2_context *dml2, const struct dc *in_dc, s
 		out->round_trip_ping_latency_dcfclk_cycles = 106;
 		out->smn_latency_us = 2;
 		out->dispclk_dppclk_vco_speed_mhz = 3600;
+		out->pct_ideal_dram_bw_after_urgent_pixel_only = 65.0;
 		break;
 
 	}
-- 
2.43.0



