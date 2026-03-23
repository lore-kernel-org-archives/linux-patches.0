Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D043BF686;
	Mon, 23 Mar 2026 16:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282663; cv=none; b=OLzNd8b6+nCsZHqO4JnLpV9zF66TBSDYdyjloYSen39Kw5mN4ylSrOHg737iaefOnIEKzY7N5vHbfHrZo81Gm+sTMBynabb/2Y5ViXCkIMQgqs+V/CAeny1hac1R+vhx53mfSCKvODeeR//5PSZlSNOTQP4D20l3d4jeND4HJYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282663; c=relaxed/simple;
	bh=LyWzsbqOP6j5Y4SHSn+RzTJwsO8Df1v/DVa282eNuzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnOmxXQVlbEN/dMInpK3F92AKbodvnadggqaCW8gn1QB6vvwZV7360K4EXzpu5xTEepgtBDYyNzi4kO/gAlr7ivV1h7CJsevyMpoNfigIuY925GobL1KKo2b32LTipceG4VGbGvIPB75y/Eikqrww8EOGNJVtvV9/p63XBIUpJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hCVnR/Df; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCVnR/Df"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1C2C2BC9E;
	Mon, 23 Mar 2026 16:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282663;
	bh=LyWzsbqOP6j5Y4SHSn+RzTJwsO8Df1v/DVa282eNuzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCVnR/Df6kcdIgrVGB0cL3yIXrQlfRBUv10iFKJEAr21ZrMdzOXuULfJPZTEsYMIg
	 9iFFvM3aTwPdINIn1RhEMqFDYRNGwQ1Zw1NSg9Pw7f7tRGpKKBXwl4fBlYQ6W9bMm7
	 4cQ1LoH89yldXVwpouvoFW3g1mMMIO4WR2HzaDNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 241/481] parisc: Increase initial mapping to 64 MB with KALLSYMS
Date: Mon, 23 Mar 2026 14:43:43 +0100
Message-ID: <20260323134531.014859201@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -94,7 +94,7 @@ extern void __update_cache(pte_t pte);
 	printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, (unsigned long)pgd_val(e))
 
 /* This is the size of the initially mapped kernel memory */
-#if defined(CONFIG_64BIT)
+#if defined(CONFIG_64BIT) || defined(CONFIG_KALLSYMS)
 #define KERNEL_INITIAL_ORDER	26	/* 1<<26 = 64MB */
 #else
 #define KERNEL_INITIAL_ORDER	25	/* 1<<25 = 32MB */


