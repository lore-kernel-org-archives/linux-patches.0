Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6883411C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC36C433C7;
	Mon, 28 Aug 2023 10:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218970;
	bh=LRx/Nwgloe1+2kXQTeJKxGIfLyrTgrxSLW7f4twgYtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+S/0mrtPWZ0RSa7Cvu6jP3n2aApgXHD0ehrhLDtTv0qtggb3zjxNse2q/c20SX+c
	 4f81U0dBAtyzGnpGfVbTLGYdr871pt4AaCjYx1JM3Q31omsmFNbHxtLRqC6SQwJV3y
	 MamzwUrJtmqReorSmy0oW7I1ltchF+qxxawPAXjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Benjamin Gray <bgray@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/158] powerpc/kasan: Disable KCOV in KASAN code
Date: Mon, 28 Aug 2023 12:12:03 +0200
Message-ID: <20230828101158.227667261@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Gray <bgray@linux.ibm.com>

[ Upstream commit ccb381e1af1ace292153c88eb1fffa5683d16a20 ]

As per the generic KASAN code in mm/kasan, disable KCOV with
KCOV_INSTRUMENT := n in the makefile.

This fixes a ppc64 boot hang when KCOV and KASAN are enabled.
kasan_early_init() gets called before a PACA is initialised, but the
KCOV hook expects a valid PACA.

Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Benjamin Gray <bgray@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230710044143.146840-1-bgray@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/kasan/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/mm/kasan/Makefile b/arch/powerpc/mm/kasan/Makefile
index 6577897673dda..22f1a7c3f4362 100644
--- a/arch/powerpc/mm/kasan/Makefile
+++ b/arch/powerpc/mm/kasan/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
 KASAN_SANITIZE := n
+KCOV_INSTRUMENT := n
 
 obj-$(CONFIG_PPC32)           += kasan_init_32.o
-- 
2.40.1



