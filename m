Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB873BFE59;
	Tue, 17 Mar 2026 16:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766575; cv=none; b=uxQ3OgSfX8UDzYvp36B0MdNOv9acXqCzy2JGUb+q08NTrZP0DwWBaqIxEEADMtDBUql3gRjH5JD8ILnMY2QPm4EHQYzaN0v25mjjFnRShaLHJivouOgTEBgztPdIRe2631j6UpKP6DiDUigZw/se+qVGcTNCZv56W0cXDBW/L84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766575; c=relaxed/simple;
	bh=Qk725uNO2SabQ1dQr9svSO7ydChIy6JEioLN+tkqNRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqeusn7pRq/Ngv+bzt2fr8OhLZxxdHkAL6iYdSjfpzNOPQzj16k9CUkFd27lL0XVC8vglO8KYzjxwibydUkzFr1ZkW2RbguPfcaektHjjTiqveeCV+E5fOkAUt+ZoD0Wg+p7Mu6FC8k2R52eCp2EIjwKjVglD0hfe81ayx2ZSX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NURsUcC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NURsUcC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1407FC4CEF7;
	Tue, 17 Mar 2026 16:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766575;
	bh=Qk725uNO2SabQ1dQr9svSO7ydChIy6JEioLN+tkqNRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NURsUcC4geb++88BiMk86uXhuy1CZS4UrNDTYomiaubTqDmkqAATCfFSQzS3Wc4ZE
	 9L25OLyN0t/Wtd6ToMSnc9fGzaTSD/1JzJcq5SsPeVrzZHEmQi/gqpxyxWVtzKG3Z+
	 E0wTnqsGeYx58diEZfklA+zpueC2rdDhPba/tvJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aradhya Bhatia <aradhya.bhatia@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Ngai-Mint Kwan <ngai-mint.kwan@linux.intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.19 268/378] drm/xe/xe2_hpg: Correct implementation of Wa_16025250150
Date: Tue, 17 Mar 2026 17:33:45 +0100
Message-ID: <20260317163016.870816813@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

commit 89865e6dc8487b627302bdced3f965cd0c406835 upstream.

Wa_16025250150 asks us to set five register fields of the register to
0x1 each.  However we were just OR'ing this into the existing register
value (which has a default of 0x4 for each nibble-sized field) resulting
in final field values of 0x5 instead of the desired 0x1.  Correct the
RTP programming (use FIELD_SET instead of SET) to ensure each field is
assigned to exactly the value we want.

Cc: Aradhya Bhatia <aradhya.bhatia@intel.com>
Cc: Tejas Upadhyay <tejas.upadhyay@intel.com>
Cc: stable@vger.kernel.org # v6.16+
Fixes: 7654d51f1fd8 ("drm/xe/xe2hpg: Add Wa_16025250150")
Reviewed-by: Ngai-Mint Kwan <ngai-mint.kwan@linux.intel.com>
Link: https://patch.msgid.link/20260227164341.3600098-2-matthew.d.roper@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit d139209ef88e48af1f6731cd45440421c757b6b5)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_wa.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -255,12 +255,13 @@ static const struct xe_rtp_entry_sr gt_w
 
 	{ XE_RTP_NAME("16025250150"),
 	  XE_RTP_RULES(GRAPHICS_VERSION(2001)),
-	  XE_RTP_ACTIONS(SET(LSN_VC_REG2,
-			     LSN_LNI_WGT(1) |
-			     LSN_LNE_WGT(1) |
-			     LSN_DIM_X_WGT(1) |
-			     LSN_DIM_Y_WGT(1) |
-			     LSN_DIM_Z_WGT(1)))
+	  XE_RTP_ACTIONS(FIELD_SET(LSN_VC_REG2,
+				   LSN_LNI_WGT_MASK | LSN_LNE_WGT_MASK |
+				   LSN_DIM_X_WGT_MASK | LSN_DIM_Y_WGT_MASK |
+				   LSN_DIM_Z_WGT_MASK,
+				   LSN_LNI_WGT(1) | LSN_LNE_WGT(1) |
+				   LSN_DIM_X_WGT(1) | LSN_DIM_Y_WGT(1) |
+				   LSN_DIM_Z_WGT(1)))
 	},
 
 	/* Xe2_HPM */


