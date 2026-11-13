Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585590;
	b=JQXWND5dNmlfl8OZkrL2Ld/CWnZ/Rthgt6mpnd18+MeLshRdPOAtAkFUTwVGCI3F5ueK
	 TsJM6xde/lgkEQZvSz6iI+GNfXDyBQznPPt3jChCr9YCHMVBaFb+uTu0p553FaMC+3EYE
	 vbVNMg0W/u1UzA1I/Z3BOIJoibK0LOSAziwIcOJ/ze+gAnWETx045kqRBlIxCX3jURxLL
	 PVowKFhC0yt3wxd1+erTIDQjJ9I0Q5aE/gBQhg4ljrM5Q8pmIROWW+WFQ1UvBK5pRg99K
	 tvuqIqjMdlla4+SDjmFtsUxjNAMrkyzLMjsl2bCjM5Ry866BriRWZVVh/1uo0Q0FpXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rp8QJdiDqh7KQxPKVGk0Lg6k8rkQ2g0GtxC2QQHk0kw=;
	b=vaC8ygFGZnpKS+UHJ7EtcwVcvLSoKrB3oUOY9yE7iWS7Ph/ClbRTQke4QWWc85pmVrq8
	 kvVk8O/vkLyZ6JdPcTzrpeR9RgQMB+NAUDmHkSZcQmtkEdUwXo909fXdhMFz35pfJJf7a
	 aH9rSQkUXslifEzyHrfQf8taIc3s1F4DdrQC5pJedy5vEvJH6iUAEMLFllcfqoQgm5Npi
	 1jEZ0sEn3X2FJ7lcJeHnpr7cym5NsroIIc4AB+LNE2sejrG+HPBJkfjf4bezAofDPEIXE
	 GNbPy0LtnHl0VeS+f9ja5ssn+456QnmU0am+5nLb2wqSnmGXuT6WMJbvkknVdDXNPxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jH+mtI5/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A752606FFEC;
	Fri, 13 Nov 2026 15:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jH+mtI5/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BFB1F000C4;
	Fri, 13 Nov 2026 15:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585590;
	bh=rp8QJdiDqh7KQxPKVGk0Lg6k8rkQ2g0GtxC2QQHk0kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jH+mtI5/xHVcm5gZqwuYMXRp0RrAuuT9fNMbMCOu2BTOfkHABZoR4yhZxjU663IRb
	 mkeslckMue0bGB2uOHftoFtfr/e0/1A6yeSHi8cPFEs+St5crhGor8nqatDEOeOdt5
	 umMqpQx7YvQMn6+4aX+2tDiPZMjR2vn773NcJXQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babu Moger <babu.moger@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 219/507] x86/resctrl: Correct ABMC counter ID field width
Date: Fri, 13 Nov 2026 10:48:43 -0500
Message-ID: <20261113153801.910778768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Babu Moger <babu.moger@amd.com>

[ Upstream commit 84b4b620af7d24916add5d45104023bc5d804f53 ]

AMD's Assignable Bandwidth Monitoring Counters (ABMC) are configured via
MSR_IA32_L3_QOS_ABMC_CFG. The cntr_id field selects the counter the
configuration applies to. The number of counters a platform supports (the
number of possible values written into that field) is enumerated separately
via CPUID.

On platforms that enumerate more than 32 counters, the current 5-bit encoding
truncates the counter ID and misprograms ABMC.

The section "Assignable Bandwidth Monitoring (ABMC)" in the APM has been
updated to widen MSR_IA32_L3_QOS_ABMC_CFG.cntr_id from 5 bits to 12 bits.

The CPUID enumeration reports the maximum counter ID in a 16-bit field and may
therefore report more counters than a 12-bit MSR_IA32_L3_QOS_ABMC_CFG.cntr_id
can address.

Widen MSR_IA32_L3_QOS_ABMC_CFG.cntr_id to 12 bits to match the architecture.
Cap the enumerated counter count at BIT(12) so every counter ID used by
resctrl can be written to MSR_IA32_L3_QOS_ABMC_CFG.cntr_id without truncation.

  [ bp: Massage and simplify commit message. ]

Fixes: 84ecefb76674 ("x86/resctrl: Add data structures and definitions for ABMC assignment")
Signed-off-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/3a5e99300f1309ae279beb058ef0438516b2bdcd.1793392128.git.babu.moger@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/resctrl/internal.h | 4 ++--
 arch/x86/kernel/cpu/resctrl/monitor.c  | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index e3cfa0c10e92d..ffd74a68671b0 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -214,8 +214,8 @@ union l3_qos_abmc_cfg {
 			      bw_src   :12,
 			      reserved1: 3,
 			      is_clos  : 1,
-			      cntr_id  : 5,
-			      reserved : 9,
+			      cntr_id  :12,
+			      reserved : 2,
 			      cntr_en  : 1,
 			      cfg_en   : 1;
 	} split;
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 3838e0a13d36f..5d0d3b18f9b82 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -470,7 +470,8 @@ int __init rdt_get_l3_mon_config(struct rdt_resource *r)
 		r->mon.mbm_cntr_assignable = true;
 		r->mon.mbm_cntr_configurable = true;
 		cpuid_count(0x80000020, 5, &eax, &ebx, &ecx, &edx);
-		r->mon.num_mbm_cntrs = (ebx & GENMASK(15, 0)) + 1;
+		/* cntr_id is 12 bits and can only encode 4096 counters. */
+		r->mon.num_mbm_cntrs = min((ebx & GENMASK(15, 0)) + 1, BIT(12));
 		hw_res->mbm_cntr_assign_enabled = true;
 	}
 
-- 
2.53.0



