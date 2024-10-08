Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0EC1DE2AD;
	Tue,  8 Oct 2024 12:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391891; cv=none; b=aKZlXrj1pvRQjnokPzHdNp9V9Rrte4qtwrl5qs4ujXqzoqK0DwYij2SwJv8ymGDrs12mfpUis5aDnyoAXcwApEwwQEOdT8F8UdlL1S0UcrarGbBay0cboqrq437qaiJ0sPBqXz4edU/RA7VCp2gAsTEc3m+Juueiqii7fvm4nPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391891; c=relaxed/simple;
	bh=IjEe64gCEK0g4CeHTTzVzGL2bpUcjzHKdO/2NX3rA3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcrhSqoi2JCZqkWzNjPrUvA9wp4vXUOd4xj0fLhBRDYH8jSEWCSOI9gMRPrmj7fBEuTU7wF1dRL3pGogExUz7EtE0GZLcsxs6H1XieIZq1SwHPzvc8LFYkFpo6GrDcNcobwdKizD798kCxSlptUn98e4PUF6mWkM1gvMvzXMMAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcLMps4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcLMps4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C364BC4CECD;
	Tue,  8 Oct 2024 12:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391891;
	bh=IjEe64gCEK0g4CeHTTzVzGL2bpUcjzHKdO/2NX3rA3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcLMps4NZEwRQrwD5bCNW6BfEs4EuWlWnn2kJ21DtYHlJzz5jENy8viD1T1f1Ajb9
	 i0vAP+HdjTvL3jDamOUFNZUF9TQlfF3eqhATWuCBppdr6OKx/psd912d+bvAlNwMav
	 9k5R4EoLbCmxW5fKHaMavdcDf3bTmXJ6mERx3eAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 254/558] drm/amd/display: Check phantom_stream before it is used
Date: Tue,  8 Oct 2024 14:04:44 +0200
Message-ID: <20241008115712.331619326@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 3718a619a8c0a53152e76bb6769b6c414e1e83f4 ]

dcn32_enable_phantom_stream can return null, so returned value
must be checked before used.

This fixes 1 NULL_RETURNS issue reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
index 6e2a08a9572b8..8bacff23c3563 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
@@ -1720,6 +1720,9 @@ void dcn32_add_phantom_pipes(struct dc *dc, struct dc_state *context,
 	// be a valid candidate for SubVP (i.e. has a plane, stream, doesn't
 	// already have phantom pipe assigned, etc.) by previous checks.
 	phantom_stream = dcn32_enable_phantom_stream(dc, context, pipes, pipe_cnt, index);
+	if (!phantom_stream)
+		return;
+
 	dcn32_enable_phantom_plane(dc, context, phantom_stream, index);
 
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {
-- 
2.43.0



