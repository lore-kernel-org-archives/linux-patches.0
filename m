Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042927;
	b=GfyHYhqFopCOpx2m41ajOvcesnIj6Ytz/v+2nIj7dJ+/2IRfgbGTNWCWqk9+dZknQli7
	 RdIyxzxTswn9GPO+XUOkLcD4a9R/E1bxMQ8fht9qqR5dqlFfNkqMXKbl0iHuv5mFFkC6n
	 Hq/EbMelOfAZKK/gevzG5n396YwQNVzSzd5C+PLpCVHtPmBGOgC/Atw1/xynTHDdHRvz9
	 0T5ZgDcCtoIr5gh/QJeaMDAS6cArf7i2qi2Nss2AYgLjendEtQjMHQ/HlxcMVzRqU2RcQ
	 JNWeuVsJLbHg92yO+N29c6s9q8GKFaULt3F9Qx6keWPyACn14vFvLJXJ0Z2lLc3FzEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XZh/902+IOj8Qo2/sDhI3RD0EXbTqZ/E3i+IJCv0NQo=;
	b=CQ5RmevGVu19tcUZ7X7fMs7ed3Z2Nt0nmULWApAKiPPMff4Zlp8d2T9K1cCf9gFAAscr
	 vCF9OUxuo294QuCRxnLTFSvCiUTsyytLCmDd/KDNkpK5OujPP1rw7OlVdVpdQ7vgAo0Uq
	 NDKy3t8dzgJzD/Wy+tBHwx7sEw5TGgUJ6tRWgnyn0AIhwEh55lMJhoD2BnINmhl5g7JFU
	 WRG1ODnEmk2HBRk3ak3j3kLfmqUBdkFT36auh0Fe+OzRTEGVUwyW0ItIHGDGmgAP6Jjkm
	 4oyIhESotTb7TU9NVJ8Fa/mzQGrUDLOmAalJ90/xxEsEsVogd3lyNH59tgw2ZTHa7Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wye+AKkp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF5D606A31C;
	Wed, 18 Nov 2026 23:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wye+AKkp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080341F000C4;
	Wed, 18 Nov 2026 23:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042927;
	bh=XZh/902+IOj8Qo2/sDhI3RD0EXbTqZ/E3i+IJCv0NQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wye+AKkpoOMElvdRUIOQtWmc234aePne6GLvV0oBmPyaiwWTbf+hZfSSp2Y0kxNxl
	 C7f71rz8e4339pO1cVO3AkTs3oJyPPSm5UoAnXe05ThPZLAl15utf7GelYKBLl+EKQ
	 UPkg5EzlnIPc3PiSUn1k11X8ALp5+2AkPYHak5n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0030/2857] perf/x86/intel: Fallback to sw branch type decoding if no hw decoding
Date: Wed, 18 Nov 2026 15:17:44 +0100
Message-ID: <20261118150202.430839841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c05b3e6de4826..3599b2f1428cc 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1143,7 +1143,7 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
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



