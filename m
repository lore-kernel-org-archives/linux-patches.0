Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055906;
	b=NLpXLUIsKw2vUZdrPNHaFAH2TbntyG4H/ejwY/wtAjzOjwSUJGH8stxEMYFFNIPUXNrt
	 LDMbot2/MQU2CwkX360YFgp1/imEi5sP6LY5+1XtGXqs5hI11jORfhi8BiylKN+NrXzqe
	 wHAVhh3CV7jduUQWq0wIIJSZUtsDwCEjJwn1m4EqygYK9uu9IDGhZlWzkfrDiwDA/ni6S
	 BHFGkMeSNBnjTgYQRj496DJ9VfhLXUJoKu/0JPh/PBP7mhe2DeBrQKGC6LnJCNF/hyw7P
	 ZJsIZveFFKvYnwOPSEHEeolopMm2JIKUTfy2gJmdYao3m00nJuLTLEP6ehwDJxz1FmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ed7N/qW8PMFIueRbwh4Qa2vmnbgRvCbLYIWCoD8Mhuo=;
	b=cYJhX92Ln2cpHARmL2HjezeFOhJSGpxOjYduKyPamUr/68MKREXPXHGWwHeMT8+K9oMG
	 NwCd1Lw4Sjq6t2FRjf3EPU95HCblSwX7ljdu1ZWupn7abLPMDyefqzofmE9pNvIjlM8GK
	 gnim3LUmQJAB7DSCIfN5ydJxQbjUpD9RQ9LG1xLyet5gVoqOoOwIt9geooEUlZFlDm8xL
	 wUUMsbPF6Trl1RorLZFCEc0DsvdW0e28etkJtOkFk1tNned1bYUH8mFEGXkEO+bHEUJPA
	 5YhGdAKuTSXfoHHTOF7WuAljuq38YyL5k0lPE/5px1ElLhOJRKtwPqMAGfvqpKnu/9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GXLq7vH3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D02606A32A;
	Thu, 19 Nov 2026 02:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GXLq7vH3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E841F000C4;
	Thu, 19 Nov 2026 02:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055906;
	bh=Ed7N/qW8PMFIueRbwh4Qa2vmnbgRvCbLYIWCoD8Mhuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GXLq7vH3FCnGucyNiaGYyg8ms6B+PczgHJl9cT9vRqleJe73RneU3eGg1YdjeNQqQ
	 +2fOWSQs5CyClBQb/7MexYLGcph9+gu/bEQQq3pPHaUIZ8kq91yj1yOq/33xzpFq71
	 Qfugoz2K+iQZJLzN1Owl1xCPb0n+vtOy+R3TGJwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1798/2214] checkkconfigsymbols.py: Parse Git status output line by line
Date: Wed, 18 Nov 2026 15:57:54 +0100
Message-ID: <20261118150123.427665721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



