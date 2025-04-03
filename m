Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CB0188A3A;
	Thu,  3 Apr 2025 15:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743694029; cv=none; b=HPQZPeCpo4ftKYFvjyyb8Ox9bicqhW7rQ+AhWRo305WZsla36FAws0huzWvNhXkBY+u1vKNQw8j2rFmCXUOL9aumj0YQFacs+eYQKseCvhGGNnZ6yBwlIMW+DSGsvWKoKZeNJunwwdSqf9hTWMhE6rtSCF3cU88y7H61sm+cQhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743694029; c=relaxed/simple;
	bh=+SZmby7JXte8km4UnK2OIJUpdtQpJFxK9UYKkJscpA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7mfmlJge4NZQoiV+kOFrZb5wdqqYHF5ZIHw3iwwZ7HPTncNazIIe0mfwYP8Ufp1iHKeihzXyN+aSzOoCC44URtWyJs0n1ufdZspGZyA5JML0WeWUsAIX/otdNZDfJBEZpV0bxmyoncDzX/ozx5ConGbJl2umyTPJbx5DkRKRkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSdl1nN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSdl1nN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2138C4CEE5;
	Thu,  3 Apr 2025 15:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743694029;
	bh=+SZmby7JXte8km4UnK2OIJUpdtQpJFxK9UYKkJscpA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSdl1nN3XiD/r8Clr+A83YpzM1lVqLURrH92IbUGZ/Gd+RHcmauInejKycRsh1Qur
	 5m70jWEG5LjO4rfn6D4ary/3A1Fef1nrZHyJJTK0OUHPRTJ439GmKLicWPGQmSpbOT
	 IBfQvNJ0hsCxLXfzcXIsuAfj656e6YpTFgB+q1Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Cliff Liu <donghua.liu@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 6.6 07/26] drm/amd/display: Check denominator crb_pipes before used
Date: Thu,  3 Apr 2025 16:20:28 +0100
Message-ID: <20250403151622.627391457@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.415201055@linuxfoundation.org>
References: <20250403151622.415201055@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit ea79068d4073bf303f8203f2625af7d9185a1bc6 upstream.

[WHAT & HOW]
A denominator cannot be 0, and is checked before used.

This fixes 2 DIVIDE_BY_ZERO issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Cliff Liu <donghua.liu@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn315/dcn315_resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn315/dcn315_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn315/dcn315_resource.c
@@ -1753,7 +1753,7 @@ static int dcn315_populate_dml_pipes_fro
 				bool split_required = pipe->stream->timing.pix_clk_100hz >= dcn_get_max_non_odm_pix_rate_100hz(&dc->dml.soc)
 						|| (pipe->plane_state && pipe->plane_state->src_rect.width > 5120);
 
-				if (remaining_det_segs > MIN_RESERVED_DET_SEGS)
+				if (remaining_det_segs > MIN_RESERVED_DET_SEGS && crb_pipes != 0)
 					pipes[pipe_cnt].pipe.src.det_size_override += (remaining_det_segs - MIN_RESERVED_DET_SEGS) / crb_pipes +
 							(crb_idx < (remaining_det_segs - MIN_RESERVED_DET_SEGS) % crb_pipes ? 1 : 0);
 				if (pipes[pipe_cnt].pipe.src.det_size_override > 2 * DCN3_15_MAX_DET_SEGS) {


