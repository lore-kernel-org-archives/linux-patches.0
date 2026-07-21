Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC121F3D56;
	Tue, 21 Jul 2026 17:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654037; cv=none; b=YsrFbS9/bjvpH3U2z9OqbP5YnYi/1CRVWTdNU81Y1sr0gyVSBsxDZ3x3abQXVASy+0OGbIV3/0I5RuexTfVQBs2frtwpaMFj29G2l9cenzVRG5aUPM3R/WJKfVn2HFcTz2OGzBIXpwMjvV86RmBVI+fV7xYNNWZzOFMly+s/ENs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654037; c=relaxed/simple;
	bh=wdJx7yNZ1fKwkqqDNP0w46Ag8IXPvYlCySyi8WJfOR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gM9uoUyQMGgveVZ0PK/BZSXHtjacIapMoe/PPfzgRVW+ktZCCsaq9uKIRqL05jV3AU1rFJ33XFf1cwwNgFy52vV7ed3R5sr3cHv7Yeg+/TC8ovYIrQS9L/ciTajI/1LzH5AMncnLj9a4bS158Dpep2axoiIGLbllVIgVtlDcLl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXkRfzip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXkRfzip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C721F00A3A;
	Tue, 21 Jul 2026 17:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654036;
	bh=xvjDgyu9BY/7b0dh1Ej5XeJAWeLCcC8uMZ7YEvbzHzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXkRfzipV2Lv/h3zNJlRbGShTD6whdKT+Ncoj0G4TShqzNybL5gXDx5Y1MqlhQtlN
	 4huRwb4H6fF8XNI52ud6TEBa0h5BPirmyDL+VAPRpsDaFv3WyrsiEK2O9wjbHk/OLu
	 /3zdmmpwW4AFJsuYA5CydAait3gW4cBza0LjlXtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 7.1 1552/2077] KVM: s390: vsie: Fix allocation of struct vsie_rmap
Date: Tue, 21 Jul 2026 17:20:25 +0200
Message-ID: <20260721152629.381488561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

commit 505fcce0c64957f475f9b11fb1403821b7f33e7e upstream.

The allocation size for struct vsie_rmap in kvm_s390_mmu_cache_topup()
was wrong due to a copy-paste error.

Fix it by using the type name.

Fixes: 12f2f61a9e1a ("KVM: s390: KVM page table management functions: allocation")
CC: stable@vger.kernel.org # 7.1
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260611104850.110313-4-imbrenda@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/dat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index 4a41c0247ffa..a4fe664f65ee 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -45,7 +45,7 @@ int kvm_s390_mmu_cache_topup(struct kvm_s390_mmu_cache *mc)
 		mc->pts[mc->n_pts] = o;
 	}
 	for ( ; mc->n_rmaps < KVM_S390_MMU_CACHE_N_RMAPS; mc->n_rmaps++) {
-		o = kzalloc_obj(*mc->rmaps[0], GFP_KERNEL_ACCOUNT);
+		o = kzalloc_obj(struct vsie_rmap, GFP_KERNEL_ACCOUNT);
 		if (!o)
 			return -ENOMEM;
 		mc->rmaps[mc->n_rmaps] = o;
-- 
2.55.0



