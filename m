Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EDB30BF68;
	Wed, 20 May 2026 17:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297649; cv=none; b=VaIcB5Zu3Jqi42tmGm/y2S2elEy30aFU/BaBVru/hDJVmkMjsTIjJAVqBp757kEVadwzbU3ucCquIaQ6Esa7TWQ78/u53i2db8OVbI/+JHBvLD4e2NIqm2iTY9Q59xuNoOSW9WBO7QAhKngN6vEePrO5KC3zt/KWtGVPSSC7f5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297649; c=relaxed/simple;
	bh=1LHY+CDyKVCvq0aORMgBBnRvod6jXPw4cG1qRQ4BouU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wyd9S/MhgOZLb9VAHUBQu7aKnBhflcmrpFVIeBlwu05aK8aVjcRNqQvpRJ+YTIbkFNglRB1bNwNDQX+zJoUNkqX04morDWNZxWMfoypMf8gBn77k4KgyCanSEx7eG4FqRhIppDscludpqmPkbIpoF8G2MSrDdk99jjVGcWtlbPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wj3Za727; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wj3Za727"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60F21F000E9;
	Wed, 20 May 2026 17:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297648;
	bh=o0aW7a+I7Uf+UDaProDqsOG3zvmLfPXaLBiahDBahl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wj3Za727eSXoN324C9oUCWJQvCpRaECLroatZieQdPZ06m/dXYA+z3jQYmxKhTeZe
	 uup6neec8VqAjxBux5X4fOOijBC4sLNQKx5yno6qqF6/ik4SGODOOyrakQYZmg7cNi
	 kHiTxGF++VlX+HEJD0zodQNsX9j7fCWk8oN1kjfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"haoyu.lu" <hechushiguitu666@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 111/957] bpf,arc_jit: Fix missing newline in pr_err messages
Date: Wed, 20 May 2026 18:09:54 +0200
Message-ID: <20260520162136.967950548@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: haoyu.lu <hechushiguitu666@gmail.com>

[ Upstream commit b6b5e0ebd429d66ce37ae5af649a74ea1f041d92 ]

Add missing newline to pr_err messages in ARC JIT.

Fixes: f122668ddcce ("ARC: Add eBPF JIT support")
Signed-off-by: haoyu.lu <hechushiguitu666@gmail.com>
Link: https://lore.kernel.org/r/20260324122703.641-1-hechushiguitu666@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/net/bpf_jit_arcv2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arc/net/bpf_jit_arcv2.c b/arch/arc/net/bpf_jit_arcv2.c
index 6d989b6d88c69..7ee50aeae5a45 100644
--- a/arch/arc/net/bpf_jit_arcv2.c
+++ b/arch/arc/net/bpf_jit_arcv2.c
@@ -2427,7 +2427,7 @@ u8 arc_prologue(u8 *buf, u32 usage, u16 frame_size)
 
 #ifdef ARC_BPF_JIT_DEBUG
 	if ((usage & BIT(ARC_R_FP)) && frame_size == 0) {
-		pr_err("FP is being saved while there is no frame.");
+		pr_err("FP is being saved while there is no frame.\n");
 		BUG();
 	}
 #endif
@@ -2454,7 +2454,7 @@ u8 arc_epilogue(u8 *buf, u32 usage, u16 frame_size)
 
 #ifdef ARC_BPF_JIT_DEBUG
 	if ((usage & BIT(ARC_R_FP)) && frame_size == 0) {
-		pr_err("FP is being saved while there is no frame.");
+		pr_err("FP is being saved while there is no frame.\n");
 		BUG();
 	}
 #endif
@@ -2868,7 +2868,7 @@ u8 gen_jmp_64(u8 *buf, u8 rd, u8 rs, u8 cond, u32 curr_off, u32 targ_off)
 		break;
 	default:
 #ifdef ARC_BPF_JIT_DEBUG
-		pr_err("64-bit jump condition is not known.");
+		pr_err("64-bit jump condition is not known.\n");
 		BUG();
 #endif
 	}
@@ -2948,7 +2948,7 @@ u8 gen_jmp_32(u8 *buf, u8 rd, u8 rs, u8 cond, u32 curr_off, u32 targ_off)
 	 */
 	if (cond >= ARC_CC_LAST) {
 #ifdef ARC_BPF_JIT_DEBUG
-		pr_err("32-bit jump condition is not known.");
+		pr_err("32-bit jump condition is not known.\n");
 		BUG();
 #endif
 		return 0;
-- 
2.53.0



