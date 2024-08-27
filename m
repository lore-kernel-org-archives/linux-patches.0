Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF4573466;
	Tue, 27 Aug 2024 15:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771145; cv=none; b=qv+JYqNhWe0J+ePoS6kUCmn1pQfMtrkZMWal3QtVwIQXgtiCxoWG8VjoPzyl6WwSfG7LVHpR9FqIKvuO1rh7zAcbnrSq5PvtkrLQzjQJ02//e3VeSNfYxEoQ3GJy5ChAGoRbdx8dOo8IOiQ7BY+XsixFqbcfkelQuCOtITsBFLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771145; c=relaxed/simple;
	bh=Sx9RNpkWm+MBEWFkAsWDFukP1x1zUS7XYWSd64KTlDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVll4zOp9l7IGy5X5/94718qqexM1I3nrs26/wSPUDCnJaE6+8iUkvFe62ncCXerkmLE/vJlHmtHZpcxT+bso9EwnJwLUpmOp14YRLjz0zx438IJn5HtS5DseTnYeDGYiyYZkp8ytxIIlwjZ0JgNUJmexbaXPJJ/+hmh0gtM4Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqEC9X3q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqEC9X3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2CDC6106C;
	Tue, 27 Aug 2024 15:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771145;
	bh=Sx9RNpkWm+MBEWFkAsWDFukP1x1zUS7XYWSd64KTlDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqEC9X3qJhUlYEC0fcdwAjmrdakxvdm8XC5CSR0CszIGZ9fqHAtN8FsiMh0+fGsYl
	 cQKZQ1RO2XwmYPyr7toLDkvs2xAUe8EgKBRzDOCP8HAe1XtmtkwWxlMKBtbEQjPdsQ
	 ojtac+u66Njh/IlULC76xKwAJtAbKMPHEsymG1Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.10 069/273] drm/amd/display: Adjust cursor position
Date: Tue, 27 Aug 2024 16:36:33 +0200
Message-ID: <20240827143836.042391774@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

commit 56fb276d0244d430496f249335a44ae114dd5f54 upstream.

[why & how]
When the commit 9d84c7ef8a87 ("drm/amd/display: Correct cursor position
on horizontal mirror") was introduced, it used the wrong calculation for
the position copy for X. This commit uses the correct calculation for that
based on the original patch.

Fixes: 9d84c7ef8a87 ("drm/amd/display: Correct cursor position on horizontal mirror")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8f9b23abbae5ffcd64856facd26a86b67195bc2f)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
@@ -3698,7 +3698,7 @@ void dcn10_set_cursor_position(struct pi
 						(int)hubp->curs_attr.width || pos_cpy.x
 						<= (int)hubp->curs_attr.width +
 						pipe_ctx->plane_state->src_rect.x) {
-						pos_cpy.x = 2 * viewport_width - temp_x;
+						pos_cpy.x = temp_x + viewport_width;
 					}
 				}
 			} else {


