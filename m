Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3671B1E00AB;
	Wed,  6 Nov 2024 12:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896558; cv=none; b=B/nST8N3I66QJoF7jJyQKrXGVhLmgWmAE2HD/WdVDl3bSyMwt/dEiUqOfjhwbqLnJvpDZ1AIH4oqF8cVMNnHrPaKewTCfi0MONJxnElfrlPHjCyBI/OA1ZHuKdFVuibKUccYYtF7b6aTUvdOjPt/6p2+io6YyTjvwg/OIYq6AwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896558; c=relaxed/simple;
	bh=SdQvoHtm5R4AWqwW4HLUHLiUgzKZj+2/2lls0f7VXbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uldREQ7X/F3hpXYyogZCFk8gHTL2p0jxCuih5KvLkXHXSn+Nb7JXr6xSohhxYa2jUCsDgrPM7olR93XSMieMuD0ez5y11a/Yxb3BMybYgPCLbh0/8GnVhJzTM/U5L4CwUMHO7BbPcvQIb0g3HJ9V4Pm21C6jBg+dDiGCEKlXJz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZejQgO9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZejQgO9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BD6C4CECD;
	Wed,  6 Nov 2024 12:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896558;
	bh=SdQvoHtm5R4AWqwW4HLUHLiUgzKZj+2/2lls0f7VXbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZejQgO9YCaK7qvbPn7jQN7igWYkHzYTLHtcPMM1Wz1okoBYGtdX7fhp/ZRqguMk2L
	 qT2Omq64zvQyWo2Ehix1I7Au9N4Wq9ed4cpyAqzTiRw2TIbQNhIypNM6UcCwc7jd+W
	 iL/rIEPKvTgDlDEWKUuRszyVogkbKJxQMD065StA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 235/245] drm/xe/xe2hpg: Add Wa_15016589081
Date: Wed,  6 Nov 2024 13:04:48 +0100
Message-ID: <20241106120325.050802987@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

commit da9a73b7b25eab574cb9c984fcce0b5e240bdd2c upstream.

Wa_15016589081 applies to xe2_hpg renderCS

V2(Gustavo)
  - rename bit macro

Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240904101333.2049655-1-tejas.upadhyay@intel.com
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
(cherry picked from commit 9db969b36b2fbca13ad4088aff725ebd5e8142f5)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h |    1 +
 drivers/gpu/drm/xe/xe_wa.c           |    4 ++++
 2 files changed, 5 insertions(+)

--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -102,6 +102,7 @@
 
 #define CHICKEN_RASTER_1			XE_REG_MCR(0x6204, XE_REG_OPTION_MASKED)
 #define   DIS_SF_ROUND_NEAREST_EVEN		REG_BIT(8)
+#define   DIS_CLIP_NEGATIVE_BOUNDING_BOX	REG_BIT(6)
 
 #define CHICKEN_RASTER_2			XE_REG_MCR(0x6208, XE_REG_OPTION_MASKED)
 #define   TBIMR_FAST_CLIP			REG_BIT(5)
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -733,6 +733,10 @@ static const struct xe_rtp_entry_sr lrc_
 			     DIS_PARTIAL_AUTOSTRIP |
 			     DIS_AUTOSTRIP))
 	},
+	{ XE_RTP_NAME("15016589081"),
+	  XE_RTP_RULES(GRAPHICS_VERSION(2001), ENGINE_CLASS(RENDER)),
+	  XE_RTP_ACTIONS(SET(CHICKEN_RASTER_1, DIS_CLIP_NEGATIVE_BOUNDING_BOX))
+	},
 
 	{}
 };


