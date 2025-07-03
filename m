Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BCC2B9A6;
	Thu,  3 Jul 2025 15:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555046; cv=none; b=gt2l7nok54HcN6UVX/ajJ7M0mKqDc1AorEFzHyEhtT9VDW//GU8XazJw50wjPQkohMqSFRpi4pIU1ObjMpfa9iMO0TpSewdAE1B9Y3As/0uzVoGDjL7UzawYK+TIveuar+s8+k18cCb/lFz+U27Wc5/FF2mzTOUBIZ5B02G8IHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555046; c=relaxed/simple;
	bh=zlV02ZBjBEDJnH+Q//eXTSipMx0Id8QlcqeiDK2X+Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eR+SVM+vvKh2EgI8jDgipE48WNao+iR43II0bO12ALm2uJhyZYtHHhGJQRo0x+imbmHaag8lWvzewHB98ZYzIjn4+o4z2nvWiXN6KmD7aFvpODDVdFmipW+eOTiMEH7erFQ6Ue5fB7NYmkhkwpTKX05cWxAsSn/HN9f4pFr0Bzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odRgno7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odRgno7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363BDC4CEE3;
	Thu,  3 Jul 2025 15:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555046;
	bh=zlV02ZBjBEDJnH+Q//eXTSipMx0Id8QlcqeiDK2X+Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odRgno7AqJa6Fu9Axz6QN6WqFOUm1KOAQ9tsHsuuUb6w9AhlmU1JEoVn1flV3CilO
	 DF2dobvMDjEMoea0xN3AQI4Gcr6kHjbxcemwI+jev30ppbWyZNg4BAzd553WJqaBUU
	 bfw50u6V19AW2DhooRAHu15pcVP3pE7aaabq2J7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.15 129/263] drm/xe: Move DSB l2 flush to a more sensible place
Date: Thu,  3 Jul 2025 16:40:49 +0200
Message-ID: <20250703144009.528175416@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

commit a4b1b51ae132ac199412028a2df7b6c267888190 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/display/xe_dsb_buffer.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/xe/display/xe_dsb_buffer.c
+++ b/drivers/gpu/drm/xe/display/xe_dsb_buffer.c
@@ -17,10 +17,7 @@ u32 intel_dsb_buffer_ggtt_offset(struct
 
 void intel_dsb_buffer_write(struct intel_dsb_buffer *dsb_buf, u32 idx, u32 val)
 {
-	struct xe_device *xe = dsb_buf->vma->bo->tile->xe;
-
 	iosys_map_wr(&dsb_buf->vma->bo->vmap, idx * 4, u32, val);
-	xe_device_l2_flush(xe);
 }
 
 u32 intel_dsb_buffer_read(struct intel_dsb_buffer *dsb_buf, u32 idx)
@@ -30,12 +27,9 @@ u32 intel_dsb_buffer_read(struct intel_d
 
 void intel_dsb_buffer_memset(struct intel_dsb_buffer *dsb_buf, u32 idx, u32 val, size_t size)
 {
-	struct xe_device *xe = dsb_buf->vma->bo->tile->xe;
-
 	WARN_ON(idx > (dsb_buf->buf_size - size) / sizeof(*dsb_buf->cmd_buf));
 
 	iosys_map_memset(&dsb_buf->vma->bo->vmap, idx * 4, val, size);
-	xe_device_l2_flush(xe);
 }
 
 bool intel_dsb_buffer_create(struct intel_crtc *crtc, struct intel_dsb_buffer *dsb_buf, size_t size)
@@ -74,9 +68,12 @@ void intel_dsb_buffer_cleanup(struct int
 
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


