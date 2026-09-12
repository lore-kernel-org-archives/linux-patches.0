Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9423217DFFA;
	Sat, 12 Sep 2026 09:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206858; cv=none; b=GeLK/9PhsaUv83/y9rerY+b2i9gobcJNxdiqdMpbRUa5R1ZS3V/gA+p0J38tDCzaPVdvRMUHE9Ik4BchNKyMs8YOEvu2CNzAXD6blrx/wL37wKYMAcfdB2tJdymRNZVq63ZV1i06FMLGVXNTtJJZs63scYsw9cZLbOf0sqANNLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206858; c=relaxed/simple;
	bh=2/fpB5bAXBKwcjKRfxLbjQ9eKV7l2S7akQOxLKjJkFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtQp3mu3JL9EbK0Acxp3A9ikrZuBRu7p87c2cNaAVn4tDSj8idqG/r87iQCnbZwAKKOMtdlQLdKZMZsbzAeHP86XNMjt7Ljz/ngIpqboKlI+66OQgZiZT+M6GRRz0H6+HxLYBNyMyakL727TqB703ku5NowJeAb5TZvc2OV81eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pf2HxACE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pf2HxACE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3121F000FF;
	Sat, 12 Sep 2026 09:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206857;
	bh=Mtf0EWMIeMqwNW26udQJOrQaEVG8VkYZTJ0FQ/9MIVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pf2HxACE8TZHUczh1VXBSJZBit8iaFHL7VpiRKzLzgp4wMGNxEO5zbDmKFz62eNMP
	 4COl7iWl+4vwfVAfRvPWz2YpEGtPqRvYhw3qoU0xz/QhW7ZOZm91FXUmy99nifR7Gk
	 WO89vTDRYmGX35iWphc5PdkUjr4K1Fih15v4x1RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0276/1518] efi: fix stale reference to efi_recover_from_page_fault()
Date: Sat, 12 Sep 2026 08:40:45 +0200
Message-ID: <20260912065629.726764244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a98cc39e7aaa8..0ec9f3dc596d4 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1228,8 +1228,8 @@ efi_call_acpi_prm_handler(efi_status_t (__efiapi *handler_addr)(u64, void *),
 
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



