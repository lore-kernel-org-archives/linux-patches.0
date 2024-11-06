Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD881FC7DA;
	Wed,  6 Nov 2024 12:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897735; cv=none; b=Ekwn6qkEMtf6tDMSi2H0WCMj+3FtNMvsAO5iCNodMMxWqXsHYpLnsWwgQ0ossBm3tKZWvHtCFtszB3OV8mBS6BcexYoFPzxAkbUUt9ncUl0wdUTN/yKvdQvq0279SGN/2J1WHqIOuzaryJHbxzuAg0lPisjjYmbk3yH18WBpQ9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897735; c=relaxed/simple;
	bh=TMUggIWQG66uPpO7d1uynyRpfdSJSTtncwvw4ZrPjjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VF53Li63OpVk1nZ4UV48p0fw3QrQ5TkrhUYG1eA49v3Pp/vPbWTh5wVTJgXgLuC+46rGAMgUu01H/t8qLWmD+9n9Q7XhxxxP/br7gnj+3dLub3w55zdibHxB9DDDgeqwrQLWA7oVtTitXgR9ZLX9dJHXujYoWhPeXKvNkUPzmlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ud6VGV7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ud6VGV7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC47C4CEF0;
	Wed,  6 Nov 2024 12:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897735;
	bh=TMUggIWQG66uPpO7d1uynyRpfdSJSTtncwvw4ZrPjjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ud6VGV7HSOL6iLK8hlJSrBO7n3HrRnjpRdQaS2DEwyD1gqpmeINenmzSylem2vr/3
	 hdRFHnpaeFk1sKt6fWh3XrlXYZ4wPbfCssrm2neYy2oYWPuYc/igKgEXcbOVbpP2fL
	 C7A72qZQUDLkUXMpdcGF/vQBr9VCr/8Y20sFkqf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/151] riscv: efi: Set NX compat flag in PE/COFF header
Date: Wed,  6 Nov 2024 13:05:04 +0100
Message-ID: <20241106120312.059423246@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



