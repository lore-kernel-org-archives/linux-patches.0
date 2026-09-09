Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA89576EA7;
	Wed,  9 Sep 2026 14:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964282; cv=none; b=Z3x6KrQpjOw5KLYrXS0O05Wwg0dtnQJnb9L9ZsOfYhA+UDFXPbMY6NmI7Ykze5XXh+DBSs1SJ7ocNrFVAJA6EpAEK3ncSQ5ghJj3PfcdH9Er1uQVoEbxkhY5CM5yU19IhOoys+8hqCdSUTk7Yx7a3L6i67BhBy1r1d43A2ngVfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964282; c=relaxed/simple;
	bh=FeQevoiB6ktG73NlIT0vYizrUt6oJt2RQDyz6rKR4m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nIG2xaAUuJcVitJ4qeY68joUcl3+34ikmUr4ZGkCyyxI48fGAopnSoXbD6hPEJPEeVKR94ZgRUAZzvCI8DGFLXfDZ8+/KlpMwRK2mXwqDUy2DeQeCHJXjFnDRsOWKNjA5yvwkDTRMUYiTqR6tcBMtIEAFFlxp+8iGB/QlosjEMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1r0zgXO0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1r0zgXO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C591F00A3A;
	Wed,  9 Sep 2026 14:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964281;
	bh=dmoQ2jWmeiF9q3mf6opdUmbdhHZytiXNUf8xAb2JE8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1r0zgXO0+QJEZtnSUgQ07oFub8JvBKNXoHD6dWTydx/p2N3tMFoxWRo/kYXTARQJy
	 VR9JbkdhJSwcO6XtNj4Uqo1g0L9VB6hlfa3LZ91koKhvcSRRVoUoEcMXZEi92SsYih
	 bBdQWCVhabJioS7QDcirAKs2YzVDRkXmGxK8uqjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	stable@kernel.org
Subject: [PATCH 6.18 370/583] drm/xe/vram: report FLAT_CCS base misalignment
Date: Wed,  9 Sep 2026 15:40:55 +0200
Message-ID: <20260909134250.850181223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit 0e68c74e44da81a4599c52437ee1f63a2c234470 upstream.

So we can easily check if a machine had the CCS bug, when looking back
over bug reports where we have the same machine with newer kernel.

Example print for a machine with the CCS bug:

  FLAT_CCS base:27bbff800, aligned:no

v2 (Matt B):
  - Unconditionally print the base + alignment

Fixes: 37173392741c ("drm/xe/vram: fix ccs offset calculation")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: stable@kernel.org
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260902124117.918018-9-matthew.auld@intel.com
(cherry picked from commit d00b7f4f03bbeb2efad872f1686130e18c2b4141)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vram.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/xe/xe_vram.c
+++ b/drivers/gpu/drm/xe/xe_vram.c
@@ -207,6 +207,9 @@ static inline u64 get_flat_ccs_offset(st
 		offset |= offset_lo << 6; /* HW view bits 31:6 */
 		offset *= num_enabled; /* convert to SW view */
 
+		drm_info(&xe->drm, "FLAT_CCS base:%llx, aligned:%s\n", offset,
+			 str_yes_no(IS_ALIGNED(offset, SZ_128K)));
+
 		/*
 		 * Everything below this offset is handed to the VRAM
 		 * allocator, so it has to be the *first* address the


