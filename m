Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031386;
	b=PrLqQjZNAU8Y4vog1pdQWlq/SMyPReQxkLmvRNhazDBIvpeff81nxZE7A2aC9dXh6MPx
	 aW6kQq/jARzxNuP/T+NghGdA9zLIFjkdqk9qEFIRi9q7s1Ptmk/rccgwvKRWzgQ290DZk
	 vk3oh6Bsp93cIOlaJwmCMxomggu1LI4/N0I8BaikZw/S8GNVNmAAXakqd8B9wq9lD9CIS
	 YfslVFnVKRj+qf41o1VpYF1HhkkSBMO6F8kNkvzQsJxhlqKjcU4XgNivQhIzD6jXCqVRA
	 9wmofkZucrWhD6t6wZwOc20g5fjFFI1peAT9p5Fkzf2jgbgI4sk9bM/fP0YPdK0lyjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uUiFUw565R0dlH/ir8MSabl7Z1TNAo0bws11Rz/utwc=;
	b=LLUdFuMNU6ez6DEcDyQnxR+/KawXAght/dDES6BW/UV7ahB4+aIdF3LvpqY3PkysU14b
	 /p3tQKWoILpEr0IoUBfEAEOKXcaJB4Y6T80B9RIGdpK5r8+wOiNNCvv0v3ID08Yd6Xx8K
	 Qz0awLP7ecsX0UuBWAfu92tkBuHueVX7+5N6+1NpAgwwA37vW1obRzV2/FsemaUYn27ls
	 bqb6XyEAoKPWtvw8PMN6ubMhU6J/4Cn+FaAvl2t5Z/LNAGwk3m863m2o9rVQLcHe7/ZNg
	 O+0sIx9jD0mQtRCowKe0T7srjwz1TAKUMTxR6k9IAd501229L4hqvmUqqbLmmAJRg5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxhnDnIB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28C8606A320;
	Wed, 18 Nov 2026 19:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxhnDnIB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415DB1F000C4;
	Wed, 18 Nov 2026 19:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031385;
	bh=uUiFUw565R0dlH/ir8MSabl7Z1TNAo0bws11Rz/utwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oxhnDnIBlvjckz/vzUCMIUZ6p6F1EM6GgQzLuOCMJHAGkTbNAoiAEgT7yvtlgM9de
	 GDVQR2ioX48BraXFaXq7ms1qgJeL8wcflBuRlmMahK2DkOlL3nxId4rHR9lSXx+Y7C
	 80g12vjOgtksa/qKHM20qrIbWaw0mphuVRuy8McI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1040/1756] clang-tools: Import os for broken pipe handling
Date: Wed, 18 Nov 2026 15:52:47 +0100
Message-ID: <20261118150051.459206598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ting-Han Hou <ue081723@gmail.com>

[ Upstream commit d26ab84593e63bc5395ed9b518502830fda3367c ]

The BrokenPipeError handler in run-clang-tools.py calls os.open() and
os.dup2() without importing os. If this handler is reached, it raises
NameError instead of redirecting stdout and exiting with status 1.

Import os so the handler can work as intended.

Fixes: 87c7ee67deb7 ("scripts: handle BrokenPipeError for python scripts")
Assisted-by: LLM
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Link: https://patch.msgid.link/20261009175836.2277-1-ue081723@gmail.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/clang-tools/run-clang-tools.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/clang-tools/run-clang-tools.py b/scripts/clang-tools/run-clang-tools.py
index f31ffd09e1eab..116deb66cfad2 100755
--- a/scripts/clang-tools/run-clang-tools.py
+++ b/scripts/clang-tools/run-clang-tools.py
@@ -12,6 +12,7 @@ compile_commands.json.
 import argparse
 import json
 import multiprocessing
+import os
 import subprocess
 import sys
 
-- 
2.53.0



