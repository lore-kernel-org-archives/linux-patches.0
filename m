Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6701D5ABA;
	Wed, 25 Feb 2026 01:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982935; cv=none; b=gXv3MitIOzrQaD1vIPz9tmD2dFDX0zDp3DUwM1hQXi1slzRfyn92VHJ8yFDw8zdHZjCIXmpFhhPNgQ8Skg9xOcFMQ5rPFeq8Pk4m8ClJAkAcrIiyOJ1iEmVdBhfX92qAbnu8uAKHcK2tpnnaL4OVfLz60wsQOB9XOfgV+a+4qVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982935; c=relaxed/simple;
	bh=9OOcR+SIUH8XyN2lS7azsJDtyeGSb/LPoKKV22BWd4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oA1kjo/Hn0P75XsblTgg78g6bB9qqz1+UDNWZtWR61injrAXsw0PUC/4J9ATZu4dbXGox3VYgQ+1Cag6ENAwtqXH8S95Fjwchu4ZCvGQO3BuU6xpyVzIXMOtyjheHUC6h+bHXMlE4TY4459deyKOdjvsKyHEPu2S/Q3QJ8pdIBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3q3YdnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3q3YdnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634FFC116D0;
	Wed, 25 Feb 2026 01:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982935;
	bh=9OOcR+SIUH8XyN2lS7azsJDtyeGSb/LPoKKV22BWd4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3q3YdnGWbJuDfctbVzI7/u1dU4i6jFPKE5xJhX4RmjIAR6GLtupx+HgIyLUQorjG
	 gTGmC0bWeZ2g1ktEyCEn9P6X2t/xx2+WBpr/tR72cvEyyM3DwnDKu9dGFJCowrdfOt
	 437cRRipGXMZIM/1R+8pmKOnNgoIjhu/AmZE1cY8=
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
Subject: [PATCH 6.19 069/781] perf/x86/core: Do not set bit width for unavailable counters
Date: Tue, 24 Feb 2026 17:12:58 -0800
Message-ID: <20260225012401.394888280@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 576baa9a52c5b..af1329ae9f82a 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -3073,8 +3073,8 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
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



