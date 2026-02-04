Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9AF421EEE;
	Wed,  4 Feb 2026 15:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218570; cv=none; b=MIWdrOWSxvYXGNBsOhMegUpF7UDstmkF9wlQixXJkt+LkGOpR/KnW+3g+K3uM9tzGJZwfDQCPJ+m3KI5rXFOqv+U6JuVLapcFkbXIxypN45GMD7vmlvvilN5ptJNj51ckCeTX6V92GvCOsnJykvZ04Oj0Itacg0Y+pfPPzTAvrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218570; c=relaxed/simple;
	bh=1E/iyiwvGxIXaU4Wa/Rst3aWXEL4++Yy4L/tCnfHBO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWr6R+g8A9PEBAp4BksiwcqsbUI3eHBpUzyLxSDyspMuC6LCcwbAdxNZ+9rTIcLvFixsUU9CJKEV+V3zZRyM5GeWz9kxbCVJUb8QtyzguBqYXoOkZaELZNzB1GXJtzAdenD8WBj1Q5LIjTcP8Zd5RBErG6bgrIk3UisRonEFBzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvK5stsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvK5stsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E54C4CEF7;
	Wed,  4 Feb 2026 15:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218570;
	bh=1E/iyiwvGxIXaU4Wa/Rst3aWXEL4++Yy4L/tCnfHBO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvK5stslZZptF6b40KneSzEdPSk6+vWApw/kPTX3WetyR/V8nI1QGC6QHFhIgcBKy
	 cMRg9f6Xs28LAqhhbR92pOmimOE2DLRGTvj5ZITvLsnI0Zs+lULB+htEAbunHHkLQL
	 2UynDR0O2Sl/IMrK3CStSa3os48Bo2kAxCEDcZvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Chen <Wen.Chen3@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.6 69/72] drm/amd/display: use udelay rather than fsleep
Date: Wed,  4 Feb 2026 15:41:12 +0100
Message-ID: <20260204143848.143146935@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 27e4dc2c0543fd1808cc52bd888ee1e0533c4a2e upstream.

This function can be called from an atomic context so we can't use
fsleep().

Fixes: 01f60348d8fb ("drm/amd/display: Fix 'failed to blank crtc!'")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4549
Cc: Wen Chen <Wen.Chen3@amd.com>
Cc: Fangzhi Zuo <jerry.zuo@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ Backport for file path changed ]
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -781,7 +781,7 @@ enum dc_status dcn20_enable_stream_timin
 		return DC_ERROR_UNEXPECTED;
 	}
 
-	fsleep(stream->timing.v_total * (stream->timing.h_total * 10000u / stream->timing.pix_clk_100hz));
+	udelay(stream->timing.v_total * (stream->timing.h_total * 10000u / stream->timing.pix_clk_100hz));
 
 	params.vertical_total_min = stream->adjust.v_total_min;
 	params.vertical_total_max = stream->adjust.v_total_max;


