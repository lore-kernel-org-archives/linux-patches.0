Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABC71AA7A6;
	Tue, 17 Mar 2026 17:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768062; cv=none; b=S2uMuysJ4tPWm6K5ZkAnqbWVDuGwgoWqPnZS60rBBEaXiMx6WGkKevmnyPlCg2uZFiXqK8wgrTSw/bDtd6NO6/pT5iZu6y0SOzhweiOXuBpklQoglYV75/LoPDIY0JJvlqAuYXFgcc5Mb73v9eCG6Dnv+0JJwDZbEzHTIjlV+OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768062; c=relaxed/simple;
	bh=E9ouidIsFguRQ/kUdvOVfQjcFY7186X8O671v77PNiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cqm+UZuWQ4u4pruOL1/qmmNj1OUWwi/gznj3mI1acH8cxDu92uM7dHWVk2tAvO2+G6Mk2ZyjAukd3xFrfOUqwyHxhDlU3qOQonr3Rh3qgwY+3KkbmjC/pkVwpNwLN9qfZ8czfW2ilLoEI7bzeNgrVErgSETjIzih8p1Shji+czU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMh8ELoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMh8ELoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7ECC4CEF7;
	Tue, 17 Mar 2026 17:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768061;
	bh=E9ouidIsFguRQ/kUdvOVfQjcFY7186X8O671v77PNiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMh8ELoEJy7qjBaaDrcV/8mDt+5K2RyCuFGbFQw7x3hKyy5FXJNrSpUdWHtV2RWPZ
	 US86sjKimuHOITg2+2ERW8IcdJuhlmeCCMrX0D9Kd+eFxjJGe/BpTN+tMuYmvz58Gx
	 8W9zLnp1rv32M7Lbi9JK6jHUipVHUnNWT/qp4A58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 223/333] parisc: Increase initial mapping to 64 MB with KALLSYMS
Date: Tue, 17 Mar 2026 17:34:12 +0100
Message-ID: <20260317163007.633517545@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 8e732934fb81282be41602550e7e07baf265e972 upstream.

The 32MB initial kernel mapping can become too small when CONFIG_KALLSYMS
is used. Increase the mapping to 64 MB in this case.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -85,7 +85,7 @@ extern void __update_cache(pte_t pte);
 	printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, (unsigned long)pgd_val(e))
 
 /* This is the size of the initially mapped kernel memory */
-#if defined(CONFIG_64BIT)
+#if defined(CONFIG_64BIT) || defined(CONFIG_KALLSYMS)
 #define KERNEL_INITIAL_ORDER	26	/* 1<<26 = 64MB */
 #else
 #define KERNEL_INITIAL_ORDER	25	/* 1<<25 = 32MB */


