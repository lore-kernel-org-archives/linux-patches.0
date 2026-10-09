Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78ADF125AA;
	Fri,  9 Oct 2026 14:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556414; cv=none; b=KLXJlfvRXvSItq9KPTkLxlrB7Lfp1RabhvTa2w6f6kAhvL+Gsp3/hWTUiJ0ZYO3uTzBgrW8/vQh74wqGIr8sRNcF5X8vRvTS0eW43oLWJw+uKmb3at260JU4V9pOZ1R0s5EK9I+atmACExBJNJrViy0ixvl/vPX1qcATP3KeAuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556414; c=relaxed/simple;
	bh=YYiFt9FD4Ds2qaWez9nKeVLqp7Hlo1rLRfbeT9FxrK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nGRh0f+8K1v19Zjv6dqdz1neReV6E4LlG9xaMMrNt70rPgyk8C+tSiv4uk1wH8Jif0KYqYKTOE/IdaXcfAts1ZdfXjm9CV46yKpX/A6/LUOTY6FnJBSc0qmGANYWKtmK0iOD+o7ZeNmOPIsEUYAl9onvh1ebZMAcgPRMuLtb9kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zeLpxRf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zeLpxRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A3F1F000FF;
	Fri,  9 Oct 2026 14:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556413;
	bh=0OOTIISfAOs9/C5gxLQqL3rXQkDAyWcopxSxuRHnsvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1zeLpxRfDOiguPLLQ26mMWmVzPeArcwONAOblFKQcS7mnua7UyXFUCfrTXvRTVotp
	 JChY0xl09g9SDZ9O531DWQnPfdU90U4zC81gX/DNX0Xn2dLkcf26yNu/A+4/5cE0O0
	 lCTvCXXv71NZF1P+gv2XqFSUIQMCEqSY3xcgsbxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 172/428] drm/amd/display: Fix fast updates on DCE 8.1
Date: Fri,  9 Oct 2026 16:08:29 +0200
Message-ID: <20261009140949.931505615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit 687d31ea9ac76b299817060fa1e5582d6c752ae0 upstream.

DCE8 should use legacy fast updates.
This was already set for DCE 8.0 and 8.3, but it seems
that DCE 8.1 (found in Kaveri chips) was forgotten.

This fix should be backported to all kernel versions that
have "Refactor fast update to use new HWSS build sequence",
but this patch won't apply cleanly to older kernels due to
another refactor in "Remove dc param from check_update".

Fixes: 0baae6246307 ("drm/amd/display: Refactor fast update to use new HWSS build sequence")
Fixes: 9ec11bb842b6 ("drm/amd/display: Remove dc param from check_update")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260923122033.1046651-2-timur.kristof@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 57605379559e3b5044c8274a1010ec658e5e73af)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
@@ -1148,6 +1148,8 @@ static bool dce81_construct(
 	dc->caps.max_cursor_size = 128;
 	dc->caps.min_horizontal_blanking_period = 80;
 	dc->caps.is_apu = true;
+	dc->debug = debug_defaults;
+	dc->check_config = config_defaults;
 
 	/*************************************************
 	 *  Create resources                             *


