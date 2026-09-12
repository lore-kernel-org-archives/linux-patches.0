Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8457282F1B;
	Sat, 12 Sep 2026 07:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198155; cv=none; b=ldYkEJxbgVkDjO+pu1NclhvrxyF+wGk7EFXA+2yN/t0VIlPPb8AB3mIJNwVvQNvR6Wuh18UQIQfP/A288dSkIXRd0uOdbeakM16C3sOSQMWtVfHSkqUARPnfLdYRxZhurBklRn2SOW3122dtd2nRLtu4orZl9rjWAe06rn9yUI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198155; c=relaxed/simple;
	bh=bHtYFZRYpn9SNPpp0DJOXpztytH5FlZOtkM7E3uvADc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etcfk+VYUELyE5pm4Csp+6K3lrrPSQykR8XK19RbKtIJKaygIJoNmeTuGcNDQy2xFNksYNThmru6Vb1AEkt0oFrKeTkQQ4HlD2CPQdklr3nDPDMvwfPtKmTmjmVPYeuFwjM6zrF9eB6BNqopzi92GWwFFzRuq0x5bD58NUcwHRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHkJqOkM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHkJqOkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50391F000FF;
	Sat, 12 Sep 2026 07:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198153;
	bh=wAJa04ZGejjZ2q5p87u2dvwliOIWG/VqYeiCzEvTuKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fHkJqOkMeS4inh71eEjvQjbY9HxQRrossvv92I2YzlwfkAdoWJ0AfLN7ewRLth2ty
	 tDRYkyRePJ1uWMrN+aVFgJnDOMa0/pMCt2gyUax+4v22nYym30nVEoo8jQPA47/MAQ
	 dK9I/VDtD3n0qOJ1MYEuT9D5ejjJq6dnI8bmCxC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0280/1815] efi: fix stale reference to efi_recover_from_page_fault()
Date: Sat, 12 Sep 2026 08:33:50 +0200
Message-ID: <20260912065655.536663629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ccbc35479684a..24221a8424121 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1212,8 +1212,8 @@ efi_call_acpi_prm_handler(efi_status_t (__efiapi *handler_addr)(u64, void *),
 
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



