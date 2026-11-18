Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045387;
	b=FYPiyjJIly2mEmcy6CsGFXjdlBYJ3TfLt1xINI3Z2b9bk8ALhtZm1/juCeUMhqDo7afX
	 f0FxTTZomgzylrCRWdln7E9sTAFuY1SKhBMI8J41Se6HoVqDjynY0YS61lty9Y8NioT/L
	 0c3DZcpteo0ypK0VVGUq6jU1KvFpM+e7N1hYAg94PeP2qIIYlxcyHcAYj00uWjcTqnEu6
	 qbNRiKMjtBqZk/51Qx7ku/3D5JYijqD6MPDpIU8qvL9++ZdvKLLQAhfwYWlKoM741urAO
	 B4RKk8F4uo203d36tmZ6C9C3NNWISonRzCh1KC1XLX+M724zXLlYmGHZpk/dgop5irg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=asq6WN99GENzApdT8u6Yy5A0lgunGQIharnZHP8yTBo=;
	b=z4lsLpHZXxfaU+lP+qw7/xDYGUnSfODytrUmh8G3YIDHqolq5t0oe7Ld3e2/Sj2DC8b5
	 nfUPttyGb96B0dKEhmxTOc5EEJPiPLB51q7i24vJWXk0Hm5vxNLg4VZRmD/FB/baHc9C7
	 aB6z+1pTHzIwzqW8jyYJ3EidVt4+pldjXEH23aahxD0sOKpkuEJnhvuQ7ya5/4UQmrNqY
	 LtBU+klooF/++yMJ1Hnnl+VFley4e73o9JAKOoH4cG9929/Q3/tKQPJjbDI+KWdC3vw+Y
	 1yYKmoHuBhjrH6AXnYLSNq0rVJs4PxxN28d5cySrVxwce/m9WtJefFxx6cCRTznQtRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uoWK2yLh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7CD606A31C;
	Wed, 18 Nov 2026 23:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uoWK2yLh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE751F000C4;
	Wed, 18 Nov 2026 23:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045386;
	bh=asq6WN99GENzApdT8u6Yy5A0lgunGQIharnZHP8yTBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uoWK2yLhPH4zNFa982mn2lYi9SXfm7k46k5bVpoljdHXe0U4aoadW2mNs2ddaoNSG
	 bDJCDDOcf78ul9V9YbzzofffyqXsVW1+kI/8BjdFGPbicRXAhy/LCOZtqend/Wd+2Z
	 owUEqyWrijef3hfQnQBh14mEt/4smaLscHrLW+GA=
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
Subject: [PATCH 6.1 0906/2857] mm/nommu: reject wrapping ranges in access_remote_vm()
Date: Wed, 18 Nov 2026 15:32:20 +0100
Message-ID: <20261118150234.188589567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6f4025d1b52be..6817fa329520e 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1705,6 +1705,9 @@ int __access_remote_vm(struct mm_struct *mm, unsigned long addr, void *buf,
 	struct vm_area_struct *vma;
 	int write = gup_flags & FOLL_WRITE;
 
+	if (addr + len < addr)
+		return 0;
+
 	if (mmap_read_lock_killable(mm))
 		return 0;
 
@@ -1758,9 +1761,6 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
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



