Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CD7375AAD
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301652; cv=none; b=MGT9hkUzSzBESiGMj0ZcbeusTIDzycw4OOIwkF/O/SqRPNKKiRJ2HuKa7rtNIt8HLhxAXdP86H24AYW2cmez0tzM5ZU1mXv3H52cQbhlqKTpEeHSdaid5C4OC+x1g3eRdI9k3CANB3p3Ftqgn9S2ppD0BoOp+7vXz4+X23LXnFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301652; c=relaxed/simple;
	bh=JX3033z/zlhuCfZb/lO0VFVsnlilJFuRhH9QQgJLtxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXhZpzdFe1ZlFXZqsK5i4RZ1tC8nhMSUtYhQQMvSYbZkrTvat19WONOyxEExfxk/zcYwst3wNk5QqF28L41rFV+ewGaqpdAzKmyZQsgFhzenGb7223/Jy41MP9auxQcP43QZH8LGYkcKQuUsdiMITTuvX8DgBib4h8g7ha0zsag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ObKb2KoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ObKb2KoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28983C19423;
	Sat, 28 Feb 2026 18:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301652;
	bh=JX3033z/zlhuCfZb/lO0VFVsnlilJFuRhH9QQgJLtxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObKb2KoLX8lPrlBJEq7tKGDpu1hb8cvgTKNovXACAIFUmxqA21q0rsrVqGdFS8xPv
	 9UaB8KChxwJWZPawf9iZa+VPfmUxEX/UOJcguUaHlExpLzeG340Hfe1HLAQcOksk56
	 XHY4ClXG/oxBJhiQbdEGAnQIbSjOxKonU9QYgQucn5jEIjcs1q/7cYlJz4OPwaYkFD
	 2RMfaweGveJsCqcIV2KXvYcrXdLZcUE1GmfWtzi9eLDgUGgqyPQIddLOxixRTPIUsn
	 JY9hpaIdjB51fW1laCfa20rxqIMnPD/dUzZfYmA1rJXgcp1NIknTkbfBtkOw+q3NIr
	 m/Tw3YtdLSWOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sandipan Das <sandipan.das@amd.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Sean Christopherson <seanjc@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Xudong Hao <xudong.hao@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/385] perf/x86/core: Do not set bit width for unavailable counters
Date: Sat, 28 Feb 2026 12:54:30 -0500
Message-ID: <20260228180011.1568201-48-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 86ba035f17a35..0f935cced0b7d 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -3051,8 +3051,8 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
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

