Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678AE10FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA66C433D2;
	Wed,  7 Jun 2023 20:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169627;
	bh=DrIOmp9TaBfRxEIlICSLUZcRJY6bSl9wUv6235PC/mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhlVT8cziM4e/aC4h0r32GwEyERYLHyAR+TYBkUHyCK+I+pYdWF09pXIRSIJN1rq4
	 HdRl6GrSYHJ1LgDq/HtEAaK6tMgPqWe3L3uXYfC54KfIWCJwXOqNHeWiBvWil2bZmb
	 eKmIKX0q0LLbsIZorrZ3GCWk5Xd0wMXWG2Au2BXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 152/286] arm64: vdso: Pass (void *) to virt_to_page()
Date: Wed,  7 Jun 2023 22:14:11 +0200
Message-ID: <20230607200928.073407156@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit b0abde80620f42d1ceb3de5e4c1a49cdd5628229 ]

Like the other calls in this function virt_to_page() expects
a pointer, not an integer.

However since many architectures implement virt_to_pfn() as
a macro, this function becomes polymorphic and accepts both a
(unsigned long) and a (void *).

Fix this up with an explicit cast.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: http://lists.infradead.org/pipermail/linux-arm-kernel/2023-May/832583.html
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/vdso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 0119dc91abb5d..d9e1355730ef5 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -288,7 +288,7 @@ static int aarch32_alloc_kuser_vdso_page(void)
 
 	memcpy((void *)(vdso_page + 0x1000 - kuser_sz), __kuser_helper_start,
 	       kuser_sz);
-	aarch32_vectors_page = virt_to_page(vdso_page);
+	aarch32_vectors_page = virt_to_page((void *)vdso_page);
 	return 0;
 }
 
-- 
2.39.2



