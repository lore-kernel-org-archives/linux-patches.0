Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90F61DE3B8;
	Wed,  6 Nov 2024 12:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896318; cv=none; b=asop3O1q6ic5X/3atqmZpm1F1Gj7CuqO2nnSEN/kj0BQw3xKXgfU5iw9/Np08sMKM2rcRvvBzksiSINguPBx/ktIYbqZzXZ0M32h7yH0JkH23YPcDueWkxQOyZu6DWhnGRYcIU0vU6+50HHqcPdCh8qbSN0rexYAOjN1RiIxlcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896318; c=relaxed/simple;
	bh=hROys7sl4KMGKt1GuuyyHmTEtQ3lBRqPBiRNilE73I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvcqORv026+kU/G/44P7/eJCauwK33AJLN44FuzscozwniPUCwFxjzbe1YQy+BWWFbq18km0JIDHnXm4M3DvZKj4kjNOlcvYvIlM4+u4OVNF64jbaXYbj799q9xxkdizQ8u2os9zTFHvOnviQVxKVQ4+aIbVD3GZskWt97U6ZlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7oSzN4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7oSzN4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E06AC4CECD;
	Wed,  6 Nov 2024 12:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896318;
	bh=hROys7sl4KMGKt1GuuyyHmTEtQ3lBRqPBiRNilE73I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7oSzN4IwItbXoK3J7yGmN6xn7QZyFrf3om4tIPb9CssZqaxP3+2fKlkITgdhX2Uy
	 IX6g26wMqRfiWPrVmq/Fg15PTHX7a+CmElwo4N634le2goymI9vQeWpu+5WPA/0p8o
	 YPnul6VqBciYhdvYz038kW0/5p5o9oz+SKtiYot4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 156/245] riscv: efi: Set NX compat flag in PE/COFF header
Date: Wed,  6 Nov 2024 13:03:29 +0100
Message-ID: <20241106120323.070242201@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>

[ Upstream commit d41373a4b910961df5a5e3527d7bde6ad45ca438 ]

The IMAGE_DLLCHARACTERISTICS_NX_COMPAT informs the firmware that the
EFI binary does not rely on pages that are both executable and
writable.

The flag is used by some distro versions of GRUB to decide if the EFI
binary may be executed.

As the Linux kernel neither has RWX sections nor needs RWX pages for
relocation we should set the flag.

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Reviewed-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Fixes: cb7d2dd5612a ("RISC-V: Add PE/COFF header for EFI stub")
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20240929140233.211800-1-heinrich.schuchardt@canonical.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/efi-header.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/efi-header.S b/arch/riscv/kernel/efi-header.S
index 515b2dfbca75b..c5f17c2710b58 100644
--- a/arch/riscv/kernel/efi-header.S
+++ b/arch/riscv/kernel/efi-header.S
@@ -64,7 +64,7 @@ extra_header_fields:
 	.long	efi_header_end - _start			// SizeOfHeaders
 	.long	0					// CheckSum
 	.short	IMAGE_SUBSYSTEM_EFI_APPLICATION		// Subsystem
-	.short	0					// DllCharacteristics
+	.short	IMAGE_DLL_CHARACTERISTICS_NX_COMPAT	// DllCharacteristics
 	.quad	0					// SizeOfStackReserve
 	.quad	0					// SizeOfStackCommit
 	.quad	0					// SizeOfHeapReserve
-- 
2.43.0



