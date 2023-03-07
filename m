Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E05BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236AEC433A0;
	Tue,  7 Mar 2023 18:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212294;
	bh=Yh3YOoIk/i1ir3llnCsDc7kUCVZGRLH/MGwJG31ZoLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYjr0wr1q1oUCu7CmSNG5luDcAMyGhEnAz6vx8lhjJgOjoJ71HKLwpWz2xhEHetV0
	 +W96k2B30sZ85IrgPyXykCiZap9+2CUrZGSTVc8v6oKNf9QoeDvasJ+iLNBi9VnKZr
	 Qz0WEmcqQAzq38Q47NxeJ4v8vAxi83fn+Cj74NoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Daniel T. Lee" <danieltimlee@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/885] libbpf: Fix invalid return address register in s390
Date: Tue,  7 Mar 2023 17:51:13 +0100
Message-Id: <20230307170007.900492112@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel T. Lee <danieltimlee@gmail.com>

[ Upstream commit 7244eb669397f309c3d014264823cdc9cb3f8e6b ]

There is currently an invalid register mapping in the s390 return
address register. As the manual[1] states, the return address can be
found at r14. In bpf_tracing.h, the s390 registers were named
gprs(general purpose registers). This commit fixes the problem by
correcting the mistyped mapping.

[1]: https://uclibc.org/docs/psABI-s390x.pdf#page=14

Fixes: 3cc31d794097 ("libbpf: Normalize PT_REGS_xxx() macro definitions")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20221224071527.2292-7-danieltimlee@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_tracing.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index 2972dc25ff722..9c1b1689068d1 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -137,7 +137,7 @@ struct pt_regs___s390 {
 #define __PT_PARM3_REG gprs[4]
 #define __PT_PARM4_REG gprs[5]
 #define __PT_PARM5_REG gprs[6]
-#define __PT_RET_REG grps[14]
+#define __PT_RET_REG gprs[14]
 #define __PT_FP_REG gprs[11]	/* Works only with CONFIG_FRAME_POINTER */
 #define __PT_RC_REG gprs[2]
 #define __PT_SP_REG gprs[15]
-- 
2.39.2



