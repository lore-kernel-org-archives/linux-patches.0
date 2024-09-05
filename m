Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFFB196446;
	Thu,  5 Sep 2024 09:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529549; cv=none; b=MItE+LiBMMc7bivASSWTYzwo90P3yaSr8EJLI3o+3QP+pP6bsoceyCooF7qXPKtyg2i3+jAP+uvfDEZtr+88DSKfKNMv2yTw7yqfrwV2rWH+2OuoKeARy7YTh8vKyI5JBjWCR/MlaNwIlA+OBy8p3e0VUkAgqhQ44yXjVqqRM+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529549; c=relaxed/simple;
	bh=E8mXhFKFKrJgfvPBOiUtfMtDu6ktsCsq+rPsdp/0LWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDgRWQpeezVmNiqCk2+wFsmi+eHpAd1RhcHn054tms68/Wh7rLTpWaChQtO6m19gYlJeMi1Ar8bruwp/EBt6plTUbkMdOJSSfOmw1roDUoGrz7tcoq1WEqvuLFQAxwLA75ezyCIIG4mf/1OzdDmrDGwvoyitnY2VeLHpSpsVypI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvmetpMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvmetpMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5841BC4CEC3;
	Thu,  5 Sep 2024 09:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529548;
	bh=E8mXhFKFKrJgfvPBOiUtfMtDu6ktsCsq+rPsdp/0LWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvmetpMf/IX0Wn3rRCyoXHsLd5GAOaqApjkR68pFR/zgXy5tq2lRmEIRlslK7Lyh5
	 KwnxUcHWJcJs32bLWwNZhTcOvT+t9DsyXqLeCrMI8r1mNN6/qHQyZubUG2GDAu0DAf
	 Ng9Kyb9r0MVHoEz3F0/RKKE8BcvgSzAAhZ7ZroIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 069/184] drm/amd/display: Add otg_master NULL check within resource_log_pipe_topology_update
Date: Thu,  5 Sep 2024 11:39:42 +0200
Message-ID: <20240905093734.933714009@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit 871cd9d881fa791d3f82885000713de07041c0ae ]

[Why]
Coverity reports NULL_RETURN warning.

[How]
Add otg_master NULL check.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index ce5adb8bc377..b43e489e8d61 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -2283,6 +2283,9 @@ void resource_log_pipe_topology_update(struct dc *dc, struct dc_state *state)
 					state->stream_status[stream_idx].mall_stream_config.paired_stream);
 			otg_master = resource_get_otg_master_for_stream(
 					&state->res_ctx, state->streams[phantom_stream_idx]);
+			if (!otg_master)
+				continue;
+
 			resource_log_pipe_for_stream(dc, state, otg_master, stream_idx);
 		}
 	}
-- 
2.43.0



