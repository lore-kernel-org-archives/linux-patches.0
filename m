Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0B533EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A46C433EF;
	Mon, 16 Jan 2023 16:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885063;
	bh=Ge97t+TTVjA0hpwZ3TDdeoduf5ulGCCignRy3QoDCW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lmq2WraY0oc2Y81Y6D3+rRtrGBtbIk7jsvmbdfpHYU11w59hb0C4bfwS9cTjiOOve
	 kpPf8c85jSGjAvsoyZGriVSN0Fc6Gfb8tUKKvsJuxQANebRSQKJOU1oUK3I82l1BcR
	 PytpKUxnrIfSwdxP2Uf8TxvJpfCecvMwBeKpv3oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willy Tarreau <w@1wt.eu>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 59/86] tools/nolibc: use pselect6 on RISCV
Date: Mon, 16 Jan 2023 16:51:33 +0100
Message-Id: <20230116154749.510888703@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit 9c2970fbb425cca0256ecf0f96490e4f253fda24 ]

This arch doesn't provide the old-style select() syscall, we have to
use pselect6().

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: 184177c3d6e0 ("tools/nolibc: restore mips branch ordering in the _start block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/nolibc.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/include/nolibc/nolibc.h b/tools/include/nolibc/nolibc.h
index 676fe5d92875..7ba180651b17 100644
--- a/tools/include/nolibc/nolibc.h
+++ b/tools/include/nolibc/nolibc.h
@@ -1256,7 +1256,10 @@ struct sys_stat_struct {
  *   - the arguments are cast to long and assigned into the target
  *     registers which are then simply passed as registers to the asm code,
  *     so that we don't have to experience issues with register constraints.
+ *
+ * On riscv, select() is not implemented so we have to use pselect6().
  */
+#define __ARCH_WANT_SYS_PSELECT6
 
 #define my_syscall0(num)                                                      \
 ({                                                                            \
-- 
2.35.1



