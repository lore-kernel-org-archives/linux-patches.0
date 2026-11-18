Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028816;
	b=iWOupX1x6LFKQ3jhAvyuDWUt6WJ2PCU8S5Hz7pPD8oJ0JtYlktgb8vzlK4O5R12bGbyD
	 9RwngMUwvwOLlH+W72YyfRSJlLSi5PzZapylj8XjuFh8CGxt2T5GKh+0IICUk/zY4q359
	 Z2UD08VO+w/xYVNfDzpcvQXrIF/5ppQWYXUkGXtRhrjmsJln2BVoTRO3EyXQdLsYbm6NQ
	 5ASmbFuE8zq6cM6oQ4mIz5jYl2M15Wd205ynDJEtPI0i2/z3JG/vDwwxNovBCmHmGB38/
	 DGT/am54EPLcCEYTOL4P5mam7DOszYswXaNu46oLjp768mK7U4rfN4z8MLHkyQI56BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s5OHZ1w7P1rVcrCDUmJPqe1fVStxg1abSgHB8kZSCJI=;
	b=TpvTL/g/hxvD1Y7F7I+kBLHCfgXp9k8LV26CtWXSL22eE05k5SCpMp/vAonF1bZKvr4X
	 yNKjFDjtBk9rDiSq+kKf8qnn7zUPxrMDXPGIzecVfJPycvYlnq4Rek+tqpC0wZkETHJn5
	 Ri1IPFIzEdtzxdMU4SZZqpeePtfG5M7wfs3eMz1qEQ1yvszmKQqar0LKw+T5FaLECpxaV
	 HK+YrVX3wI72YmK3E3k2/zNZTRKHySCtTfaxAn4wC7Oc9nnY0EDOPY9O+Oz1aBLPBIvDY
	 /qinxLugmwWw/EY93yhykK7nnX7QsQFQZn27NO4xYXPQOP2Co3YGqdq5tdwJ8xfgmOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k1JUcHly;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED267606A33A;
	Wed, 18 Nov 2026 19:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k1JUcHly
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE211F000C6;
	Wed, 18 Nov 2026 19:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028815;
	bh=s5OHZ1w7P1rVcrCDUmJPqe1fVStxg1abSgHB8kZSCJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1JUcHlyLUq+3KWgP2L383Daj2u30avSpUYONwacUvj+/LhvgBk0GDaXTlWfKY9Kb
	 JHcZfq85ik0ZYo/Pqf9QGbpPqSFGaWA/vR04ZAEAXJyVIHOXO+CAbVqwmsh1nczX1O
	 RMaJDWQkv8WBSj0ID+WtnIcQ6MgacqQDdyAWRcTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0129/1756] x86/microcode/AMD: Move the no-revision fixup to get_patch_level()
Date: Wed, 18 Nov 2026 15:37:36 +0100
Message-ID: <20261118150013.330426929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit 098bcea71b8d257d80b0037b97b66070806600a5 ]

On machines which don't have microcode applied yet, the revision is 0.
However, this doesn't work with the Zen family/model/stepping patch
arithmetic. So move the fixup to the patch level getter function and
this way make sure the patch level is always proper and thus the
arithmetic always works.

And now that it can be called on any family, make this Zen-only.

Assisted-by: claude/claude-opus-4-6
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20260530024213.86137-1-bp@kernel.org
[ sashal: get_patch_level() here lacks the upstream debug/hypervisor branch; the fixup goes right after native_rdmsr() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/amd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 24709a5589633..a846864ba89f8 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -221,11 +221,6 @@ static bool need_sha_check(u32 cur_rev)
 {
 	u32 cutoff;
 
-	if (!cur_rev) {
-		cur_rev = cpuid_to_ucode_rev(bsp_cpuid_1_eax);
-		pr_info_once("No current revision, generating the lowest one: 0x%x\n", cur_rev);
-	}
-
 	cutoff = get_cutoff_revision(cur_rev);
 	if (cutoff)
 		return cur_rev <= cutoff;
@@ -297,6 +292,13 @@ static u32 get_patch_level(void)
 	u32 rev, dummy __always_unused;
 
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
+	if (!rev) {
+		if (x86_family(bsp_cpuid_1_eax) < 0x17)
+			return rev;
+
+		rev = cpuid_to_ucode_rev(bsp_cpuid_1_eax);
+		pr_info_once("No current revision, generating the lowest one: 0x%x\n", rev);
+	}
 
 	return rev;
 }
-- 
2.53.0



