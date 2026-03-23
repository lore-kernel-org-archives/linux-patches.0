Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0408728504F;
	Mon, 23 Mar 2026 15:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278488; cv=none; b=BspEgVY0NONNW0DayYcnoEgc1yLfdCD3xUhZLS/ECp737p3oAD8NYnHgv/CE5StqPHJI7KZ9W0OnCawWB68YkUhuFOM9V+4X3SeHtt8vjcl55GJP3ELid3XigfNjOS+k3BlMi4DbPQZ3NwPRODKiv3P+OriME7MT5Z+DLEMhTVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278488; c=relaxed/simple;
	bh=aBwMCxIAKgRJDSc51+pmSHQRZqXKQrLYrTt8IqGm+vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4Vw6348G+ch2kEfMrb4Z+nbfefSBE9Rez3oqmT9HTMz76iHnT4Aw60z6b4cLB8eiHAyX28fBCxS8qqZxGGEmjv3sR90PJvTtGjHl2kMlgApCFpiL1oLoIOYyvoTRB0agP+zGgOV5KqJ4Mwn5NuHu85vvwsYpJe6EPivQHIpvPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CY2Htecb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CY2Htecb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC59C2BC9E;
	Mon, 23 Mar 2026 15:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278487;
	bh=aBwMCxIAKgRJDSc51+pmSHQRZqXKQrLYrTt8IqGm+vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CY2HtecbQ8fcADlv8mZZMMnLOz4dnNfzFJWA9t1YsawBGSv9O+RHu0p68Wy3T4bQx
	 9BUjXIfRc2eN6v1rIBJuE1Qg6pFe30EG+P0E8KdbOAPmFc4e1UXqXG48AJcDFRfS5m
	 iohhzvxE9mOcOLsjgiHVeFpo6u2ls0hvd0qyvq7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 321/567] parisc: Increase initial mapping to 64 MB with KALLSYMS
Date: Mon, 23 Mar 2026 14:44:01 +0100
Message-ID: <20260323134541.772199895@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


