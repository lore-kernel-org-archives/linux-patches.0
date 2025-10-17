Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1FF32C944;
	Fri, 17 Oct 2025 15:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714150; cv=none; b=BMDYCIkbQ/wjMd3SUhbpcrGwlWXTatzbTnVDEjIuKN5bNfmMcE7NnNzKFOsWXMoeiqHoAFb44GVtUootNPRlJVMeRLIBI/ltne/y5UBPYm9bec+et9etcfw+Zn/T6Ie7XzQ8E1aBthwdgxq84IJa8ORYjBGUNdlywdK7RxjUDlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714150; c=relaxed/simple;
	bh=ItUsbdDJVDPNHQzAc+WQfggFOaLVd72zvH5HrE4+lHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEB7yQVsidGO6qQW1b1GxdMCf2wCJxn7vLdrlXzWokCN1Ie5O8ZpQqwH/jEnUfdN9Z3qD/ygA/qNIBm82OmFHSEkJSap//6Ym3/3K/kSPFjlKBfPmVF55pcI/7V30YeQNymR3yFzEdw5RW4sW7H7zUhKIGXHO0ZJ911U+XlWk4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2Xmwvq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2Xmwvq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D63DC4CEE7;
	Fri, 17 Oct 2025 15:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714150;
	bh=ItUsbdDJVDPNHQzAc+WQfggFOaLVd72zvH5HrE4+lHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2Xmwvq6RsO8hKM9CmPA2lywdkSeXKBr+1ISo4Okqjbr2/VfZrDAwYU5+LZp3mkiN
	 dnsV5S3tvraKeZu1Lx1vvnFaXdIDof4GrCvtQ9cKoS2Tcf5z4KlLPimdDAipEhw8xv
	 eTbupnU57JBICWgWkP1whD2LxIfwIYc2AjlBI9Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/277] LoongArch: Init acpi_gbl_use_global_lock to false
Date: Fri, 17 Oct 2025 16:50:52 +0200
Message-ID: <20251017145148.792337188@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 98662be7ef20d2b88b598f72e7ce9b6ac26a40f9 ]

Init acpi_gbl_use_global_lock to false, in order to void error messages
during boot phase:

 ACPI Error: Could not enable GlobalLock event (20240827/evxfevnt-182)
 ACPI Error: No response from Global Lock hardware, disabling lock (20240827/evglock-59)

Fixes: 628c3bb40e9a8cefc0a6 ("LoongArch: Add boot and setup routines")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 1fa6a604734ef..2ceb198ae8c80 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -354,6 +354,7 @@ void __init platform_init(void)
 
 #ifdef CONFIG_ACPI
 	acpi_table_upgrade();
+	acpi_gbl_use_global_lock = false;
 	acpi_gbl_use_default_register_widths = false;
 	acpi_boot_table_init();
 #endif
-- 
2.51.0



