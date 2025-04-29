Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5494F251798;
	Tue, 29 Apr 2025 16:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945922; cv=none; b=KS/I3ZYpahqqIHNp8P1AEZ+lgnkyySbYlEoWY+d9x2v8FRACJy9fF8QmOkETnX3Xitbk3X1jSIQqqjTpyleebm1uQdwMLkekRTxlVSZ6ilam9VXb04yYHpMsvkb+A6EyMvNcGAlrcwVqKDVWBtH0qvFDut18pwyW2/y6C8Ctvhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945922; c=relaxed/simple;
	bh=yMUv/OaV+hPS6y446mTGvemzs911IU9mW/GsFSc5hmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEP1vdklN+h10BplVpL60KHYX6+hgBrZh9N8NKUXAnibSrJjKTuMjZ+6lD51Nl7Vgt/Fx47yvdglDL68wsu5wUemHMRKcgnCTMRa0UkaY6Btp0bwWAnwABvOL5T/wIst+ypkPK9+hKVr+TpAKENpYlSu8vTuxVEfaL3IrTBcUjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcsAIIst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcsAIIst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1C1C4CEE9;
	Tue, 29 Apr 2025 16:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945922;
	bh=yMUv/OaV+hPS6y446mTGvemzs911IU9mW/GsFSc5hmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcsAIIstFHc7wyLEjBLNykci2g1aqYr3ohB75wriCEFz+jTsKO/oFSWWsQOTDa3Fx
	 WUdy70Mi3ginclS1KYUvOXc3hg1BKRmSs2FxwokwbDkWij9xrl3OSrUvvO2BA+tZii
	 RorY4M3mQDvM8VIJ/aDGsqM5MXelpWzvDD5dzLds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 095/311] bpf: Add namespace to BPF internal symbols
Date: Tue, 29 Apr 2025 18:38:52 +0200
Message-ID: <20250429161124.934140651@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit f88886de0927a2adf4c1b4c5c1f1d31d2023ef74 ]

Add namespace to BPF internal symbols used by light skeleton
to prevent abuse and document with the code their allowed usage.

Fixes: b1d18a7574d0 ("bpf: Extend sys_bpf commands for bpf_syscall programs.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/bpf/20250425014542.62385-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/bpf/bpf_devel_QA.rst    | 8 ++++++++
 kernel/bpf/preload/bpf_preload_kern.c | 1 +
 kernel/bpf/syscall.c                  | 6 +++---
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
index de27e1620821c..0acb4c9b8d90f 100644
--- a/Documentation/bpf/bpf_devel_QA.rst
+++ b/Documentation/bpf/bpf_devel_QA.rst
@@ -382,6 +382,14 @@ In case of new BPF instructions, once the changes have been accepted
 into the Linux kernel, please implement support into LLVM's BPF back
 end. See LLVM_ section below for further information.
 
+Q: What "BPF_INTERNAL" symbol namespace is for?
+-----------------------------------------------
+A: Symbols exported as BPF_INTERNAL can only be used by BPF infrastructure
+like preload kernel modules with light skeleton. Most symbols outside
+of BPF_INTERNAL are not expected to be used by code outside of BPF either.
+Symbols may lack the designation because they predate the namespaces,
+or due to an oversight.
+
 Stable submission
 =================
 
diff --git a/kernel/bpf/preload/bpf_preload_kern.c b/kernel/bpf/preload/bpf_preload_kern.c
index 0c63bc2cd895a..56a81df7a9d7c 100644
--- a/kernel/bpf/preload/bpf_preload_kern.c
+++ b/kernel/bpf/preload/bpf_preload_kern.c
@@ -89,4 +89,5 @@ static void __exit fini(void)
 }
 late_initcall(load);
 module_exit(fini);
+MODULE_IMPORT_NS("BPF_INTERNAL");
 MODULE_LICENSE("GPL");
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e1e42e918ba7f..1c2caae0d8946 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1562,7 +1562,7 @@ struct bpf_map *bpf_map_get(u32 ufd)
 
 	return map;
 }
-EXPORT_SYMBOL(bpf_map_get);
+EXPORT_SYMBOL_NS(bpf_map_get, "BPF_INTERNAL");
 
 struct bpf_map *bpf_map_get_with_uref(u32 ufd)
 {
@@ -3345,7 +3345,7 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd)
 	bpf_link_inc(link);
 	return link;
 }
-EXPORT_SYMBOL(bpf_link_get_from_fd);
+EXPORT_SYMBOL_NS(bpf_link_get_from_fd, "BPF_INTERNAL");
 
 static void bpf_tracing_link_release(struct bpf_link *link)
 {
@@ -5981,7 +5981,7 @@ int kern_sys_bpf(int cmd, union bpf_attr *attr, unsigned int size)
 		return ____bpf_sys_bpf(cmd, attr, size);
 	}
 }
-EXPORT_SYMBOL(kern_sys_bpf);
+EXPORT_SYMBOL_NS(kern_sys_bpf, "BPF_INTERNAL");
 
 static const struct bpf_func_proto bpf_sys_bpf_proto = {
 	.func		= bpf_sys_bpf,
-- 
2.39.5



