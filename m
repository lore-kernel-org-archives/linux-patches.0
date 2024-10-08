Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60601DE2AE;
	Tue,  8 Oct 2024 12:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390156; cv=none; b=KwGURZ5hRzcUpK7RSQsvTNHxwI0nKxFtNkBN1uWVu5x1Kcq/0exOS5I5IK2Rim9J4X0gMLtccfWMsqgwHMDQP5r3hFg3eUjf7s1mr9kTE5db3bxNl/KwUwFcQ1+iGCTeKxOlTGHlX9bHmCOfYJ+isQxCddh/o+vzzr9rYzr8Kdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390156; c=relaxed/simple;
	bh=L7pMFmonRvvVGtr5UjUSabjLrGfpz/xvS27lJf8JqNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZCb2bNrgTlvPehqo9QVmp8BnXncoU9foIkCSXANlxMcs4Vp+8qTg5yF4lxT1NsUxgmfayIgtJxPnrVKP6R7cQ6Z37T/TEIpspvwgf71b00RGMzqqN+ni8SAO5mcnW09i7NMJpkEOq5yCLs67S0n7rr9KhtHxq/XsYYs/fNVQII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aI2XxZDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aI2XxZDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F527C4CECE;
	Tue,  8 Oct 2024 12:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390156;
	bh=L7pMFmonRvvVGtr5UjUSabjLrGfpz/xvS27lJf8JqNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aI2XxZDA0VazyuprKP7c/J5aXdKg6PMRuKo7KY3jMgyAyJKfxoBCC84IGQRDpPF+I
	 INUfbNKLte+8vC4PLmlErMXHDEMRJm3ilh2SCvvKmbtUu/H4Y7rGtCxSPl6VVFyxE3
	 j8Cz0nXbXNNq5wamoGlFSw5NCZ3hmt+tKyV/u3Ho=
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
Subject: [PATCH 6.10 190/482] drm/amd/display: Add NULL check for function pointer in dcn20_set_output_transfer_func
Date: Tue,  8 Oct 2024 14:04:13 +0200
Message-ID: <20241008115655.781209514@linuxfoundation.org>
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

[ Upstream commit 62ed6f0f198da04e884062264df308277628004f ]

This commit adds a null check for the set_output_gamma function pointer
in the dcn20_set_output_transfer_func function. Previously,
set_output_gamma was being checked for null at line 1030, but then it
was being dereferenced without any null check at line 1048. This could
potentially lead to a null pointer dereference error if set_output_gamma
is null.

To fix this, we now ensure that set_output_gamma is not null before
dereferencing it. We do this by adding a null check for set_output_gamma
before the call to set_output_gamma at line 1048.

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
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index 7d833fa6dd77c..58e8b7482f4f5 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -1040,7 +1040,8 @@ bool dcn20_set_output_transfer_func(struct dc *dc, struct pipe_ctx *pipe_ctx,
 	/*
 	 * if above if is not executed then 'params' equal to 0 and set in bypass
 	 */
-	mpc->funcs->set_output_gamma(mpc, mpcc_id, params);
+	if (mpc->funcs->set_output_gamma)
+		mpc->funcs->set_output_gamma(mpc, mpcc_id, params);
 
 	return true;
 }
-- 
2.43.0



