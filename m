Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5673C1997;
	Thu, 15 Jan 2026 17:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499545; cv=none; b=mI/Rop4RcnfJqzT/9sI1hyd8ffON/+KxHk08RvAUNg+KTWtq8ZL/jjis3bKLtnKGzCBN3RxaY7ojoSWCygG0J0UCCj36HCUpU7NffyRYUSyBZK2u5PqmSu6hBOvHStmtOXZbrDBDj3bDn8/+VT48vqwX2OT/9vgN4OJRSgx4Z6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499545; c=relaxed/simple;
	bh=Wur3+XaQaKrJ4K3WAlihJl1MHcLKIbOk9ddHGULjgYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PsrljYG+ReC0haeK75T5E/TC3+rx7Bw3+n4BHSJIWepr7Wv9POvsHX84MNYsGm4syBsH98ET0kr2/biZuTwirTmDZpFu+PgiOSRbDBdDuY7CxKnRVbvkrR+iB0CmMzVa42Q7znywC/WXOinYBWX7yJUL91aEAPteatodaLrp0LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mAHAjAea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mAHAjAea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC09C116D0;
	Thu, 15 Jan 2026 17:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499545;
	bh=Wur3+XaQaKrJ4K3WAlihJl1MHcLKIbOk9ddHGULjgYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mAHAjAeaNClEy/Zvvah1GBNJ8tFiKISX5rtC1Ab9wKxnheKrlAQV/u7NeRgBf0dQb
	 c0bhoAQV2333U41tpJKhynDHLisf3/3z3MhsYynGCFUMLXxOyfYYcaGL+hkEC1Mtzx
	 KmHS4bqCi2vowq9vH1GQkYUHG4RgT40eoWEItrFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 263/451] drm/amd/display: Use GFP_ATOMIC in dc_create_plane_state()
Date: Thu, 15 Jan 2026 17:47:44 +0100
Message-ID: <20260115164240.399884319@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 3c41114dcdabb7b25f5bc33273c6db9c7af7f4a7 upstream.

This can get called from an atomic context.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4470
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8acdad9344cc7b4e7bc01f0dfea80093eb3768db)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_surface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_surface.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_surface.c
@@ -104,7 +104,7 @@ void enable_surface_flip_reporting(struc
 struct dc_plane_state *dc_create_plane_state(struct dc *dc)
 {
 	struct dc_plane_state *plane_state = kvzalloc(sizeof(*plane_state),
-							GFP_KERNEL);
+							GFP_ATOMIC);
 
 	if (NULL == plane_state)
 		return NULL;


