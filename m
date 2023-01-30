Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF90A28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378ABC433EF;
	Mon, 30 Jan 2023 14:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088157;
	bh=oQMtx7NufkVDtsOcmTfoxzd+Q67sQff0+LCC8sKKthg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W46sskzmnfYVQjGFSsCj4RWUjamQfkQKr+yZ4Qz9rntqWKf+XkUrpGQxru47DCfrI
	 wsRvZCD3BUSdvqtn1Rtk3n4qlp/b5qzBQ+Zqti666sM9HCWQybei7R1UXYSPEU5IpJ
	 4F0/cAe5L1jxW1/osZ7dsCR+F50BlmjQd0LVh/EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/204] perf/x86/msr: Add Emerald Rapids
Date: Mon, 30 Jan 2023 14:51:10 +0100
Message-Id: <20230130134320.962773450@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 69ced4160969025821f2999ff92163ed26568f1c ]

The same as Sapphire Rapids, the SMI_COUNT MSR is also supported on
Emerald Rapids. Add Emerald Rapids model.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230106160449.3566477-3-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/msr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/msr.c b/arch/x86/events/msr.c
index 96c775abe31f..d23b5523cdd3 100644
--- a/arch/x86/events/msr.c
+++ b/arch/x86/events/msr.c
@@ -69,6 +69,7 @@ static bool test_intel(int idx, void *data)
 	case INTEL_FAM6_BROADWELL_G:
 	case INTEL_FAM6_BROADWELL_X:
 	case INTEL_FAM6_SAPPHIRERAPIDS_X:
+	case INTEL_FAM6_EMERALDRAPIDS_X:
 
 	case INTEL_FAM6_ATOM_SILVERMONT:
 	case INTEL_FAM6_ATOM_SILVERMONT_D:
-- 
2.39.0



