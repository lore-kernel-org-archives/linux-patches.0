Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CCD2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93809C433EF;
	Sun, 22 Jan 2023 15:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400872;
	bh=37LvORqzfbTlx8VyWNDMpu7pFMSXnVQxC6mBfEdKJyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xv7teoiQ7BVWfNttxtvMBArClcu28TMckJ01d/o1ZFP/IqvZ4Mz4wjpw2hzZCJgIF
	 FfqqW3YJH++2rfuTUTJwsl4TCM3JlBGM4Yf5kk6PorQkwPfARY6UysdCzgcjctcqpK
	 yagNqqFyWUk7WHZ+xnd8gIF8WS805BzyyF/6wqDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Stephane Eranian <eranian@google.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/193] perf/x86/rapl: Treat Tigerlake like Icelake
Date: Sun, 22 Jan 2023 16:02:32 +0100
Message-Id: <20230122150247.424818998@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit c07311b5509f6035f1dd828db3e90ff4859cf3b9 ]

Since Tigerlake seems to have inherited its cstates and other RAPL power
caps from Icelake, assume it also follows Icelake for its RAPL events.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Link: https://lore.kernel.org/r/20221228113454.1199118-1-rodrigo.vivi@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/rapl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/events/rapl.c b/arch/x86/events/rapl.c
index a829492bca4c..ae5779ea4417 100644
--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -800,6 +800,8 @@ static const struct x86_cpu_id rapl_model_match[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,		&model_hsx),
 	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE_L,		&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE,		&model_skl),
+	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L,		&model_skl),
+	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE,		&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_N,		&model_skl),
-- 
2.35.1



