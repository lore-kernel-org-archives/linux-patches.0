Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2091E3DF9;
	Tue,  3 Dec 2024 15:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239162; cv=none; b=i4oHyZQvNsoQBsl3yxIcw0zwwlndgCnxjDL//y1W2FgpXlORVrAgSYiwyJ9yYEYVGHpMeS6B0oe1fnzs8zeIteHnzL/mQP5b9wACpgP12TyUmUpfvYB/xHXWBxpwtKK8vmE7DlGpwFJCChJOM9A/YF+j6LhLR+WZhQ8j1Ouqp4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239162; c=relaxed/simple;
	bh=UgUa5ULrAinM06cU8GvAZ7SZhKdd0kR0P66ILF5lPqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oitTQ0V6uXqUHRxzlBFZMMeGyEnvI2CjMmDwZU6LtI5tomKQtb4xerR702PV5GgqKLnBp08V3SUmm9WA2pDiMliKJtOpyc07U2LWr4LGBx5QyPG6EjnGlAojfU7VAmVKJd7NlYRQ/187Yh5PpFh2qdHGh3MG6oBHyh7pIf+Ewn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwRbSe4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwRbSe4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3916C4CED6;
	Tue,  3 Dec 2024 15:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239162;
	bh=UgUa5ULrAinM06cU8GvAZ7SZhKdd0kR0P66ILF5lPqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwRbSe4+TwYhDVr19dzAj/sWswQZkJhPTROwbJzeEQ0OD3QPU718lhG8I4PhXcJnm
	 GEm/tWpHwsyNQlYT+Z0URxw/JedRmtJQtQ9CZZyKi5GYNmHGl/ynzli91/eJvKQ7vd
	 en2prmruo1JnEJI2IF/cHgiSwZJt08UusfQllgxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Leo Yan <leo.yan@arm.com>,
	Guilherme Amadio <amadio@gentoo.org>,
	linuxarm@huawei.com,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 521/817] perf build: Add missing cflags when building with custom libtraceevent
Date: Tue,  3 Dec 2024 15:41:33 +0100
Message-ID: <20241203144016.230094218@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit d5a0a4ab4af4c27de097b78d6f1b7e7f7e31908f ]

When building with custom libtraceevent, below errors occur:

  $ make -C tools/perf NO_LIBPYTHON=1 PKG_CONFIG_PATH=<custom libtraceevent>
  In file included from util/session.h:5,
                   from builtin-buildid-list.c:17:
  util/trace-event.h:153:10: fatal error: traceevent/event-parse.h: No such file or directory
    153 | #include <traceevent/event-parse.h>
        |          ^~~~~~~~~~~~~~~~~~~~~~~~~~
  <snip similar errors of missing headers>

This is because the include path is missed in the cflags. Add it.

Fixes: 0f0e1f445690 ("perf build: Use pkg-config for feature check for libtrace{event,fs}")
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Guilherme Amadio <amadio@gentoo.org>
Cc: linuxarm@huawei.com
Link: https://lore.kernel.org/r/20241024133236.31016-1-yangyicong@huawei.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 9fccdff682af7..0ee690498d311 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -1197,7 +1197,7 @@ endif
 ifneq ($(NO_LIBTRACEEVENT),1)
   $(call feature_check,libtraceevent)
   ifeq ($(feature-libtraceevent), 1)
-    CFLAGS += -DHAVE_LIBTRACEEVENT
+    CFLAGS += -DHAVE_LIBTRACEEVENT $(shell $(PKG_CONFIG) --cflags libtraceevent)
     LDFLAGS += $(shell $(PKG_CONFIG) --libs-only-L libtraceevent)
     EXTLIBS += $(shell $(PKG_CONFIG) --libs-only-l libtraceevent)
     LIBTRACEEVENT_VERSION := $(shell $(PKG_CONFIG) --modversion libtraceevent).0.0
-- 
2.43.0



