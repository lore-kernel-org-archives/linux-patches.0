Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEA91B87E8;
	Tue, 26 Aug 2025 13:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214459; cv=none; b=t5ZXokfwgbLAeKBMD14WBeElHwFNJ/7mk4XjprCvE7F81QcyPcRJ11BFDpZDGOZgDjhPEXylonVEL3ZLFkzxN2VrdlOV79QRauDhZiOFOEZK3rWtS2IPE/tO86vP0/3+sV6b+87tgfN7OtZZhh3CaHxHqZbClGlKTjTETvkiftM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214459; c=relaxed/simple;
	bh=RdSUXSNEorZVt56zWQtdomExEoiIM5tuYdj6h+cKTk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rlf4F5nmcnvelv3x+wFAm4H0oXp+uH23YMvGBcOuCOHuNZwsyTzNWw3lWfSdR/rCK1L44RjW8h0Qllz12H7fBKdk+rJoBOokhmnp6+ZqAZR9uZ9ONk+rinFgVhNSIbOGV7QAFaiirt7K6Lpok83Kjje8NtivSbdxuFbFziZ7JFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2MnMsQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2MnMsQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CE3C4CEF1;
	Tue, 26 Aug 2025 13:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214458;
	bh=RdSUXSNEorZVt56zWQtdomExEoiIM5tuYdj6h+cKTk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2MnMsQemXWIY9v+/dWnAxsoW7BYxW8ei90GAdAaOWWvu9n19rR8ZXWyD70UV/Vfi
	 BYSMOGWBJXUjit7Ksuzn9Te0eGhXM6cCzjxzxlBZJlBXpk8v4NNUOhgoFzkeT9wKz2
	 ptVTCLubgDeWL7J2N0yq1ICQHxWmHnKzplP5WSwA=
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
Subject: [PATCH 6.1 144/482] drm/amd/display: Separate set_gsl from set_gsl_source_select
Date: Tue, 26 Aug 2025 13:06:37 +0200
Message-ID: <20250826110934.373574335@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 81b1ab55338a..d8cf5f20ef3b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -164,14 +164,13 @@ static void dcn20_setup_gsl_group_as_lock(
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



