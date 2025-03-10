Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994E3BA3D;
	Mon, 10 Mar 2025 18:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630891; cv=none; b=m8KvGGRdnXy9RhgosdCuxY09ajnPursT7ZE730XlYYbiehKGI5jfONo1mMZpOVSGp6utRoEQVfYzL1dZjG0LQvdhvDt9A5xTE6xA572Odnr8JQc724JDDKI0pwZcV7kd+kPj6wwg8/STVlz1xuxcWC6ug0bwHkybwgRYFSvXFXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630891; c=relaxed/simple;
	bh=oFsV43Zt09s14305CTJEGiRtT5MTqBdiM2nrbUDoGhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyFP8m/G1j5Ngxe1Q9frAzTUEvqfm7EMe3+JDAkYL3MPVdikG8ULxwciJCncW9NwgD3ltzDsH69qzpObHD8xzGOmJDIrXagL6j5GUwaNykQpC7401WleVh1Nzd7if1hbmyQytPTpjMEVM8LCMz41dq+LAPetDlV+k1/odmCU+JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMgIl8n6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMgIl8n6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20064C4CEE5;
	Mon, 10 Mar 2025 18:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630891;
	bh=oFsV43Zt09s14305CTJEGiRtT5MTqBdiM2nrbUDoGhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMgIl8n6HZrToDsKzM0kwiqgzOaA4doIz0q8HW4BKgWpdHnfIKTL8pXmdxywXcgZR
	 dEuZx/bNFUiQlJDie/0JsY78Va2bUrGRwXcfUxXIlwqviRyLwDNY2FTE81qoWKvFg4
	 prR/1TmJ1/a70Cukh4BDeLNj2zFJJWFQKaUEaYSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 571/620] x86/sgx: Export sgx_encl_{grow,shrink}()
Date: Mon, 10 Mar 2025 18:06:57 +0100
Message-ID: <20250310170608.082107152@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit 3a5351415228d06c988a1e610e71d3889f707ac9 ]

In order to use sgx_encl_{grow,shrink}() in the page augmentation code
located in encl.c, export these functions.

Suggested-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lkml.kernel.org/r/d51730acf54b6565710b2261b3099517b38c2ec4.1652137848.git.reinette.chatre@intel.com
Stable-dep-of: 0d3e0dfd68fb ("x86/sgx: Fix size overflows in sgx_encl_create()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/sgx/encl.h  | 2 ++
 arch/x86/kernel/cpu/sgx/ioctl.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index ed5ced8ccd2c8..90e3a1181bd62 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -121,5 +121,7 @@ bool sgx_va_page_full(struct sgx_va_page *va_page);
 void sgx_encl_free_epc_page(struct sgx_epc_page *page);
 struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 					 unsigned long addr);
+struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl);
+void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page);
 
 #endif /* _X86_ENCL_H */
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 217777c029eea..f21890150216d 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -17,7 +17,7 @@
 #include "encl.h"
 #include "encls.h"
 
-static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
+struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
 {
 	struct sgx_va_page *va_page = NULL;
 	void *err;
@@ -43,7 +43,7 @@ static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
 	return va_page;
 }
 
-static void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page)
+void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page)
 {
 	encl->page_cnt--;
 
-- 
2.39.5



