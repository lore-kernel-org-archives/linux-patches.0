Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E17168C4;
	Mon, 27 May 2024 19:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837653; cv=none; b=tgglTbcIbNtk6gCAySFTnRyk2r2pGz0J6FwKvrkswqc9XXa2y08InYM27huNzCMmf5KvghCUnLSZsIl/Zf301gl9h6WyypuBLDLJBSRslgOlFc+I1pPjFGMjrVAGkCtfhjTpMV33EUT6UQFAdCkmygblouiIeY9rb4vPXp1mycQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837653; c=relaxed/simple;
	bh=PlOttVY5sp6isk5522uAUXxPYnv5PxR2dvUqpUIa8Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rr2J6QIqrBt/FuulA0r8seOnLbvhYBLRz0XoYmuvt7cRNnZcPX6syLKMhL84U+HHWZdEVNid9mceFq8hppQe3yfgMRZ2PRdGSVm7VbBpeHZvzYj99cfDNb4rH0GeuAYudmNVx8kAkSjPvy5VJ6A3sVjwhIgVbM1l2zm8PzNPOnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMWGjFUa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMWGjFUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD13C2BBFC;
	Mon, 27 May 2024 19:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837653;
	bh=PlOttVY5sp6isk5522uAUXxPYnv5PxR2dvUqpUIa8Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hMWGjFUaT+ADTI8xRMVnFqmh1zPNOhCKzk2Kls4cBh4hMdMTBJKi5g4Gjr+hTk3jR
	 9wqt8fBRiXLEECvmQuuT7dvLbaTuWijouIs16WqtZhBz3SvVx6LK/CtSHZtGNoFDX2
	 WIicDxWDG2APkrmm8XeH9CB7CJ7D3Gt/2JvYEfLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 093/493] drm/amd/display: Ensure that dmcub support flag is set for DCN20
Date: Mon, 27 May 2024 20:51:35 +0200
Message-ID: <20240527185633.452304287@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit be53bd4f00aa4c7db9f41116224c027b4cfce8e3 ]

In the DCN20 resource initialization, ensure that DMCUB support starts
configured as true.

Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn20/dcn20_resource.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn20/dcn20_resource.c
index f9c5bc624be30..f81f6110913d3 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn20/dcn20_resource.c
@@ -2451,6 +2451,7 @@ static bool dcn20_resource_construct(
 	dc->caps.post_blend_color_processing = true;
 	dc->caps.force_dp_tps4_for_cp2520 = true;
 	dc->caps.extended_aux_timeout_support = true;
+	dc->caps.dmcub_support = true;
 
 	/* Color pipeline capabilities */
 	dc->caps.color.dpp.dcn_arch = 1;
-- 
2.43.0



