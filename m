Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D971A6828;
	Mon, 23 Mar 2026 14:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275610; cv=none; b=mAIudeneEZJbT3m88zQl40SqCAqLVZHaKi2jWtIQieq6qIwGlSLM/ByeIqQ32WHcCZgSsm8FIDmvakxXPi2StFhm6HMSyrBhOOiCasU2tXNQqVUCxfuJ2zD6KaAS6xIADVANKId83bD8ZBM6e6FIGtT7U+sAGVrjNBJszjDUKxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275610; c=relaxed/simple;
	bh=EuXRuVu2VgNl27jBZw8bmWWwmHFdDxv1gtISibB7yWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhxSGIWyDb2iSgbzuTb3RIJ2Ry53LHG/TwtKKI/O5Of2GfacBV8v++Q6x+btSI8OWVrqw5bPbCo7710lobv+HW0hBztDFiTfVu923aZsems0t0W6FjYWdJYQn6T7tCQ2a3fHQBnGGf8aOYIsvpbuEd3jckF/V4CtWEyMW8gI6iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w97O8QpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w97O8QpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FE8C4CEF7;
	Mon, 23 Mar 2026 14:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275609;
	bh=EuXRuVu2VgNl27jBZw8bmWWwmHFdDxv1gtISibB7yWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w97O8QpWUls+JQio2QM/yd2VOKPhNVkpioFsYsnFs212oVaH4GuSTVj0BX/wgjjqt
	 HkIs2GUh8RKAqDHjmQhZfMt3FKLoCifpn55En4Wi9M7uWPKlYaDW75RrmIRY27Kmer
	 AZIm06F/rDf6qCFiY9Ww9vMWmHXvj4rBUcLWw40o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 160/460] parisc: Increase initial mapping to 64 MB with KALLSYMS
Date: Mon, 23 Mar 2026 14:42:36 +0100
Message-ID: <20260323134530.489206237@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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


