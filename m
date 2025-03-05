Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEC41A5BB7;
	Wed,  5 Mar 2025 18:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198320; cv=none; b=Te5Nsu+J8pXzGFC4Gc6li/rHurYI//QIUaxHK6RVqEVv2/CwQw5dWHRprDr+XXs6BlJziY0ct4n3xMYXJMPiaLLNkrUyETY2TRc+xzu+JpxdfRhQMs3s9Ze707b4plGFEQwFLaCPGTboZFYNhLjEMn+QUVyTzpI/P9jUNUQOsTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198320; c=relaxed/simple;
	bh=1NoJnQ7fR6lRvV69Q4fBGy/ae97Fy1V4+WGVpOqHxlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vCarhex7c0xmHkC/wNt+RLSbpil7hhcw89sXPbLyjmVIrNs4Hizzx9IEPLZRTR0icDozR9EvPBAns/PgfsB97gxEIsXqDy10HiwRrJKYq9q8G9CmX+EgHX0L3QdQJJmXHtnaBSeHeOUGuk6Lw1PQtkDk0OMp6qovJrjW3pnH+Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBXfjogL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBXfjogL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEA9C4CED1;
	Wed,  5 Mar 2025 18:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198320;
	bh=1NoJnQ7fR6lRvV69Q4fBGy/ae97Fy1V4+WGVpOqHxlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBXfjogLSHvVNajrXbxQE0wXvz5Ye8QKHHP2XOBtoAgAtgqOVRBxL1xYxZDVHvAkU
	 WWEf8Ygq18tsZeIthn4K7/lK22323SsLqlPOCSGHB097A7/xE7SbyP0ice3riUGYJe
	 L/y7nPghVjhk9uxYisUdxI2LSJkz5yjEZ2I6wtxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.12 138/150] riscv: cacheinfo: Use of_property_present() for non-boolean properties
Date: Wed,  5 Mar 2025 18:49:27 +0100
Message-ID: <20250305174509.361913102@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

commit fb8179ce2996bffaa36a04e2b6262843b01b7565 upstream.

The use of of_property_read_bool() for non-boolean properties is
deprecated in favor of of_property_present() when testing for property
presence.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Clément Léger <cleger@rivosinc.com>
Cc: stable@vger.kernel.org
Fixes: 76d2a0493a17 ("RISC-V: Init and Halt Code")
Link: https://lore.kernel.org/r/20241104190314.270095-1-robh@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/cacheinfo.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/riscv/kernel/cacheinfo.c
+++ b/arch/riscv/kernel/cacheinfo.c
@@ -108,11 +108,11 @@ int populate_cache_leaves(unsigned int c
 	if (!np)
 		return -ENOENT;
 
-	if (of_property_read_bool(np, "cache-size"))
+	if (of_property_present(np, "cache-size"))
 		ci_leaf_init(this_leaf++, CACHE_TYPE_UNIFIED, level);
-	if (of_property_read_bool(np, "i-cache-size"))
+	if (of_property_present(np, "i-cache-size"))
 		ci_leaf_init(this_leaf++, CACHE_TYPE_INST, level);
-	if (of_property_read_bool(np, "d-cache-size"))
+	if (of_property_present(np, "d-cache-size"))
 		ci_leaf_init(this_leaf++, CACHE_TYPE_DATA, level);
 
 	prev = np;
@@ -125,11 +125,11 @@ int populate_cache_leaves(unsigned int c
 			break;
 		if (level <= levels)
 			break;
-		if (of_property_read_bool(np, "cache-size"))
+		if (of_property_present(np, "cache-size"))
 			ci_leaf_init(this_leaf++, CACHE_TYPE_UNIFIED, level);
-		if (of_property_read_bool(np, "i-cache-size"))
+		if (of_property_present(np, "i-cache-size"))
 			ci_leaf_init(this_leaf++, CACHE_TYPE_INST, level);
-		if (of_property_read_bool(np, "d-cache-size"))
+		if (of_property_present(np, "d-cache-size"))
 			ci_leaf_init(this_leaf++, CACHE_TYPE_DATA, level);
 		levels = level;
 	}


