Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036395;
	b=nRhT+Y3FG02LXJ76kD/ixCxT4IHRroritQEWeE5Ndy7sLq8vGax0dalqJM2OOm9tf4Qj
	 8DvxACqyTkbxcMq4gRSkaz2aT67qHJFJhbntErfxGQsFbf9Mb4AhbYxuhWej+9EluH+Hr
	 o1mG7XuZqTnrtPKt9CZ2eRNTHfFlQzz2p7Zkiy6aQVanoALl9J/PVmyllbx/Ikwy5tyU5
	 fFnIR71C+MmsZRJxnaO7NeqRmtOIZwYKRCIhvrxssfPG+oGWXzpsT/PC0oozELkzQvjaP
	 /IoQHyhv/qRdp1TL5Emcc4+XlCfkGkxM/iTxOnnIEkmXfFb99u02hhKZGx5PoNAxGVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eBHpahG4FZoGJC6XzYF+/bGAmpWf3KFL2F9RSKMeFDI=;
	b=xh9np5v1YllWolvEazaA0YU7Cz3xEdVXOiYOG3PYEBhljZ3txZa4tdcYb0j2xD3GINLs
	 Und2j2kuAeLQZJxMtFCD5NCwkWviKxuKkqdN3T8Hk93t2CwCgmYH+9cv6YMV+dtlId/rS
	 AhRY6u+wYZAXpzrmJG2ErkHK8lM9IR1fBwWdxANfigbi1n2Rsc0rZPBxtnLAAB8cbjImR
	 8brO95RMpSXCNMmfcpc50eR7vuCcDbbKjRAD4VgRxicKBwFMVxj4YsYJUXgw6KKz74jJ5
	 APoI60MUxHF8lC8ZhyHY5HlNXcXEOjnvf8bBStAvgAJ6V8V1fpwqe9UFRgffgd5VdIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JBtIuNSG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E717A606A325;
	Wed, 18 Nov 2026 21:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JBtIuNSG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DFB1F000C4;
	Wed, 18 Nov 2026 21:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036394;
	bh=eBHpahG4FZoGJC6XzYF+/bGAmpWf3KFL2F9RSKMeFDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JBtIuNSGcnLx/8Kid7Hllzbs0KGOzU0wRsR5OkTbQW7wtGTOD/8btfT8kNUEyUU/4
	 1hwXOwIB1yFj2i7FqWCe4kd9fqSK9lsMNeenqYCXE09EAhQX+za5H1JkMxDqXC8vH/
	 xNiRhtGs6WxUcdi13MeblUFJaLO6hOPGquVpFnD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasios Papagiannis <tasos.papagiannnis@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Hajime Tazaki <thehajime@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1043/3318] mm/nommu: reject wrapping ranges in access_remote_vm()
Date: Wed, 18 Nov 2026 15:27:45 +0100
Message-ID: <20261118150351.198381399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>

[ Upstream commit 51a8de81fd2edbf87d8046e352060329bb216fad ]

The NOMMU implementation of access_process_vm() rejects address ranges
whose end wraps around, but access_remote_vm() bypasses this check even
though both functions delegate to __access_remote_vm().

Move the wraparound check into __access_remote_vm() so it applies to both
entry points.

This is originally reported in [1].

Link: https://lore.kernel.org/20260909064231.18693-1-tasos.papagiannnis@gmail.com
Fixes: f55f199b7d76 ("NOMMU: implement access_remote_vm")
Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://lore.kernel.org/bpf/4ef240a5bea36ff84df9589671367832860795159386a4c8fba546a0fa8b786f@mail.kernel.org/ [1]
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Hajime Tazaki <thehajime@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/nommu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 3228b2d3e4ab6..119af19b5c2e6 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1663,6 +1663,9 @@ int __access_remote_vm(struct mm_struct *mm, unsigned long addr, void *buf,
 	struct vm_area_struct *vma;
 	int write = gup_flags & FOLL_WRITE;
 
+	if (addr + len < addr)
+		return 0;
+
 	if (mmap_read_lock_killable(mm))
 		return 0;
 
@@ -1716,9 +1719,6 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
 {
 	struct mm_struct *mm;
 
-	if (addr + len < addr)
-		return 0;
-
 	mm = get_task_mm(tsk);
 	if (!mm)
 		return 0;
-- 
2.53.0



