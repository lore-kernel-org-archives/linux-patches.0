Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0A61A27D
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agq8MrH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1924C433C8;
	Mon, 16 Oct 2023 08:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446253;
	bh=RuFrLPpmiTVTHA8O2mdYvDV9O54DjeYoy2cRFuVSjuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agq8MrH3WtO3qCDXE2MlhMwuaUipq6maaj3aE44U/jaQVdM40wBAz5CJd/Q6gH7GC
	 eG24t2bl4qLiS7cWPFEVprDWvfomLN29yDsXz3W2W6lrxS3LCKlidTqmQgtw8gqSF4
	 VmgFkZ7YGijhDMV8AxU1lZFLiVsmpvR/eV+wPV3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie@huawei.com,
	Ren Zhijie <renzhijie2@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 099/102] arm64: armv8_deprecated: fix unused-function error
Date: Mon, 16 Oct 2023 10:41:38 +0200
Message-ID: <20231016083956.343823709@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


