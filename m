Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DF52C2598;
	Wed, 23 Apr 2025 15:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422486; cv=none; b=lT3UqHFdgOXWATK1kOFQ7avoSbOXp7/bB899JSGTCwu9PjUjrhrupSUhN/bx+AfMF5SjLQWPxji0IdHlr5KxwSXwL3AucVDgFz3eKHFIjtclrSuulMzU5DpcEHmlTmT920cAVOHm23oSgKv072M+pV/uwgy/v/7Rh+sQMdvtsFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422486; c=relaxed/simple;
	bh=IjRbjy5JJiXhw7bmD6BoKqi+bzN6hVAGwgVD/vzU/Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tp8GW7z47VLlYco3Iux5KcbBabqA/XPnqiZws2JYbW3nN8h6QmWfW/aeyi+gdwBmBRAG/YNgKUQatt9HqnYDRCPSL93p3a9ZWJjzK1naJCsghJ1V2hqVCdEKSHVuOz/puJRxfZlXmkk4PtVMlp/9mnJIC3RWrHpf1xvTf5tBeJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKOL4+eR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKOL4+eR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B933C4CEE3;
	Wed, 23 Apr 2025 15:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422485;
	bh=IjRbjy5JJiXhw7bmD6BoKqi+bzN6hVAGwgVD/vzU/Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKOL4+eRQw2757pdGtZ9AqRGwZl6q+X0I4fFA36uIjBhnQ9a5yEanxDP5iTm5KjDl
	 lYhMMlhhh66te7L6iPC07iMYz1Czsql0aDUjKbKxpICXIMoLlLKteAoN9Xn1dd9MR4
	 vEkO4vHXRRj9AUNaqOwFWIt0Mi2eE36KSombuGbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Allen Pais <apais@linux.microsoft.com>
Subject: [PATCH 6.6 369/393] efi/libstub: Bump up EFI_MMAP_NR_SLACK_SLOTS to 32
Date: Wed, 23 Apr 2025 16:44:25 +0200
Message-ID: <20250423142658.578731331@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>

commit ec4696925da6b9baec38345184403ce9e29a2e48 upstream.

Recent platforms require more slack slots than the current value of
EFI_MMAP_NR_SLACK_SLOTS, otherwise they fail to boot. The current
workaround is to append `efi=disable_early_pci_dma` to the kernel's
cmdline. So, bump up EFI_MMAP_NR_SLACK_SLOTS to 32 to allow those
platforms to boot with the aforementioned workaround.

Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Allen Pais <apais@linux.microsoft.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/efistub.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -171,7 +171,7 @@ void efi_set_u64_split(u64 data, u32 *lo
  * the EFI memory map. Other related structures, e.g. x86 e820ext, need
  * to factor in this headroom requirement as well.
  */
-#define EFI_MMAP_NR_SLACK_SLOTS	8
+#define EFI_MMAP_NR_SLACK_SLOTS	32
 
 typedef struct efi_generic_dev_path efi_device_path_protocol_t;
 


