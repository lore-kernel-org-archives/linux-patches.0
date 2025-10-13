Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93723081D2;
	Mon, 13 Oct 2025 15:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368791; cv=none; b=NW7IpuQyz1Opj9aHEQk7qGrrGtG8+c0Jyr12xM+JvlT2+2eooD4QSQx0mY6RPQll14sipXdNSvFIVCGrZrRYHtZvZj1MB2ZtqMwR6F2YDmHzfmCkVZfTPLEKMnLMm98vsgN0eDu+1Ls4IU/SxzX1gAakoisCKh0FUWoVx4rLDj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368791; c=relaxed/simple;
	bh=tNUxtZEcdVv45pd7JZJNJmMk2UjJMc2H9cl6Pex0kng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebaH1H/MhOIBpy8dxVtKbzPtUCOFwvQCgtm8WpPzOr/yONIxLvIfozOSHT+IVh7TsMtSXkqpJjbZxpHyzizS+2AQW0BZL9t7lNOMeg3nRjABbbhlgvyCDrOTNnYg9zNGAdeey0VXgn8EAgta+3BCz9VAXW9kWAvAqIB3mLTsdlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pW98pbmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pW98pbmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2C5C4CEE7;
	Mon, 13 Oct 2025 15:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368790;
	bh=tNUxtZEcdVv45pd7JZJNJmMk2UjJMc2H9cl6Pex0kng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pW98pbmqJSOqm9U5kyHAq17QlwpYZtWHRoJ3ikb2742+e65RmdfzksrO3JXepiPHY
	 ILr7gr9WPZ0Z6dJrXBAFAWA0IPbqCcl3Y7iapjOWJL6dt/oxIeN4WbKp2p0ADiThjO
	 XS3+zQFDCtCT5CQgkxpWIfzKo1n8c7YU8h6bBCTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nicolas Schier <n.schier@avm.de>,
	Kienan Stewart <kstewart@efficios.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 007/563] kbuild: Add missing $(objtree) prefix to powerpc crtsavres.o artifact
Date: Mon, 13 Oct 2025 16:37:48 +0200
Message-ID: <20251013144411.556497797@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kienan Stewart <kstewart@efficios.com>

[ Upstream commit 46104a7d3ccd2acfe508e661393add0615c27a22 ]

In the upstream commit 214c0eea43b2ea66bcd6467ea57e47ce8874191b
("kbuild: add $(objtree)/ prefix to some in-kernel build artifacts")
artifacts required for building out-of-tree kernel modules had
$(objtree) prepended to them to prepare for building in other
directories.

When building external modules for powerpc,
arch/powerpc/lib/crtsavres.o is required for certain
configurations. This artifact is missing the prepended $(objtree).

Fixes: 13b25489b6f8 ("kbuild: change working directory to external module directory with M=")
Acked-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nicolas Schier <n.schier@avm.de>
Tested-by: Nicolas Schier <n.schier@avm.de>
Signed-off-by: Kienan Stewart <kstewart@efficios.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250218-buildfix-extmod-powerpc-v2-1-1e78fcf12b56@efficios.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 9753fb87217c3..a58b1029592ce 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -58,7 +58,7 @@ ifeq ($(CONFIG_PPC64)$(CONFIG_LD_IS_BFD),yy)
 # There is a corresponding test in arch/powerpc/lib/Makefile
 KBUILD_LDFLAGS_MODULE += --save-restore-funcs
 else
-KBUILD_LDFLAGS_MODULE += arch/powerpc/lib/crtsavres.o
+KBUILD_LDFLAGS_MODULE += $(objtree)/arch/powerpc/lib/crtsavres.o
 endif
 
 ifdef CONFIG_CPU_LITTLE_ENDIAN
-- 
2.51.0



