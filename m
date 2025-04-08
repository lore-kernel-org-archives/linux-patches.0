Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225DA26F47D;
	Tue,  8 Apr 2025 12:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117056; cv=none; b=ahrF73Q3qEj5NQjqskO8/cs1+a0sYEYFo7+IUm5I+aM6oKief+H+UhXeTazEWNJxjl9aLneYkope9lZ7yryvGB7OVuoLbEVyQD4yyhjVINZ5HHUEepxQPywIEYf2bZ5cj/ZdDr0aP10jdFLNTQBdbfeREdEGjOdugBt+Mi9JqjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117056; c=relaxed/simple;
	bh=+iGTOSh7mAlrjbCzPhXZxDvnAEXa2j+8MEb3o7BGXC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvflcDmDD67ORMvWkoinTAHYOf+9zQh9+Gj9UDxHtY/7iCIvj09XoDcj9VXlFAPSTkssvpAqJvqLnCLzXE9msR67CwHj2yCJv/zA0wXMrzOrOgBPCVbo8RvzWEv4u1H2viN0zT5AT7xHGsjxBLwEIQu4BAOqCtNLk/OpvNiKaV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pt6wjMK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pt6wjMK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAFDC4CEE5;
	Tue,  8 Apr 2025 12:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117056;
	bh=+iGTOSh7mAlrjbCzPhXZxDvnAEXa2j+8MEb3o7BGXC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pt6wjMK7xZMiLgmuP6n4aNMUy7raTskV7iKb18WzRoyyfh4RDQyQlCUGTNY5FgVgi
	 v7prruMJ56KqZJeTAkG6Ttqf5oD9shaXWr9FYHT3m32XdZdKqbG88pZxuDCWzEu0dJ
	 QqlrExkiAyEuw8JNkKJwjxME9lKKAgwEUzlzimHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyu Lan <tiala@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.12 368/423] x86/hyperv: Fix check of return value from snp_set_vmsa()
Date: Tue,  8 Apr 2025 12:51:34 +0200
Message-ID: <20250408104854.436851626@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -339,7 +339,7 @@ int hv_snp_boot_ap(u32 cpu, unsigned lon
 	vmsa->sev_features = sev_status >> 2;
 
 	ret = snp_set_vmsa(vmsa, true);
-	if (!ret) {
+	if (ret) {
 		pr_err("RMPADJUST(%llx) failed: %llx\n", (u64)vmsa, ret);
 		free_page((u64)vmsa);
 		return ret;


