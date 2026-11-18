Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052546;
	b=t3rUvoc/m5ZRyWwOVbQtEVqdAtFyr5eRzV3iZYnS+85YotAahAMLWciVxpdj+WjnxZDD
	 F7LHPlccMi1bFRmMUlxHwQdkwiYnMDMmsrpNamIkou3/7BfzgC7CWRYzlBOpyw5j2tJVd
	 +kkH6ub/MM9nWSv8vchxiY3Lm7DzWPZgF1DaSY4OezQI/ieiCegz06i/6SlRXEDihV8nG
	 lXdcZ4A6X+om8axOwxtujeUFm6V00GoUIF5hSkXo0m2Si2oRsDfgMRJWsglkCZGHRMJw1
	 VbtH/lxK79bSuDmot/ICiYib2IncrRZdSPCq2PhmvWAr1U10Q3CYKmsWKJJNp+TazJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NfdM7YwqPR1lubfE2HkED4mhVQHhHxQQRZ5OM++kQaE=;
	b=gtUCYaUx/R6vbNlJe5KVi1r+9dikO6BYLMnPCWpDa0FQuccSle9asytk2UVuki08QPFV
	 JmCtmXunVK/2Gkr4Cqiymxo62GiFeYueJ35Wbvy8/PLW4eA5XqVfMbMxhAPs/itz4iZn8
	 JTMkCwE4rkqfrGe59Go25smNwf7N025DSQrIXWd7uDgfIEGK8T40iYgmQlWH/nvI93HCm
	 AP6BKnDoqFq+B59UzHVtvMEuxnY+Eda+PMpgjZqTSdQ/c7jZbSoj3u8zU2J13/3HeiZsD
	 ZW5Khx8k5DlbXhT0urFj9jkV4E5MxuLA6Rk5YHjthXMk+MOlGwlOXZ/vOsGQyzzc4vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nvq4eNSB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF60606A320;
	Thu, 19 Nov 2026 01:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nvq4eNSB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41ED1F000C4;
	Thu, 19 Nov 2026 01:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052546;
	bh=NfdM7YwqPR1lubfE2HkED4mhVQHhHxQQRZ5OM++kQaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nvq4eNSBQgWQVIELrEPovB4ptXFm5j5RZNazG++66MCW7WYpSUo3CcdlNjCdVuY6e
	 1kALUbYO5dwYR934ng4+2Ms7X2Kgo6BZCcDle7+YfAYtms73zhHyHxpUSic1anpAFd
	 OBqvk8Q6Qi4ydv38mIJaAcXfhOT8CSbX/NiEGNOo=
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
Subject: [PATCH 5.15 0602/2214] mm/nommu: reject wrapping ranges in access_remote_vm()
Date: Wed, 18 Nov 2026 15:37:58 +0100
Message-ID: <20261118150035.068640526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8b5c95528b008..984f2f90621f8 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1665,6 +1665,9 @@ int __access_remote_vm(struct mm_struct *mm, unsigned long addr, void *buf,
 	struct vm_area_struct *vma;
 	int write = gup_flags & FOLL_WRITE;
 
+	if (addr + len < addr)
+		return 0;
+
 	if (mmap_read_lock_killable(mm))
 		return 0;
 
@@ -1718,9 +1721,6 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
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



