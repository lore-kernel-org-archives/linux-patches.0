Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026082;
	b=tprEMVIWAwPFNKgPhODGt5F50FYzlC7/eoQLt1O6y6eXOEp1aZNYoBQo52IuhRXtrZiV
	 s/oR/Gw+NMjHTiATl8nYgKjVeFiB4CSfhNvVWF/F4OYL+BAILj2QeTPZ+oG9OZV3xLdtH
	 3RBGd235+vFrG4UKA1GlOZaAhOx7jolMF1Zh4u8JWRzwt/py1zPmKAm60htNuLSdJWLK8
	 OHfNvx0fw5Of9o2XCBSrLXZPylsKaojUTVRNh19Tn4mD35wTyrHb9oeCYq+jL7AGvejHy
	 nNh8x+zjXhtaVIGR/LOJ4iWjAkgrCHHD7Yjt4aJ/uKS/JW7dYQuWEOD8qqqJhySTuxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Uo8xr1g1Qc89Gx7znFBmw7jgxSIl6JIYprmc3SzRWRw=;
	b=wJsJplCM95NNPExoHQxIPm8kcNGxkwDkvUPBTfhZe9FUWFUbvFIENIR/fxFhfRbuItqH
	 cxs1HWhDX7krTaoMlkHuhoduE62RQUFbK4bb4nhcihlVmhj1+mkPPg6MrLMadR2HiNQQY
	 lZaIUj1hpvHYxxEUl3+nwSwC/9rkPlfQaMQKlGuqfaQdNSHyZfYQYmWXuOv06pbiv75cP
	 XzJ+qzUeZaefAcftdNF3zHP8lJEO0HW/WFs0FxVKuN7IE0tAIL8SEak9XmuQ5eZjC+UXk
	 immrbfhHjvFcMAZLhiuoUJ+cy1WNkRRvEk7Zz0TmVyWquksc32Lk42Leb53m33J1H4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2KdKQ+E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFD0606A31C;
	Wed, 18 Nov 2026 18:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2KdKQ+E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158AD1F000C4;
	Wed, 18 Nov 2026 18:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026082;
	bh=Uo8xr1g1Qc89Gx7znFBmw7jgxSIl6JIYprmc3SzRWRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2KdKQ+EgH9pgCIXijjazy+ZHU7u8Jpqz7eM0Ji+aCIJWqcu7ilvjFMcL1eyVz/Bl
	 Z9BSZF2/MmHGUdSQunHiFMJsbuCZpoAYbjBJy77DpCd1/fZxRovYbJdCPUemb0ds2L
	 +STJNB8Goie6bgR4LrYILDALJgxLOAeduZwVSl3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1308/2151] clang-tools: Import os for broken pipe handling
Date: Wed, 18 Nov 2026 15:50:43 +0100
Message-ID: <20261118150209.746766263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



