Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A8F168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2ECC433D2;
	Mon,  8 May 2023 11:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544203;
	bh=5reWMY1QyHJiEfO03ZqIWcrgIdzY0sVbUP63ahsyz9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJb9Mj1ur9j3SlOuMgcQEFm2qHrX7PRB+7uJGDdgw7XuWAw/JozLFysMuuJgzNoG7
	 XoNreg99EQd9rpM+4ipZQ7YutrCK1ukwld92y+8CYoTcuVYAHF9PmvdvHgKm0t67Oa
	 ReOIwIv7RbYtqtrOzXLgSvNoTasl2ejgWu8gB7r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay12@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 334/694] libbpf: Fix arm syscall regs spec in bpf_tracing.h
Date: Mon,  8 May 2023 11:42:49 +0200
Message-Id: <20230508094443.286856394@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Puranjay Mohan <puranjay12@gmail.com>

[ Upstream commit 06943ae675945c762bb8d5edc93d203f2b041d8d ]

The syscall register definitions for ARM in bpf_tracing.h doesn't define
the fifth parameter for the syscalls. Because of this some KPROBES based
selftests fail to compile for ARM architecture.

Define the fifth parameter that is passed in the R5 register (uregs[4]).

Fixes: 3a95c42d65d5 ("libbpf: Define arm syscall regs spec in bpf_tracing.h")
Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20230223095346.10129-1-puranjay12@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_tracing.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index 6db88f41fa0df..2cd888733b1c9 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -204,6 +204,7 @@ struct pt_regs___s390 {
 #define __PT_PARM2_SYSCALL_REG __PT_PARM2_REG
 #define __PT_PARM3_SYSCALL_REG __PT_PARM3_REG
 #define __PT_PARM4_SYSCALL_REG __PT_PARM4_REG
+#define __PT_PARM5_SYSCALL_REG uregs[4]
 #define __PT_PARM6_SYSCALL_REG uregs[5]
 #define __PT_PARM7_SYSCALL_REG uregs[6]
 
-- 
2.39.2



