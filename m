Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9429A273D6D;
	Tue,  2 Sep 2025 13:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819413; cv=none; b=h2S5+uRN/3sjh8846t4NNqEHikQmLIQVgZ6uOl9zQ8S7seaPCT8XClZz/Caa+pZw5M6jGsrDDOJl2IXSM1hFr853YRtXNXKfcO6XcjsMCaI6yjeTyZv41WJVl5s5ii4hS+XeXMq4lCodyJqtPYKm+OELGpGjzXikijxmV/zLZ7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819413; c=relaxed/simple;
	bh=Nt+OMVqJoQK8lqH3+zsAUmt/jb0Rg3SZ/iAX0K85heM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2g5a1UPOAAVOmT+rBMmc3BPBPm6k0niRzGBz9kDruXqJE09E/LvM4tTXTgWjkcxI7gvvjGv+Hq5qC9GhM7ZewAiyhw+bikmC0J66hEm8Rn1uwC1go4r5ybo6k6YkT4DxUrTlkXZS8Eg7337Oq6u0m+U2ibtdWUGKoypepsOsAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPh0uN+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPh0uN+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E0CC4CEED;
	Tue,  2 Sep 2025 13:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819412;
	bh=Nt+OMVqJoQK8lqH3+zsAUmt/jb0Rg3SZ/iAX0K85heM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPh0uN+8ZAtTnvSGwv5MSexlWSl+yfS+IAUvHkIBg2bN3k2y0uxlGUbZJdEwV+Zqk
	 idVX81SpuQUYc5iuuVEBPTSoO0SR8iOA2P1tu4aex8ta9bGXA1ZPI62V4ABwH285Op
	 mKT2YFOiMxmt506uyUbciX1q31QMRMU/xJaB5zRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 003/142] rtla: Check pkg-config install
Date: Tue,  2 Sep 2025 15:18:25 +0200
Message-ID: <20250902131948.286754578@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Chen <chen.dylane@linux.dev>

[ Upstream commit 7b128f1d53dcaa324d4aa05d821a6bf4a7b203e7 ]

The tool pkg-config used to check libtraceevent and libtracefs, if not
installed, it will report the libs not found, even though they have
already been installed.

Before:
libtraceevent is missing. Please install libtraceevent-dev/libtraceevent-devel
libtracefs is missing. Please install libtracefs-dev/libtracefs-devel

After:
Makefile.config:10: *** Error: pkg-config needed by libtraceevent/libtracefs is missing
on this system, please install it.

Link: https://lore.kernel.org/20250808040527.2036023-2-chen.dylane@linux.dev
Fixes: 01474dc706ca ("tools/rtla: Use tools/build makefiles to build rtla")
Signed-off-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/Makefile.config | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/tracing/rtla/Makefile.config b/tools/tracing/rtla/Makefile.config
index 5f2231d8d6266..07ff5e8f3006e 100644
--- a/tools/tracing/rtla/Makefile.config
+++ b/tools/tracing/rtla/Makefile.config
@@ -1,10 +1,18 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
+include $(srctree)/tools/scripts/utilities.mak
+
 STOP_ERROR :=
 
 LIBTRACEEVENT_MIN_VERSION = 1.5
 LIBTRACEFS_MIN_VERSION = 1.6
 
+ifndef ($(NO_LIBTRACEEVENT),1)
+  ifeq ($(call get-executable,$(PKG_CONFIG)),)
+    $(error Error: $(PKG_CONFIG) needed by libtraceevent/libtracefs is missing on this system, please install it)
+  endif
+endif
+
 define lib_setup
   $(eval LIB_INCLUDES += $(shell sh -c "$(PKG_CONFIG) --cflags lib$(1)"))
   $(eval LDFLAGS += $(shell sh -c "$(PKG_CONFIG) --libs-only-L lib$(1)"))
-- 
2.50.1



