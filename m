Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D5C29AAF4;
	Wed, 23 Apr 2025 15:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422506; cv=none; b=rr/Fwdfj7ZCCp1HhOANgVT5qX/kxKlkT584FMJahw+kFF8M1msEC2gaXCuA8EktBmrL3R9oYI+7xpAiFYa/liJlXM9t4AtrxQ5OA8DleFlkN1bJpky/UrwRHJOFcwwNeu1pKuQfIEqPb6R1LFot+DOroWN46CJwhVseN0qqxBtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422506; c=relaxed/simple;
	bh=kXHbFb2/pml2ooLQYzmHItbaWcOHlHYzxazYEIWdaNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgWWJ6aSN5YddnwO+wjh2YjsdF0mvX+knWvrVVLce/Sacx6OOtMCBySH6/pBmJORP4bxaYcg30D3s8guOpFhqEro9n6kVQ6TuyH31qQIpNISj4V15RxSU+Y+s2cc1vUQcGG8PkHUB2NZTuT/3xZd1fszxhsv3TI0Img435nwFwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTjP5F1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTjP5F1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289ACC4CEE2;
	Wed, 23 Apr 2025 15:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422506;
	bh=kXHbFb2/pml2ooLQYzmHItbaWcOHlHYzxazYEIWdaNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTjP5F1CxmvPj4DKsV0txZZfnSP6mtIRp68GMPauYt3Bsotn4V/T4BvVttjkqNM/a
	 QUIIHGEgtm1luSLHlzqAZ0SlLPa5YDe9e98Q11LzCCZhaG5tCnngcupztUKjPbQiz6
	 XDq7ZTl/qcCifP5WB9/jaORCdh8vdAQdfMuVEqVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 376/393] LoongArch: Eliminate superfluous get_numa_distances_cnt()
Date: Wed, 23 Apr 2025 16:44:32 +0200
Message-ID: <20250423142658.860967638@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -216,18 +216,6 @@ static __init int setup_node(int pxm)
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


