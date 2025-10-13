Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A528B30ACEA;
	Mon, 13 Oct 2025 15:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367707; cv=none; b=WSV3E3RWm/BKYNjVoIsNHAuhuwKd5QY8cx/8V7PGzBHQL8ewZy8T7C2n2jb9onw8PL+umBzRf6Qz6Exu9HABpTG8gp5tjgWKwCtiorKfimAUax6StfG1H2JeZ6Td3j/fhkB5d6YtX+Avw4LkthHtwH2yt5UGuAHUZLi+N2uQNk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367707; c=relaxed/simple;
	bh=Kx1g2Z7eOXqKUgBDW6g8yU+bdPj9AiBWyDXo6wOyJNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+Us2oDty2JjtZ3BpNtDutg2lsOo4TeNfKlt6Yd+pGBO9re+M/IPPEryP27LiaYOzSLbs7M0YQ8ZeztL8wfKX70L3rjnEWxu8OL9mrhcXCnKwnBLlEUge7W1vc7mpupJkHUpkBRJkGO6sGj1KnfBKgkl8lZNKQ2xYOoa5y8sjaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8pOzXEY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8pOzXEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302DDC4CEE7;
	Mon, 13 Oct 2025 15:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367707;
	bh=Kx1g2Z7eOXqKUgBDW6g8yU+bdPj9AiBWyDXo6wOyJNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8pOzXEY36OtX0KkTXb84tnp+j9mvN4J00hQsdrN5uHfDqqgreYatJHLorYzgo/MO
	 xp4wlVG4T7XEBadVQGxjvwUipt8D2MGtinbMTbuFH+0FZrfPyFDIdUGIbk6GJFs28M
	 aZMhABwSxhANXqklPyAvDjH9r18v9ZUIMYF3HIn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/196] drm/amd/display: Remove redundant semicolons
Date: Mon, 13 Oct 2025 16:44:22 +0200
Message-ID: <20251013144317.760737811@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Liao Yuanhong <liaoyuanhong@vivo.com>

[ Upstream commit 90b810dd859c0df9db2290da1ac5842e5f031267 ]

Remove unnecessary semicolons.

Fixes: dda4fb85e433 ("drm/amd/display: DML changes for DCN32/321")
Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c    | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
index 9ba6cb67655f4..6c75aa82327ac 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
@@ -139,7 +139,6 @@ void dml32_rq_dlg_get_rq_reg(display_rq_regs_st *rq_regs,
 	if (dual_plane) {
 		unsigned int p1_pte_row_height_linear = get_dpte_row_height_linear_c(mode_lib, e2e_pipe_param,
 				num_pipes, pipe_idx);
-		;
 		if (src->sw_mode == dm_sw_linear)
 			ASSERT(p1_pte_row_height_linear >= 8);
 
-- 
2.51.0



