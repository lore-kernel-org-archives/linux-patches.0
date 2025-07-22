Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E0A2EA739;
	Tue, 22 Jul 2025 14:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193744; cv=none; b=aMidsiy8MDPzkapT+eMkul+LmfMpZjoanSpp90mPaymGVI99pPT8MHBuIo0l0lI8Pc940B0Oa8irtSw4vatkzG3x4cXBlcadx/+vhEl98zuyVGXtNFDg5Y4dCfgqVvUqedaPy2b4cE7Ttbf3gak1sGBzR4x/rt4k6B+PNFhvTp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193744; c=relaxed/simple;
	bh=AWRUZ8pzIzvYVwwNFmNExXHLt3QbY+RL/lvPcDThnH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERBZvesXUlNAyrBg356eEIHIv38MVZPKZBQVHPkKkPSbVZxV+mpRQAW4DGPlxALmJrn8PsnIVrPnDRwcwTwjfy/Wmng1WXoC8jWAfBoRe6X9jj3njXtIk8jS92ZmfxbeOB67Fs2m9JmRSzoqH3fddrFKuc8HgT4OZPcWHlz7/3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DG0uxGuu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DG0uxGuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FC6C4CEEB;
	Tue, 22 Jul 2025 14:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193744;
	bh=AWRUZ8pzIzvYVwwNFmNExXHLt3QbY+RL/lvPcDThnH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DG0uxGuuMNKmxcE1JkMz489T9jd63PtSDVrhv3ariHhd1FBCcL7j7dR7+1MpteSE2
	 8ZaQIG39MJ/88AvfsH0C5RXtUe5cu36BMiubbEUDUENKc1cCHQYjwOlAJXA4uUBuex
	 GVw2z+1SvcaYHpErIl1w+sHXdj2PezSI4LEzhmFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Ravi Kumar Vodapalli <ravi.kumar.vodapalli@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 185/187] drm/xe/mocs: Initialize MOCS index early
Date: Tue, 22 Jul 2025 15:45:55 +0200
Message-ID: <20250722134352.660345975@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -375,6 +375,8 @@ int xe_gt_init_early(struct xe_gt *gt)
 	if (err)
 		return err;
 
+	xe_mocs_init_early(gt);
+
 	return 0;
 }
 
@@ -592,8 +594,6 @@ int xe_gt_init(struct xe_gt *gt)
 	if (err)
 		return err;
 
-	xe_mocs_init_early(gt);
-
 	err = xe_gt_sysfs_init(gt);
 	if (err)
 		return err;


