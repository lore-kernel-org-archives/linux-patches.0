Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712D2396D3D;
	Mon, 23 Mar 2026 14:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277044; cv=none; b=Wt7IwLFNBeUKaVn+ejGvnUHxvpoV0kyzp+hodAw+Cx1/8DjVy08Kp35SmYA9CV/QKYD1qx2jYfBB6050nTcSabpjKrR0s5pOe3EBDhfcXAP6ssK/8Pl3n9AEEqzJfITlaartq0fMIFT0t3Dpbsojy84+ZIKAQ716pf53sdCGW3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277044; c=relaxed/simple;
	bh=fg/W9FX0eTxgm4RL7EoBZ4G0BnPkhSwxQn1vQV0tBMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dUQH0ARhFNT2bleZzuHLcgSMBXYvbetS0Zx/NgxGjlzXxYw/zxEc0YFTb9NbVsEHi/gqlOQhyVOqun3/KEkbPDLs0ocamVqyv2l7BSVNPGiuP0mHkcnpAcYYjhSgUAIyxPv5qm4ldFpS+vf8H619aKSrZYej4wRBqZBlKFwUgRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQBCALwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQBCALwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025E5C4CEF7;
	Mon, 23 Mar 2026 14:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277044;
	bh=fg/W9FX0eTxgm4RL7EoBZ4G0BnPkhSwxQn1vQV0tBMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQBCALwCgN0hEzLrgRqbs/jPEpSiTdOvbRXfRBU2ltUB/HORUCIYNoAV8np83AVx6
	 ENI5jkUS7Ybid9dVfq1hGWVdMujvG8E8mjODT8y3xZlyybCUJizt/x2P5REe1rQ6qw
	 ML4TkqcBDvV3dk2LikhOFPso06+m1OHQRJcQmWxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Animesh Manna <animesh.manna@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Grzelak?= <michal.grzelak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.12 301/460] drm/i915/alpm: ALPM disable fixes
Date: Mon, 23 Mar 2026 14:44:57 +0100
Message-ID: <20260323134533.879242740@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit eb4a7139e97374f42b7242cc754e77f1623fbcd5 upstream.

PORT_ALPM_CTL is supposed to be written only before link training. Remove
writing it from ALPM disable.

Also clearing ALPM_CTL_ALPM_AUX_LESS_ENABLE and is not about disabling ALPM
but switching to AUX-Wake ALPM. Stop touching this bit on ALPM disable.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/7153
Fixes: 1ccbf135862b ("drm/i915/psr: Enable ALPM on source side for eDP Panel replay")
Cc: Animesh Manna <animesh.manna@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.10+
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Michał Grzelak <michal.grzelak@intel.com>
Link: https://patch.msgid.link/20260212062731.397801-1-jouni.hogander@intel.com
(cherry picked from commit 008304c9ae75c772d3460040de56e12112cdf5e6)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2114,12 +2114,7 @@ static void intel_psr_disable_locked(str
 	/* Panel Replay on eDP is always using ALPM aux less. */
 	if (intel_dp->psr.panel_replay_enabled && intel_dp_is_edp(intel_dp)) {
 		intel_de_rmw(display, ALPM_CTL(display, cpu_transcoder),
-			     ALPM_CTL_ALPM_ENABLE |
-			     ALPM_CTL_ALPM_AUX_LESS_ENABLE, 0);
-
-		intel_de_rmw(display,
-			     PORT_ALPM_CTL(display, cpu_transcoder),
-			     PORT_ALPM_CTL_ALPM_AUX_LESS_ENABLE, 0);
+			     ALPM_CTL_ALPM_ENABLE, 0);
 	}
 
 	/* Disable PSR on Sink */


