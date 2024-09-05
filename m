Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17271991A1;
	Thu,  5 Sep 2024 09:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529869; cv=none; b=qDzgq4PQ20iQ6To2NQktNrvaX3zwycygbXy7XIUqfVXZOUiSYAdaqVKhlYEl6pVforweKssNRNNS/7wt9cg4IGenzegc+80bTbCV3jfkYag5o+944WYJUljKRIO8BRs5rK1NazueNFl3qdDENLCnVGdsrdopN1bRqjlaKP+Fbdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529869; c=relaxed/simple;
	bh=1pEk82SfYXv5AfQQIatIlXyRs2jjMLM0t+++QA/Y0KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4aaIlKUELE1d88NlUY8+8cKZXbztqttlRtP/UL5c3RhOirhu/aza0/jAyG2VMAWgOzEGh/Yl114ogfDjUZhq/6eWAQ3K1j/c8hwMc2CCe5+l4Qqg9nAj8AQHJy30+UFSjy0hNwC7p3JCZIsm4vcD5Ohk+pvfkyS469l+84i96k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuWyoY/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuWyoY/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DFDC4CEC3;
	Thu,  5 Sep 2024 09:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529869;
	bh=1pEk82SfYXv5AfQQIatIlXyRs2jjMLM0t+++QA/Y0KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uuWyoY/CBw7L6Oy8IRxMw9y5QPJ0lVVUnlzuOSW9HMNURAHCHEUSwZ+2MCdg33sXj
	 05i6tESTPkV5Dad8MnpgRdw1VE3tkQ5MOHlRY5tvL9nV/7ujkjQnsvpzq8lppPw37A
	 07ALduhh3fKzu3ybNMYKPOrovbzw37AdJRVy8ups=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	winstang <winstang@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 168/184] drm/amd/display: added NULL check at start of dc_validate_stream
Date: Thu,  5 Sep 2024 11:41:21 +0200
Message-ID: <20240905093738.897657004@linuxfoundation.org>
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

From: winstang <winstang@amd.com>

[ Upstream commit 26c56049cc4f1705b498df013949427692a4b0d5 ]

[Why]
prevent invalid memory access

[How]
check if dc and stream are NULL

Co-authored-by: winstang <winstang@amd.com>
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: winstang <winstang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index b43e489e8d61..786b56e96a81 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -4672,6 +4672,9 @@ void resource_build_bit_depth_reduction_params(struct dc_stream_state *stream,
 
 enum dc_status dc_validate_stream(struct dc *dc, struct dc_stream_state *stream)
 {
+	if (dc == NULL || stream == NULL)
+		return DC_ERROR_UNEXPECTED;
+
 	struct dc_link *link = stream->link;
 	struct timing_generator *tg = dc->res_pool->timing_generators[0];
 	enum dc_status res = DC_OK;
-- 
2.43.0



