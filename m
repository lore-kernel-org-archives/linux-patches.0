Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4064218021
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tp9PjwzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC75C433C7;
	Mon, 23 Oct 2023 11:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061525;
	bh=JOcCT9n8Yz6LcU5tewhOEgRWHT2rHxTEbKqMaRQAIPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tp9PjwzZ0SYadCGFyFxzf2nC0xZY1NYf/i1iLm1UI2Z97PIvpTONVOwfhSo+po3Zb
	 h9tUlWCnXOlj4vRmwUfvrRuWotJE2MnbxWRTPDDxRLf5K6x2QEIz9L6jWxfMX8lNs2
	 L9qpN3Vc4nMhtuX3hKOpNhS9naPOdh+ns9GyV55o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie@huawei.com,
	Ren Zhijie <renzhijie2@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 077/202] arm64: armv8_deprecated: fix unused-function error
Date: Mon, 23 Oct 2023 12:56:24 +0200
Message-ID: <20231023104828.797361809@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ren Zhijie <renzhijie2@huawei.com>

commit 223d3a0d30b6e9f979f5642e430e1753d3e29f89 upstream.

If CONFIG_SWP_EMULATION is not set and
CONFIG_CP15_BARRIER_EMULATION is not set,
aarch64-linux-gnu complained about unused-function :

arch/arm64/kernel/armv8_deprecated.c:67:21: error: ‘aarch32_check_condition’ defined but not used [-Werror=unused-function]
 static unsigned int aarch32_check_condition(u32 opcode, u32 psr)
                     ^~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

To fix this warning, modify aarch32_check_condition() with __maybe_unused.

Fixes: 0c5f416219da ("arm64: armv8_deprecated: move aarch32 helper earlier")
Signed-off-by: Ren Zhijie <renzhijie2@huawei.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20221124022429.19024-1-renzhijie2@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/armv8_deprecated.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -64,7 +64,7 @@ struct insn_emulation {
 
 #define	ARM_OPCODE_CONDITION_UNCOND	0xf
 
-static unsigned int aarch32_check_condition(u32 opcode, u32 psr)
+static unsigned int __maybe_unused aarch32_check_condition(u32 opcode, u32 psr)
 {
 	u32 cc_bits  = opcode >> 28;
 


