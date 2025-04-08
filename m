Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F64268FEB;
	Tue,  8 Apr 2025 11:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112082; cv=none; b=hza5bJ89ASKl8/+PbQNEcMpFf9VG7QqjT3gIeQHn7ajKImihNhvfEACfrWv5R7+7r9VR5NVcdbEeBt+nHfGpU2f3EsJolN99TtmP/Fg/rwUCRpMRNFiEJbKtDHTLXtcFGuSbaptxQCWhZiurpqFRUcHJQl3XB5TNnky3OoV6LCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112082; c=relaxed/simple;
	bh=c2ivwaaHJuSXJ8gUruGXLB9kHMhB86n1N/SwBhgHqWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wwh7ZqWdGffzeFYsq0vp/UpAGaUVXDVyP9tVg57vnGP7Q5DejkJFXF47vVncHY3XbwHomP9oc9mAsUhdcQGfncVbVv1Sc2x0l7Cj26tX2piR76TZ90XVeRgCr/3kdKkw03Wq9qI0G7Fd931oZeILSiYLaUfLHf15CHpm3ZHK+O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLtdBGj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLtdBGj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5031BC4CEE5;
	Tue,  8 Apr 2025 11:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112082;
	bh=c2ivwaaHJuSXJ8gUruGXLB9kHMhB86n1N/SwBhgHqWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLtdBGj4B4hB1P086WwGBNsyg4VuvEwfRa+x2cLUPl+gC/3wLdKn/vLd8sQ9rtk6d
	 ZgRhhPdL7/hCxyTai1dWDQZ9r4MVFKi20MhYpm7egfo4Uj2mQ73pul+yXHZ69R2+H2
	 BXe56duhMGU0G1hW4Hic18QSO+66SGkaV0kYNXPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyu Lan <tiala@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.14 668/731] x86/hyperv: Fix check of return value from snp_set_vmsa()
Date: Tue,  8 Apr 2025 12:49:25 +0200
Message-ID: <20250408104929.804161976@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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
@@ -338,7 +338,7 @@ int hv_snp_boot_ap(u32 cpu, unsigned lon
 	vmsa->sev_features = sev_status >> 2;
 
 	ret = snp_set_vmsa(vmsa, true);
-	if (!ret) {
+	if (ret) {
 		pr_err("RMPADJUST(%llx) failed: %llx\n", (u64)vmsa, ret);
 		free_page((u64)vmsa);
 		return ret;


