Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F9C8F5B;
	Tue,  8 Jul 2025 16:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993004; cv=none; b=OCNI2A2tvsU3MI1wwwmll+SN6FK1F2pxKYGnzAKAbN6fVXd/+V61NtJ3kigY1Ee8FE/wL+c4apV76FhNYyYXLUmmkoha0QCEg3SNX2rMO6TrL9+wSXghy2X1/3cWk8fIheHxibGs/zyYS+lmjQYp9c+5HgwcKk/bWsiKbuQJOLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993004; c=relaxed/simple;
	bh=FEDs2bFYZz9wD4eCrEEc387rxqhzmhYp0KZAVkI3vhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nK5wPlpvb02FBwol0cWk8xsaUZSXF7S69h4RYkbFIh/SetoQYaMvsQP8r7rGKeU43OHe0BpSqyNCTe4PNww4Hq+0jlLxUNnmd0gAFmrvRyowomvRPzZvH/m/buxpqGJBCkY03IGXKV3z4/onO5Wqf3aWydRa7woPe7v8VC1LrwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u51oUnks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u51oUnks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36B8C4CEED;
	Tue,  8 Jul 2025 16:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993004;
	bh=FEDs2bFYZz9wD4eCrEEc387rxqhzmhYp0KZAVkI3vhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u51oUnksI+G6IhxvuVBpWAalH4DJA9n605Kf0mNm12nNuvjeRUXHBnigmMN7Es23O
	 HacQyEY2ujM4I3COLmc/DoOXFx1oj8SNzzbRmLxE/d18EWIE8a9vvhH2E76r3IROCm
	 85O6XCJjyNqiJ1gfOKxgx/RpFfaA1legH8rVZ2lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/232] drm/xe: Move DSB l2 flush to a more sensible place
Date: Tue,  8 Jul 2025 18:22:30 +0200
Message-ID: <20250708162245.466846708@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

[ Upstream commit a4b1b51ae132ac199412028a2df7b6c267888190 ]

Flushing l2 is only needed after all data has been written.

Fixes: 01570b446939 ("drm/xe/bmg: implement Wa_16023588340")
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: stable@vger.kernel.org # v6.12+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://lore.kernel.org/r/20250606104546.1996818-3-matthew.auld@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 0dd2dd0182bc444a62652e89d08c7f0e4fde15ba)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_dsb_buffer.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/xe_dsb_buffer.c b/drivers/gpu/drm/xe/display/xe_dsb_buffer.c
index f95375451e2fa..9f941fc2e36bb 100644
--- a/drivers/gpu/drm/xe/display/xe_dsb_buffer.c
+++ b/drivers/gpu/drm/xe/display/xe_dsb_buffer.c
@@ -17,10 +17,7 @@ u32 intel_dsb_buffer_ggtt_offset(struct intel_dsb_buffer *dsb_buf)
 
 void intel_dsb_buffer_write(struct intel_dsb_buffer *dsb_buf, u32 idx, u32 val)
 {
-	struct xe_device *xe = dsb_buf->vma->bo->tile->xe;
-
 	iosys_map_wr(&dsb_buf->vma->bo->vmap, idx * 4, u32, val);
-	xe_device_l2_flush(xe);
 }
 
 u32 intel_dsb_buffer_read(struct intel_dsb_buffer *dsb_buf, u32 idx)
@@ -30,12 +27,9 @@ u32 intel_dsb_buffer_read(struct intel_dsb_buffer *dsb_buf, u32 idx)
 
 void intel_dsb_buffer_memset(struct intel_dsb_buffer *dsb_buf, u32 idx, u32 val, size_t size)
 {
-	struct xe_device *xe = dsb_buf->vma->bo->tile->xe;
-
 	WARN_ON(idx > (dsb_buf->buf_size - size) / sizeof(*dsb_buf->cmd_buf));
 
 	iosys_map_memset(&dsb_buf->vma->bo->vmap, idx * 4, val, size);
-	xe_device_l2_flush(xe);
 }
 
 bool intel_dsb_buffer_create(struct intel_crtc *crtc, struct intel_dsb_buffer *dsb_buf, size_t size)
@@ -74,9 +68,12 @@ void intel_dsb_buffer_cleanup(struct intel_dsb_buffer *dsb_buf)
 
 void intel_dsb_buffer_flush_map(struct intel_dsb_buffer *dsb_buf)
 {
+	struct xe_device *xe = dsb_buf->vma->bo->tile->xe;
+
 	/*
 	 * The memory barrier here is to ensure coherency of DSB vs MMIO,
 	 * both for weak ordering archs and discrete cards.
 	 */
-	xe_device_wmb(dsb_buf->vma->bo->tile->xe);
+	xe_device_wmb(xe);
+	xe_device_l2_flush(xe);
 }
-- 
2.39.5



