Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4DA1DEFEF;
	Tue,  8 Oct 2024 12:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390196; cv=none; b=iPo7IxYZoVKJerqzhh8AKzX3kA1IiS80+J7jW0qdLjEhfuMNcXBHzOJGgW10ixGbY3QWjP6Co1fQKH3FV61ytqrDu+RPCoJoAWROFFrUNWIdhdHcx+5bmaWHy325ZNg5OoVutm24NFgmD9nSQi0zXRa9fuhVWsL6oWNLbjsKaM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390196; c=relaxed/simple;
	bh=Sx0Um1amXTdd+XadY3BPCCrOcCAdPY6zbPF8LEzA6a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNasS7OSmNABFFQ9VYQswDyLF/WMnJFhP1aNqs+HRd21ZdjPwY6fN3s2itdSfZ1iGxeSzWUsIho2MEzzAhLzuBkwdgcnexmJvV3hwStk5bwzKB8+poj5L1pprjiL2HpaZ0fsZiRY1tuZ12ujdcOaXUp2aBKMRgrSsR1BOZDVi8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3NNryBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3NNryBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5756C4CEC7;
	Tue,  8 Oct 2024 12:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390195;
	bh=Sx0Um1amXTdd+XadY3BPCCrOcCAdPY6zbPF8LEzA6a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3NNryBR4VAhO51e85N+sMu+ROWrbDzhJUSDl7uX0uKFVIiMiEd51b3/3diIaYE6Z
	 UukQcDq/FCqiUA/sRLfQkyypweLTDFdXc5TQ6A9tdCpdOaTgbDvauD3vlAY15fGL3u
	 DVbtFHirpKPdgsJP/W8PkU4h8wnFTw1a2QIyZ/9U=
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
Subject: [PATCH 6.10 191/482] drm/amd/display: Add NULL check for function pointer in dcn32_set_output_transfer_func
Date: Tue,  8 Oct 2024 14:04:14 +0200
Message-ID: <20241008115655.820324471@linuxfoundation.org>
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

[ Upstream commit 28574b08c70e56d34d6f6379326a860b96749051 ]

This commit adds a null check for the set_output_gamma function pointer
in the dcn32_set_output_transfer_func function. Previously,
set_output_gamma was being checked for null, but then it was being
dereferenced without any null check. This could lead to a null pointer
dereference if set_output_gamma is null.

To fix this, we now ensure that set_output_gamma is not null before
dereferencing it. We do this by adding a null check for set_output_gamma
before the call to set_output_gamma.

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
 drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
index aaf576f30a777..c050acc4ff065 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
@@ -581,7 +581,9 @@ bool dcn32_set_output_transfer_func(struct dc *dc,
 		}
 	}
 
-	mpc->funcs->set_output_gamma(mpc, mpcc_id, params);
+	if (mpc->funcs->set_output_gamma)
+		mpc->funcs->set_output_gamma(mpc, mpcc_id, params);
+
 	return ret;
 }
 
-- 
2.43.0



