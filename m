Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026085;
	b=pwNRSxatDR78eT66ShShPAsNoDM6AzxGA2/rF3hv9uFvJkf1I6Es6Kg/qW5+RFSlupg7
	 zgSLRXDXlqB7EDCbMhOcuL4nl+bkWrbklPkm7155Dq7hYMB1PO35e/PHJieq8CUV+mEvR
	 F/NDOpDyvPfbPT/NQq9KQJ+Bsd+xTaiaZAB04DWszyHDM8Ke7nVjtNf03Chkvs2hk0pPS
	 WTBJqOOGM9ztloBsq0q57WAW/KHvPjIWHgpxPx9Tr7ClxzV75une/0RV+zQ09Y50Pmrhj
	 MVEa6HVV0eXW0dTi0QwfmhgM9Wd5IHijMBgx7oRN+31gZn+qdE8U6oAIhQweO3czDlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EtScv+aX9LmX8dNoZoAwMTrXL1XUHzFwD852M0F5WdY=;
	b=bIndBF2hskh75WYkXQJP2JbPkW0c3tF4xvQcZtnssy+MyTfiAubuewcy+iMrG/M9XOK/
	 jkowmneTHY5RGmPvI0jtQVzQvLu6Cn6sHHURtIz1xz3YwWxfOFlih4DoXG7B/nAfeRZCz
	 6MiMkiX31ssERHUuL6Ul0vQYVqFtYjNQZrGfzhqoql+xD6Vbn6Sdw66556IvXRxRm6J2K
	 Tv20MB6RGaYtkTqThd89ItynIjVEk+ZtGuSHS+0cby6vgqQWrZEL1ZaLZTC0I3ks0BIbo
	 Mjl9MFvEfCW7OVbweQpGDAveke/X3U+irNglSlUIfdbcfOCgJV91QS+NbppvXwET6iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FNPp173X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC85606A320;
	Wed, 18 Nov 2026 18:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FNPp173X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D563A1F000C4;
	Wed, 18 Nov 2026 18:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026085;
	bh=EtScv+aX9LmX8dNoZoAwMTrXL1XUHzFwD852M0F5WdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FNPp173Xa4FQiVJrTDJv5tAZD62j0Ajg3Ez3sD5PDSvA6XDfzgvYlvJO7XkXXS8j/
	 8AhvuU8tsfzcIBZ2zBd2Bu4V0pqYgdM9W6T6lqpa8sQdWJ6ZrPnDmOFq8OeW6tCDIF
	 QG9Urj/HbfxLK/OKy7qUpdWZhhBhWTHo/fEHeo/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Simon Glass <sjg@chromium.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1309/2151] scripts/make_fit: Ignore schema checks when decomposing DTBs
Date: Wed, 18 Nov 2026 15:50:44 +0100
Message-ID: <20261118150209.785347460@linuxfoundation.org>
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

[ Upstream commit 3bf2237f59af842e546fa4b2c146198db95d1519 ]

With CHECK_DTBS enabled, Kbuild appends a schema validation command to
the fdtoverlay command saved in a composite DTB's .cmd file. When DTB
decomposition is requested, process_dtb() treats every word after -i as
an input file, including the semicolon and the validator arguments.
FIT generation then fails with FileNotFoundError while opening or
checking the size of those words as files.

Limit the input list to the fdtoverlay command before extracting its
arguments. This preserves the base DTB and overlay order and ignores
the subsequent schema validation command.

Fixes: 17c31aded9a1 ("scripts/make_fit: Support decomposing DTBs")
Assisted-by: LLM
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Reviewed-by: Simon Glass <sjg@chromium.org>
Link: https://patch.msgid.link/CA+NtrhQBK8uW32qO3dXxVxO1GSN-0EJfyJ16tnyx0o52T17WtQ@mail.gmail.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/make_fit.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/make_fit.py b/scripts/make_fit.py
index 1683e5ec6e675..34528e4a40e35 100755
--- a/scripts/make_fit.py
+++ b/scripts/make_fit.py
@@ -240,7 +240,8 @@ def process_dtb(fname, args):
 
         if 'scripts/dtc/fdtoverlay' in cmd:
             # This depends on the structure of the composite DTB command
-            files = cmd.split()
+            # Ignore any subsequent commands, such as schema validation
+            files = cmd.split(';', 1)[0].split()
             files = files[files.index('-i') + 1:]
         else:
             files = [fname]
-- 
2.53.0



