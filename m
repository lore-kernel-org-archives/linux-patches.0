Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9F1266B65;
	Tue, 30 Sep 2025 15:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244846; cv=none; b=GAy/ZwzHRmPGUZhDj2UZdV9gk9yOpRpuIBu9Hhqp70O4Vvr7mqPZCSE1rrxJ2Vgn/JRvh8dLrUC15+kocpT8NcmYWG4rVfom7yExfXJ6WHQrQDZv1CeTp666YzNW2FywzWDy+9p2D0Z8l0Z56U7GZW7Wi9o2pkrpfj7HmeSiMpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244846; c=relaxed/simple;
	bh=a4tlshXUwxUSkc5zkxRtjEqpU0cFgn966Nc6NwvuvhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBrYlEroY0lz1aWDoZlgKBy1FUOyrcfNeo0wAQ5V2PTLAfqxIsuHraXB6Wc3krrzEY62HeuiTPCd25EeNsulQ7WEPehUzNQ/8ebglqO45XsVWrxyYvi4/w952bG7tEbRWw9/5F8hUf2e7WrpHdPp97nMExHegx/jFWq4WNR0RLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUsuiBTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUsuiBTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60178C4CEF0;
	Tue, 30 Sep 2025 15:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244845;
	bh=a4tlshXUwxUSkc5zkxRtjEqpU0cFgn966Nc6NwvuvhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUsuiBTSSmZrg1zCOXWN2Ri3OB8IHDl/f+YCw028QDeUf47+Ll71jQFliFlrNF3vc
	 XqpliGHsKECTKUG8DtmWQhAJirqOdPkm8tzKRaTba6mI5lrQ80r4gi2oOrIjj2+VDg
	 EVXmkZO47SxbBA7x9DbNCEQ9a2EaSnAlVPSfyhK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Popov <alex.popov@linux.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.16 132/143] x86/Kconfig: Reenable PTDUMP on i386
Date: Tue, 30 Sep 2025 16:47:36 +0200
Message-ID: <20250930143836.491626092@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Popov <alex.popov@linux.com>

commit 4f115596133fa168bac06bb34c6efd8f4d84c22e upstream.

The commit

  f9aad622006bd64c ("mm: rename GENERIC_PTDUMP and PTDUMP_CORE")

has broken PTDUMP and the Kconfig options that use it on ARCH=i386, including
CONFIG_DEBUG_WX.

CONFIG_GENERIC_PTDUMP was renamed into CONFIG_ARCH_HAS_PTDUMP, but it was
mistakenly moved from "config X86" to "config X86_64". That made PTDUMP
unavailable for i386.

Move CONFIG_ARCH_HAS_PTDUMP back to "config X86" to fix it.

  [ bp: Massage commit message. ]

Fixes: f9aad622006bd64c ("mm: rename GENERIC_PTDUMP and PTDUMP_CORE")
Signed-off-by: Alexander Popov <alex.popov@linux.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,7 +26,6 @@ config X86_64
 	depends on 64BIT
 	# Options that are inherently 64-bit kernel only:
 	select ARCH_HAS_GIGANTIC_PAGE
-	select ARCH_HAS_PTDUMP
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
 	select ARCH_SUPPORTS_PER_VMA_LOCK
@@ -101,6 +100,7 @@ config X86
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_PREEMPT_LAZY
+	select ARCH_HAS_PTDUMP
 	select ARCH_HAS_PTE_DEVMAP		if X86_64
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_HW_PTE_YOUNG


