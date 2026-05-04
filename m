Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37C421CC4F;
	Mon,  4 May 2026 14:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903567; cv=none; b=u9rkfr7+/zBvTAt7MgDnALo9DWEblEbcFkqu11ARrrzTRYMTHI7ajyrHESH7e52QoDd80Sx9U/WvLX6ZZDEC9fWHPY8jlJD5wk5ejzcgMVAJ2v+9rzbFwcrtdCcxVxuXmINc1RJhPDEaEkIX+HeTp4suyc6McOArcy+n6sZIEYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903567; c=relaxed/simple;
	bh=4tGuwRckG5nt7NUm9CBUXjcvazNWEKndrLRhqQgXA1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJzvQgzY3oHov/5E9jAxnj7hKgVh49inoL5vr/AtJgDzWa7j3VE/BzFJv67bkRlB/gw4FyDoVaw8Za22tobInc4u8mnWB9Avyz1x1z2nlZOLbZnQekRaFXBh2zjuYwk5K48zMkoKGEtBUlXlroS4zvRExToIc6xJa46V0QLlTCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptHNg+qJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptHNg+qJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49726C2BCB8;
	Mon,  4 May 2026 14:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903567;
	bh=4tGuwRckG5nt7NUm9CBUXjcvazNWEKndrLRhqQgXA1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptHNg+qJk8kaF13QpPvsoV8ZTTIYgABH4vk8NX0qKUq9wy3H2kR3roaFNPFA88cKB
	 12hFVvAQi8jNSOF7wI2DcTtO+C/I2KfSYPRCY/pnr9juFYNGCroeBSOpxUeayR/f40
	 QHlFcx3EEj5qaO2gzCsyjwipSJ1N4Ypq5GvWaOMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WANG Rui <r@hev.cc>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Namhyung Kim <namhyung@kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 7.0 285/307] perf loongarch: Fix build failure with CONFIG_LIBDW_DWARF_UNWIND
Date: Mon,  4 May 2026 15:52:50 +0200
Message-ID: <20260504135153.514327333@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WANG Rui <r@hev.cc>

commit 841dbf4871c57ce2da18c4ea7ffac5487d0eda16 upstream.

Building perf for LoongArch fails when CONFIG_LIBDW_DWARF_UNWIND is
enabled because unwind-libdw.o is still referenced in
arch/loongarch/util/Build.

Fixes: e62fae9d9e8 ("perf unwind-libdw: Fix a cross-arch unwinding bug")
Signed-off-by: WANG Rui <r@hev.cc>
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/arch/loongarch/util/Build |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/perf/arch/loongarch/util/Build
+++ b/tools/perf/arch/loongarch/util/Build
@@ -1,4 +1,3 @@
 perf-util-y += header.o
 
 perf-util-$(CONFIG_LOCAL_LIBUNWIND) += unwind-libunwind.o
-perf-util-$(CONFIG_LIBDW_DWARF_UNWIND) += unwind-libdw.o


