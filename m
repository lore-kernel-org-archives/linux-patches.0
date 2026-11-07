Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064555;
	b=XeoSR9qQoWuW0vBtaLchvN05futbauPk0zGcoFABhkWkeJ6Fhuw0SFOdvYSnTVYHTPwA
	 VfOV3AlxEEhy61Qst68SYRPxDyXkKEBakGmOMI8gCIEnz+qeh8aPGLxU/0Frryp+1JNlO
	 Nt7sKvTUfNZPGlvfKbLRovLbaMvLxIyA1Tt77wSpWS/DhEQ7ZHOI89TOYDpTA7F8N471i
	 NCxP+Sl70JxlB7aBSS2RpVpQP6wcXgauAalcl9wSYi/PRRHIxNxwUjPpn+30EHNO8Y4XG
	 WYKXrFs5yP9kUamgCLyte+4SgIeFHZqrfpa8IBWexDhXYb13opIo7DOdmZh/wXU80Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/++Mx2Guo09mhg9HhICRz635oC1U1U5l/+7i55vssRo=;
	b=p3sIquEbiWmum3Su0719ybu/egsVoxHWg0txvML0GI0kQjHtgTq+Of0WdYozNhGnyyZ2
	 j0bRTSTCxKn+m6NtwSTvcouQZxorFexV8Zi0mjx9ADZy21zPtZm6t7UWFtobXkZ6tIZjV
	 eN1QRwOxeUjFZO3OpYhqyKoFqzRcYFvjz0cqh68jbcMEpzEePdjp1whc4nMbKaKaXDmHH
	 T1ccJz7RCUVfoOLSGFuepP3L/JcervXaC/RRiawD9ZZUfPVQhh4k1h33f0y5bA/AO+8zm
	 A6bJWJtlOUjzK/vjgja8lUkHmo0JIqdBW1/dWWFn4qn8l4DRAOD9/u8Rr93iqbtFZjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UayQrTKr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCBD606D811;
	Sat,  7 Nov 2026 15:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UayQrTKr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500C41F0089F;
	Sat,  7 Nov 2026 15:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064555;
	bh=/++Mx2Guo09mhg9HhICRz635oC1U1U5l/+7i55vssRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UayQrTKrcsKqy7pR6/x0wfjMfwXl6QNZamflneXXDzfvIACLTE/7Mhs+NXNWT4QQL
	 hzfA9wd/pXd64+9ym2+W98oBH1417FdCTOF71FK72IFml+3Dx/oSttUqewsDMvXTP+
	 HNkmCY8Z4SrVH6uEMXhtto/79G1ZYfFto3MO6ZJA=
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
Subject: [PATCH 7.3 0578/1257] mm/nommu: reject wrapping ranges in access_remote_vm()
Date: Sat,  7 Nov 2026 08:47:54 -0500
Message-ID: <20261107134955.305940230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 498e01ee40b05..ed44510e37707 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1674,6 +1674,9 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 	struct vm_area_struct *vma;
 	int write = gup_flags & FOLL_WRITE;
 
+	if (addr + len < addr)
+		return 0;
+
 	if (mmap_read_lock_killable(mm))
 		return 0;
 
@@ -1727,9 +1730,6 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
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



