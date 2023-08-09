Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89FF53B7
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDE2C433C7;
	Wed,  9 Aug 2023 11:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579691;
	bh=6FMxgJ1s/T9kUA97OsxYGFxf4sgRKGw3uC3xZAKkG7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KS7PfbUo0ZugOl77cOdGva+AFH7wCCH+1GTTZ4WePGF3FnC4nGeiBPqNRJny7u7ND
	 te0au0v1FAFh2MfhVldBKSg4DLSpl2caK7QUKZR1gpbvnSUupytrOp8Jh60f1m9vLz
	 vAJG6XokvAyBR2JDlWpoc5oB3ThaoZIt0CElBLd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineet Gupta <vgupta@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 082/323] ARCv2: entry: avoid a branch
Date: Wed,  9 Aug 2023 12:38:40 +0200
Message-ID: <20230809103701.872766574@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vineet Gupta <vgupta@synopsys.com>

[ Upstream commit ab854bfcd310b5872fe12eb8d3f2c30fe427f8f7 ]

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Stable-dep-of: 92e2921eeafd ("ARC: define ASM_NL and __ALIGN(_STR) outside #ifdef __ASSEMBLY__ guard")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/include/asm/entry-arcv2.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arc/include/asm/entry-arcv2.h b/arch/arc/include/asm/entry-arcv2.h
index 3209a67629606..beaf655666cbd 100644
--- a/arch/arc/include/asm/entry-arcv2.h
+++ b/arch/arc/include/asm/entry-arcv2.h
@@ -100,12 +100,11 @@
 	; 2. Upon entry SP is always saved (for any inspection, unwinding etc),
 	;    but on return, restored only if U mode
 
+	lr	r9, [AUX_USER_SP]			; U mode SP
+
 	mov.nz	r9, sp
 	add.nz	r9, r9, SZ_PT_REGS - PT_sp - 4		; K mode SP
-	bnz	1f
 
-	lr	r9, [AUX_USER_SP]			; U mode SP
-1:
 	PUSH	r9					; SP (pt_regs->sp)
 
 	PUSH	fp
-- 
2.39.2



