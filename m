Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED8D15B10D;
	Mon, 28 Oct 2024 06:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097456; cv=none; b=XivJjFdxdrGwHLrp8ojyTDyZSc8p5VD/VyWlNIrV5Epgz4YXnAYvtkQ48E2mnEiXs7ATvNGZHohKmS2aXIHN4Ln7INpVLlJkwgs+PtwmG8jZ0reodGnt9ARKb5+tnVIHbA7WJxe9eR1XB2k3UQ0e8mkhdnRmDN4qpJhwKTrH4OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097456; c=relaxed/simple;
	bh=U8cFNwXchwFqXzUFxj8nZhd7RDSQv/GRoyQjIbSZrbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nb7xo89wTRdjIKbQDSiwhEF7+LQsQB8EOUqgtDT/tItekQdq1j4O1XmHxZA+ODpokj8B06tIofUq4J+ZwF/IlqCoapYqoOpnUN60qPO7sOQ8Ffxe960UvDZEijFUYWBjwDyCHbKzovyTX20poUQngIQ5V4+KERB8/za18QNiEpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+uJapo+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+uJapo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBECC4CEC3;
	Mon, 28 Oct 2024 06:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097456;
	bh=U8cFNwXchwFqXzUFxj8nZhd7RDSQv/GRoyQjIbSZrbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+uJapo+vStFz0qgoZQdI+cYC3qVpZkNHWOfR/zvuA3bigfC/qfsaRQQeoIeULyhS
	 YZzSKWHuw3aaeH4+zlV2LBBHIhklZeOu/ESMtfyPLYndxvtRZYrHJ0tHQ5aLAbjd2o
	 Duh17alVTqv1i8UADrQVyPTVgaXWJO8foDs1XAuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	junhua huang <huang.junhua@zte.com.cn>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 137/137] arm64/uprobes: change the uprobe_opcode_t typedef to fix the sparse warning
Date: Mon, 28 Oct 2024 07:26:14 +0100
Message-ID: <20241028062302.527434568@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: junhua huang <huang.junhua@zte.com.cn>

commit ef08c0fadd8a17ebe429b85e23952dac3263ad34 upstream.

After we fixed the uprobe inst endian in aarch_be, the sparse check report
the following warning info:

sparse warnings: (new ones prefixed by >>)
>> kernel/events/uprobes.c:223:25: sparse: sparse: restricted __le32 degrades to integer
>> kernel/events/uprobes.c:574:56: sparse: sparse: incorrect type in argument 4 (different base types)
@@     expected unsigned int [addressable] [usertype] opcode @@     got restricted __le32 [usertype] @@
   kernel/events/uprobes.c:574:56: sparse:     expected unsigned int [addressable] [usertype] opcode
   kernel/events/uprobes.c:574:56: sparse:     got restricted __le32 [usertype]
>> kernel/events/uprobes.c:1483:32: sparse: sparse: incorrect type in initializer (different base types)
@@     expected unsigned int [usertype] insn @@     got restricted __le32 [usertype] @@
   kernel/events/uprobes.c:1483:32: sparse:     expected unsigned int [usertype] insn
   kernel/events/uprobes.c:1483:32: sparse:     got restricted __le32 [usertype]

use the __le32 to u32 for uprobe_opcode_t, to keep the same.

Fixes: 60f07e22a73d ("arm64:uprobe fix the uprobe SWBP_INSN in big-endian")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: junhua huang <huang.junhua@zte.com.cn>
Link: https://lore.kernel.org/r/202212280954121197626@zte.com.cn
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/uprobes.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/uprobes.h
+++ b/arch/arm64/include/asm/uprobes.h
@@ -14,7 +14,7 @@
 #define UPROBE_SWBP_INSN_SIZE	AARCH64_INSN_SIZE
 #define UPROBE_XOL_SLOT_BYTES	AARCH64_INSN_SIZE
 
-typedef u32 uprobe_opcode_t;
+typedef __le32 uprobe_opcode_t;
 
 struct arch_uprobe_task {
 };


