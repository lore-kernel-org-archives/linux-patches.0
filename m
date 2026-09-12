Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D39344DBD;
	Sat, 12 Sep 2026 16:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229302; cv=none; b=cXvXKEQnSNk9QuiL+6E10hJGR+hzEsch23AZ5s51mwzgvpxEaZC7sZr0V+BN9bhjyieRcUcGrUW42FjZEOWK4omdThXTkSI32qBMb0RKam96/N63GygGAlzjICP6lZs1eXLefLtQoFiDE0QMZK8ssaxBendYr1jJLNc6I5BO7dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229302; c=relaxed/simple;
	bh=Amgib3uXIf7NC/AIO9AcPVDg4mqi5OGFr5n/Jg+zQcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FcGSMOhGlKytV60WXDJI48frVK945N+6KSgfgoTDVDv22u8SDokXl/5O54/VI1V57KXAMMuaqtxaSjH4qKY/US0bndzAF36XPbHuT3xBLnrbpRjifxVLuO2A1LyLJjuzlup0mY+yAXseqtwNU0sIRByDtOcybKIOO0e9hJr5SsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0P9xEq+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0P9xEq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243021F00893;
	Sat, 12 Sep 2026 16:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229300;
	bh=ZIZrK8C/aEILlOgAPIFQQlqg+5gaeuUlNe6g4wi8uE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d0P9xEq+nV2Mp+u/lvPeq5g08zsiYjkkJYnY4ApBRHMqTtaKm9bAa3eLUWEBUSAJv
	 CxuLkRyraLPq+QNGIvb9eDUDQzfld5Mds95omD0+QYsdSsuM3xXR2R+pqYpqV3QI91
	 FXi3BEBrRINGJUTg03KHC4KQ+jmkYcKv3bDP3PAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0563/1191] efi: fix stale reference to efi_recover_from_page_fault()
Date: Sat, 12 Sep 2026 08:54:51 +0200
Message-ID: <20260912065600.889728756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5868c4b293326..68b2c82df2b62 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1254,8 +1254,8 @@ extern unsigned long rci2_table_phys;
 
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



