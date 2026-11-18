Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033493;
	b=jgb+zsgkfGBdeFyNH7rutgssRHCY3rAKC+ANE0AbUgfptAxe8a/iw99laOJY7z39eW/i
	 yaqQ1VVWYL8hZksOnTbUZl1MurazmKHhtl7MptxufRPepn3sfyaibLf+k+MBjv4epWKD7
	 h8NC9FNtbA3KG+ZerGSLS91mpTuWnli0dHTXKfbXlQt0SSMB4TiwOc66gKUKqpm6T3cm5
	 SctsLS6JSCVVh1Tpd5wj5zFHmorgBHSI7qTDtCh6/BhA1lRahfJU/ufHgWqKPjeLKYSN9
	 AAt5V0xg6G5yRNb63Em7kvWOtwpPjsosTzQSYalKicxGPUqio0z0RfPxf1fL5mSVFvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cBG++x94nC1ZdZPUot3RjCrOoYOhvoZrHwrPXJBvNSQ=;
	b=UKtGapaynD08hIYUAiUyDocEswT/EjqetTC1u0wvVAF5Qz6JD3MmuQS+BTxVgPQ1NcgT
	 tm+NcNifUYM6zQs6hc5EaV/ff+nI5dz1nmL4Kcf6vm8jzNrWtv147Ep+PEwVGPqqe24IH
	 ih+SR+E65TX4wCQUwQUB9RS57RY3jr0wtpuAD45qqjnNMkxFymQwcAvX6ITjbXyBemcID
	 C+YmTr6lNZQTkBAPATVPYghjJlHDVBz+zeyc7fIdlgDCuujzZTKSHgphM3Qp/ajV5odz8
	 QPddIOtfwWx941xN1Gh3QFV/lAIlt+5Vdhd+qU3zpXTrLqAfO7E6DEdX2TlWWFLMBNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lVihtM5W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A978606A320;
	Wed, 18 Nov 2026 20:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lVihtM5W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2F81F000C6;
	Wed, 18 Nov 2026 20:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033493;
	bh=cBG++x94nC1ZdZPUot3RjCrOoYOhvoZrHwrPXJBvNSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVihtM5WcgG6JKk8sKeiWjcmYMuCe5a7gztU1ZCNT5Rk+1vaSrta8opWwk6Wozy6e
	 pTHtVE0aFhnQM7Vl3nlCbAiyISQE3TjPKEpipZcxNzecbV6L7vIyGQjAnTDLPNlyIS
	 fNatxEwIZu+C8ne7VzoFh0oz/Rh1L0DgaJSDVApQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0035/3318] perf/x86/intel: Fallback to sw branch type decoding if no hw decoding
Date: Wed, 18 Nov 2026 15:10:57 +0100
Message-ID: <20261118150314.878033710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dc4e0804b9008..f83d1247bc89c 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1144,7 +1144,7 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
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



