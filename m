Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6701C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4CEC433EF;
	Wed, 28 Dec 2022 16:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244689;
	bh=ajrtAJSFoMvEYaYNkMRXxNrl6mUalFOqk28OHQmYJiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSOaovTvu9ieOXRKnCRSseF6dX0h+TPJbMKXifuZiomzo/JUZJptSiAWJanndeKi4
	 xxZ7mrcQUupWQ8XZaOt89PK3ijIVeL8sP8FVxXaWww6cN8Ps4gocb0XOLU9yAA38Z4
	 s66dCfKAX3YJv4JuBJ797UoVpSz81lB6lc7ujpa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0757/1073] ftrace: Allow WITH_ARGS flavour of graph tracer with shadow call stack
Date: Wed, 28 Dec 2022 15:39:05 +0100
Message-Id: <20221228144348.579438826@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 38792972de4294163f44d6360fd221e6f2c22a05 ]

The recent switch on arm64 from DYNAMIC_FTRACE_WITH_REGS to
DYNAMIC_FTRACE_WITH_ARGS failed to take into account that we currently
require the former in order to allow the function graph tracer to be
enabled in combination with shadow call stacks. This means that this is
no longer permitted at all, in spite of the fact that either flavour of
ftrace works perfectly fine in this combination.

So permit WITH_ARGS as well as WITH_REGS.

Fixes: ddc9863e9e90 ("scs: Disable when function graph tracing is enabled")
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20221213132407.1485025-1-ardb@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 8b311e400ec1..732a4680e733 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -629,7 +629,7 @@ config ARCH_SUPPORTS_SHADOW_CALL_STACK
 config SHADOW_CALL_STACK
 	bool "Shadow Call Stack"
 	depends on ARCH_SUPPORTS_SHADOW_CALL_STACK
-	depends on DYNAMIC_FTRACE_WITH_REGS || !FUNCTION_GRAPH_TRACER
+	depends on DYNAMIC_FTRACE_WITH_ARGS || DYNAMIC_FTRACE_WITH_REGS || !FUNCTION_GRAPH_TRACER
 	help
 	  This option enables the compiler's Shadow Call Stack, which
 	  uses a shadow stack to protect function return addresses from
-- 
2.35.1



