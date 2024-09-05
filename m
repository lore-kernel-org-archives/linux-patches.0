Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686B5194AD6;
	Thu,  5 Sep 2024 09:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529587; cv=none; b=pj0aEitbnHNg4yxvU3n82TsPp85ivA/vpY/xnRrjLBG2I7sjebk2yMACp/HjFoUxn82iinyRUNvBBjOIFNp+Y8bt20Vq+ySZnt0C3X+vbBpSm1bl5xtwSqTGCg/xJhFT29x6ZnOpfZe8G0atqkgV48H0GJYhaWrteJkB7FmyOFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529587; c=relaxed/simple;
	bh=clvZZcXHYDqVzSEiguDX89zGNZw74/CwQ0TrPydkFaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtAFdJ+2r+x4Vmqx6q/6B7IcLlORXJ481PnSAvI/W9EPKmIBeVuWfI/IH1TE7Se2wHf7rZ00UgJOYwEkiIHxxmsRD0yyekm9i9EvCcFiEPurcSxiclUQ/oQ2idhGe59oXKy6kc17VN8r9aiIHMtfmRgnggb8cgcy9TI48DqAcWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eHEqvZam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eHEqvZam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F39C4CEC3;
	Thu,  5 Sep 2024 09:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529587;
	bh=clvZZcXHYDqVzSEiguDX89zGNZw74/CwQ0TrPydkFaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eHEqvZamSwDDagfhtDJC0ba93x7PccM6gSXdvlJFIVjepzLtg41Tvlx94oxej69yF
	 KvnuCtCKWQ5P/ljGkk7Siy4IRSsH3WZaVpqlAuCteR2hXdnfzluyO1qkH6bzL3FP6I
	 oTQtBtX+wnwl6MIA2ZGJV2Umnc/l/KW2IRa2I6IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 080/184] drm/xe: Demote CCS_MODE info to debug only
Date: Thu,  5 Sep 2024 11:39:53 +0200
Message-ID: <20240905093735.364686929@linuxfoundation.org>
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

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

[ Upstream commit e9c190b9b8e7e07bc0ef0ba9b87321fa37b456c5 ]

This information is printed in any gt_reset, which actually
occurs in any runtime resume, what can be so verbose in
production build. Let's demote it to debug only.

Cc: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240503190331.6690-1-rodrigo.vivi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_ccs_mode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_ccs_mode.c b/drivers/gpu/drm/xe/xe_gt_ccs_mode.c
index 396aeb5b9924..a34c9a24dafc 100644
--- a/drivers/gpu/drm/xe/xe_gt_ccs_mode.c
+++ b/drivers/gpu/drm/xe/xe_gt_ccs_mode.c
@@ -68,8 +68,8 @@ static void __xe_gt_apply_ccs_mode(struct xe_gt *gt, u32 num_engines)
 
 	xe_mmio_write32(gt, CCS_MODE, mode);
 
-	xe_gt_info(gt, "CCS_MODE=%x config:%08x, num_engines:%d, num_slices:%d\n",
-		   mode, config, num_engines, num_slices);
+	xe_gt_dbg(gt, "CCS_MODE=%x config:%08x, num_engines:%d, num_slices:%d\n",
+		  mode, config, num_engines, num_slices);
 }
 
 void xe_gt_apply_ccs_mode(struct xe_gt *gt)
-- 
2.43.0



