Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019394;
	b=OyA4hA3q0YbMospDAjINAgk/P9ZHVQLIu0lxAw4p7bjRg9DvcjMafV0Lu7mZpSjK33dH
	 lyJNKz3a+93xXdHXLqZ3gqziP6xnK2ODiH1P2m67oFZ4dgSAZSiKGakxaQWwWShL9xSMd
	 BcWNHSahcH5gIbt3kGQR9kBk7f+HGg7tdKBTk3Z2vDgTvjSChdnkFB8MT/j81YCjKpsl9
	 YvgKunney6OGmoOS5vLHGSpbGjAIK+bnJOvEH4a9+GASIyYo+GGxCrWKq9yEhwWdGNq5i
	 9Q2CY/z2Qb9b9rKk2GGUVbV0jjpdC4krK6vUiaS4dqfQSI27SbmJcARhQolyri4TpMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d+grb7NARD5NIRuSU6iEG5+k8ujzwGDUrK1jl1Q1xF8=;
	b=WKkbJXWcNKLbh9AxoZCO5pKa9LeXDd5Hm72/YL/d2gOcoo5HkRK87exaGjlj3u4zKub7
	 gBcMKTA1fnebVzy3xYD7GZ3tPNTvVbfNvAdMnSLmnZE1reNyEEIY9Aks4vZgrpqDHc3B9
	 giR0xW8qIn0RpziToFae64hCluYVk1GJMl3drxxHvOFI983z+J+UchkUtnaavxRmxfD2C
	 B1gwjXZTgmDIBibSBoNTmf6rGUL709RaaCnfZc1w37pgcn646aKdLgxZBqjKKQhZkedqP
	 fO/o37CH18h4v8JpY35MffiYRKevSCRo8dmCcOWssYCK+D3/ZnOEY4IJtXg/GUwRF6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xHFE0c7q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE06606A33F;
	Wed, 18 Nov 2026 16:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xHFE0c7q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4791F000C6;
	Wed, 18 Nov 2026 16:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019394;
	bh=d+grb7NARD5NIRuSU6iEG5+k8ujzwGDUrK1jl1Q1xF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xHFE0c7qlUsqQTKHoumMr8i+zrCdwRxhbPLh64fT/T0VjMdKiIc17GR0H4YGfL85t
	 Jh3xyhybLokutwi8kyP9Sm61yG+44asx4F4HmyvVHZY8h6QMm89BaZ9fvNHBwwamvv
	 7xN1T7XMuEibhFqfRJi/qNpN5WqtCs0MSpy1lNCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1581/2651] clang-tools: Import os for broken pipe handling
Date: Wed, 18 Nov 2026 15:47:01 +0100
Message-ID: <20261118150344.834995747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e78be82aa6931..79d58b34e7acd 100755
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



