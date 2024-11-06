Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF8F646;
	Wed,  6 Nov 2024 13:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899263; cv=none; b=shFZ/vWoM3dvC1/1ZZLzuzgHaa9+bq9r4ZhhrxZvcJwdAtIGQnxfm0QzRMncKyIdXutNtqOK+6xtsnGUH5H01P3rR/VtBr8mKyQlLapMlkZ8dsqPf516XUstQHA5hM8zTtDUDvcgM2vJTzYcBAjUfkVw+x6M20uLa3m9XIMmDpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899263; c=relaxed/simple;
	bh=yJ6WQYdKFwB9UHn6/7ZEYyKp9Z1POdRXdwXbl7XXZE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUK3qRcv+l6IBXNFZtuPkjXWlscdDb1Vbl+8UMklCPF5w68G715WA7/rvgTFNCYz0RnNQZVZUoes50noU8aLLN+JF770VGwBnKsbnyGqv4thR2MJXlctavkAxJkZTIEbXliMXbJc3q/taZPSwzMOBdlCUdVKjQVcpxU0Lwnt8Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/kOEG8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/kOEG8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE3CC4CECD;
	Wed,  6 Nov 2024 13:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899262;
	bh=yJ6WQYdKFwB9UHn6/7ZEYyKp9Z1POdRXdwXbl7XXZE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/kOEG8VCzeiOyCteiW3BZXpYrNg5m3icO7NnE99BnyHGitMzlm43TSwMaLntxRwa
	 LY96dlTtT2cVuhvxRkypEGEmBl3OStHfgFHaHFGQR1hg7PJzLbwqZ9KLftdjsB8HTB
	 EWys2Is3zw1Yw/65fLD7N6MpnLSIhipzAuyHVUZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 52/73] riscv: efi: Set NX compat flag in PE/COFF header
Date: Wed,  6 Nov 2024 13:05:56 +0100
Message-ID: <20241106120301.517748810@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8e733aa48ba6c..c306f3a6a800e 100644
--- a/arch/riscv/kernel/efi-header.S
+++ b/arch/riscv/kernel/efi-header.S
@@ -59,7 +59,7 @@ extra_header_fields:
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



