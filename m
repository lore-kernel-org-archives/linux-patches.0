Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13E7242D64;
	Wed, 23 Apr 2025 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422272; cv=none; b=Ln5tx29gqgczTfFjllZO6txUU0fqJMVFQ9VoYp1ll2ENrG0O0h9uBkZhFjQg0sfDmZ7DI6vQReNU7ba9iHjEr7ZHtsRNl71HDQCtBMoooagHsPUeQ5V+pGbR6VAzwmlxs6AEFpKwT4Lc9JyDtsn+8J/Zj1LBN9nMMkivJp0/eR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422272; c=relaxed/simple;
	bh=2x1VzHGf96rEkAFA1ltrdRnSAGzjQs6mbI1h/EL+FMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcFTciT07aGpTWn11kGaK/ryId67HU0drdJnK1lLptmRXsCpUw3CWyPs1JYhWyxIWV347yCZXpN/1UBwd7T9hSsfNsVJ3+mUbpEPJ/dskBwpWB6qhoPWdvIetEkk546UV/a70IVdIN7TrUAUXguIhADBWyTYb3VDFZn5PKANk5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BiCrsOi9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BiCrsOi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DE6C4CEE2;
	Wed, 23 Apr 2025 15:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422272;
	bh=2x1VzHGf96rEkAFA1ltrdRnSAGzjQs6mbI1h/EL+FMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BiCrsOi9OQ2+FWT0EaNLCK9STy+i7jl7sIoLrBAwMhjiB4uN2rQjyxHlJIiC3PqQW
	 mrXvC0ZrpZrY8kwSaOJCtRr3puj+CU3H/GISIBqJjZLO3yQUflCK2uesh9fC+pFwTf
	 uAyYTm4Y5bG37ei2CqPnh4EVf93ND/8aeEy8uhsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 268/291] LoongArch: Eliminate superfluous get_numa_distances_cnt()
Date: Wed, 23 Apr 2025 16:44:17 +0200
Message-ID: <20250423142635.372704409@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yuli Wang <wangyuli@uniontech.com>

commit a0d3c8bcb9206ac207c7ad3182027c6b0a1319bb upstream.

In LoongArch, get_numa_distances_cnt() isn't in use, resulting in a
compiler warning.

Fix follow errors with clang-18 when W=1e:

arch/loongarch/kernel/acpi.c:259:28: error: unused function 'get_numa_distances_cnt' [-Werror,-Wunused-function]
  259 | static inline unsigned int get_numa_distances_cnt(struct acpi_table_slit *slit)
      |                            ^~~~~~~~~~~~~~~~~~~~~~
1 error generated.

Link: https://lore.kernel.org/all/Z7bHPVUH4lAezk0E@kernel.org/
Signed-off-by: Yuli Wang <wangyuli@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/acpi.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/arch/loongarch/kernel/acpi.c
+++ b/arch/loongarch/kernel/acpi.c
@@ -173,18 +173,6 @@ static __init int setup_node(int pxm)
 	return acpi_map_pxm_to_node(pxm);
 }
 
-/*
- * Callback for SLIT parsing.  pxm_to_node() returns NUMA_NO_NODE for
- * I/O localities since SRAT does not list them.  I/O localities are
- * not supported at this point.
- */
-unsigned int numa_distance_cnt;
-
-static inline unsigned int get_numa_distances_cnt(struct acpi_table_slit *slit)
-{
-	return slit->locality_count;
-}
-
 void __init numa_set_distance(int from, int to, int distance)
 {
 	if ((u8)distance != distance || (from == to && distance != LOCAL_DISTANCE)) {


