Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD9D3F54D1;
	Tue, 17 Mar 2026 16:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766674; cv=none; b=UAGSueEEu6+x8WK7s3npGR5TeaHcvhHb8ZbSlcH/xczeRp8fs3x3FLa9y5duM3ob//W9acUEv3MORewjbvfMCi/HVD2jM6iXG4xoIw7i+UmMbYemRF2Xzh7LTc7ig+3wPvC3ZwY5BA4G4u15wLd0i9CxjaHTcb2FkmovaZ4jqcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766674; c=relaxed/simple;
	bh=qHtJiEPYyMuHPzPR6J7kAu7uAZluqbRsME5MoH7cjfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQs1SBvKFqFmav9Z4LNCaMcGZxWv9GAkJvhIOhV+TJK0+6gqww3BBY3PfVPoS9prgn8B86SJ7updmXLa+oyP9C68cHBJJoVYdEG/MgNC0yzixw6qeorO8iCz2JmqG2WBFAEJmEifBZLAXzHa5mewOayRhhwOa1yrGIizkPYbvBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbjZ0fWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbjZ0fWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5568CC4CEF7;
	Tue, 17 Mar 2026 16:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766673;
	bh=qHtJiEPYyMuHPzPR6J7kAu7uAZluqbRsME5MoH7cjfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbjZ0fWYGDM44HeQoC+cWstFrRZ3zibox+/nbZw0AHdGxmL9BNcnFhuUCfOld/wdQ
	 vLCYLdO892XRAKGIPV7t7fsmJpOAUlS0JY7aunGpnM7wqdMmgn6E/FUTWxFTe723OS
	 hEUCG8BQ8eicZczOh8vOJQLCAOrzo17yszHcsn7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.19 270/378] parisc: Increase initial mapping to 64 MB with KALLSYMS
Date: Tue, 17 Mar 2026 17:33:47 +0100
Message-ID: <20260317163016.943891004@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


