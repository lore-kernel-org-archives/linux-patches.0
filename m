Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FD5267386;
	Tue, 26 Aug 2025 11:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207427; cv=none; b=U6FdKOQcoIWtmmqm88cdRVqp9wG+eIDX1PfFsbKEAREm9ZFYJOGPzk2G1ZeVDnthh0M5Woy7yt9qWFpIxp8bT+mSHpErzWg21fYYRpbwvG6MpZMkdW0aPufikNQCxGgQolBNqiFwZmtuyplkst9onCsWYZAzXVYYQ/QWrIb0G7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207427; c=relaxed/simple;
	bh=sbHX/Ciz356FO0hX6Q3zAFg4R0Z3lueIJM/o+sjL+d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OISoDWg6MaUAy8ROwub1kd9uHVhaaoMAWmys1eMAVFVQi2iwKU+iY1njMDpdZa9zGGtYl4xrHRzXWdn+z0Km0yMS1c8RuYPXNfm2vLp9JJKeHKQ8x+NEte8neGU8AR6y4uu3B3Ae5+MAXYvtK0lmqQRbeBu+0JE8CdE/0wpxgY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x50gQEUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x50gQEUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E83C4CEF4;
	Tue, 26 Aug 2025 11:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207427;
	bh=sbHX/Ciz356FO0hX6Q3zAFg4R0Z3lueIJM/o+sjL+d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x50gQEUs+rWrtGL7i8JlImn7F2XimVf2qdOs9eLH/GUHry+MUkPRlw5rXLd1DDGSI
	 cxJ2HKW49XxmA2CTK9j4UvU8lJghmfmZA+xcklH/bV06oMIib09V6N7buTigpmLOWY
	 lrKWWX09HyCR0gpVLBNWTJi6GfU39Z8AlLoTIUTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Shkenev <mustela@erminea.space>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 176/457] drm/amdgpu: check if hubbub is NULL in debugfs/amdgpu_dm_capabilities
Date: Tue, 26 Aug 2025 13:07:40 +0200
Message-ID: <20250826110941.724502613@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Shkenev <mustela@erminea.space>

commit b4a69f7f29c8a459ad6b4d8a8b72450f1d9fd288 upstream.

HUBBUB structure is not initialized on DCE hardware, so check if it is NULL
to avoid null dereference while accessing amdgpu_dm_capabilities file in
debugfs.

Signed-off-by: Peter Shkenev <mustela@erminea.space>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -3988,7 +3988,7 @@ static int capabilities_show(struct seq_
 
 	struct hubbub *hubbub = dc->res_pool->hubbub;
 
-	if (hubbub->funcs->get_mall_en)
+	if (hubbub && hubbub->funcs->get_mall_en)
 		hubbub->funcs->get_mall_en(hubbub, &mall_in_use);
 
 	if (dc->cap_funcs.get_subvp_en)


