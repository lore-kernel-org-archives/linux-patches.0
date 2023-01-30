Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D823428EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50626C433EF;
	Mon, 30 Jan 2023 14:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088160;
	bh=n+Pugw7pyJIb26g7hIVl+LDidytgC6dNEVIEfaZFQQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5RJKLkIRUmvSMzX+mK0RAW3DB8hJFY5TZewXzSMb7YVR0PNn4Wu7nRqVnJBeFmmC
	 z2DKeGGVMvLHFK7j1TpPiPppTw0HpykxP091OwpzXDbxIDR5NyZw/GIyHTjgDPO78S
	 F8AEmY6eLn3exWV8lC09OiblXWFzQ3bxWQsKrCV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/204] perf/x86/intel/uncore: Add Emerald Rapids
Date: Mon, 30 Jan 2023 14:51:11 +0100
Message-Id: <20230130134321.012714298@linuxfoundation.org>
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

[ Upstream commit 5268a2842066c227e6ccd94bac562f1e1000244f ]

>From the perspective of the uncore PMU, the new Emerald Rapids is the
same as the Sapphire Rapids. The only difference is the event list,
which will be supported in the perf tool later.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230106160449.3566477-4-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index c72e368dd164..7e16c590f259 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1829,6 +1829,7 @@ static const struct x86_cpu_id intel_uncore_match[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&adl_uncore_init),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&adl_uncore_init),
 	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	&spr_uncore_init),
+	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X,	&spr_uncore_init),
 	X86_MATCH_INTEL_FAM6_MODEL(ATOM_TREMONT_D,	&snr_uncore_init),
 	{},
 };
-- 
2.39.0



