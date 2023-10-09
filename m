Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C37B1A5A3
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inFdEdzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DE9C433C8;
	Mon,  9 Oct 2023 13:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858582;
	bh=B3uzr6nz3k4rrOiXcK8H3VnYeo46vleP4FP0xnfsE+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inFdEdzpWzEVCL8qKAHITb23uzpNph6s6o8rq1nAAZY55VlNfhJpC875dLocmfxYb
	 OFIXUkk3kSNa1Ydr8RK6V/hMW35lrge5zA1/D8EANE/4JxJLsMXNanULiBv3PxhcaI
	 hxIO5ymrZcmtWWeXz64duX6wAVqmwzRkH3LSGhgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Kees Cook <keescook@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/226] selftests/tls: Add {} to avoid static checker warning
Date: Mon,  9 Oct 2023 14:59:57 +0200
Message-ID: <20231009130127.729142484@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit f50688b47c5858d2ff315d020332bf4cb6710837 ]

This silences a static checker warning due to the unusual macro
construction of EXPECT_*() by adding explicit {}s around the enclosing
while loop.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 7f657d5bf507 ("selftests: tls: add selftests for TLS sockets")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: c326ca98446e ("selftests: tls: swap the TX and RX sockets in some tests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tls.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index b599f1fa99b55..44984741bd41d 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -387,8 +387,9 @@ TEST_F(tls, sendmsg_large)
 		EXPECT_EQ(sendmsg(self->cfd, &msg, 0), send_len);
 	}
 
-	while (recvs++ < sends)
+	while (recvs++ < sends) {
 		EXPECT_NE(recv(self->fd, mem, send_len, 0), -1);
+	}
 
 	free(mem);
 }
-- 
2.40.1



