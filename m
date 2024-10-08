Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02DC1DEFE4;
	Tue,  8 Oct 2024 12:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391805; cv=none; b=Rw1leSU4RtICCy4r/ViHZIlgs7vPhnjaLLwEnLh59IaB0wUpE65mH01ghPe7ye8SNE0nifgXnMkgJGjcRBmxmVVd021d61Bp1kMzaQkrft877TMVkd1ABeXziXFFh76wJuNfbfGCgLoMUjTyYqp4MUjQ0uGqY0qxRm6Yyh5PCZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391805; c=relaxed/simple;
	bh=J/2g0PKlMi25VCKJlenHNo5wDC1YHKZVVUcmVYW2fXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiXd86vcN1G77tWORVCwHERnSt2MIq1lQqbHOMamURWVGUSCv/fDRVkh1qRAGfOzUt7K4q2USTSEGXflA5gLsqupsd59tf/gkcw89KPkQw+TDK+ksnm8Qb1tDpWYalmfa4i/xvV9m056FkH38UtdK3bP0jBOgddRqS1JKlUKkok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYVfiLl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYVfiLl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C6AC4CEC7;
	Tue,  8 Oct 2024 12:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391805;
	bh=J/2g0PKlMi25VCKJlenHNo5wDC1YHKZVVUcmVYW2fXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYVfiLl6EGoyhbEmB/crlMn+TgPl3HySuAi/Ghb3RR+fCHK9vm44ikVnTMrvQgc5w
	 joIbYYhayCyGkSTAVHBRpR1Q7WnimrCsDJiADcz70lVwH4zZEWEvUAY1IFNgSK5o8K
	 jvriIYKPzzgwlnHULkpYTrpPaYXmEqWOgUJskpQw=
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
Subject: [PATCH 6.11 227/558] drm/amd/display: Add NULL check for function pointer in dcn32_set_output_transfer_func
Date: Tue,  8 Oct 2024 14:04:17 +0200
Message-ID: <20241008115711.274607234@linuxfoundation.org>
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
index 9a912b9c1f2e9..33e3d94e429d4 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
@@ -582,7 +582,9 @@ bool dcn32_set_output_transfer_func(struct dc *dc,
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



