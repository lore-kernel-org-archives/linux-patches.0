Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B9030E842;
	Tue,  2 Sep 2025 13:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819388; cv=none; b=ly2od9e1RjOOGbwYYBEOCm1+2v67Kd98gC+QoLyfw3HB3KIED0lH9rB9UKJUPuqRXbMBmCxAq8+a7Ara5ZzmP6cxGLXb+F+5QNqdse4AR7KHiZHm7NafvS509/CAN6WZO/NywNZ5kfbpew9E1dLBv+GZMjFjFKgxklNBDosKOGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819388; c=relaxed/simple;
	bh=gu/82B4ASVBa1LFc0Ga5aWRYPjIbSpTs7+T5b0GyNZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRV0zNxjpjIq+OOZMfGJGjW6vyhckiLkCsO2E4F3ljwCQc1inepRwAF6ap+zzOGORgpx+XX2l96/+KAAbPJjBDfjiUd6To5xeZpHnjbPUK+dzuocjqDt1A4rmnVi1iAsvBp4Ezh/IXe7pVdSWi3riEKdeL8FMrLA5EQx1IPQ7Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppaa1gmU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppaa1gmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A0DC4CEED;
	Tue,  2 Sep 2025 13:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819388;
	bh=gu/82B4ASVBa1LFc0Ga5aWRYPjIbSpTs7+T5b0GyNZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppaa1gmUR/ncB/XbAf3GAgfDIy6K3C2+vfZh8wlvkT6i0LWBlqQrr9QD33n4mYFup
	 fGA0tj1vtPVAgjpqu4qNnt7FGLFPxAFxnZZrF7cQX/9XfI6tcOXwOxeJGLY7KTWp35
	 eFI1/VfFLRbz5w+hqirm2B/WmHGCJLQdI9ndzafk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 002/142] tools/latency-collector: Check pkg-config install
Date: Tue,  2 Sep 2025 15:18:24 +0200
Message-ID: <20250902131948.250630073@linuxfoundation.org>
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

[ Upstream commit 26ebba25e210116053609f4c7ee701bffa7ebd7d ]

The tool pkg-config used to check libtraceevent and libtracefs, if not
installed, it will report the libs not found, even though they have
already been installed.

Before:
libtraceevent is missing. Please install libtraceevent-dev/libtraceevent-devel
libtracefs is missing. Please install libtracefs-dev/libtracefs-devel

After:
Makefile.config:10: *** Error: pkg-config needed by libtraceevent/libtracefs is missing
on this system, please install it.

Link: https://lore.kernel.org/20250808040527.2036023-1-chen.dylane@linux.dev
Fixes: 9d56c88e5225 ("tools/tracing: Use tools/build makefiles on latency-collector")
Signed-off-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/latency/Makefile.config | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/tracing/latency/Makefile.config b/tools/tracing/latency/Makefile.config
index 0fe6b50f029bf..6efa13e3ca93f 100644
--- a/tools/tracing/latency/Makefile.config
+++ b/tools/tracing/latency/Makefile.config
@@ -1,7 +1,15 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
+include $(srctree)/tools/scripts/utilities.mak
+
 STOP_ERROR :=
 
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



