Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D5A6CDC9;
	Tue, 14 May 2024 10:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683924; cv=none; b=Fad46WsvTf+AJeKTellbkbm0fhxp9HaaoPIF9xYZNTZz7lwOtwi1FGVKLMc83DG1De1Hlm4LArululMtJtrEnoXX72pzlfPlUB4nvlVIYCX4onyoc958ioIQ2wSQfEg0qUPf/gYIWi4rXmLZw2Lwx/nVt5B6oMeHQ7avK+ztOxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683924; c=relaxed/simple;
	bh=WMJQLQK3xvtxXIucFzzsCvik3TpnnQ8GDX/UfG/DdT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b5QGdGbUr3kvfrV+a5cx/eYmZM2qA+Z44tLAaqIpNBPEDi2+WEUsYlvMRMLxXEA1PoY2fEXlvyNAVSrzakeyA7z+izHWAhISUMFZI8WL7wiuUJcN03K6/oRvgiEmJ3RexqHJLrtYouXsRCbtcC+vI2xNOUAJxz0w3jYxyeGneTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rq3Cz4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rq3Cz4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4469EC2BD10;
	Tue, 14 May 2024 10:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683924;
	bh=WMJQLQK3xvtxXIucFzzsCvik3TpnnQ8GDX/UfG/DdT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rq3Cz4UrpBXEQ3MrY1RZVqRZNn1ej5WuOR1RKvOQRvf3eCpZ3O66o2wL9lJ91qxb
	 sOX8v4GYJG/5d/7S9IGARSdBhDz3eH7Z75kOOJK0/rlx8Gc9YejWmAGJa3h2UpIH4U
	 UowE86m3WpuEhLx4RkVRdC8ZqGXnXICVl4PUyuBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.8 296/336] drm/ttm: Print the memory decryption status just once
Date: Tue, 14 May 2024 12:18:20 +0200
Message-ID: <20240514101049.790528517@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit 27906e5d78248b19bcdfdae72049338c828897bb upstream.

Stop printing the TT memory decryption status info each time tt is created
and instead print it just once.

Reduces the spam in the system logs when running guests with SEV enabled.

Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Fixes: 71ce046327cf ("drm/ttm: Make sure the mapped tt pages are decrypted when needed")
Reviewed-by: Christian König <christian.koenig@amd.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: <stable@vger.kernel.org> # v5.14+
Link: https://patchwork.freedesktop.org/patch/msgid/20240408155605.1398631-1-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_tt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -92,7 +92,7 @@ int ttm_tt_create(struct ttm_buffer_obje
 	 */
 	if (bdev->pool.use_dma_alloc && cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
 		page_flags |= TTM_TT_FLAG_DECRYPTED;
-		drm_info(ddev, "TT memory decryption enabled.");
+		drm_info_once(ddev, "TT memory decryption enabled.");
 	}
 
 	bo->ttm = bdev->funcs->ttm_tt_create(bo, page_flags);


