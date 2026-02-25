Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5716826E6F4;
	Wed, 25 Feb 2026 01:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983774; cv=none; b=hATl6yUAl+y/Ysm0uJhNPfWyIf2F71KewZQI9QNd6Ye8PtxAaAJigrU6EoevrthSfoZYexLlqDrMensVBn2pbWZT9PVUQfG7GLDm3kdvDosNnERMEud1uEvLt4gkk+MWbRfk3/GciPAKhGq0jVdEtavCr3WrnAUCntMfN4QZI5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983774; c=relaxed/simple;
	bh=Vo2yMwofN9BgMIfLlhg2Ifh8OEKxwyfgPWW4GHk/bOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4sEyWJ3He9Q7VfmnqKmKf0FbE+568EBe8hr4rLxWr39CbD1k5OpIODsf3SRl8RW4Q+VgEdGHyisnC+OdtU9bnchgjo6JGjVaHF3WNuY+9cHhxsAioNHQYuCWO+nCDOV1Ex+BhRzRRiMQe6gLMzF1mPpI5yAV8m+5sAdjvdzH4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bu1IU2wR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bu1IU2wR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F03AC116D0;
	Wed, 25 Feb 2026 01:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983774;
	bh=Vo2yMwofN9BgMIfLlhg2Ifh8OEKxwyfgPWW4GHk/bOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bu1IU2wR7iM39W+Zk6fanzNfg6H5US+YP4cu1SCBV1PYHBJujg5kDGeCuvAcz2P2s
	 PfSRJRV2a0JZe3XEYVpwfHRBThBCY6iCUXboKwy4jZwFypgZx4d90XdILsX0XDGeAY
	 N6kHWZKIUJWaCK7VivmGyyNmVgOyPYSrDbLtP508=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Sean Christopherson <seanjc@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Xudong Hao <xudong.hao@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 064/641] perf/x86/core: Do not set bit width for unavailable counters
Date: Tue, 24 Feb 2026 17:16:30 -0800
Message-ID: <20260225012350.605534549@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit b456a6ba5756b6fb7e651775343e713bd08418e7 ]

Not all x86 processors have fixed counters. It may also be the case that
a processor has only fixed counters and no general-purpose counters. Set
the bit widths corresponding to each counter type only if such counters
are available.

Fixes: b3d9468a8bd2 ("perf, x86: Expose perf capability to other modules")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Link: https://patch.msgid.link/20251206001720.468579-11-seanjc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index dd9ff120ad437..56df4855f38e9 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -3101,8 +3101,8 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->version		= x86_pmu.version;
 	cap->num_counters_gp	= x86_pmu_num_counters(NULL);
 	cap->num_counters_fixed	= x86_pmu_num_counters_fixed(NULL);
-	cap->bit_width_gp	= x86_pmu.cntval_bits;
-	cap->bit_width_fixed	= x86_pmu.cntval_bits;
+	cap->bit_width_gp	= cap->num_counters_gp ? x86_pmu.cntval_bits : 0;
+	cap->bit_width_fixed	= cap->num_counters_fixed ? x86_pmu.cntval_bits : 0;
 	cap->events_mask	= (unsigned int)x86_pmu.events_maskl;
 	cap->events_mask_len	= x86_pmu.events_mask_len;
 	cap->pebs_ept		= x86_pmu.pebs_ept;
-- 
2.51.0



