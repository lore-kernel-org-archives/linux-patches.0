Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF04C267B65;
	Tue,  8 Apr 2025 11:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110329; cv=none; b=T/9Hu+9JVM+/8cr/e6XhiEg5SJ4VZzC9riO4V00j9iCE65r1gknQjt+vO4wDCQSmDwYUr5yokXaf/O13RsN4cwZ0k9HkFDLD/+37NGM/BS5NNwleJzxy6Hzrt/OcWyHjfTEBiMns3DKA3L03RwaLd6Yd6vZAlHLtPV3CYmeeKh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110329; c=relaxed/simple;
	bh=1NLL//mifMkigeI1/V/wD39hhWccp7U8dwTwdj+Xmfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWZQG5mZY58mBlj7m8xDMiXmXymE5yzIYuHmkvkMAO5yuse1acNz8/0MH0us7LBNIQDESfsBC6MOkhl+CgwjhXecIHue2bIcCrJgaLOHHPAbN/tc3iwlj2o3pwdW6nIQIsqfhmcWKDPqBX03Kq60VDwL7UaDysRskPr14FjhUAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+nLilIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+nLilIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BC2C4CEE5;
	Tue,  8 Apr 2025 11:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110329;
	bh=1NLL//mifMkigeI1/V/wD39hhWccp7U8dwTwdj+Xmfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+nLilIxYqIU1YK4vsIcB3ZsWy2FV3xE8BvW2RioLX6EGo5PxqoaN1tJhaiJYHgHO
	 MBl/KNQxgTXN+YM4xMKf8yGuC4a4K1xQDw4zY+DSgYeW1YgoGsKUjPVxB4toVc+3Bb
	 deCGG6oINASMsBD6azrOFl5nIsbDeHRaJaVpN6Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Loughlin <kevinloughlin@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 024/731] x86/sev: Add missing RIP_REL_REF() invocations during sme_enable()
Date: Tue,  8 Apr 2025 12:38:41 +0200
Message-ID: <20250408104914.829230335@linuxfoundation.org>
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

From: Kevin Loughlin <kevinloughlin@google.com>

[ Upstream commit 72dafb567760320f2de7447cd6e979bf9d4e5d17 ]

The following commit:

  1c811d403afd ("x86/sev: Fix position dependent variable references in startup code")

introduced RIP_REL_REF() to force RIP-relative accesses to global variables,
as needed to prevent crashes during early SEV/SME startup code.

For completeness, RIP_REL_REF() should be used with additional variables during
sme_enable():

  https://lore.kernel.org/all/CAMj1kXHnA0fJu6zh634=fbJswp59kSRAbhW+ubDGj1+NYwZJ-Q@mail.gmail.com/

Access these vars with RIP_REL_REF() to prevent problem reoccurence.

Fixes: 1c811d403afd ("x86/sev: Fix position dependent variable references in startup code")
Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/r/20241122202322.977678-1-kevinloughlin@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/mem_encrypt_identity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index e6c7686f443a0..9fce5b87b8c50 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -565,7 +565,7 @@ void __head sme_enable(struct boot_params *bp)
 	}
 
 	RIP_REL_REF(sme_me_mask) = me_mask;
-	physical_mask &= ~me_mask;
-	cc_vendor = CC_VENDOR_AMD;
+	RIP_REL_REF(physical_mask) &= ~me_mask;
+	RIP_REL_REF(cc_vendor) = CC_VENDOR_AMD;
 	cc_set_mask(me_mask);
 }
-- 
2.39.5



