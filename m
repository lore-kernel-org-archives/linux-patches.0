Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4332FFDEA;
	Sat, 12 Sep 2026 14:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222945; cv=none; b=FSXLjHjd0itMk4Hz44WfG0HQntxK/gKaBkCNVn9/TJpfVoGdiw7cRL8WNdmmOR73Z06lkm1QGWnh4T+T2KL9njuUO4i1P9fe2Fd6xCRKMj8w5ulLdo75ptVNSAF05VTObZl7618zynCVP3WiWOkOOqFHK4DC6jPy/fJPRpepyKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222945; c=relaxed/simple;
	bh=v1QQ1h4TiP8Ods35kqtE9UWeVR/Cyvy3htvN1PGBhHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4zLZTxL4O8Yf10g0FSDJ8+pN6zowHt0MdAYBs9bd0L8ZaflNnd3AT1HBl7mOehLTjScIiTwY489dlaTaHSvQbSQoOrcnOkO38Jgny6c6+RPdA/owr5ZLetSCxI7dCCwcrznCWyDOjM7sDVpDtAIFrp3tLMc8dng2AAti1F35e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZ6Fg9s3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZ6Fg9s3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF27B1F000FF;
	Sat, 12 Sep 2026 14:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222934;
	bh=6fx5kNxSRNgtF7xneoZOS0IRR5QPYyQlpHFV8B0tFT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZ6Fg9s3eM+IRVxXM97+IJ1Zb2nyzjOnRePaMGWCe5nPpnsR16xVGX/WZDJQ2bDOn
	 Ss7+PMavm8aUUcDvoDBtv0IPhyYDyBWTY+NrDKwyBSj6HzGHfol/BG/MNxDW2NBA+o
	 JABMDTTKRHkgRTHISrJWfWjsk11/+C2Izcbalr1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0688/1424] efi: fix stale reference to efi_recover_from_page_fault()
Date: Sat, 12 Sep 2026 08:52:00 +0200
Message-ID: <20260912065622.707274454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 718ee46ba4d95d28d50d3f6437afbbe2be531175 ]

efi_recover_from_page_fault() was renamed to
efi_crash_gracefully_on_page_fault(), but the comment above enum
efi_rts_ids was not updated. Use the current name.

Fixes: c46f52231e79 ("x86/{fault,efi}: Fix and rename efi_recover_from_page_fault()")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/efi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 7db1c0759c096..a066f58db5f5b 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1236,8 +1236,8 @@ efi_call_acpi_prm_handler(efi_status_t (__efiapi *handler_addr)(u64, void *),
 
 /*
  * efi_runtime_service() function identifiers.
- * "NONE" is used by efi_recover_from_page_fault() to check if the page
- * fault happened while executing an efi runtime service.
+ * "NONE" is used by efi_crash_gracefully_on_page_fault() to check if the
+ * page fault happened while executing an efi runtime service.
  */
 enum efi_rts_ids {
 	EFI_NONE,
-- 
2.53.0



