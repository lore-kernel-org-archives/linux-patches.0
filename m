Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94915479887;
	Sat, 12 Sep 2026 12:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215078; cv=none; b=HJjQ7MbbUGklIIgmaVSYEUZG3sz5nLYqKqlHICj63cOcaxgPdolWcbCsngw669VN9L2Rtmf6v6C+Ndjz09QEBalZxwtONxZ+eYtTIUGmGCOJRv8ne4T9+gjeLClI9J+fLOZCy5ccTWXcvFY4oCQoGAuFjzfi534UJAOM05EtyUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215078; c=relaxed/simple;
	bh=IqMSqsdo6BAQr/B2z7hSa0iLri/x5jQ2fQaagztiQcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bucnjI7fn8TdZ07z9vUN5IInIUlaWj7HI4ADlVEpWhoiaE2FKQoCL99Vf67r88lLZL8hYlwpkYtQMMSwXIpZ/9mePJ5dETJ7a0BYjYsxCSULJNR0ZvKtcETqZoUVbMSexTsB5xL7ebZkCQdvnLWKUNX8Fl397dEExE5jUe6ciHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAniG3H/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAniG3H/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF131F000FF;
	Sat, 12 Sep 2026 12:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215075;
	bh=1CogdlDnbhFeD5Y4R60DZMfUqGSp4Fk9LOH0DxkDOtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bAniG3H/1Rh8u/2WGAqxSaXY4SJoLg4Th8IH6syiOEJaRWKlj2b+VHVPl+FnEpyAC
	 /3VA3+/e5K4U9L18nBUB0IYvrck6IIEYSDG0RH+zr666Aroi8Tugx9h5TcDn16onNl
	 LgVhdZ1PA475yzd+3HfyYvpUDP9T109KF7F9RWoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0456/1376] efi: fix stale reference to efi_recover_from_page_fault()
Date: Sat, 12 Sep 2026 08:48:02 +0200
Message-ID: <20260912065617.694657186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2f1bfd7562eb2..06e8d3c69f9e6 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1239,8 +1239,8 @@ efi_call_acpi_prm_handler(efi_status_t (__efiapi *handler_addr)(u64, void *),
 
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



