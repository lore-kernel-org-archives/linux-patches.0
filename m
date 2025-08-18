Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DFD322DA2;
	Mon, 18 Aug 2025 13:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523782; cv=none; b=jIMENikeIag/fdO0xueiqdeVp8LEzt1W6G1TmBDj3ij+9eLu2FO1SNv8zIG7fCHdAC5ghPxsK6ktfCgnQ3GWbuvzRPyZphjN4wOVe+CwT/KtMa20H5FXzxUp4OXNGIeM/+whVMJthlE3KhEJN3zn/f7lZtGRVeOLPE9Xt2eRtYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523782; c=relaxed/simple;
	bh=kJUmP4IRVMFrwdqKYEKuU3BRNObWSv3mx2INivwLK0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaciiKvaPrggyVOd0a949mzp2LubayXWcNM46DSyRms1F0q3v+q1DiYOacQ7lln9Vwa8TGnYPlS9FdunOM8T1ej4dHfW3QcAUAtULj6DsObs7y8PfsnFKgbizgsvZvOkCqe+4p2dzniolUiOgNQOv3jLSdLQ581fE0d8+Nuz9cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OC3y2MOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OC3y2MOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97587C4CEEB;
	Mon, 18 Aug 2025 13:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523782;
	bh=kJUmP4IRVMFrwdqKYEKuU3BRNObWSv3mx2INivwLK0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OC3y2MOWjxqUIhorCnhYMFUgsQU/8zSvL3heTuBhC01Xo3+LW3Y4Yhllba8rerBWt
	 BmTA/f7zpyeNBy7TNEOhvELqlOm8zFoDLZXQ36Tp7FUkCqoQYiebT+2brYKasrAq2T
	 stZU8tu9B+tNydK0E3V7UMbp1FlqvDy3tL7PgLNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nevenko Stupar <nevenko.stupar@amd.com>,
	Ilya Bakoulin <Ilya.Bakoulin@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 272/515] drm/amd/display: Separate set_gsl from set_gsl_source_select
Date: Mon, 18 Aug 2025 14:44:18 +0200
Message-ID: <20250818124508.889795422@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Ilya Bakoulin <Ilya.Bakoulin@amd.com>

[ Upstream commit 660a467a5e7366cd6642de61f1aaeaf0d253ee68 ]

[Why/How]
Separate the checks for set_gsl and set_gsl_source_select, since
source_select may not be implemented/necessary.

Reviewed-by: Nevenko Stupar <nevenko.stupar@amd.com>
Signed-off-by: Ilya Bakoulin <Ilya.Bakoulin@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index 846c9c51f2d9..637f1235d0b7 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -273,14 +273,13 @@ void dcn20_setup_gsl_group_as_lock(
 	}
 
 	/* at this point we want to program whether it's to enable or disable */
-	if (pipe_ctx->stream_res.tg->funcs->set_gsl != NULL &&
-		pipe_ctx->stream_res.tg->funcs->set_gsl_source_select != NULL) {
+	if (pipe_ctx->stream_res.tg->funcs->set_gsl != NULL) {
 		pipe_ctx->stream_res.tg->funcs->set_gsl(
 			pipe_ctx->stream_res.tg,
 			&gsl);
-
-		pipe_ctx->stream_res.tg->funcs->set_gsl_source_select(
-			pipe_ctx->stream_res.tg, group_idx,	enable ? 4 : 0);
+		if (pipe_ctx->stream_res.tg->funcs->set_gsl_source_select != NULL)
+			pipe_ctx->stream_res.tg->funcs->set_gsl_source_select(
+				pipe_ctx->stream_res.tg, group_idx, enable ? 4 : 0);
 	} else
 		BREAK_TO_DEBUGGER();
 }
-- 
2.39.5



