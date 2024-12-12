Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9B722654A;
	Thu, 12 Dec 2024 16:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019998; cv=none; b=ldEnRavdjKvgRJXcz1zusoaOKLCRq1WcYMEfLPVUq6N5BYgYXxd07PLBhSU2kloXrw+gIsutyA37a+ALBaM1c/h8waRoVa0chF+GJeGPCDy62mqtZdVugwgkNp5tTFRTqGZBiX8xdSCT1EEp5efqbW+lzyWLE+yGUcu6j4WKOBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019998; c=relaxed/simple;
	bh=4lRJK/R2FDDknHaGuEjyWnQ6X/eY9v83W7HtQotP1lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgnaDmiWfilihO5q5EL9wAhDPtxzC5+OdNHBx94aiozE5qyMwiH4Lt4mSZGIF/RbO6PpgfCFgj0mxgod5ctUR3XiKYU58lWCx4bfu/uwkG3QXOzhE8ZF8UpNA0KY2tIn4tcTNkluDVF0C0j0Sp2VYeqD/tTUOw9E1OxzaK4BENU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nIBERYJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIBERYJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3C1C4CED0;
	Thu, 12 Dec 2024 16:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019998;
	bh=4lRJK/R2FDDknHaGuEjyWnQ6X/eY9v83W7HtQotP1lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nIBERYJ0SpETHEEnZJKw5t43wan1JpB/hEGNws2MZDDHOa8W/uAdwPAAe/Vy6isCl
	 YMxOERB1R+YeLQe+M9ilbVHtCYXcvuNRM8fJEFhi/tYvYw2U0K80MMYG9It/Jd7iKI
	 aisrCu9BcHxKLxjPUQamjDHCzrRLsG8/ADWbUmCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 350/772] drm/amd/display: Check phantom_stream before it is used
Date: Thu, 12 Dec 2024 15:54:55 +0100
Message-ID: <20241212144404.372524516@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit 3718a619a8c0a53152e76bb6769b6c414e1e83f4 upstream.

dcn32_enable_phantom_stream can return null, so returned value
must be checked before used.

This fixes 1 NULL_RETURNS issue reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Xiangyu: BP to fix CVE: CVE-2024-49897, modified the source path]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -1796,6 +1796,9 @@ void dcn32_add_phantom_pipes(struct dc *
 	// be a valid candidate for SubVP (i.e. has a plane, stream, doesn't
 	// already have phantom pipe assigned, etc.) by previous checks.
 	phantom_stream = dcn32_enable_phantom_stream(dc, context, pipes, pipe_cnt, index);
+	if (!phantom_stream)
+		return;
+
 	dcn32_enable_phantom_plane(dc, context, phantom_stream, index);
 
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {


