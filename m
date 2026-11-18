Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031210;
	b=m8coGP447JEbDlc5SH1RvWNZOD55C7mf8dR8Cz6jTL8RE2a0kw6RkVNAFJtxymv8VvyW
	 2bN0NNRTgeB3EMAosABhghb7HLdmMDPUF7YchIbtcaLSsq5t4UleouHE3k3Aog002kLNe
	 25R+11PMEFfstOk3gKAjhWwvQdxhfECaTzoLfI3y1WB2o0LEZ/2LdNl3xtB2TW6UU8K4s
	 WUoJlV9xu1N0rINUPPkNzCwUoq9ylF6x1g7vD2fMFcBa8m9V5y+oWHaZLZ+jzbzhnSTxL
	 kLd4M3ZYOs9RwhliiM72Rq7hxSuGtA60H9sDyOfzmFek9/8iKv9lT6NT/BIho9WkGzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lpGFnpzFO5Kj6ggxyPXGbdLEwE+UwGuyVtjtWbAy0Tk=;
	b=gvfR09bDALdLcQ8twmWKPrVhi2IvTX7oOJf2zEXIk8gOwUzIJ/fF5oQzVxEvE374eFLK
	 CZWLV9gscSKo0dsWkNDDWis7Z0o7uJ91HmPMTFGTjgVisIeEAhEJKjwyfxMWjfDGATGWX
	 pyLP5cPPhUycq3mQwHCptr59Y6qXFXVIfcuSU1cXtzsgLe9xUkC3G7WS3AMoB5g+m77Tl
	 z+MvJuhL/xIiq+XqZ/UcxoVjwV8SUCJFMYmSi6TZ7Ftg/bilWeige9I6nRnFVp43uIpyR
	 lJdqph+HVsQ1ky4JBMnTU/fbLuhY0AVl+23wV4CHcaEaEWbkM48FUYeQw/B4CTEPX5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TvNn+zgB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47912606A32C;
	Wed, 18 Nov 2026 19:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TvNn+zgB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0091F000C5;
	Wed, 18 Nov 2026 19:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031210;
	bh=lpGFnpzFO5Kj6ggxyPXGbdLEwE+UwGuyVtjtWbAy0Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TvNn+zgB7+8RrizecMHXRnBgmZ0yvNOHwh7ZPedW6CHy8Mg413XwISmnQZz9m9cJc
	 Pan9Nb4jm44L8+rRP694hOMrdHkDaOz4OD8BF96IUO5v7xwFMprzXD/AM8HnezI8V5
	 dYuu+Ob7rA7DojITkcM3lsyNzMXT1jcJooRe6i1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0979/1756] checkkconfigsymbols.py: Parse Git status output line by line
Date: Wed, 18 Nov 2026 15:51:46 +0100
Message-ID: <20261118150049.139216957@linuxfoundation.org>
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



