Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3CD3214
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9DEC433EF;
	Tue,  7 Feb 2023 13:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775537;
	bh=HIknskYPa/Ba2/x4sv35oqZnRKagxd7936BqMdJ+D1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiT6nIHf8s3FEfblwSQutqtLzjWw4yqK4hQ/95HcsC44TxcU/dYgD90WOS+aH3ygX
	 0yRmGmC95W2xnov5weyJ5T16+MwWlrWDgbN5a0Gjy5/8OVbfkGDjJduUDx+yfk0kbM
	 jTUEDowTWx8UdjuKgEZXtgzzrkQRlanM+Ny6Zey8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Gherzan <andrei.gherzan@canonical.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/120] selftests: net: udpgso_bench_rx: Fix used uninitialized compiler warning
Date: Tue,  7 Feb 2023 13:56:55 +0100
Message-Id: <20230207125620.645829482@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrei Gherzan <andrei.gherzan@canonical.com>

[ Upstream commit c03c80e3a03ffb4f790901d60797e9810539d946 ]

This change fixes the following compiler warning:

/usr/include/x86_64-linux-gnu/bits/error.h:40:5: warning: ‘gso_size’ may
be used uninitialized [-Wmaybe-uninitialized]
   40 |     __error_noreturn (__status, __errnum, __format,
   __va_arg_pack ());
         |
	 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	 udpgso_bench_rx.c: In function ‘main’:
	 udpgso_bench_rx.c:253:23: note: ‘gso_size’ was declared here
	   253 |         int ret, len, gso_size, budget = 256;

Fixes: 3327a9c46352 ("selftests: add functionals test for UDP GRO")
Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20230201001612.515730-1-andrei.gherzan@canonical.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index 6a193425c367..d0895bd1933f 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -250,7 +250,7 @@ static int recv_msg(int fd, char *buf, int len, int *gso_size)
 static void do_flush_udp(int fd)
 {
 	static char rbuf[ETH_MAX_MTU];
-	int ret, len, gso_size, budget = 256;
+	int ret, len, gso_size = 0, budget = 256;
 
 	len = cfg_read_all ? sizeof(rbuf) : 0;
 	while (budget--) {
-- 
2.39.0



