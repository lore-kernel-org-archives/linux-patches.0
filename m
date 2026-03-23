Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDDC3AEF22;
	Mon, 23 Mar 2026 14:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274752; cv=none; b=HQ8PlGA9FquE8iRY4fDrRqxNmQ4Ieew/bFSGbmZTRZ4i5JVu7CYs5svOCaI7u2BXqieiBAYxH6r6bLitHceXjhaLC52pZZyOhZoKSTflL7AlLVZ3mJd54m6mjPvGJ6weQ/oj6ekweraoaNBYacs+MI8WS8CyAP0mBtFa9qnsFfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274752; c=relaxed/simple;
	bh=I8ydgMKa/jKbDQmYBd0kXEbPLhl0wLkRWxFEOkJR8X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ja9/gLQnshHl8pb3oi5ZJA4mCip2ZmsWejHK9GpylOVUoDS+NDU5n2OLAHh9LKXMi7iRMfDN2J93UCyOgsRtfySS8moU3z8aL/KjCp4m0XPtXvS/+Gma+oLTzjUOoPOW5oDNYckLdcZG5Q/p1xd4mpzzpPMWf/aJzuAdwc9U5ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDpHMyuv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDpHMyuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779B7C2BCB6;
	Mon, 23 Mar 2026 14:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274751;
	bh=I8ydgMKa/jKbDQmYBd0kXEbPLhl0wLkRWxFEOkJR8X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDpHMyuv13SDjTXDmJPlNQl3kuUO89N1YkkpD3JXnuIAaPCE4Lw8ytH6jWhp9Uqxs
	 hvF9jQWJmdSoo7flmZLvp2X2BRy3a1RK0JIOrMb5ujoUEDciJYQRR/YFlJGq0tTYae
	 yU/x3CvaTdj1IiciVnxJ1gY8YoVeCiJ1kiYzUvMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LiarOnce <liaronce@hotmail.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 080/212] drm/amd/display: Wrap dcn32_override_min_req_memclk() in DC_FP_{START, END}
Date: Mon, 23 Mar 2026 14:45:01 +0100
Message-ID: <20260323134506.305540325@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Ruoyao <xry111@xry111.site>

commit ebe82c6e75cfc547154d0fd843b0dd6cca3d548f upstream.

[Why]
The dcn32_override_min_req_memclk function is in dcn32_fpu.c, which is
compiled with CC_FLAGS_FPU into FP instructions.  So when we call it we
must use DC_FP_{START,END} to save and restore the FP context, and
prepare the FP unit on architectures like LoongArch where the FP unit
isn't always on.

Reported-by: LiarOnce <liaronce@hotmail.com>
Fixes: ee7be8f3de1c ("drm/amd/display: Limit DCN32 8 channel or less parts to DPM1 for FPO")
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 25bb1d54ba3983c064361033a8ec15474fece37e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
@@ -1786,7 +1786,10 @@ static bool dml1_validate(struct dc *dc,
 
 	dc->res_pool->funcs->calculate_wm_and_dlg(dc, context, pipes, pipe_cnt, vlevel);
 
+	DC_FP_START();
 	dcn32_override_min_req_memclk(dc, context);
+	DC_FP_END();
+
 	dcn32_override_min_req_dcfclk(dc, context);
 
 	BW_VAL_TRACE_END_WATERMARKS();


