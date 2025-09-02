Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF683064AF;
	Tue,  2 Sep 2025 13:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819864; cv=none; b=KK5yj+ehz1SZ/VEAXRYKqY91zh3TpbYEWr15a88YmmrEsXFCS/g96MLYnSc92UOTKtBF7QuCeisftyF3uodbsENl6W0/ol0TldHHiYJi94REE+QrE9Mm3QKDRR2bPGFvBH2cUFfoEV8B4G6I12YTTWscoMM7qkBSW2Ytur+x2XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819864; c=relaxed/simple;
	bh=T/KyQHcD6k7lylIGfYb8mesvM6IpByY3zgdc+Y0J5Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/VftE5mbIY1Aqt49j0I79jCaSMSzEB2FdmcwMW1ksT+U3TQluHeq2E+W4e2M9VYHRnbnL8Kizue0fQ+7zcZ9oNL7M4gzAOBB989D2jZyVv9PkR6mmZr1Bm64sTmgzK3QH1PsP/AW5AP7x3J7TIfMUPNeqphEdWeaehUedem+b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RS4QE/Nx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RS4QE/Nx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC79C4CEF5;
	Tue,  2 Sep 2025 13:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819864;
	bh=T/KyQHcD6k7lylIGfYb8mesvM6IpByY3zgdc+Y0J5Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RS4QE/NxpQbgMCZ/QrxgeE8xNh2KRpfj2yfbzoDMbVvtqRgSv9K3LP96iOZqued+I
	 BWgqSxFD5p7xADjxk1vIjn6HUK+2bKGTqAcgZ2jg9dhBNU6syRJONeEgBZVDBE17ZF
	 pdwuQT3gx7gw69oU0tGY+X+hynlZBFvzh60FVl7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 02/95] rtla: Check pkg-config install
Date: Tue,  2 Sep 2025 15:19:38 +0200
Message-ID: <20250902131939.703694527@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5f8c286712d4c..a35d6ee55ffcd 100644
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



