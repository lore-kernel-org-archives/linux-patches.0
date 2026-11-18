Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041175;
	b=jE9yUcMSSmAb+PfMQJ0m+pSJhKA8svLTmp3S2OBJ2/HnCjqsSPQKs/tvs1MZ41ACaV5j
	 3I1k0FwcULTJP3Pc+ENwZpmJ/Svgf4ZrlSdb4qOcc1bybqbXcE5uxKuFZCf9PUveQrrqg
	 PETRj2wHz2kuYWDxLUhJb5zVIXHHR9D+/P3vfr/jbuUZejThAR79nvzB43a0d7XQrfHY0
	 em/opZjCncfiZs9GnWoT9rhzO30q//wK/2pnln01dIOLuON8Ukw3ySwPu8w/0K/EqU+pu
	 AlA8rTPMELt4RKxEn9Os1lxVklI05tQBysY8wNcye69WCCBMfxcPz6x76YmfKlSmlHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g3FXM8M3fBphz0HTX5uWsZgT3p76yUSn7Q25OiVlYNk=;
	b=3A2uXBr32YwFWbd1YhHWoDCvYCr2Tnp+aWTLM6vtC//lrL3evrWj9F09s5jM8qq7rdGF
	 2L5CTQxt+P44ulUCUKzQSJ+7oNcpjNE+27/9ij4xdhtTxSg6QwxwSi7KAfWyVe2BXaTkK
	 1tIrH5j3InGQat546Yh2rxuYZf/aTmS7rYKEmlifekE3BqGVGEw6Fqr+HoUm64Te3CwfG
	 V+m1zIib/UM1Bd2A/6AiESmDo+mpzSpYNoHnempHEfK58Bln+cWUHdU7ja+0XDmqdMPYC
	 ECN4O+v6zdxY7jtXIRqYeHwnfBk+Dynk/R/EDVT+PhUvkBSbQbqtcG0+n6kMzFTANpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AuICIEmJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00014606A31C;
	Wed, 18 Nov 2026 22:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AuICIEmJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551A51F000C4;
	Wed, 18 Nov 2026 22:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041174;
	bh=g3FXM8M3fBphz0HTX5uWsZgT3p76yUSn7Q25OiVlYNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AuICIEmJ6/Va2E5W7vJfmjTvbY5zmH/hvTgsdYxwcjjwneRQd62T97cwJYxSpzl2I
	 mIBx6fs+MwmDEwQHEH/ooMdJ9KRs26XEw0Zo1liFLMB5CBoaMY6fuYBeDGICRB+L+5
	 uMp2xHXXzeVq/BeHgFW79zTyx/MfYVK5FN6FxxeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2678/3318] checkkconfigsymbols.py: Parse Git status output line by line
Date: Wed, 18 Nov 2026 15:55:00 +0100
Message-ID: <20261118150441.333570858@linuxfoundation.org>
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



