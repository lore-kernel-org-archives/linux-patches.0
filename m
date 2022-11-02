Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5845F7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D29BC433C1;
	Wed,  2 Nov 2022 03:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359062;
	bh=icFqFopmqoX/aDGUC4FTvhp5GMXkbbyROAF2R6wfw1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEEL9d9zzhNu4L0bVszQQPZMH7xyQvXF8iUXhNmzrI6qy55UcnQgEloTMwEu1g/Wc
	 MEL7vwPli51R0mpiPpyBfL7SpE9OsgNBcgzc2np0fbQL1sWS0sbl12/SJMKUD/XTa1
	 1RM0R3h3mc37KVOEQnZxScTi9+FDsZ/4sxru0e0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 43/91] perf/x86/intel/lbr: Use setup_clear_cpu_cap() instead of clear_cpu_cap()
Date: Wed,  2 Nov 2022 03:33:26 +0100
Message-Id: <20221102022056.259490443@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit b329f5ddc9ce4b622d9c7aaf5c6df4de52caf91a ]

clear_cpu_cap(&boot_cpu_data) is very similar to setup_clear_cpu_cap()
except that the latter also sets a bit in 'cpu_caps_cleared' which
later clears the same cap in secondary cpus, which is likely what is
meant here.

Fixes: 47125db27e47 ("perf/x86/intel/lbr: Support Architectural LBR")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lkml.kernel.org/r/20220718141123.136106-2-mlevitsk@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/lbr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 42173a7be3bb..4b6c39c5facb 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1847,7 +1847,7 @@ void __init intel_pmu_arch_lbr_init(void)
 	return;
 
 clear_arch_lbr:
-	clear_cpu_cap(&boot_cpu_data, X86_FEATURE_ARCH_LBR);
+	setup_clear_cpu_cap(X86_FEATURE_ARCH_LBR);
 }
 
 /**
-- 
2.35.1



