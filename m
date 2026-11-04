Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829309;
	b=FLUAtosesxJ0Z1ZZRvwe/l1qpHhKL86gqAjjemVcrVx22jHZZ0nR+OlMvs4VypXsvlrU
	 4JXeYbpSyHorZaBXKljjL5pgmhaYGmUtRjRn3ldHY1QgkHrWv7xJI7tKtKlNL1L+g6UL7
	 KN2Tt3zYJtMvsvlatBZEXyrIY7yx6Zg/iutIIJ7U9Q5d/bDogUcDaTzMpBuOU4tA5utBA
	 BpaX28QToyJZnKH43YXqR3m9aftbZG0e+2+D3FjWRSc8V5UkQL2flfXi4QYZ1svx2g+PR
	 X6pSanyyC9gUiz7jkWvwTsTVly4Jc/g5q3PooUFcZteiTbE8ABWqxBiUxDlA7QE0Dbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yFddJlitZzCEgR9rd9TIvr0YL24gVu1PgOBkAhyu4bM=;
	b=KNSUIjuSWSd6mxhOjSUXyTuN5MqGrgzj9WQF/Doe86mZvFIYMrVamVEeALN6XBfDn8rE
	 ehKkTBJrJeHA0IzSkz1RhhkqopictywkFmoCO8O3FELSWHOCJT8iAWu1Ul0nZ5Jsa5cAt
	 2LWgjrlO8IDHxthHaUMKCRHwQUQ95qgXO/lEpY1iGMdtXK9+0R6HkTbAwh5r8MJpJDndL
	 bWfxVFrdkCiZTzzKawSlVz8fN7VtzgbTzCVaMpDMvJNIqw7oBJIAyclwvnuICIVTRJcY2
	 2Mux6L/LJ0s/aLJPzas1jTlQodrJ8t66Vgsi3k7hTiE9XIYmaG8TmdTbp20vGTJ2v4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mt/P9fJh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53F0608661B;
	Wed,  4 Nov 2026 21:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mt/P9fJh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA411F000C1;
	Wed,  4 Nov 2026 21:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829308;
	bh=yFddJlitZzCEgR9rd9TIvr0YL24gVu1PgOBkAhyu4bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mt/P9fJhplFPNY89nrP4eWq9PoLAd3WsQuWY8ki3AtMrVHHed/1K+eB0zUVAd5iSd
	 zHprKY+wfIyq9Yc/u+SWV5+tpsNiLFRg+Ey7jqAZOhl0z13nyUwTU5LVY6M2iflzwN
	 LK4qNwhyjLXgTLG0DVEbIc1rojX8+phpEU/CpEQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0043/1005] perf/x86/intel: Fallback to sw branch type decoding if no hw decoding
Date: Wed,  4 Nov 2026 15:56:16 -0500
Message-ID: <20261104211044.787278293@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 170cc6b02e3d5203ccaa49ffea1ee5a7ab08c885 ]

intel_pmu_lbr_filter() currently assumes arch-LBR provides hardware
branch-type decoding and skips software decoding on that path.

However, arch-LBR may not always expose branch-type information. In
that case, treating entries as hardware-decoded can misclassify sampled
branches (for example, defaulting to JCC), which breaks branch-type
filtering results.

Fix this by using software branch-type decoding when hardware
branch-type decoding is unavailable (that is, when x86_lbr_type is not
enabled). This keeps branch classification and filtering behavior
correct across arch-LBR configurations.

Since x86_lbr_type is only set to true when arch-LBR is supported,
it's unnecessary to check if the CPU has the arch-LBR feature.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260616044654.3468742-4-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/lbr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 44f5556440223..bbfd6ffbdd68a 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1230,7 +1230,7 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
 		 * Doesn't support OTHER_BRANCH decoding for now.
 		 * OTHER_BRANCH branch type still rely on software decoding.
 		 */
-		if (static_cpu_has(X86_FEATURE_ARCH_LBR) &&
+		if (static_branch_likely(&x86_lbr_type) &&
 		    type <= ARCH_LBR_BR_TYPE_KNOWN_MAX) {
 			to_plm = kernel_ip(to) ? X86_BR_KERNEL : X86_BR_USER;
 			type = arch_lbr_br_type_map[type] | to_plm;
-- 
2.53.0



