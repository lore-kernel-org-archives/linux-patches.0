Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060638;
	b=373TntZFElQjDNhy9eEIfumefY6EgSW0wdOk2sXLGMoRSnjUCk5vU7TlLnbYk6j6jl3O
	 PpNE27MChNCt2u6ICUyWTPEufnPrl3kBCa97x1U1ccLRrRQy3sMhbK29OH+L5tpAYWOAw
	 GrvXCfcqbmZlyWMwS/Nkeza1UZbfxUfGK5glGaaXllvt6QOyrnIqOJhX4jkSQBq4tPjz2
	 D/Ijl4YJtoAnB3Ocf7ZxtplwKNSjETp6a3L3HAt8Tck3JCAUltjxdOG3kmy6vi3yMyUfs
	 CfgDDgiYqPFfFLcIIKzEko24PNdAWNTOXocid1gVm9+ncE4AvBqcgKjTiHdWxEDsyYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Cgo/Drtn1AEEMMYfYaS1yoDSNcra9Mpkus71rsHNHI=;
	b=jsG8bGKu7m8rIq2RJQbpn1G5NG/kwYnNWbQZ/55RrEnJ1Mgx6JPipq2ozRlYQixmIou2
	 wt9MYFeKlXlJsm+nArayt39mi3qXA/PNxcJNkTT5wi3HZgr8odO0/oX+UH5ln50c8rByQ
	 g5eMiHyfSDac5Wzw2cwF6BudBlVqfHQwuQEhEMz9fFY9D9hrWkACKipIBcWR3dPcSGFtV
	 fvP2S5wNSOKHxBr7Ske1z9s2Dml4oIDOoEUU6qGlGeU/aGwElgwB4phzEwVr++1wgI7vU
	 NzS1i1fTh5kZYoXir18oicaim8TQ2/PaHW5o6cx+K1wrOcDq8fv2g4s4BucJSuE3sxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aST9fVFW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11082606A326;
	Sat,  7 Nov 2026 14:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aST9fVFW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A509F1F0089F;
	Sat,  7 Nov 2026 14:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060637;
	bh=5Cgo/Drtn1AEEMMYfYaS1yoDSNcra9Mpkus71rsHNHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aST9fVFWOwPmF6IskvgDu2LUfHIK0/wUqdp/xvv9PmNazsMUMxG28C6wfzXDpTxM+
	 74A+/dv04bTFoxgaZti3CR/fRWTWwJZU75YPm7IWHRl8ZvnyNP3v4wp7OrMD0ZbGIQ
	 I+HTEAMhtC67Ry2c2BNo15gNPsPS+/0yNpRxTfjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0042/1536] perf/x86/intel: Fallback to sw branch type decoding if no hw decoding
Date: Sat,  7 Nov 2026 08:34:18 -0500
Message-ID: <20261107134958.841739370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7df17b5ff50cd..6c35a01e885cb 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1222,7 +1222,7 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
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



