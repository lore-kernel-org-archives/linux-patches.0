Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B185646BA0;
	Mon,  4 Mar 2024 21:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589086; cv=none; b=fZfEA77N6/aBcSZLoZKpgZXpHUbdO22jWiJy3yBx5MePMkKuL73qh/YQtABKLwWsMwzZHxb6sJyaqeI/i78PBGIjDEub4qcugv35OxY7ebJj/y0Nh+u1AalnXMHrmqMtJ+ZP5C7G7y2I+hRgEt5Thlh3/SKngBJmjj0IXtQChKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589086; c=relaxed/simple;
	bh=r7rBAuxZfqGJBnAR+8WOG9WwxQpsDzkCat8keTzkzxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIAwk26eMuPhN8cmleT3If+Jl+hQ+Bk0sdbwtON0drelaQmaBGVTq7jA26u6T7ssLVk9k100ms7OLbFwgF4zeIgUYin1ixZVRPpaQEspmWrlUYAyccWoFrvelYS3IUyrDZOWZVZWcHODK8YvGPLXaJf2ril8fGvnLXSlPglZBUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNC3wnCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNC3wnCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF758C433C7;
	Mon,  4 Mar 2024 21:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589086;
	bh=r7rBAuxZfqGJBnAR+8WOG9WwxQpsDzkCat8keTzkzxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNC3wnCEg/HbdncsY9JC/s8BXovO3dwhRw0C2PAdPsE7Sa8xtmTeThY4ZKGrOmUZm
	 5Qcjs6hY9oNctmPC7t+cIeBuEwJzh+VNySmndQprX16szMibXOMbsPFElBlarx1p9p
	 BR/F4PTrltxKNYKF2yzYoX2DhhsCRW9Ttcgx5hJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.1 195/215] x86/boot: efistub: Assign global boot_params variable
Date: Mon,  4 Mar 2024 21:24:18 +0000
Message-ID: <20240304211603.160841173@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ard Biesheuvel <ardb+git@google.com>

From: Ard Biesheuvel <ardb@kernel.org>

[ Commit 50dcc2e0d62e3c4a54f39673c4dc3dcde7c74d52 upstream ]

Now that the x86 EFI stub calls into some APIs exposed by the
decompressor (e.g., kaslr_get_random_long()), it is necessary to ensure
that the global boot_params variable is set correctly before doing so.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/x86-stub.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -827,6 +827,8 @@ void __noreturn efi_stub_entry(efi_handl
 	unsigned long kernel_entry;
 	efi_status_t status;
 
+	boot_params_ptr = boot_params;
+
 	efi_system_table = sys_table_arg;
 	/* Check if we were booted by the EFI firmware */
 	if (efi_system_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)


