Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049442;
	b=SUzbsPiGg094P3Dnx86MiqNp7CwlFewFSeY2+JSB/CRAjDdAZDpBDu4k9mPrlGe2REJb
	 90/7OdO/N23P3qrF9XozWxwXyIkj0/GTL7xys0+et3d1kWeiw3iHoTcNBv/9dKXaMwfD4
	 oYa0bk0LsFINNaWqkis3wPaXQAoDFmdWesL2btaa+eM2bTWXG45/dZGMmUgf36nxB4Ill
	 Zp1Wjt2MF7xvd2IJKI85mVWhaE5Snmdb6DXRDer3460vyavSt+u3CGOo9pavRZ8CpSZEc
	 o+aUm2GX0cPS62G3wYkSKnEBXPpO8qLT/gUC2PG8uDhT5VEc9H9AfzWYXxmOdiuKijg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ar1dfcN54SZl54R4Fk41wGIIxBJcC3SFXL8TZucAoCQ=;
	b=LWyABbEyBS6FkkXAsbZP1vfyQd5kDP4ZNtPKPu3M68w1PQj4DEsVFmWpP1YvwCw+kSbS
	 Ez5IIOOhNoAgRRJf9Ks4O5Q2Faxe0xyPAN7vKJ5G5x9xIORJ7QPXsa+lr9IERgXMMQhuM
	 ijvleB+az2RJtKjzQZgc2y7GsZAxzmxT3EAtitUXBI0hD4mndV5m77WsGv7WjenDmkP4J
	 3DAyDlO0KaWIxu/RSFZKHd+lrwVVXGr62QESPwjeWn8VIhvBP8apHJquOi409L6C6N0N9
	 0l/Yw9bRj+nbgaraF9X5kUYNA76suiNP0eIDrxFYF5qxxFVqXytdhag83VIGstcPIxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m14m/Gtx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75EE606A325;
	Thu, 19 Nov 2026 00:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m14m/Gtx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452D61F000C5;
	Thu, 19 Nov 2026 00:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049441;
	bh=ar1dfcN54SZl54R4Fk41wGIIxBJcC3SFXL8TZucAoCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m14m/GtxLk4Nmvd8wdWvmaZpmKM7KPML30nqpYbr6gE8GSRBnB/3UWQahIMj9H4AM
	 sJ/JKnK3qgwNJ+8hbtAU+x4zrMUnBMWEHoxLyh/5NYz9IUAuHDBUct49zPzlFBJcWX
	 M0jycmEed1hqMhl/JjnTIL/Zlaolu7tg+4NS/Uuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2352/2857] clang-tools: Import os for broken pipe handling
Date: Wed, 18 Nov 2026 15:56:26 +0100
Message-ID: <20261118150326.210694909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3266708a86586..6827dfee145cb 100755
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



