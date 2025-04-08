Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104BE26A0AF;
	Tue,  8 Apr 2025 12:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113661; cv=none; b=ly2nRh5VUWug+69n8EeFhZqrb4ZrHaJ2vRXSwzqRjgJ+HkW4FjdoJpJJ7MApiyaRpDu08pefqWhoFZAenV+TyavRb4GFrvsI4BeTFj9BmdEI69fm0l+FtQ/nJRnYG7+mVmQMXlvW2mH1b5O0prA01O8LyT025OFU238mkhZItFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113661; c=relaxed/simple;
	bh=bJ7FuPpJXntvNolUjEZRbM21tktNjpOE/ux3jF6J8Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNkdvY24k12Inop2dekEqmIaumzaQhMVSPzPqcP3wHIwGJ8pjJ1NdXie3rVuJxhgHPgGcNh7pDH7Q3B+/o4COvpc/MGrWiH5PAKlO6hJROAJB6zJdh02i8TKrZLjjGqpSUXQGfyQJ8J9xEiHE20tITa2PyTikJQ1SOiMK+PYC18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JyrPkT5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JyrPkT5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9470CC4CEE5;
	Tue,  8 Apr 2025 12:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113660;
	bh=bJ7FuPpJXntvNolUjEZRbM21tktNjpOE/ux3jF6J8Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JyrPkT5mLTvFuiyXH2va4lpoInv9UweiojhgTk8pDL9I4c6I9peyAbaUbtU/MbC38
	 7eIYGMuPxx3P02Fhb8gH8uJI+g1xY+DgdQ3BbCyd+kZD+9kdY+BwVX6qllCA0S1+wX
	 JVVz8pL8h7BiUhMWb2rIwiiMrkR8KN3ovYSo7mWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyu Lan <tiala@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.6 235/268] x86/hyperv: Fix check of return value from snp_set_vmsa()
Date: Tue,  8 Apr 2025 12:50:46 +0200
Message-ID: <20250408104834.930282657@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianyu Lan <tiala@microsoft.com>

commit e792d843aa3c9d039074cdce728d5803262e57a7 upstream.

snp_set_vmsa() returns 0 as success result and so fix it.

Cc: stable@vger.kernel.org
Fixes: 44676bb9d566 ("x86/hyperv: Add smp support for SEV-SNP guest")
Signed-off-by: Tianyu Lan <tiala@microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/20250313085217.45483-1-ltykernel@gmail.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20250313085217.45483-1-ltykernel@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/hyperv/ivm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -338,7 +338,7 @@ int hv_snp_boot_ap(int cpu, unsigned lon
 	vmsa->sev_features = sev_status >> 2;
 
 	ret = snp_set_vmsa(vmsa, true);
-	if (!ret) {
+	if (ret) {
 		pr_err("RMPADJUST(%llx) failed: %llx\n", (u64)vmsa, ret);
 		free_page((u64)vmsa);
 		return ret;


