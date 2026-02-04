Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E1E40FD81;
	Wed,  4 Feb 2026 15:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218898; cv=none; b=YQji5zGCIfKtaS6UvKs3+t9IeE5APRDavcbatTajGq6yDDZlX2tUPFKcSBaZx3KqjpIW/vqXgKv8jqEIpDwOTC+E2pTiqJF2ftI4iJKiqrjy3CFuGhfQ6CLQRI6fzxBW5nYl1hIHT/heDQoRqOFv00Vu92pr8bJw7c62xEjPePk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218898; c=relaxed/simple;
	bh=5eJLNObIloBjI8rjHIphd9xQ29JcGenpLuGDcLRXN7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tGwe3gEZ94tiy02Poe6yg7pDL8yvpb0UwXtPux8mQjfc3tdYZnAg4TQVTLcPq3tGYnntCWYakT1x7EGHarxPNZ3gPgjgtJEsfP5mzGZ6IoQXYz9nBdeXaemrGOnKCa0bn2RK/hy/XS0FXogpPgcVdxU/1H8jQXpuq6zKRZQJW/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpGw2eio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpGw2eio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31CFC116C6;
	Wed,  4 Feb 2026 15:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218898;
	bh=5eJLNObIloBjI8rjHIphd9xQ29JcGenpLuGDcLRXN7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpGw2eioHvKY9oWju/28ruF7TRW5jNdKQ+VWhYq8lD3KTNdRS+Y2b57Oe+rObuRrQ
	 qRahVS579UhtixU6coH7vksNXIpTmLjEhnp7UZlNIZt4M9t+V/pmk8q5Rj3cbDdF2S
	 Parz8JpxAPoyLjjzlymk9ivgnSx1whpPmJS18uUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.12 87/87] bpf/selftests: test_select_reuseport_kern: Remove unused header
Date: Wed,  4 Feb 2026 15:41:25 +0100
Message-ID: <20260204143850.061076726@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>

commit 93cf4e537ed0c5bd9ba6cbdb2c33864547c1442f upstream.

test_select_reuseport_kern.c is currently including <stdlib.h>, but it
does not use any definition from there.

Remove stdlib.h inclusion from test_select_reuseport_kern.c

Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20250227-remove_wrong_header-v1-1-bc94eb4e2f73@bootlin.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[shung-hsi.yu: Fix compilation error mentioned in footer of Alexis'
patch with newer glibc header:

  [...]
    CLNG-BPF [test_progs-cpuv4] test_select_reuseport_kern.bpf.o
  In file included from progs/test_select_reuseport_kern.c:4:
  /usr/include/bits/floatn.h:83:52: error: unsupported machine mode
  '__TC__'
     83 | typedef _Complex float __cfloat128 __attribute__ ((__mode__
  (__TC__)));
        |                                                    ^
  /usr/include/bits/floatn.h:97:9: error: __float128 is not supported on
  this target
     97 | typedef __float128 _Float128;

I'm not certain when the problem starts to occur, but I'm quite sure
test_select_reuseport_kern.c were not meant to be using the C standard
library in the first place.]
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2018 Facebook */
 
-#include <stdlib.h>
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>


