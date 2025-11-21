Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C0E3176E1;
	Fri, 21 Nov 2025 13:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731509; cv=none; b=htJgRmn2bFcloQx4iF4esW/M4Y+9KbNO0cE1/cZRfsy/3U2CNR0qyC0JetvaddxFQxB722uS4G9jeuw5IsDCRBZFG8lQZlbu+hhg0ykj7nhcNnC3pGgG/fCXhdBPvxdQ3HLNzYFiGZxAgwOhVuRY3rs1xubWcGtjjD0UW4IzeQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731509; c=relaxed/simple;
	bh=tQfWbu+KEifAFYvGnSDCp1ePYFXoL9OFuHsOOSpJyHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oz4h5igXRsJ2rSWDO71tOCL9RjohE6v2brqtKAPlw8S8P0Jh3XC05sZ8BeGz+yXLjb6tCxDlvqlBSKg5c+mj+cG4mQHMfwd9LqIfRHYY9dF600Hmhpl64Q1H6fktC2lW52Zu4H2bVo+xrgxteIFq/yp/hVF86Sg7Q9WkuIpaOt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDjM0Ecl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDjM0Ecl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81133C4CEF1;
	Fri, 21 Nov 2025 13:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731508;
	bh=tQfWbu+KEifAFYvGnSDCp1ePYFXoL9OFuHsOOSpJyHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDjM0Ecl96TUupzQjOqsDGg9wVkAhw0bOSBlr+a3mnkGc0H6/LaInStf9QLcWHD42
	 yj4gxoRb1iFlSWIRydy+54mD5FvyCr1lpBsVZvzTn1zP6M4D02dcx2C3say5sZ5R9c
	 Ot7VsjPswM6i+FJRNbA0JUlRPUXxIxjJ54+dKxn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Gote <nitin.r.gote@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.17 225/247] drm/xe/xe3: Add WA_14024681466 for Xe3_LPG
Date: Fri, 21 Nov 2025 14:12:52 +0100
Message-ID: <20251121130202.810246392@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitin Gote <nitin.r.gote@intel.com>

commit 0b2f7be548006b0651e1e8320790f49723265cbc upstream.

Apply WA_14024681466 to Xe3_LPG graphics IP versions from 30.00 to 30.05.

v2: (Matthew Roper)
   - Remove stepping filter as workaround applies to all steppings.
   - Add an engine class filter so it only applies to the RENDER engine.

Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
Link: https://patch.msgid.link/20251027092643.335904-1-nitin.r.gote@intel.com
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 071089a69e199bd810ff31c4c933bd528e502743)
Cc: stable@vger.kernel.org # v6.16+
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h |    1 +
 drivers/gpu/drm/xe/xe_wa.c           |    4 ++++
 2 files changed, 5 insertions(+)

--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -168,6 +168,7 @@
 
 #define XEHP_SLICE_COMMON_ECO_CHICKEN1		XE_REG_MCR(0x731c, XE_REG_OPTION_MASKED)
 #define   MSC_MSAA_REODER_BUF_BYPASS_DISABLE	REG_BIT(14)
+#define   FAST_CLEAR_VALIGN_FIX			REG_BIT(13)
 
 #define XE2LPM_CCCHKNREG1			XE_REG(0x82a8)
 
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -890,6 +890,10 @@ static const struct xe_rtp_entry_sr lrc_
 		       ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(CHICKEN_RASTER_1, DIS_CLIP_NEGATIVE_BOUNDING_BOX))
 	},
+	{ XE_RTP_NAME("14024681466"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3005), ENGINE_CLASS(RENDER)),
+	  XE_RTP_ACTIONS(SET(XEHP_SLICE_COMMON_ECO_CHICKEN1, FAST_CLEAR_VALIGN_FIX))
+	},
 };
 
 static __maybe_unused const struct xe_rtp_entry oob_was[] = {


