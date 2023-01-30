Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DA128EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7262C433D2;
	Mon, 30 Jan 2023 14:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088149;
	bh=M9QqjWcnMQ82/qi6H4r7WthglJD/V66MbBnFMi48uSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPqJIDMloH3F5edazXmgjrBt/zIlGXLDnmlAhJZAPW1+VpjpgJxKFZYawn1VMxqWP
	 SmaC8Qd9P6Sv/eDdJIZpilCwarER/yGhBl8WmP1mSTDD0T+qoF44ea18i6Fvinu/TB
	 K6w3wrHGN2/DIH1IE2s2xr/7BuOik7lT345jQ3Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/204] hexagon: Fix function name in die()
Date: Mon, 30 Jan 2023 14:51:35 +0100
Message-Id: <20230130134322.250704906@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

commit 4f0712ccec09c071e221242a2db9a6779a55a949 upstream.

When building ARCH=hexagon defconfig:

arch/hexagon/kernel/traps.c:217:2: error: implicit declaration of
function 'make_dead_task' [-Werror,-Wimplicit-function-declaration]
        make_dead_task(err);
        ^

The function's name is make_task_dead(), change it so there is no more
build error.

Fixes: 0e25498f8cd4 ("exit: Add and use make_task_dead.")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lkml.kernel.org/r/20211227184851.2297759-2-nathan@kernel.org
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/hexagon/kernel/traps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index 6dd6cf0ab711..1240f038cce0 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -214,7 +214,7 @@ int die(const char *str, struct pt_regs *regs, long err)
 		panic("Fatal exception");
 
 	oops_exit();
-	make_dead_task(err);
+	make_task_dead(err);
 	return 0;
 }
 
-- 
2.39.0



