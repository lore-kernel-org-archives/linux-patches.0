Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041194;
	b=ksYlyENfB/mO0pY6ClKB0tLLN/s488v7y5i+IG/oij+pRTiXj4F804bhKPxLQw4TRzyo
	 oHY+fn8XEBkwilf1TJwerR4lN4dnHqq2P1imETojoC3YxZZflBLqUNBEPFDw3JcbFRkCW
	 wJfJ17xRzqO4mIYs2U36AfPpHnqxljrczlAcijokeToVJjX41efir0jVl9iTKBYOVFON9
	 Z+Z+gR5ITuTgqZnQv0uHKTGG+ErBoEa7DPI7aSvy6xsxJDAVIWUnLy/iC95vJrDDCH3qV
	 hOe4Y7e5r+WIY6STzkw7LBprAaDBkeZ9fMeQmP0EMe4d6ITWFfrCirE0adF80wW243w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R1Afcr8deSAIKhrh6UMnhKRC02S2YELDhzcrrunyjYM=;
	b=KMpxdsRRnyCwW97Lx9rmUpaN2JjgXhUvdDWtxAKvHiUXlvr6qPT4DGH3h1UWhLIwBzKB
	 tf7vrecK5/igw4CyWh8E+6ZYI7ofX3gksOGNExpRZW5VP314WoUZOLHmH4/1NwYB33zKj
	 Rlb/jG3hsGLkfN/fyYGSA2YXb+Vb6F35lXQ8EBx5EZnBs135zWODMXZmumtqsjV6NK46w
	 N9shVb8AFWIDOEp+k4l78BzTlCRbdDZj1leOrlmX2gZs/pOWIeBIC4a7vcomnXMI+iYAx
	 /4djDYfNOPVbKQymVY9PJQqt6TXTOz1lfHcl26/00XGVUs4sK0crsBO0+FpXpMHLQcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2QTInJv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDA8606A320;
	Wed, 18 Nov 2026 22:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2QTInJv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FB31F000C4;
	Wed, 18 Nov 2026 22:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041194;
	bh=R1Afcr8deSAIKhrh6UMnhKRC02S2YELDhzcrrunyjYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2QTInJvLIXky03hRqsJd+CGM5Fb5SipTl5xfLEJENHKg6sIzNPdNofu4QOnzYf1I
	 xCyIXYdjg4UDNA6WStpmpCyBvUf9tJqZ63Y0RjDRYmq9h+0L28P6RyrpiL9jIvRLjb
	 rEK3M3FRy6y+LYvJdArPZ8ct5tcSlZ+ExPLv/hUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2727/3318] clang-tools: Import os for broken pipe handling
Date: Wed, 18 Nov 2026 15:55:49 +0100
Message-ID: <20261118150442.640026195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



