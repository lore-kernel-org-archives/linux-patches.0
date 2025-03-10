Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC906230D0F;
	Mon, 10 Mar 2025 17:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626617; cv=none; b=enfN03JygH7UIdTODiBOmfOB2sejzxhrgwM1DSeKPOKeLISWa8evewZqjvDgogdB48Qxe+7pzNPAuHgn12tMXwnOdqVRz3hsfQTjFZuMZawyR6aYTvmaX7gVm8SBIm5Y0jveaicEBV0C/+TvADIwuwspKk91zIW7HGP3Xlcj/Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626617; c=relaxed/simple;
	bh=al4eda13LG3mbk5VjsMItC0iNSf0OYsFWz5QdV6sWhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdE96YADwCxdGMjw2HlzAN4ko9DuU4M0eg4bHwgYiAiEjRDTeC5g8iB+TZxCDA/N275ervbJ5mM04vCUuc29gM58p0w0Rlddc/GZbVZMqzl+g0273+Xp6bOfLHV0uKO2qizCorkR2qKUvt/QBC20v2qVae/OonpZGtm4Fy3T2s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJE3CvLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJE3CvLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F5BC4CEE5;
	Mon, 10 Mar 2025 17:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626616;
	bh=al4eda13LG3mbk5VjsMItC0iNSf0OYsFWz5QdV6sWhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJE3CvLieo5US05ZZuGYxuLB6QTmXNUGrnBp3oeB1c5QPEzIH9JLk48iv3Pbn9+Xr
	 /Cs9WtoiSN3iExKbR3QArFMXCut6pfkJ5+cfoECZvCk8WUPLhYh7VxdcB+vhAISu3g
	 cOnf991H0+019osTx5QdhE3RR078P+NLoCmFZoNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.13 054/207] drm/xe: Fix GT "for each engine" workarounds
Date: Mon, 10 Mar 2025 18:04:07 +0100
Message-ID: <20250310170449.918445540@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit 54f94dc7f6b4db45dbc23b4db3d20c7194e2c54f upstream.

Any rules using engine matching are currently broken due RTP processing
happening too in early init, before the list of hardware engines has been
initialised.

Fix this by moving workaround processing to later in the driver probe
sequence, to just before the processed list is used for the first time.

Looking at the debugfs gt0/workarounds on ADL-P we notice 14011060649
should be present while we see, before:

 GT Workarounds
     14011059788
     14015795083

And with the patch:

 GT Workarounds
     14011060649
     14011059788
     14015795083

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: stable@vger.kernel.org # v6.11+
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250227101304.46660-2-tvrtko.ursulin@igalia.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 25d434cef791e03cf40680f5441b576c639bfa84)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_gt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -380,9 +380,7 @@ int xe_gt_init_early(struct xe_gt *gt)
 	if (err)
 		return err;
 
-	xe_wa_process_gt(gt);
 	xe_wa_process_oob(gt);
-	xe_tuning_process_gt(gt);
 
 	xe_force_wake_init_gt(gt, gt_to_fw(gt));
 	spin_lock_init(&gt->global_invl_lock);
@@ -474,6 +472,8 @@ static int all_fw_domain_init(struct xe_
 	}
 
 	xe_gt_mcr_set_implicit_defaults(gt);
+	xe_wa_process_gt(gt);
+	xe_tuning_process_gt(gt);
 	xe_reg_sr_apply_mmio(&gt->reg_sr, gt);
 
 	err = xe_gt_clock_init(gt);


