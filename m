Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829686;
	b=qtoaUnAMKzYDn84J5a9+NAg1aPUSI2x/oEiNXAlzyuiwuxpnkVJ7ED+gzNHNj8dzIpG6
	 /ijYPGLCdOW83qLkV1/gHiXAXz5mKpXtTT+eGxJ3F2Sw4rDncK5y+zk+b//USr/Wl2aFX
	 zQPW4rKwjPdJ8DZO5YRl+5L3haaf2HR4ZoEHR2v4/iNZWGhnKMitHnL2wcmBuhNm1H5pL
	 FyOfcUlqU7Ud81c9nykjq3mENbRBmKLTfWiR9bZDKZdUjb4/R5urbr3rFfoAv4N6aUSt5
	 sc7YL3aUu2IaL4VdwTvhxtCmy07+CmWFEnWLYIEChIQDlqFSRVXuyrzmpeSfiyXcFgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sLv2CAdnS1qpO7k7ww6QXAfxiwOkbub3lPDIx3foRSo=;
	b=gFAJRpGg2UgG67KD02GtbjusseigAXjcRTwuDuvNtvhvxEPxAsrR7fRuQS3IELEjIztL
	 th3WUEYpNKEaWa+p8s0bUSPB32qFL1xJ9FJ2M+FGW7drSHxq+90cXrxm3ejbFEIVWgbyz
	 rnzBPsB0B7jEGvQUVviIK7OqEeenDbWZu0O+TDJZQ+go7Y8PI1m1Lwz8Ycvo8CkfcFZFa
	 GM1S5aFsmTaNZ4P2J8Cw4c+qMmkOh0+E1TfspJc0N+tci3/qEh0WSeqa/kJqojI3BJYSw
	 7eEaLDoLb96cfMJHKlBhk8lHb+ux8Rk0bIlC91PTi/Lx46Jv2BJFcjy2p/KiVWuyoXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIzVM4Pl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0170E606EE91;
	Wed,  4 Nov 2026 22:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIzVM4Pl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8380B1F00919;
	Wed,  4 Nov 2026 22:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829685;
	bh=sLv2CAdnS1qpO7k7ww6QXAfxiwOkbub3lPDIx3foRSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sIzVM4PlFcQpxmuy7637QY31dw8sX7ThbfSqZ5ONFBCV3B26EXJTNW+nHC3FvJaEx
	 Z0BP/eD/4YyskdMoX4MAjblF4/hNoppac3QpsoPrDREwB00VBTKFLWsawsEWZspdEk
	 0HcgDU3T4qS1octa6lHI+neaPZk9AcJylIvZwNqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.18 0279/1005] s390/mm: Add missing mm check to do_secure_storage_access()
Date: Wed,  4 Nov 2026 16:00:12 -0500
Message-ID: <20261104211051.707486930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 7cf227b2707ed0129018c283ffc8f893945586db ]

Similar like the normal exception handler the secure storage access
exception handler needs to verify if mm is not NULL, which may happen
with kernel threads.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260717132345.539A11F00A3A@smtp.kernel.org/
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>> ---
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/fault.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 069f72703a915..46e5748b5b1b3 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -404,9 +404,9 @@ void do_secure_storage_access(struct pt_regs *regs)
 {
 	union teid teid = { .val = regs->int_parm_long };
 	unsigned long addr = get_fault_address(regs);
+	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct folio_walk fw;
-	struct mm_struct *mm;
 	struct folio *folio;
 	int rc;
 
@@ -448,9 +448,8 @@ void do_secure_storage_access(struct pt_regs *regs)
 		if (rc)
 			return handle_fault_error_nolock(regs, 0);
 	} else {
-		if (faulthandler_disabled())
+		if (faulthandler_disabled() || !mm)
 			return handle_fault_error_nolock(regs, 0);
-		mm = current->mm;
 		mmap_read_lock(mm);
 		vma = find_vma(mm, addr);
 		if (!vma)
-- 
2.53.0



