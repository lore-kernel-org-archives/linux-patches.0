Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026041;
	b=PAS6N3rdoseQcInaWCxNvpK14ui28GwccVX69hEapfPhQU7UO85XzNusi3/Y7BMhNGMQ
	 3SBYcuIX/4zhsfuUfQ9q19JAgFaVT7eUsAmQQpW4ZXYAKOZnpdkR1oN3+v2/YWzlIoNVK
	 f7mLHQu3fUrAgVNgEya97tF04mpY5VzPQKciEFv8PAxXVxyVOxGPD/8schYvQqGDo6pd4
	 rvQ9KOZh1f3AVCRNEn06G5MusUXYDNn4BUS0zBzHzqbgEjKOD9s+EhJkXp+1dn6N8bEfh
	 RS8GuYBxdrnqWlYb7htIntbIqwm7cr+aJ0jon7KOEcrVqu9ChBbMEgaJq7dHLjih4PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xQ1YBsQWluD96scW6DlLqCySsIqvYqdksw6jwnKVEAo=;
	b=BfZtH4lq+iyL7Zp7PECH0whTFsRxDsNcKRHlzU+L11DV+eKIbtWV5+b1NtvPj+DxQsLx
	 B5CE5NKPE8xI/qV5Pn3/yx/ZCvQhR4G81wipmvmABZZaSnPvE4Jy3DDG1CZ1L/WQbT8ac
	 aCXUEu0ZKJ8Mje1tmJPQgs8mT7eEhJVG2rJTnQdzYIDoa6P2kKNbOBp/CBAI3q4OQQyQB
	 qHTQc59psmgGwDn/wUS/mUQu9iKlaxtSXvMHSrwH5etKtxZbcLLyZjDZ0ArMM3YQiYlkt
	 Mal9xIhYpTrnTZddF0FiU0cJCLrDtfUBlsrnjMGyDEsUnMJYhQ/9AhtZ8xDAy0pFJzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+ZsAUlb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AC0606A31C;
	Wed, 18 Nov 2026 18:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+ZsAUlb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D201F000C4;
	Wed, 18 Nov 2026 18:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026040;
	bh=xQ1YBsQWluD96scW6DlLqCySsIqvYqdksw6jwnKVEAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+ZsAUlb0eYIeTOCunzG73x3mUdF1d6eoEL462RBsfQvRjwhn7ruKgUiVfsBM791z
	 SHzEXgAZrHmAxAetcN8wfBI2WM+l20EirQN80U5Ke9k1JEJyKlOnVuVpt6C9Ls1bx2
	 kk608tOhd1KPMS6nJZxKosZLMcP60uh7U2Gf0BSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1241/2151] checkkconfigsymbols.py: Parse Git status output line by line
Date: Wed, 18 Nov 2026 15:49:36 +0100
Message-ID: <20261118150207.377590037@linuxfoundation.org>
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

[ Upstream commit 72a61a7fef954152abd9df9def4f94816eb344ca ]

tree_is_dirty() iterates over the string returned by execute() one
character at a time. Its status check therefore examines filenames as
well as the two status columns.

An otherwise clean tree containing an untracked README is reported as
dirty because its name contains letters matched by [URMADC]. This
prevents --commit and --diff from running, whereas an untracked
notes.txt does not trigger the check.

Split the output into lines before examining the two status columns so
that filenames do not affect the dirty-tree check.

Fixes: b1a3f243485f ("checkkconfigsymbols.py: make it Git aware")
Assisted-by: LLM
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Link: https://patch.msgid.link/CA+NtrhQqXgjT+4eg6W4P94Hc=DqdV3gQXz3EKKCxWvdWzfND6A@mail.gmail.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/checkkconfigsymbols.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkkconfigsymbols.py b/scripts/checkkconfigsymbols.py
index 36c920e713137..9f7aed98d91c0 100755
--- a/scripts/checkkconfigsymbols.py
+++ b/scripts/checkkconfigsymbols.py
@@ -245,7 +245,7 @@ def tree_is_dirty():
     """Return true if the current working tree is dirty (i.e., if any file has
     been added, deleted, modified, renamed or copied but not committed)."""
     stdout = execute(["git", "status", "--porcelain"])
-    for line in stdout:
+    for line in stdout.splitlines():
         if re.findall(r"[URMADC]{1}", line[:2]):
             return True
     return False
-- 
2.53.0



