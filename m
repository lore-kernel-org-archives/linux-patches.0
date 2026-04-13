Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA4528505E;
	Mon, 13 Apr 2026 16:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097515; cv=none; b=GbLBn22Fym4lc1FectxOa4NKHEb3ceQ3D+SigFH4hxwrODeCLwYGJy6qQI/i7PlES+DO6mIT6jwl+F5TVwMmYJYmLY+NuK3esBOxTPeqgucq6KSzKi62IRU2her805pJZ1iIScks1b/Hz/mZncdSCLzQyVFp9g8Mzr6EdRtgZ5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097515; c=relaxed/simple;
	bh=uF7Yk8pFemWb2lVvqzEsftUp7eqgFVJ0vB/vWvxzYTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDGAV8ousbGQyJDWTd0hYg7InmZMj6iWt68qvuGeMaAYsmzNfnQch4+AAow0kgR57UDhqjgt8/S4W7GyonZuGKxZ2mryJBbZttWvlwIkWIjhPJqLWAPBKGvaEo5nf0R8rT+GC1Q67QomYnirs84ImBv531/8v9JODE3Nt1l0zmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTbQbFu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTbQbFu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F38EC2BCAF;
	Mon, 13 Apr 2026 16:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097515;
	bh=uF7Yk8pFemWb2lVvqzEsftUp7eqgFVJ0vB/vWvxzYTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTbQbFu/kgn5YuzbTwUqW8kqoTsaJlo9GVkXOCIeV1I2ZO+BmREvZAjPHSdutEhiw
	 hpJRSz72rN/W2Q2dDLgWQbHfzXS8EiL2bZ3GjGMNjL4IlIndrx0xEm4VA88SofD45R
	 mhau7qH+1rIPS1D/Jl8m6FZwp0mVVwN3YNgEPlcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 167/570] parisc: Increase initial mapping to 64 MB with KALLSYMS
Date: Mon, 13 Apr 2026 17:54:58 +0200
Message-ID: <20260413155836.708253678@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -109,7 +109,7 @@ extern void __update_cache(pte_t pte);
 	printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, (unsigned long)pgd_val(e))
 
 /* This is the size of the initially mapped kernel memory */
-#if defined(CONFIG_64BIT)
+#if defined(CONFIG_64BIT) || defined(CONFIG_KALLSYMS)
 #define KERNEL_INITIAL_ORDER	26	/* 1<<26 = 64MB */
 #else
 #define KERNEL_INITIAL_ORDER	25	/* 1<<25 = 32MB */


