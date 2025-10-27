Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F2231D749;
	Mon, 27 Oct 2025 18:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590967; cv=none; b=KdBkOr2uEAOO31FusKOqT6yUBRNPq94hhwGhtZvweE1zOnwfe/yRVdsQ3LO18edeuNKwUX3coSrW22rABWuYmlpclzZxp8ZTSFtbw0uDurdiPSDNu6R5ePS6kSNlOZCn2KbcW6ORv3Atf1tQyylC7rThdrCdsagfzumCSk+LXKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590967; c=relaxed/simple;
	bh=HqBPMyqeUs7cKw8CQCavPR52Mky3e8Bq5ToybHHno2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpGDCHiR1jTlIIZw4BjDtQxOCovGBPPjIzvTPXHPJRYo/sulLZsiPaHniIbWvQo0UCF/joHi6DUrws3sH7ZPfRfTCAJW4SCO7DoAcISd+X0NtAnhogbvRlkrH/BBMtyUzKHT9Fe4s2VpB5p6A2gICypyWubRPlQJN/udTwLW2dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Os3HhoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Os3HhoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C16C4CEF1;
	Mon, 27 Oct 2025 18:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590966;
	bh=HqBPMyqeUs7cKw8CQCavPR52Mky3e8Bq5ToybHHno2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Os3HhoPd1YFMK550DfkvmJN+WJbLUaAawk+CvMH0dRzAf5ECCxjpd5/AFndWZGrB
	 QFWSiXuG3+bV4v8162OyQClyPBsLSzwlepejksSVSIzUK4+g7j8JadYl/d55Mo5wDh
	 ANzwUWtyccZT+bbsc45evpAOjngqtItaaPfvk3kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lang Yu <Lang.Yu@amd.com>,
	Roman Li <roman.li@amd.com>,
	Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Eslam Khafagy <eslam.medhat1993@gmail.com>
Subject: [PATCH 5.10 017/332] drm/amd/display: Remove redundant safeguards for dmub-srv destroy()
Date: Mon, 27 Oct 2025 19:31:10 +0100
Message-ID: <20251027183525.078411377@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Roman Li <roman.li@amd.com>

commit 3beac533b8daa18358dabbe5059c417d192b2a93 upstream.

[Why]
dc_dmub_srv_destroy() has internal null-check and null assignment.
No need to duplicate them externally.

[How]
Remove redundant safeguards.

Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Eslam Khafagy <eslam.medhat1993@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1141,10 +1141,8 @@ static void amdgpu_dm_fini(struct amdgpu
 	if (adev->dm.dc)
 		dc_deinit_callbacks(adev->dm.dc);
 #endif
-	if (adev->dm.dc->ctx->dmub_srv) {
-		dc_dmub_srv_destroy(&adev->dm.dc->ctx->dmub_srv);
-		adev->dm.dc->ctx->dmub_srv = NULL;
-	}
+
+	dc_dmub_srv_destroy(&adev->dm.dc->ctx->dmub_srv);
 
 	if (adev->dm.dmub_bo)
 		amdgpu_bo_free_kernel(&adev->dm.dmub_bo,


