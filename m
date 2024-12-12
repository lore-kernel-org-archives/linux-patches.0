Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC67213E99;
	Thu, 12 Dec 2024 16:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019987; cv=none; b=E+Ehic0e1g33l/piGAa/45/XqIGEYk6UM7QA3tiKhKg6tXJFoc2mRK+1bYmw21yykiubB2qiwVWTIMVP7Tiq0kMMaihAGM4k6jgHBCoA5TNzuPXfD4oU/4EcP9kx3svYixmheJgN41SHA9kfRxOL0cYoOA3C+ef2aaMbdJt2G/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019987; c=relaxed/simple;
	bh=uacbkvJRfX2YmgIq5DAi6hIBEGFD2UofJAiSbAiZj3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Arg/8vv1EJUpBK3UFqy0FLbOzqAWW/4jzx210sefARWtFjudnuOXq5XYZKmO696XDG1RPN+SR8jwIfOGztdMyTGmADAdvmzFHsn68hB0+NVAXsSKdPqccMuPDwNIgfIt+eF+1GaRE6B/4Ax4GKthv7kH/h0Q6Nqe+5MyJp2JI0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtLgvBsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtLgvBsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A748C4CECE;
	Thu, 12 Dec 2024 16:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019986;
	bh=uacbkvJRfX2YmgIq5DAi6hIBEGFD2UofJAiSbAiZj3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtLgvBsbGmfCjUXqzdEGewoIFNe6KXls5MRB3mHlUkHZog3b5VvXxY7mFdAA6AxA5
	 stZaY5hs9+sIIODi4FoQ7gS757uLogcwbfmI1PlgPnoSCd7Yih0ElhXepLjKCRl6dr
	 DAcebhTVPA0S4RT5ahmC0iUZ/cReueilphWPnv4E=
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
	Sasha Levin <sashal@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 349/772] drm/amd/display: Add NULL check for function pointer in dcn20_set_output_transfer_func
Date: Thu, 12 Dec 2024 15:54:54 +0100
Message-ID: <20241212144404.332470550@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit 62ed6f0f198da04e884062264df308277628004f upstream.

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
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -856,7 +856,8 @@ bool dcn20_set_output_transfer_func(stru
 	/*
 	 * if above if is not executed then 'params' equal to 0 and set in bypass
 	 */
-	mpc->funcs->set_output_gamma(mpc, mpcc_id, params);
+	if (mpc->funcs->set_output_gamma)
+		mpc->funcs->set_output_gamma(mpc, mpcc_id, params);
 
 	return true;
 }


