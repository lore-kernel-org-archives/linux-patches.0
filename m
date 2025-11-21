Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47F43446BD;
	Fri, 21 Nov 2025 13:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730983; cv=none; b=gV38HdSzaUjhC9gEETQgmAhXvn3Xuf1DmV5edZtgFNOjiPcTAe6aJKSMijfwrJ4h6So+k4BySqYeyIf8jJb2Vuh4cFDowJtHZU+mzfSCX+IsDyIo0r0uzWIlr3k4UyDF+pSt8jqgvyRVJSNZ9Z5ZltXx13Nq1oWHTxCJXSEcQpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730983; c=relaxed/simple;
	bh=OvPbYJKpomv0yCV1UfI80UUlj7KvP9MxpeoNCJrzRM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QVr/TssvoYTLK0KmhbUi9YCQEJ2U2JvMA/Cwe59pQLXC+swv93SP6lY02Qcv3tCsC2UgbpaAj0EOWgcVxf0k/DRkxi47M6BWKCYc7Bnh/EK2tXudacak7y4hTL7rSzFgOBXDEwkBxMJdZnd+Jcv9Lnkq8YaP/ZzfdP+SAEwHSBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UHv/7F2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UHv/7F2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099AEC16AAE;
	Fri, 21 Nov 2025 13:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730982;
	bh=OvPbYJKpomv0yCV1UfI80UUlj7KvP9MxpeoNCJrzRM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0UHv/7F2Ir2k3Ayz6o6a1Y04o1VDlY1dYdYrjeOa+71062tM4a4pDx4D9JAQNzAlR
	 5W6Xvx3iQCqbaoMlAZXzndxfsFyIkiJIyvAH3Nr9OuXkL9wGHcgGggWerKRJbLBUnN
	 CWnyj1zvIvP5BLKuAKX8Y7k/UOEWYTFJB9gST/BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 016/247] drm/amd/display: Disable fastboot on DCE 6 too
Date: Fri, 21 Nov 2025 14:09:23 +0100
Message-ID: <20251121130155.184142640@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 7495962cbceb967e095233a5673ea71f3bcdee7e ]

It already didn't work on DCE 8,
so there is no reason to assume it would on DCE 6.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 32fd6bdc18d73..537f538114607 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1923,10 +1923,8 @@ void dce110_enable_accelerated_mode(struct dc *dc, struct dc_state *context)
 
 	get_edp_streams(context, edp_streams, &edp_stream_num);
 
-	// Check fastboot support, disable on DCE8 because of blank screens
-	if (edp_num && edp_stream_num && dc->ctx->dce_version != DCE_VERSION_8_0 &&
-		    dc->ctx->dce_version != DCE_VERSION_8_1 &&
-		    dc->ctx->dce_version != DCE_VERSION_8_3) {
+	/* Check fastboot support, disable on DCE 6-8 because of blank screens */
+	if (edp_num && edp_stream_num && dc->ctx->dce_version < DCE_VERSION_10_0) {
 		for (i = 0; i < edp_num; i++) {
 			edp_link = edp_links[i];
 			if (edp_link != edp_streams[0]->link)
-- 
2.51.0



