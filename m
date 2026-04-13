Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D2626ED41;
	Mon, 13 Apr 2026 16:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098859; cv=none; b=tdm3q/UeV5RuwVqCTsqA9kXMUU3n/7rDZnA8CtVedaX+eCC5VXLwLkFMflnu9OW65t0UmfVnTHiWkLsL8MdJ/6En3Bub8Tr/n61A/3Os6X0FX8Gmyv/LQ8nRWd+gvfqX7zCwyXh9nNeOf6CQKON3cPrscEcVXEQcwWc42t+Qb5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098859; c=relaxed/simple;
	bh=AiwYLcIIH7TWDBmLMtKhaiIiyhB5ORE3DQytiQ8LJGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khDIexf3cF19/VbJ54PC9v7Dal7H0bgDrGH8VNv2Bs0PeSTM4MTYnjHukXI8XtwdEVMrnqKeWB9JMXeBMK4ObViFu9uIt7228be6g+Qhz2jYrjLXlUcI/g94sAjuR+DnG3NCMQL5XEmCwE7KapV0viKq2x7TM1nYph2kklyDlQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UduaNRxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UduaNRxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A7EC2BCAF;
	Mon, 13 Apr 2026 16:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098858;
	bh=AiwYLcIIH7TWDBmLMtKhaiIiyhB5ORE3DQytiQ8LJGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UduaNRxM/y46b3riBtrT7djpelV0h3ebURnR9pe0UisIhLrtTGHvw55TGMC6ADPhg
	 ZbUUtjtQS2e377K22Chtqdgb2WV+DJNCEjB1fQFuvN7ghbpqADVY8Ja6khjZ/L8q0C
	 3ay4yoW5QdUJC28iXk9CbZqklTTq8kfWwTiCF5EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 117/491] parisc: Increase initial mapping to 64 MB with KALLSYMS
Date: Mon, 13 Apr 2026 17:56:02 +0200
Message-ID: <20260413155823.421537154@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


