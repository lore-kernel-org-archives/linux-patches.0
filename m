Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27702C9A;
	Tue, 22 Jul 2025 14:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193122; cv=none; b=LNmq6MC7gyqaPXYCWVSFWi0msCJ+pZjdrpymO/WQ7Ku34iNqXtF8MA0dZLLyb7+ofxWy+mPeDuW3JrUY8pav6vmOPmRxdZf8MguHSRskE4fFAxZOx8e8rlK1to7Vn9NtpLmHkmSdheOfb2YBbnGVu5o/kmb23wlB9qiYPuiAUnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193122; c=relaxed/simple;
	bh=XGVKyUkyuspg79EvpNrR1Nj/pq1YgpAFzgJsJuGwaS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OoPUoCEaSKC0+3SnZUnzVOKjKHUaQDMme9/NYCovXg4lXerF3AtSHS0Xaj7UjTCsWjYl/L2Sxlotoeg/qYfKqSF1X/B/ac0EIckWVuWNzW1fYZSIwSXwYvGUw1A8T6by3Mdz7I5BeF5a1aYroFrEl2Ws4lXPXnTSUMfZCfmu9MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=baAMxqpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="baAMxqpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2304DC4CEEB;
	Tue, 22 Jul 2025 14:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193122;
	bh=XGVKyUkyuspg79EvpNrR1Nj/pq1YgpAFzgJsJuGwaS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=baAMxqpQ2ADdhPOmJyH9FSOqn3wq6HS6CYYJIZM8SPCTce0Iu42miVFpGXUbQrb0i
	 2Jt+Ruvnvq8uaP7vM8tsLVFcPT4SacN1P/NztkuRIA5L+OHJCnQITw19leC4Qd1MD4
	 bWztoh+ctVp6ZsWGGXks1kWTDkNm/e9vwj2Ssq04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Ravi Kumar Vodapalli <ravi.kumar.vodapalli@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/158] drm/xe/mocs: Initialize MOCS index early
Date: Tue, 22 Jul 2025 15:45:40 +0200
Message-ID: <20250722134346.532289704@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>

commit 2a58b21adee3df10ca6f4491af965c4890d2d8e3 upstream.

MOCS uc_index is used even before it is initialized in the following
callstack
    guc_prepare_xfer()
    __xe_guc_upload()
    xe_guc_min_load_for_hwconfig()
    xe_uc_init_hwconfig()
    xe_gt_init_hwconfig()

Do MOCS index initialization earlier in the device probe.

Signed-off-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Reviewed-by: Ravi Kumar Vodapalli <ravi.kumar.vodapalli@intel.com>
Link: https://lore.kernel.org/r/20250520142445.2792824-1-balasubramani.vivekanandan@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 241cc827c0987d7173714fc5a95a7c8fc9bf15c0)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Stable-dep-of: 3155ac89251d ("drm/xe: Move page fault init after topology init")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_gt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -389,6 +389,8 @@ int xe_gt_init_early(struct xe_gt *gt)
 	if (err)
 		return err;
 
+	xe_mocs_init_early(gt);
+
 	return 0;
 }
 
@@ -596,8 +598,6 @@ int xe_gt_init(struct xe_gt *gt)
 	if (err)
 		return err;
 
-	xe_mocs_init_early(gt);
-
 	err = xe_gt_sysfs_init(gt);
 	if (err)
 		return err;


