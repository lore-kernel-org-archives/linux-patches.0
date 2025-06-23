Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288B31E487;
	Mon, 23 Jun 2025 13:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686107; cv=none; b=Qin3LmzIkMqiZAg+dfnNcBB3LcHslvJnaCVRIkyYaLOwLm/R8Dr+omV7q6dgoWI/WGxHOR0nQEz8r7hzCpAB2ellOPB+YhvBMvWbLjDKQIWDxySMvYdryoIu5A/uk2lvqTeTQeBpdVwHgJ8LrVFElawmEByIFDL1Io2KyDs1V68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686107; c=relaxed/simple;
	bh=hhxfObArWSJGG1bppGmi1LCwGA4B6fJfQlER4BOPi3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJE4v71bDYfK6uSmVuSpHm+fHhY1bqA5bBqvIZYYLLb0J3FKquXO9nLukqSn20NQpb5kR0cqZSUpP1oWmE2X79tCe+IE/4zdFvb5FF9q5Xk/ElrmYN3FMr46JEilhlMquavEXvgtR7Jt5g+J1JMexDplXP7M8eJHEVMsq2c/QUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSStsSET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSStsSET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3238C4CEEA;
	Mon, 23 Jun 2025 13:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686107;
	bh=hhxfObArWSJGG1bppGmi1LCwGA4B6fJfQlER4BOPi3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSStsSETcWyB4ljLKM2Fq6QRI4/usbAT32j7jv3VzTddiLWsV3Kpp0E5jK9gUHTK4
	 uvo59C+MC5id6fUHF6MPNxUsI/95pekAZtbq6Wxz8Xu1W/yl9iPcBndge1Da3Tffrj
	 Iv2UXp5QfmVgD2VEYjNZ3N8CHMByvNstJ4BUODHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Ovidiu Bunea <Ovidiu.Bunea@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 281/592] drm/amd/display: Update IPS sequential_ono requirement checks
Date: Mon, 23 Jun 2025 15:03:59 +0200
Message-ID: <20250623130707.028697270@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Bunea <Ovidiu.Bunea@amd.com>

[ Upstream commit b4db797117ceba88ba405a080811369418104304 ]

[why & how]
ASICs that require special RCG/PG programming are determined based
on hw_internal_rev. Update these checks to properly include all such
ASICs.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Ovidiu Bunea <Ovidiu.Bunea@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dpp/dcn35/dcn35_dpp.c           | 2 +-
 drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c | 2 +-
 drivers/gpu/drm/amd/display/dc/resource/dcn36/dcn36_resource.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dpp/dcn35/dcn35_dpp.c b/drivers/gpu/drm/amd/display/dc/dpp/dcn35/dcn35_dpp.c
index 62b7012cda430..f7a373a3d70a5 100644
--- a/drivers/gpu/drm/amd/display/dc/dpp/dcn35/dcn35_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dpp/dcn35/dcn35_dpp.c
@@ -138,7 +138,7 @@ bool dpp35_construct(
 	dpp->base.funcs = &dcn35_dpp_funcs;
 
 	// w/a for cursor memory stuck in LS by programming DISPCLK_R_GATE_DISABLE, limit w/a to some ASIC revs
-	if (dpp->base.ctx->asic_id.hw_internal_rev <= 0x10)
+	if (dpp->base.ctx->asic_id.hw_internal_rev < 0x40)
 		dpp->dispclk_r_gate_disable = true;
 	return ret;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
index ffd2b816cd02c..8948d44a7a80e 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
@@ -1903,7 +1903,7 @@ static bool dcn35_resource_construct(
 	dc->caps.max_disp_clock_khz_at_vmin = 650000;
 
 	/* Sequential ONO is based on ASIC. */
-	if (dc->ctx->asic_id.hw_internal_rev > 0x10)
+	if (dc->ctx->asic_id.hw_internal_rev >= 0x40)
 		dc->caps.sequential_ono = true;
 
 	/* Use pipe context based otg sync logic */
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn36/dcn36_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn36/dcn36_resource.c
index b6468573dc33d..7f19689e976a1 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn36/dcn36_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn36/dcn36_resource.c
@@ -1876,7 +1876,7 @@ static bool dcn36_resource_construct(
 	dc->caps.max_disp_clock_khz_at_vmin = 650000;
 
 	/* Sequential ONO is based on ASIC. */
-	if (dc->ctx->asic_id.hw_internal_rev > 0x10)
+	if (dc->ctx->asic_id.hw_internal_rev >= 0x40)
 		dc->caps.sequential_ono = true;
 
 	/* Use pipe context based otg sync logic */
-- 
2.39.5



