Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00E526F2B6;
	Mon, 13 Oct 2025 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369541; cv=none; b=uSNZ8SCuklQKqES7/VTrIQDmU88yaC4GD6QxcdovWU2FiAVsY70KOHBxqbc5gN/SmFxQwOXUJi3LKx/56hwLCmhRNal+wYR9CYQQlf1mU2bawoBzVAAUNkG93j6XUreH6McKtoWNm1WWV06FE3NUmghB+2GfGOYeDPPkkxBj4QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369541; c=relaxed/simple;
	bh=jzXuiocfFCcgtsKrddEckm6DYEqPHlmi15s7gwLQDiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBzqVtCEqHQBQUfpnzeJlatBR0xfSx1LLhxn4mi5v6tSKR1AScSpgKoJoM6x9o0NmXhfbMa8pWpwDrVzzJa9YRyZ4udPZSeSyy8uplLLP5RdpPMbHrvpVYCMpgCe1uftMePmS16clp+WTVzMthaWqGDPsAFyxEJ158nrZwHR0sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYvqrrla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYvqrrla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469B9C4CEE7;
	Mon, 13 Oct 2025 15:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369540;
	bh=jzXuiocfFCcgtsKrddEckm6DYEqPHlmi15s7gwLQDiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYvqrrlacdFlNCxUBL1ZHkfpbtZHEOu8VLbty7Vg5d6zuf9ySCh463nDt98o9rsw0
	 jqMZBKBS+Qwf0EjVfuHUm6dgB76FvmhvczMlHEOWgAOy537HNmbBRChk3/Qo7+z42n
	 4IP0oJwQpMF+YsXU4MTOdRsG0wSvwtY5Cbmiky7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Richard Lyu <richard.lyu@suse.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 283/563] efi: Explain OVMF acronym in OVMF_DEBUG_LOG help text
Date: Mon, 13 Oct 2025 16:42:24 +0200
Message-ID: <20251013144421.523205724@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 05e75ac35ee9e38f96bbfebf1830ec2cace2e7f8 ]

People not very intimate with EFI may not know the meaning of the OVMF
acronym.  Write it in full, to help users with making good decisions
when configuring their kernels.

Fixes: f393a761763c5427 ("efi: add ovmf debug log driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Richard Lyu <richard.lyu@suse.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/Kconfig | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index d528c94c5859b..29e0729299f5b 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -267,9 +267,10 @@ config OVMF_DEBUG_LOG
 	bool "Expose OVMF firmware debug log via sysfs"
 	depends on EFI
 	help
-	  Recent OVMF versions (edk2-stable202508 + newer) can write
-	  their debug log to a memory buffer.  This driver exposes the
-	  log content via sysfs (/sys/firmware/efi/ovmf_debug_log).
+	  Recent versions of the Open Virtual Machine Firmware
+	  (edk2-stable202508 + newer) can write their debug log to a memory
+	  buffer.  This driver exposes the log content via sysfs
+	  (/sys/firmware/efi/ovmf_debug_log).
 
 config UNACCEPTED_MEMORY
 	bool
-- 
2.51.0



