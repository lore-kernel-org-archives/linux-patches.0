Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058565;
	b=Yb/G2FvHbd6IDFPgTHstzRZ9jspgd1U2gTTuLCU3RB1ZHP0grHZ4IYI1jzfu5ED0Asyy
	 ejgZBrpMSMmqMXlnM565viR8y9CunGe46qZiR+mIq6677Zk11YYvBD0tnDc+OnPVIlsDz
	 hak1ldR4dOFWv2e2quio0UpH87zHuUtinT2Bqjq4MPz/sDCzfv1yhnR+U6bRdoB6oNXXT
	 Vfv9LE2+Gu08HPVwzW4U3zc2KUPTqTWmQTOpmiWvNhS/xM9tqsWb4PMzFMnAMmO8M3oKw
	 bbnUMVilM1bf8Pg3yAfE2YojgHrxfEKb0GVjt8vAXY6FtXS2D8nFfdHfZjuOtKDoyeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zn6EpNLgFEUvMQ27dZw2l37aCeOW4QIrQaWMJA176fM=;
	b=euc/4+Kf7xeqDBGQ2eVcXXyng20Dutkp0K7IWDZpU5Zg0rlpdOYrXZy03BhhZcMWoMx7
	 08EduIo0QhBE0Ean9dAcft1bDXmShkwDPDaJQqXQF1PkW+coELTbpxhiKX5vk7DUgA7dO
	 DsjzKJwAENL49bFbjHpMUve18Que+PVY4xc3LM0g7Q0ynSMFr7gUPCjseH8c42VPRjPS/
	 fN931t0jiD2I1sfp4W+0GYiniCIAebeF4U7ziOgOaR7yGoZt52ucWn6N3cVmPpKI/9QR1
	 B+SQgtqYEwhuIrUgkZHaMEEqDjZhlcSkdeiuDdiaUlvDuOAnJxqToK+fEy7vQVUwqBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uh3lesuw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640A4606A330;
	Thu, 19 Nov 2026 03:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uh3lesuw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1801F000C4;
	Thu, 19 Nov 2026 03:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058565;
	bh=zn6EpNLgFEUvMQ27dZw2l37aCeOW4QIrQaWMJA176fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uh3lesuwgnBfrXZulfOM78EoWYmlJLeM08NkP6J1yQIy3nU/RADPCTVE24daFsz/N
	 +UxxUiVC3nGwh6IpylSdsKQGgoSiPOylEjlMLrE5PqweIVEmVCkaNSgDAinl9tDJET
	 4iAkGhAewUSbfFNjQhyyXvsaBDEOGLhPYOemSRCI=
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
Subject: [PATCH 5.10 0491/1848] mm/nommu: reject wrapping ranges in access_remote_vm()
Date: Wed, 18 Nov 2026 15:42:09 +0100
Message-ID: <20261118145934.862951295@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 015d291e18302..eba0a6717d213 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1680,6 +1680,9 @@ int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
 	struct vm_area_struct *vma;
 	int write = gup_flags & FOLL_WRITE;
 
+	if (addr + len < addr)
+		return 0;
+
 	if (mmap_read_lock_killable(mm))
 		return 0;
 
@@ -1733,9 +1736,6 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
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



