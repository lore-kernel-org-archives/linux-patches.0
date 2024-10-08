Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B57165F08;
	Tue,  8 Oct 2024 12:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390061; cv=none; b=jIWa6E9k2h+rRbma+SPVxHWorkXn66mER8h2XlpGja0Xq/uvmAZVmJfK1+TZg+huTSEjqfbeE6vjScI+E2LCtoyN63ruU7cUkZsRtPjJGhucijTinSVtt7ygAEM5LaVMVeRolNGszPqb7OKjSh0KjATbwE7rLeadu1TXGWB1278=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390061; c=relaxed/simple;
	bh=NGHoaPTQbH+8clhTeOaNCdUg7eyT8L94HbfP0k1QLlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCtyVVRLXzRHA00RCLdSFUe52qZkUi/8Yl+PYEt+t66k9aUB5vhqNhj1RFMkKHq2f/nl6kpinH77cwO1yGePaH++RW0FWDwk5d+S96zg93TyWr0Bp0+IVKAfsXbDZzC7vCTcu3dRJEymSK4HnI+OFv3vX/hNcDdC14mvSUHa138=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUrrCJ5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUrrCJ5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3101CC4CEC7;
	Tue,  8 Oct 2024 12:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390060;
	bh=NGHoaPTQbH+8clhTeOaNCdUg7eyT8L94HbfP0k1QLlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUrrCJ5J3H4Yben3YtDmQOgaTnmhFlJzgA8WOSpj3NDNqW++RDiEAZhpYmH3T4QZs
	 a8UVcYL8COc0NiADGKjfkS3t1IhQZOhOMNKs+aED0IBTxWsozS01CbvRKT2U/zY4Yc
	 AoYowsRqinJP2JlgPj9NKxx9ZgYTTcpb4LSLAz6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 178/482] drm/amd/display: Add null check for head_pipe in dcn201_acquire_free_pipe_for_layer
Date: Tue,  8 Oct 2024 14:04:01 +0200
Message-ID: <20241008115655.309718313@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit f22f4754aaa47d8c59f166ba3042182859e5dff7 ]

This commit addresses a potential null pointer dereference issue in the
`dcn201_acquire_free_pipe_for_layer` function. The issue could occur
when `head_pipe` is null.

The fix adds a check to ensure `head_pipe` is not null before asserting
it. If `head_pipe` is null, the function returns NULL to prevent a
potential null pointer dereference.

Reported by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/resource/dcn201/dcn201_resource.c:1016 dcn201_acquire_free_pipe_for_layer() error: we previously assumed 'head_pipe' could be null (see line 1010)

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/resource/dcn201/dcn201_resource.c  | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn201/dcn201_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn201/dcn201_resource.c
index 070a4efb308bd..1aeede348bd39 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn201/dcn201_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn201/dcn201_resource.c
@@ -1005,8 +1005,10 @@ static struct pipe_ctx *dcn201_acquire_free_pipe_for_layer(
 	struct pipe_ctx *head_pipe = resource_get_otg_master_for_stream(res_ctx, opp_head_pipe->stream);
 	struct pipe_ctx *idle_pipe = resource_find_free_secondary_pipe_legacy(res_ctx, pool, head_pipe);
 
-	if (!head_pipe)
+	if (!head_pipe) {
 		ASSERT(0);
+		return NULL;
+	}
 
 	if (!idle_pipe)
 		return NULL;
-- 
2.43.0



